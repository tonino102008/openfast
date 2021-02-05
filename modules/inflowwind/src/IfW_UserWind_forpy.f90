!> This module is a placeholder for any user defined wind types.  The end user can use this as a template for their code.
!! @note  This module does not need to exactly conform to the FAST Modularization Framework standards.  Three routines are required
!! though:
!!    -- IfW_UserWind_Init          -- Load or create any wind data.  Only called at the start of FAST.
!!    -- IfW_UserWind_CalcOutput    -- This will be called at each timestep with a series of data points to give wind velocities at.
!!    -- IfW_UserWind_End           -- clear out any stored stuff.  Only called at the end of FAST.
MODULE IfW_UserWind
!**********************************************************************************************************************************
! LICENSING
! Copyright (C) 2015-2016  National Renewable Energy Laboratory
!
!    This file is part of InflowWind.
!
! Licensed under the Apache License, Version 2.0 (the "License");
! you may not use this file except in compliance with the License.
! You may obtain a copy of the License at
!
!     http://www.apache.org/licenses/LICENSE-2.0
!
! Unless required by applicable law or agreed to in writing, software
! distributed under the License is distributed on an "AS IS" BASIS,
! WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
! See the License for the specific language governing permissions and
! limitations under the License.
!
!**********************************************************************************************************************************

   USE                                       NWTC_Library
   USE                                       IfW_UserWind_Types
   USE                                       forpy_mod

   IMPLICIT                                  NONE
   PRIVATE

   TYPE(ProgDesc),   PARAMETER               :: IfW_UserWind_Ver = ProgDesc( 'IfW_UserWind', '', '' )

   PUBLIC                                    :: IfW_UserWind_Init
   PUBLIC                                    :: IfW_UserWind_End
   PUBLIC                                    :: IfW_UserWind_CalcOutput

CONTAINS

!====================================================================================================

!----------------------------------------------------------------------------------------------------
!> A subroutine to initialize the UserWind module. This routine will initialize the module. 
!----------------------------------------------------------------------------------------------------
SUBROUTINE IfW_UserWind_Init(InitData, ParamData, MiscVars, Interval, InitOutData, ErrStat, ErrMsg)


   IMPLICIT                                                       NONE

   CHARACTER(*),           PARAMETER                           :: RoutineName="IfW_UserWind_Init"


      ! Passed Variables

            !  Anything this code needs to be able to generate or read its data in should be passed into here through InitData.
   TYPE(IfW_UserWind_InitInputType),            INTENT(IN   )  :: InitData          !< Input data for initialization.

            !  Store all data that does not change during the simulation in here (including the wind data field).  This cannot be changed later.
   TYPE(IfW_UserWind_ParameterType),            INTENT(INOUT)  :: ParamData         !< Parameters.

            !  Store things that change during the simulation (indices to arrays for quicker searching etc).
   TYPE(IfW_UserWind_MiscVarType),              INTENT(  OUT)  :: MiscVars          !< Misc variables for optimization (not copied in glue code)
   
            !  Anything that should be passed back to the InflowWind or higher modules regarding initialization.
   TYPE(IfW_UserWind_InitOutputType),           INTENT(  OUT)  :: InitOutData       !< Initial output.

   REAL(DbKi),                                  INTENT(IN   )  :: Interval          !< Do not change this!!



      ! Error handling
   INTEGER(IntKi),                              INTENT(  OUT)  :: ErrStat           !< determines if an error has been encountered
   CHARACTER(*),                                INTENT(  OUT)  :: ErrMsg            !< A message about the error.  See NWTC_Library info for ErrID_* levels.

      ! local variables
   ! Put local variables used during initializing your wind here.  DO NOT USE GLOBAL VARIABLES EVER!
   INTEGER(IntKi)                                              :: UnitWind          ! Use this unit number if you need to read in a file.

      ! Temporary variables for error handling
   INTEGER(IntKi)                                              :: TmpErrStat        ! Temp variable for the error status
   CHARACTER(ErrMsgLen)                                        :: TmpErrMsg         ! temporary error message


      !-------------------------------------------------------------------------------------------------
      ! Set the Error handling variables
      !-------------------------------------------------------------------------------------------------

   ErrStat     = ErrID_None
   ErrMsg      = ""


      ! Get a unit number to use

   CALL GetNewUnit(UnitWind, TmpErrStat, TmpErrMsg)
   CALL SetErrStat(TmpErrStat,TmpErrMsg,ErrStat,ErrMsg,RoutineName)
   IF (ErrStat >= AbortErrLev) RETURN


      !-------------------------------------------------------------------------------------------------
      ! Copy things from the InitData to the ParamData.  If you need to store it for later calculations,
      !  copy it over now.
      !-------------------------------------------------------------------------------------------------
    ParamData%ierror_w = forpy_initialize()
    ParamData%ierror_w = get_sys_path(ParamData%paths_w)
    ParamData%ierror_w = ParamData%paths_w%append(".")
    ParamData%ierror_w = import_py(ParamData%FLORIS_ROUTINE, "FLORIS_ROUTINE")
!   ParamData%RefHt            =  InitData%ReferenceHeight
!   ParamData%RefLength        =  InitData%RefLength

      !-------------------------------------------------------------------------------------------------
      ! Open the file for reading.  Proceed with file parsing etc.  Populate your wind field here.
      !-------------------------------------------------------------------------------------------------

!   CALL OpenFInpFile (UnitWind, TRIM(InitData%WindFileName), TmpErrStat, TmpErrMsg)
!   CALL SetErrStat(TmpErrStat,TmpErrMsg,ErrStat,ErrMsg,RoutineName)
!   IF ( ErrStat >= AbortErrLev ) RETURN


      !-------------------------------------------------------------------------------------------------
      ! Set the MiscVars:
      !-------------------------------------------------------------------------------------------------
      
    MiscVars%DummyMiscVar = 0


      !-------------------------------------------------------------------------------------------------
      ! Set the InitOutput information. Set Any outputs here.
      !-------------------------------------------------------------------------------------------------

   InitOutdata%Ver         = IfW_UserWind_Ver

   RETURN

END SUBROUTINE IfW_UserWind_Init

!====================================================================================================

!-------------------------------------------------------------------------------------------------
!>  This routine and its subroutines calculate the wind velocity at a set of points given in
!!  PositionXYZ.  The UVW velocities are returned in OutData%Velocity
!!
!! @note    This routine may be called multiple times in a single timestep!!!
!!
!! @note    The PositionXYZ coordinates have been rotated into the wind coordinate system where the
!!          primary wind flow is along the X-axis.  The rotations to PropagationDir are taken care of
!!          in the InflowWind_CalcOutput subroutine which calls this routine.
!-------------------------------------------------------------------------------------------------
SUBROUTINE IfW_UserWind_CalcOutput(Time, PositionXYZ, ParamData, Velocity, DiskVel, MiscVars, ErrStat, ErrMsg)

   IMPLICIT                                                       NONE

   CHARACTER(*),           PARAMETER                           :: RoutineName="IfW_UserWind_CalcOutput"


      ! Passed Variables
   REAL(DbKi),                                  INTENT(IN   )  :: Time              !< time from the start of the simulation
   REAL(ReKi),                                  INTENT(IN   )  :: PositionXYZ(:,:)  !< Array of XYZ coordinates, 3xN  ONLY IN ATTRIBUTE!!! BUT IS IT CHANGING ANYTHING?
   TYPE(IfW_UserWind_ParameterType),            INTENT(INOUT)  :: ParamData         !< Parameters
   REAL(ReKi),                                  INTENT(INOUT)  :: Velocity(:,:)     !< Velocity output at Time    (Set to INOUT so that array does not get deallocated)
   REAL(ReKi),                                  INTENT(  OUT)  :: DiskVel(3)        !< HACK for AD14: disk velocity output at Time
   TYPE(IfW_UserWind_MiscVarType),              INTENT(INOUT)  :: MiscVars          !< Misc variables for optimization (not copied in glue code)

      ! Error handling
   INTEGER(IntKi),                              INTENT(  OUT)  :: ErrStat           !< error status
   CHARACTER(*),                                INTENT(  OUT)  :: ErrMsg            !< The error message


      ! local counters
   INTEGER(IntKi)                                              :: PointNum          ! a loop counter for the current point

      ! local variables
   REAL(ReKi), DIMENSION(SIZE(PositionXYZ, 1),SIZE(PositionXYZ, 2)) :: PositionXYZ_COPIA
   INTEGER(IntKi)                                              :: NumPoints         ! Number of points passed in
   REAL(ReKi)                                                  :: xy1, xy2
   REAL(ReKi), DIMENSION(:,:), ALLOCATABLE, SAVE               :: FunInt
   REAL(ReKi), DIMENSION(:),   ALLOCATABLE, SAVE               :: xxdom
   REAL(ReKi), DIMENSION(:),   ALLOCATABLE, SAVE               :: yydom
   REAL(ReKi), DIMENSION(:),   ALLOCATABLE, SAVE               :: zzdom
   REAL(ReKi), DIMENSION(:),   ALLOCATABLE, SAVE               :: xx1len_mat
   INTEGER(IntKi), SAVE                                        :: xx1len
   REAL(ReKi), DIMENSION(:),                        POINTER          :: matrix
   REAL(ReKi), DIMENSION(:),                        POINTER          :: matrix_shape
   REAL(ReKi), DIMENSION(:),                        POINTER          :: matrix_xxdom
   REAL(ReKi), DIMENSION(:),                        POINTER          :: matrix_yydom
   REAL(ReKi), DIMENSION(:),                        POINTER          :: matrix_zzdom
   REAL(ReKi), DIMENSION(:),                        POINTER          :: matrix_xx1len

   REAL(ReKi), DIMENSION(:), ALLOCATABLE                       :: SpeedZ

   TYPE(object)                                                :: return_FLORIS_ROUTINE
   TYPE(ndarray)                                               :: return_array_FLORIS_ROUTINE
   TYPE(object)                                                :: return_FLORIS_ROUTINE_SHAPE
   TYPE(ndarray)                                               :: return_array_FLORIS_ROUTINE_SHAPE
   TYPE(object)                                                :: return_XXDOM
   TYPE(ndarray)                                               :: return_array_XXDOM
   TYPE(object)                                                :: return_YYDOM
   TYPE(ndarray)                                               :: return_array_YYDOM
   TYPE(object)                                                :: return_ZZDOM
   TYPE(ndarray)                                               :: return_array_ZZDOM
   TYPE(object)                                                :: return_XX1LEN
   TYPE(ndarray)                                               :: return_array_XX1LEN

   INTEGER(IntKi), DIMENSION(:), ALLOCATABLE, SAVE                                        :: k
   INTEGER(IntKi)                                              :: nTurb

   INTEGER(IntKi)                                              :: i, j
   INTEGER(IntKi)                                              :: indZ, indX, indY
   INTEGER(IntKi)                                              :: ind1, ind2, ind3, ind4

      ! temporary variables
   INTEGER(IntKi)                                              :: TmpErrStat        ! temporary error status
   CHARACTER(ErrMsgLen)                                        :: TmpErrMsg         ! temporary error message



      !-------------------------------------------------------------------------------------------------
      ! Initialize some things
      !-------------------------------------------------------------------------------------------------

   ErrStat     = ErrID_None
   ErrMsg      = ""

   print*, ""
   print*, ""
   print*, ""
   print*, ""
   print*, "ARRAY ARRIVING FROM AERODYN", MiscVars%AllInAD
   print*, ""
   print*, ""
   print*, ""

      ! The array is transposed so that the number of points is the second index, x/y/z is the first.
      ! This is just in case we only have a single point, the SIZE command returns the correct number of points.
   NumPoints   =  SIZE(PositionXYZ,DIM=2)

   IF (Time < 1d-4 .AND. .NOT. ALLOCATED(FunInt)) THEN
      ! GET DIMENSIONS OF FUNINT TO ALLOCATE THE ARRAY
      ParamData%ierror_w = call_py(return_FLORIS_ROUTINE_SHAPE, ParamData%FLORIS_ROUTINE, "FLORIS_ROUTINE_SHAPE")
      ParamData%ierror_w = cast(return_array_FLORIS_ROUTINE_SHAPE, return_FLORIS_ROUTINE_SHAPE)
      ParamData%ierror_w = return_array_FLORIS_ROUTINE_SHAPE%get_data(matrix_shape)

      print*, INT(matrix_shape(1)), INT(matrix_shape(2))

      ALLOCATE(FunInt(INT(matrix_shape(1)), INT(matrix_shape(2))))

      !FILL IN THE ARRAY FUNINT

      ParamData%ierror_w = call_py(return_FLORIS_ROUTINE, ParamData%FLORIS_ROUTINE, "FLORIS_ROUTINE")
      ParamData%ierror_w = cast(return_array_FLORIS_ROUTINE, return_FLORIS_ROUTINE)
      ParamData%ierror_w = return_array_FLORIS_ROUTINE%get_data(matrix)

      FunInt = TRANSPOSE(RESHAPE(matrix, (/INT(matrix_shape(2)), INT(matrix_shape(1))/)))

      !ALLOCATE AND FILL XXDOM AND YYDOM

      ParamData%ierror_w = call_py(return_XXDOM, ParamData%FLORIS_ROUTINE, "xxdom")
      ParamData%ierror_w = cast(return_array_XXDOM, return_XXDOM)
      ParamData%ierror_w = return_array_XXDOM%get_data(matrix_xxdom)
      ParamData%ierror_w = call_py(return_YYDOM, ParamData%FLORIS_ROUTINE, "yydom")
      ParamData%ierror_w = cast(return_array_YYDOM, return_YYDOM)
      ParamData%ierror_w = return_array_YYDOM%get_data(matrix_yydom)
      ParamData%ierror_w = call_py(return_ZZDOM, ParamData%FLORIS_ROUTINE, "zzdom")
      ParamData%ierror_w = cast(return_array_ZZDOM, return_ZZDOM)
      ParamData%ierror_w = return_array_ZZDOM%get_data(matrix_zzdom)

      ALLOCATE(xxdom(INT(matrix_xxdom(ubound(matrix_xxdom, 1)))))
      ALLOCATE(yydom(INT(matrix_yydom(ubound(matrix_yydom, 1)))))
      ALLOCATE(zzdom(INT(matrix_zzdom(ubound(matrix_zzdom, 1)))))

      DO i = 1, INT(matrix_xxdom(ubound(matrix_xxdom, 1)))
         xxdom(i) = matrix_xxdom(i)
         yydom(i) = matrix_yydom(i)
         IF (i <= matrix_zzdom(ubound(matrix_zzdom, 1))) THEN
            zzdom(i) = matrix_zzdom(i)
         END IF
      ENDDO

      ! ASSIGN XX1LEN
      ParamData%ierror_w = call_py(return_XX1LEN, ParamData%FLORIS_ROUTINE, "xx1len")
      ParamData%ierror_w = cast(return_array_XX1LEN, return_XX1LEN)
      ParamData%ierror_w = return_array_XX1LEN%get_data(matrix_xx1len)

      ALLOCATE(xx1len_mat(SIZE(matrix_xx1len)))
      nTurb = INT(matrix_xx1len(2))
      xx1len = INT(matrix_xx1len(1))

      xx1len_mat = matrix_xx1len

      print*, "xx1len: ", xx1len
      print*, "nTURBINES: ", nTurb

      call return_FLORIS_ROUTINE%destroy
      call return_array_FLORIS_ROUTINE%destroy
      call return_FLORIS_ROUTINE_SHAPE%destroy
      call return_array_FLORIS_ROUTINE_SHAPE%destroy
      call return_XXDOM%destroy
      call return_array_XXDOM%destroy
      call return_YYDOM%destroy
      call return_array_YYDOM%destroy
      call return_ZZDOM%destroy
      call return_array_ZZDOM%destroy
      call return_XX1LEN%destroy
      call return_array_XX1LEN%destroy

   END IF

   IF (.NOT. ALLOCATED(k)) THEN
      ALLOCATE(k(4))
      k(1) = 1
      k(2) = nTurb
      k(3) = 0 ! LASCIA COSI CHE AL PRIMO CICLO FA UNA CHIAMATA IN PIU, CONTROLLA DA EWIND.TXT CHE SIA GIUSTO
      k(4) = 2 ! n° of calls made from INFLOW WIND TO MY ROUTINE
   END IF

   PositionXYZ_COPIA(1,:) = PositionXYZ(1,:) + xx1len_mat(2 + k(1))
   PositionXYZ_COPIA(2,:) = PositionXYZ(2,:) + xx1len_mat(5 + k(1))
   PositionXYZ_COPIA(3,:) = PositionXYZ(3,:)

   IF (k(3) == k(4)) THEN
      PositionXYZ_COPIA(1,:) =  PositionXYZ_COPIA(1,:) - 5.0 ! DONE FOR THE SPEED AT HUB HEIGHT, SUBTRACT 5 FOR FREE WIND SPEED!!!!!
   END IF

   IF ((k(1) < k(2)) .AND. (k(3) == k(4))) THEN
      k(1) = k(1) + 1
      k(3) = 1
   ELSE IF ((k(1) == k(2)) .AND. (k(3) == k(4))) THEN
      k(1) = 1
      k(3) = 1
   ELSE IF ((k(1) < k(2)) .AND. (k(3) < k(4))) THEN
      k(3) = k(3) + 1
   ELSE IF ((k(1) == k(2)) .AND. (k(3) < k(4))) THEN
      k(3) = k(3) + 1
   END IF

   ALLOCATE(SpeedZ(SIZE(FunInt, 2)))

   DO PointNum = 1, NumPoints

      !FILL INTERPOLATED SPEED ON Z-AXIS
      indZ = MINLOC(ABS(zzdom - PositionXYZ_COPIA(3,PointNum)), DIM = 1)
      indX = MINLOC(ABS(xxdom - PositionXYZ_COPIA(1,PointNum)), DIM = 1)
      indY = MINLOC(ABS(yydom - PositionXYZ_COPIA(2,PointNum)), DIM = 1)

      IF (xxdom(indX) > PositionXYZ_COPIA(1,PointNum)) THEN
         indX = indX - 1
      END IF

      IF (yydom(indY) > PositionXYZ_COPIA(2,PointNum)) THEN
         indY = indY - 1
      END IF

      IF (PositionXYZ_COPIA(3,PointNum) < zzdom(1)) THEN
         PositionXYZ_COPIA(3,PointNum) = zzdom(1)
      END IF

      IF (PositionXYZ_COPIA(3,PointNum) > zzdom(SIZE(zzdom))) THEN
         PositionXYZ_COPIA(3,PointNum) = zzdom(SIZE(zzdom)) - 1e-4
      END IF

      IF (zzdom(indZ) > PositionXYZ_COPIA(3,PointNum)) THEN
         indZ = indZ - 1
      END IF

      SpeedZ = FunInt(indZ,:) + (FunInt(indZ + 1, :) - FunInt(indZ, :))*(PositionXYZ_COPIA(3,PointNum) - zzdom(indZ))/(zzdom(indZ + 1) - zzdom(indZ))

      ind1 = MAXLOC(SpeedZ * MERGE(1,0,((ABS((xxdom - xxdom(indX))) < 1e-4) .AND. (ABS((yydom - yydom(indY))) < 1e-4))), DIM = 1)
      !ind2 = MAXLOC(SpeedZ * MERGE(1,0,((ABS((xxdom - xxdom(indX))) < 1e-4) .AND. (ABS((yydom - yydom(indY + 1 + xx1len))) < 1e-4))), DIM = 1)
      ind2 = MAXLOC(SpeedZ * MERGE(1,0,((ABS((xxdom - xxdom(indX))) < 1e-4) .AND. (ABS((yydom - yydom(indY + xx1len))) < 1e-4))), DIM = 1)
      ind3 = MAXLOC(SpeedZ * MERGE(1,0,((ABS((xxdom - xxdom(indX + 1))) < 1e-4) .AND. (ABS((yydom - yydom(indY))) < 1e-4))), DIM = 1)
      !ind4 = MAXLOC(SpeedZ * MERGE(1,0,((ABS((xxdom - xxdom(indX + 1))) < 1e-4) .AND. (ABS((yydom - yydom(indY + 1 + xx1len))) < 1e-4))), DIM = 1)
      ind4 = MAXLOC(SpeedZ * MERGE(1,0,((ABS((xxdom - xxdom(indX + 1))) < 1e-4) .AND. (ABS((yydom - yydom(indY + xx1len))) < 1e-4))), DIM = 1)

      !BILINEAR INTERPOLATION ON GRID
      !xy1 = ((xxdom(indX + 1) - PositionXYZ_COPIA(1,PointNum))/(xxdom(indX + 1) - xxdom(indX)))*SpeedZ(ind1) + ((PositionXYZ_COPIA(1,PointNum) - xxdom(indX))/(xxdom(indX + 1) - xxdom(indX)))*SpeedZ(ind3)
      !xy2 = ((xxdom(indX + 1) - PositionXYZ_COPIA(1,PointNum))/(xxdom(indX + 1) - xxdom(indX)))*SpeedZ(ind2) + ((PositionXYZ_COPIA(1,PointNum) - xxdom(indX))/(xxdom(indX + 1) - xxdom(indX)))*SpeedZ(ind4)
      !Velocity(1,PointNum) = ((yydom(indY + 1 + xx1len) - PositionXYZ_COPIA(2,PointNum))/(yydom(indY + 1 + xx1len) - yydom(indY)))*xy1 + ((PositionXYZ_COPIA(2,PointNum) - yydom(indY))/(yydom(indY + 1 + xx1len) - yydom(indY)))*xy2
      !Velocity(2,PointNum) = 0.0
      !Velocity(3,PointNum) = 0.0

      xy1 = ((xxdom(indX + 1) - PositionXYZ_COPIA(1,PointNum))/(xxdom(indX + 1) - xxdom(indX)))*SpeedZ(ind1) + ((PositionXYZ_COPIA(1,PointNum) - xxdom(indX))/(xxdom(indX + 1) - xxdom(indX)))*SpeedZ(ind3)
      xy2 = ((xxdom(indX + 1) - PositionXYZ_COPIA(1,PointNum))/(xxdom(indX + 1) - xxdom(indX)))*SpeedZ(ind2) + ((PositionXYZ_COPIA(1,PointNum) - xxdom(indX))/(xxdom(indX + 1) - xxdom(indX)))*SpeedZ(ind4)
      Velocity(1,PointNum) = ((yydom(indY + xx1len) - PositionXYZ_COPIA(2,PointNum))/(yydom(indY + xx1len) - yydom(indY)))*xy1 + ((PositionXYZ_COPIA(2,PointNum) - yydom(indY))/(yydom(indY + xx1len) - yydom(indY)))*xy2
      Velocity(2,PointNum) = 0.0
      Velocity(3,PointNum) = 0.0

   ENDDO

   DEALLOCATE(SpeedZ)

   print*, k
   print*, Velocity
   print*, PositionXYZ
   print*, PositionXYZ_COPIA

   DiskVel(1) = 0.0 ! We'll be using AD15 for all the various calculations
   DiskVel(2) = 0.0
   DiskVel(3) = 0.0

   RETURN

END SUBROUTINE IfW_UserWind_CalcOutput

!====================================================================================================

!----------------------------------------------------------------------------------------------------
!>  This routine closes any open files and clears all data stored in UserWind derived Types
!!
!! @note  This routine does not satisfy the Modular framework.  The InputType is not used, rather
!!          an array of points is passed in. 
!! @date:  16-Apr-2013 - A. Platt, NREL.  Converted to modular framework. Modified for NWTC_Library 2.0
!----------------------------------------------------------------------------------------------------
SUBROUTINE IfW_UserWind_End( ParamData, MiscVars, ErrStat, ErrMsg)


   IMPLICIT                                                       NONE

   CHARACTER(*),           PARAMETER                           :: RoutineName="IfW_UserWind_End"


      ! Passed Variables
   TYPE(IfW_UserWind_ParameterType),            INTENT(INOUT)  :: ParamData         !< Parameters
   TYPE(IfW_UserWind_MiscVarType),              INTENT(INOUT)  :: MiscVars          !< Misc variables for optimization (not copied in glue code)


      ! Error Handling
   INTEGER(IntKi),                              INTENT(  OUT)  :: ErrStat           !< determines if an error has been encountered
   CHARACTER(*),                                INTENT(  OUT)  :: ErrMsg            !< Message about errors


      ! Local Variables
   INTEGER(IntKi)                                              :: TmpErrStat        ! temporary error status
   CHARACTER(ErrMsgLen)                                        :: TmpErrMsg         ! temporary error message


      !-=- Initialize the routine -=-

   ErrMsg   = ''
   ErrStat  = ErrID_None



      ! Destroy parameter data

   CALL IfW_UserWind_DestroyParam(       ParamData,     TmpErrStat, TmpErrMsg )
   CALL SetErrStat( TmpErrStat, TmpErrMsg, ErrStat, ErrMsg, RoutineName )


      ! Destroy the misc data

   CALL IfW_UserWind_DestroyMisc(  MiscVars,   TmpErrStat, TmpErrMsg )
   CALL SetErrStat( TmpErrStat, TmpErrMsg, ErrStat, ErrMsg, RoutineName )

   call ParamData%FLORIS_ROUTINE%destroy
   call ParamData%paths_w%destroy
   call forpy_finalize !CLOSE forpy communication module


END SUBROUTINE IfW_UserWind_End


!====================================================================================================
!====================================================================================================
!====================================================================================================
END MODULE IfW_UserWind
