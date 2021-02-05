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
   TYPE(IfW_UserWind_ParameterType),            INTENT(  OUT)  :: ParamData         !< Parameters.

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
   INTEGER(IntKi)                                              :: UnitLayout          ! Use this unit number if you need to read in a file.
   INTEGER(IntKi),            PARAMETER                        :: NumCols = 6       ! Number of columns in the Uniform file
   REAL(ReKi)                                                  :: TmpData(NumCols)  ! Temp variable for reading all columns from a line
   INTEGER(IntKi),            PARAMETER                        :: NumColsL = 5       ! Number of columns in the Uniform file
   REAL(ReKi)                                                  :: TmpDataL(NumColsL)  ! Temp variable for reading all columns from a line
   INTEGER(IntKi)                                              :: I
   INTEGER(IntKi)                                              :: NumComments
   INTEGER(IntKi)                                              :: NumLinesL
   INTEGER(IntKi)                                              :: ILine             ! Counts the line number in the file
   CHARACTER(1024)                                             :: Line              ! Temp variable for reading whole line from file

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

   CALL GetNewUnit(UnitLayout, TmpErrStat, TmpErrMsg)
   CALL SetErrStat(TmpErrStat,TmpErrMsg,ErrStat,ErrMsg,RoutineName)
   IF (ErrStat >= AbortErrLev) RETURN

      !-------------------------------------------------------------------------------------------------
      ! Open the file for reading.  Proceed with file parsing etc.  Populate your wind field here.
      !-------------------------------------------------------------------------------------------------

   CALL OpenFInpFile (UnitWind, TRIM(InitData%WindFileName), TmpErrStat, TmpErrMsg)
   CALL SetErrStat(TmpErrStat,TmpErrMsg,ErrStat,ErrMsg,RoutineName)
   IF ( ErrStat >= AbortErrLev ) RETURN

      !READING INPUT FILE FOR FLORIS ROUTINE PARAMETERS

   LINE = '!'                          ! Initialize the line for the DO WHILE LOOP
   NumComments = -1                    ! the last line we read is not a comment, so we'll initialize this to -1 instead of 0

   DO WHILE ( (INDEX( LINE, '!' ) > 0) .OR. (INDEX( LINE, '#' ) > 0) .OR. (INDEX( LINE, '%' ) > 0) ) ! Lines containing "!" are treated as comment lines
      NumComments = NumComments + 1

      READ(UnitWind,'( A )',IOSTAT=TmpErrStat) LINE

      IF ( TmpErrStat /=0 ) THEN
         CALL SetErrStat(ErrID_Fatal,' Error reading from FLORIS wind file on line '//TRIM(Num2LStr(NumComments+1))//'.',   &
               ErrStat, ErrMsg, RoutineName)
         CLOSE(UnitWind)
         RETURN
      END IF

   END DO !WHILE


      !-------------------------------------------------------------------------------------------------
      ! Find the number of data lines
      !-------------------------------------------------------------------------------------------------

   ParamData%NumDataLines = 0

   READ(LINE,*,IOSTAT=TmpErrStat) ( TmpData(I), I=1,NumCols ) ! this line was read when we were figuring out the comment lines; let's make sure it contains

   DO WHILE (TmpErrStat == 0)  ! read the rest of the file (until an error occurs)
      ParamData%NumDataLines = ParamData%NumDataLines + 1

      READ(UnitWind,*,IOSTAT=TmpErrStat) ( TmpData(I), I=1,NumCols )

   END DO !WHILE


   IF (ParamData%NumDataLines < 1) THEN
      TmpErrMsg=  'Error: '//TRIM(Num2LStr(NumComments))//' comment lines were found in the FLORIS wind file, '// &
                  'but the first data line does not contain the proper format.'
      CALL SetErrStat(ErrID_Fatal,TmpErrMsg,ErrStat,ErrMsg,RoutineName)
      CLOSE(UnitWind)
      RETURN
   END IF

   ! ALLOCATING ARRAYS TO STORE THE WIND PROPERTIES AND FARM LAYOUT

   IF (.NOT. ALLOCATED(ParamData%ti_par))   ALLOCATE(ParamData%ti_par(4))


   ! READING VALUES FROM FILE

   REWIND( UnitWind )

   DO I=1,NumComments
      CALL ReadCom( UnitWind, TRIM(InitData%WindFileName), 'Header line #'//TRIM(Num2LStr(I)), TmpErrStat, TmpErrMsg )
      CALL SetErrStat(TmpErrStat,TmpErrMsg,ErrStat,ErrMsg,RoutineName)
      IF ( ErrStat >= AbortErrLev ) THEN
         CLOSE(UnitWind)
         RETURN
      ENDIF
   END DO !I

   ! ASSIGNING DIRECTLY WIND PARAMETERS FROM THE FIRST TWO LINES THE FILE

   ParamData%dT = Interval

   CALL ReadAry( UnitWind, TRIM(InitData%WindFileName), TmpData(1:NumCols), NumCols, 'TmpData', &
                'Data from FLORIS wind file line '//TRIM(Num2LStr(NumComments+1)), TmpErrStat, TmpErrMsg)
      CALL SetErrStat(TmpErrStat,'Error retrieving data from the FLORIS wind file line'//TRIM(Num2LStr(NumComments+1)),   &
            ErrStat,ErrMsg,RoutineName)
      IF ( ErrStat >= AbortErrLev ) THEN
         CLOSE(UnitWind)
         RETURN
      ENDIF

   ParamData%Vb = TmpData(1)
   ParamData%z0 = TmpData(2)
   ParamData%zmin = TmpData(3)
   ParamData%WindDir = TmpData(4)
   ParamData%WindVeer = TmpData(5)
   ParamData%Ttot = TmpData(6)

   CALL ReadAry( UnitWind, TRIM(InitData%WindFileName), TmpData(1:NumCols-2), NumCols-2, 'TmpData', &
                'Data from FLORIS wind file line '//TRIM(Num2LStr(NumComments+2)), TmpErrStat, TmpErrMsg)
      CALL SetErrStat(TmpErrStat,'Error retrieving data from the FLORIS wind file line'//TRIM(Num2LStr(NumComments+1)),   &
            ErrStat,ErrMsg,RoutineName)
      IF ( ErrStat >= AbortErrLev ) THEN
         CLOSE(UnitWind)
         RETURN
      ENDIF

   ParamData%ka = TmpData(1)
   ParamData%kb = TmpData(2)
   ParamData%alpha = TmpData(3)
   ParamData%beta = TmpData(4)

   CALL ReadAry( UnitWind, TRIM(InitData%WindFileName), TmpData(1:NumCols-2), NumCols-2, 'TmpData', &
                'Data from FLORIS wind file line '//TRIM(Num2LStr(NumComments+3)), TmpErrStat, TmpErrMsg)
      CALL SetErrStat(TmpErrStat,'Error retrieving data from the FLORIS wind file line'//TRIM(Num2LStr(NumComments+1)),   &
            ErrStat,ErrMsg,RoutineName)
      IF ( ErrStat >= AbortErrLev ) THEN
         CLOSE(UnitWind)
         RETURN
      ENDIF

   ParamData%ti_par(1) = TmpData(1)
   ParamData%ti_par(2) = TmpData(2)
   ParamData%ti_par(3) = TmpData(3)
   ParamData%ti_par(4) = TmpData(4)

   CLOSE( UnitWind )

   !READING INPUT FILE FOR FLORIS ROUTINE PARAMETERS

   CALL OpenFInpFile (UnitLayout, TRIM(InitData%LayoutFileName), TmpErrStat, TmpErrMsg)
   CALL SetErrStat(TmpErrStat,TmpErrMsg,ErrStat,ErrMsg,RoutineName)
   IF ( ErrStat >= AbortErrLev ) RETURN

   LINE = '!'                          ! Initialize the line for the DO WHILE LOOP
   NumComments = -1                    ! the last line we read is not a comment, so we'll initialize this to -1 instead of 0

   DO WHILE ( (INDEX( LINE, '!' ) > 0) .OR. (INDEX( LINE, '#' ) > 0) .OR. (INDEX( LINE, '%' ) > 0) ) ! Lines containing "!" are treated as comment lines
      NumComments = NumComments + 1

      READ(UnitLayout,'( A )',IOSTAT=TmpErrStat) LINE

      IF ( TmpErrStat /=0 ) THEN
         CALL SetErrStat(ErrID_Fatal,' Error reading from FLORIS wind file on line '//TRIM(Num2LStr(NumComments+1))//'.',   &
               ErrStat, ErrMsg, RoutineName)
         CLOSE(UnitLayout)
         RETURN
      END IF

   END DO !WHILE


      !-------------------------------------------------------------------------------------------------
      ! Find the number of data lines
      !-------------------------------------------------------------------------------------------------

   NumLinesL = 0

   READ(LINE,*,IOSTAT=TmpErrStat) ( TmpDataL(I), I=1,NumColsL ) ! this line was read when we were figuring out the comment lines; let's make sure it contains

   DO WHILE (TmpErrStat == 0)  ! read the rest of the file (until an error occurs)
      NumLinesL = NumLinesL + 1

      READ(UnitLayout,*,IOSTAT=TmpErrStat) ( TmpDataL(I), I=1,NumColsL )

   END DO !WHILE


   IF (NumLinesL < 1) THEN
      TmpErrMsg=  'Error: '//TRIM(Num2LStr(NumComments))//' comment lines were found in the FLORIS wind file, '// &
                  'but the first data line does not contain the proper format.'
      CALL SetErrStat(ErrID_Fatal,TmpErrMsg,ErrStat,ErrMsg,RoutineName)
      CLOSE(UnitLayout)
      RETURN
   END IF

   ! ALLOCATING ARRAYS TO STORE THE WIND PROPERTIES AND FARM LAYOUT

   IF (.NOT. ALLOCATED(ParamData%zhub))   ALLOCATE(ParamData%zhub(NumLinesL))
   IF (.NOT. ALLOCATED(ParamData%drot))   ALLOCATE(ParamData%drot(NumLinesL))
   IF (.NOT. ALLOCATED(ParamData%Layout)) ALLOCATE(ParamData%Layout(NumLinesL,3))

   ! READING VALUES FROM FILE

   REWIND( UnitLayout )

   DO I=1,NumComments
      CALL ReadCom( UnitLayout, TRIM(InitData%LayoutFileName), 'Header line #'//TRIM(Num2LStr(I)), TmpErrStat, TmpErrMsg )
      CALL SetErrStat(TmpErrStat,TmpErrMsg,ErrStat,ErrMsg,RoutineName)
      IF ( ErrStat >= AbortErrLev ) THEN
         CLOSE(UnitLayout)
         RETURN
      ENDIF
   END DO !I

   DO I=1,NumLinesL

      CALL ReadAry( UnitLayout, TRIM(InitData%LayoutFileName), TmpDataL(1:NumColsL), NumColsL, 'TmpData', &
                'Data from FLORIS wind file line '//TRIM(Num2LStr(NumComments+I)), TmpErrStat, TmpErrMsg)
      CALL SetErrStat(TmpErrStat,'Error retrieving data from the FLORIS wind file line'//TRIM(Num2LStr(NumComments+I)),   &
            ErrStat,ErrMsg,RoutineName)
      IF ( ErrStat >= AbortErrLev ) THEN
         CLOSE(UnitLayout)
         RETURN
      ENDIF

      ParamData%Layout(I,1) = TmpDataL(1)
      ParamData%Layout(I,2) = TmpDataL(2)
      ParamData%Layout(I,3) = TmpDataL(3)
      ParamData%zhub(I)     = TmpDataL(4)
      ParamData%drot(I)     = TmpDataL(5)

   END DO !I

   CLOSE( UnitLayout )

   ! PRINTING MY FARM LAYOUT TO VERIFY CORRECT READING OF INPUT FILE
   print*, "INPUT FILE PER INFLOW WIND + FARM LAYOUT"
   print*, ParamData%Layout
   print*, ParamData%zhub
   print*, ParamData%drot
   print*, ParamData%Vb, ParamData%z0, ParamData%zmin, ParamData%WindDir, ParamData%WindVeer
   print*, ParamData%ka, ParamData%kb, ParamData%alpha, ParamData%beta
   print*, ParamData%dT, ParamData%Ttot
   print*, ParamData%ti_par
   print*, ParamData%NumDataLines
   print*, MiscVars%BlPos
   print*, TRIM(InitData%WindFileName)
   print*, "END OF INPUT FILE PER INFLOW WIND + FARM LAYOUT"

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
   REAL(ReKi),                                  INTENT(IN   )  :: PositionXYZ(:,:)  !< Array of XYZ coordinates, 3xN
   TYPE(IfW_UserWind_ParameterType),            INTENT(IN   )  :: ParamData         !< Parameters
   REAL(ReKi),                                  INTENT(INOUT)  :: Velocity(:,:)     !< Velocity output at Time    (Set to INOUT so that array does not get deallocated)
   REAL(ReKi),                                  INTENT(  OUT)  :: DiskVel(3)        !< HACK for AD14: disk velocity output at Time
   TYPE(IfW_UserWind_MiscVarType),              INTENT(INOUT)  :: MiscVars          !< Misc variables for optimization (not copied in glue code)

      ! Error handling
   INTEGER(IntKi),                              INTENT(  OUT)  :: ErrStat           !< error status
   CHARACTER(*),                                INTENT(  OUT)  :: ErrMsg            !< The error message


      ! local counters
   INTEGER(IntKi)                                              :: PointNum          ! a loop counter for the current point
   INTEGER(IntKi)                                              :: i, j
   INTEGER(IntKi), DIMENSION(:), ALLOCATABLE, SAVE             :: k
   INTEGER(IntKi), DIMENSION(:), ALLOCATABLE                   :: turb_loc

      ! local variables
   INTEGER(IntKi)                                              :: NumPoints         ! Number of points passed in
   REAL(ReKi)                                                  :: tmpwinddir, I0, dist_wake    ! Wind Parameters
   REAL(ReKi)                                                  :: IntArea, IntAreaTurb, Aint   ! Wind Parameters
   REAL(ReKi)                                                  :: VelWake, Iadd, kr
   REAL(ReKi), DIMENSION(:),   ALLOCATABLE, SAVE               :: Ctin, gammain, ain !, I0vec  ! Turbine Parameters OpenFast order
   REAL(ReKi), DIMENSION(:),   ALLOCATABLE                     :: Ct, gammat, a, I0vec  ! Turbine Parameters Layout WindDir order
   REAL(ReKi), DIMENSION(:,:), ALLOCATABLE                     :: RotLayout, SortLayout
   REAL(ReKi), DIMENSION(:,:), ALLOCATABLE                     :: wakeveccalcpos, windentrypos
   REAL(ReKi), DIMENSION(:,:), ALLOCATABLE                     :: layoutpos, IaddTurb
   REAL(ReKi), DIMENSION(2)                                    :: d_wake
   REAL(ReKi), DIMENSION(3)                                    :: tmpPos, tmpVel, PositionXYZin

      ! temporary variables
   INTEGER(IntKi)                                              :: TmpErrStat        ! temporary error status
   CHARACTER(ErrMsgLen)                                        :: TmpErrMsg         ! temporary error message



      !-------------------------------------------------------------------------------------------------
      ! Initialize some things
      !-------------------------------------------------------------------------------------------------

   ErrStat     = ErrID_None
   ErrMsg      = ""

      ! The array is transposed so that the number of points is the second index, x/y/z is the first.
      ! This is just in case we only have a single point, the SIZE command returns the correct number of points.
   NumPoints   =  SIZE(PositionXYZ,DIM=2)

   IF (.NOT. ALLOCATED(k)) THEN
      ALLOCATE(k(4))
      ALLOCATE(Ctin   (SIZE(ParamData%Layout(:,1))))
      ALLOCATE(ain    (SIZE(ParamData%Layout(:,1))))
      ALLOCATE(gammain(SIZE(ParamData%Layout(:,1))))
      !ALLOCATE(I0vec  (SIZE(ParamData%Layout(:,1))))

      k(1) = 1     ! TURB AT THIS STEP
      k(2) = SIZE(ParamData%Layout(:,1))
      k(3) = 0 ! LASCIA COSI CHE AL PRIMO CICLO FA UNA CHIAMATA IN PIU, CONTROLLA DA EWIND.TXT CHE SIA GIUSTO
      k(4) = 2 ! n° of calls made from INFLOW WIND TO MY ROUTINE

      Ctin = 0.0 ! INITIALIZING VECTORS THAT MUST BE SAVED
      ain = 0.0
      gammain = 0.0
      !I0vec = 0.0
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

   !THIS SECTION HAS TO BE MOVED IN THE ABOVE CYCLE--> INFLOW WIND makes 2 calls for turbine!!!!
   IF (k(3) == 1) THEN
      tmpwinddir = (ParamData%WindDir -  270) * (ACOS(-1.0) / 180.0)   !SET WIND AND WAKE ANGLE
      IF (ABS(tmpwinddir) < 1e-2) tmpwinddir = 0.0
      Ctin(k(1)) = MiscVars%AllInAD(28)
      CALL RotAvgAxInd(MiscVars%AllInAD(1:27), MiscVars%BlPos, MiscVars%BlOutNd, ain(k(1)))
      gammain(k(1)) = MiscVars%YawAngle !+ tmpwinddir  ! YAW OF SINGLE TURBINES
      IF (ABS(gammain(k(1))) < 1e-2) gammain(k(1)) = 0.0
      !I0vec(k(1)) = 1 / LOG(ParamData%zhub(k(1)) / ParamData%z0)
   END IF

   print*, "CT, GAMMA, AX. IND. + I0 from AERODYN+SERVODYN", Ctin, gammain, ain
   print*, "CT, GAMMA, AX. IND. + I0 from AERODYN+SERVODYN", SIZE(Ctin)
   print*, "CT, GAMMA, AX. IND. + I0 from AERODYN+SERVODYN", SIZE(gammain)
   print*, "CT, GAMMA, AX. IND. + I0 from AERODYN+SERVODYN", SIZE(ain)
   read(*,*)
   
   !TO LET FIRST ITERATION ADVANCE --> DUMMY VALUES OF Ct And Ax.Ind.
   DO i = 1, k(2)
      IF (ABS(Ctin(i)) < 1e-2) Ctin(i) = 0.89
      IF (ABS(ain(i)) < 1e-2) ain(i) = 0.334
   ENDDO

   print*, "CT, GAMMA, AX. IND. + I0 from AERODYN+SERVODYN", Ctin, gammain, ain
   print*, "CT, GAMMA, AX. IND. + I0 from AERODYN+SERVODYN", SIZE(Ctin)
   print*, "CT, GAMMA, AX. IND. + I0 from AERODYN+SERVODYN", SIZE(gammain)
   print*, "CT, GAMMA, AX. IND. + I0 from AERODYN+SERVODYN", SIZE(ain)
   read(*,*)

   ALLOCATE(Ct            (SIZE(ParamData%Layout(:,1))))
   ALLOCATE(a             (SIZE(ParamData%Layout(:,1))))
   ALLOCATE(gammat        (SIZE(ParamData%Layout(:,1))))
   ALLOCATE(turb_loc      (SIZE(ParamData%Layout(:,1))))
   ALLOCATE(RotLayout     (SIZE(ParamData%Layout(:,1)), SIZE(ParamData%Layout(:,2))))
   ALLOCATE(SortLayout    (SIZE(ParamData%Layout(:,1)), SIZE(ParamData%Layout(:,2))))
   ALLOCATE(IaddTurb      (SIZE(ParamData%Layout(:,1)), SIZE(ParamData%Layout(:,2))))
   ALLOCATE(windentrypos  (SIZE(ParamData%Layout(:,1)), SIZE(ParamData%Layout(:,2))))
   ALLOCATE(wakeveccalcpos(SIZE(ParamData%Layout(:,1)), SIZE(ParamData%Layout(:,2))))
   ALLOCATE(layoutpos     (SIZE(ParamData%Layout(:,1)), SIZE(ParamData%Layout(:,2))))
   ALLOCATE(I0vec         (SIZE(ParamData%Layout(:,1))))

   windentrypos = 0.0
   wakeveccalcpos = 0.0
   I0vec = 0.0
   IaddTurb = 0.0
   I0vec(1) = 1 / LOG(ParamData%zhub(1) / ParamData%z0)

   !LOGARITHMIC WIND PROFILE CODE
   kr = 0.19 * ((ParamData%z0 / 0.05) ** 0.07)
   IF (ParamData%zhub(k(1)) > ParamData%zmin) THEN
      windentrypos(1,1) = ParamData%Vb * kr * LOG(ParamData%zhub(k(1))/ParamData%z0)
   ELSE
      windentrypos(1,1) = ParamData%Vb * kr * LOG(ParamData%zmin/ParamData%z0)
   END IF

   CALL RotLayoutAndSort(ParamData%Layout, tmpwinddir, Rotlayout, Sortlayout, Ctin, ain, gammain, &
   & Ct, a, gammat, turb_loc) ! ROTATING layouts in wind direction + sorting all the turbines by x-rotated-axis

   print*, "TURBOLENZA IMBOCCO NEL PUNTO RICHIESTO", IaddTurb(1,:)
   print*, "TURBOLENZA IMBOCCO NEL PUNTO RICHIESTO", IaddTurb(2,:)
   print*, "TURBOLENZA IMBOCCO NEL PUNTO RICHIESTO", IaddTurb(3,:)

   !IF (k(3) == 1) THEN
      DO i = 1, turb_loc(k(1)) - 1          !  EVALUATING SPEED AT TURBINES INLET AT (Y,Z) coord required by USER TO OBTAIN AddedTurbulence
         I0 = 1 / LOG(ParamData%zhub(i) / ParamData%z0)
         DO j = i + 1, turb_loc(k(1))  
            print*, windentrypos(i,i)
            CALL RotoTransPoint(Sortlayout(j,:), 0.0, tmpPos, - Sortlayout(i,:))    ! ROTATE ASKED POINT FROM GLOBAL SDR TO WAKE SDR TO COMPUTE u(x,y,z)
            tmpPos(3) = ParamData%zhub(j)
            CALL WindCalc(Ct(i), gammat(i), ParamData%zhub(i), ParamData%drot(i), windentrypos(i,i), I0vec(i), ParamData%ka, &
            & ParamData%kb, ParamData%alpha, ParamData%beta, ParamData%WindVeer, tmpPos, tmpVel, d_wake, dist_wake)
            wakeveccalcpos(i,j) = (1 - (tmpVel(1)/windentrypos(i,i))) ** 2
            CALL IntersectArea(d_wake / 2, ParamData%drot(i) / 2, dist_wake, gammat(j) - gammat(i), IntArea, IntAreaTurb, Aint)

            IF ((((tmpPos(1) ** 2) + (tmpPos(2) ** 2)) ** 0.5) <= (15 * ParamData%drot(i)) .AND. &       ! ASSESSING THAT UPSTREAM TURBINE IS IN RANGE OF MODEL VALIDITY
            & (dist_wake < (2 * ParamData%drot(i))) .AND. (tmpPos(1) > 0.0)) THEN                       ! AND THAT THE TURBINE/POINT CONSIDERED IS EFFECTIVELY DOWNSTREAM
               CALL AddedTurb(I0, (((tmpPos(1) ** 2) + (tmpPos(2) ** 2)) ** 0.5), ParamData%drot(j), a(i), ParamData%ti_par, Aint, Iadd)
               IaddTurb(i,j) = Iadd ** 2
            END IF

            print*, "TURBOLENZA IMBOCCO NEL PUNTO RICHIESTO", IaddTurb(1,:)
            print*, "TURBOLENZA IMBOCCO NEL PUNTO RICHIESTO", IaddTurb(2,:)
            print*, "TURBOLENZA IMBOCCO NEL PUNTO RICHIESTO", IaddTurb(3,:)
            print*, "VEL, Dwake, AREA INTERSECT", tmpVel, d_wake, Aint, IntAreaTurb, gammat
            print*, "J + LAYOUT", j, tmpPos, dist_wake
            print*, "WAKECALCPOS", wakeveccalcpos(1,:)
            print*, "WAKECALCPOS", wakeveccalcpos(2,:)
            print*, "WAKECALCPOS", wakeveccalcpos(3,:)
         ENDDO
         windentrypos(i +1,i + 1) = - (((SUM(wakeveccalcpos(:,i + 1)) ** 0.5) * windentrypos(1,1)) - windentrypos(1,1))
         I0vec(i + 1) = ((I0 ** 2) + SUM(IaddTurb(:, i + 1))) ** 0.5      !SUM UP ALL THE ADDED TURB FROM ALL UPSTREAM TURBINES
         print*, "VELOCITA IMBOCCO NEL PUNTO RICHIESTO", windentrypos(1,:)
         print*, "VELOCITA IMBOCCO NEL PUNTO RICHIESTO", windentrypos(2,:)
         print*, "VELOCITA IMBOCCO NEL PUNTO RICHIESTO", windentrypos(3,:)
      ENDDO
   !END IF

   DO PointNum = 1, NumPoints

      DO i = 2, SIZE(layoutpos, 2)
         layoutpos(i,2:3) = PositionXYZ(2:3,PointNum)
      ENDDO

      layoutpos(:,1) = ParamData%Layout(:,1)
      print*, "LAYOUT POS, ATTENZIONE!!!!", PositionXYZ(:,PointNum)   ! PARTO DA j = i+1 --> NO PROBLEM
      print*, "LAYOUT POS", layoutpos(1,:)
      print*, "LAYOUT POS", layoutpos(2,:)
      print*, "LAYOUT POS", layoutpos(3,:)            ! RIGA SOTTO: SE TURBINA E' YAWED DEVI ANCHE RUOTARE QUEI PUNTI!!! (SE OPENFAST TE LI PASSA NON RUOTATI CON LO YAW!!) USA ROUTINE DI ROTAZIONE
      CALL RotoTransPoint(PositionXYZ(:,PointNum), gammat(k(1)), tmpPos)
      print*, " POSPOSPOS NON ROT", tmpPos  
      !PositionXYZin = PositionXYZ(:,PointNum) + layout(turb,:) !layout(turb_loc(turb),:)  ! STAI ATTENTO turb o turb_loc(turb)???
      PositionXYZin = tmpPos + ParamData%Layout(k(1),:) !layout(turb_loc(turb),:)  ! STAI ATTENTO turb o turb_loc(turb)???
      print*, " POSPOSPOS NON ROT", PositionXYZin
      VelWake = 0.0
      windentrypos = windentrypos*0.0
      
      !LOGARITHMIC WIND PROFILE CODE

      kr = 0.19 * ((ParamData%z0 / 0.05) ** 0.07)
      IF (PositionXYZin(3) > ParamData%zmin) THEN
         windentrypos(1,1) = ParamData%Vb * kr * LOG(PositionXYZin(3)/ParamData%z0)
      ELSE
         windentrypos(1,1) = ParamData%Vb * kr * LOG(ParamData%zmin / ParamData%z0)
      END IF
      print*, windentrypos
      wakeveccalcpos = wakeveccalcpos*0.0

      DO i = 1, turb_loc(k(1)) - 1  !turb !turb_loc(turb) - 1   !  EVALUATING SPEED AT TURBINES INLET AT (Y,Z) coord required by USER
         print*, i
         DO j = i + 1, turb_loc(k(1))  !turb !turb_loc(turb)
            print*, windentrypos(i,i)
            !CALL RotoTransPoint(layoutpos(j,:) - layout(i,:), tmpwinddir, tmpPos)     ! ROTATE ASKED POINT FROM GLOBAL SDR TO WAKE SDR TO COMPUTE u(x,y,z)
            CALL RotoTransPoint(layoutpos(j,:), tmpwinddir, tmpPos)  
            tmpPos = tmpPos - Sortlayout(i,:)
            CALL WindCalc(Ct(i), gammat(i), ParamData%zhub(i), ParamData%drot(i), windentrypos(i,i), I0vec(i), ParamData%ka, &
            & ParamData%kb, ParamData%alpha, ParamData%beta, ParamData%WindVeer, tmpPos, tmpVel, d_wake, dist_wake)
            wakeveccalcpos(i,j) = (1 - (tmpVel(1)/windentrypos(i,i))) ** 2
            print*, "J + LAYOUT", j, tmpPos, dist_wake
            print*, "WAKECALCPOS", wakeveccalcpos(1,:)
            print*, "WAKECALCPOS", wakeveccalcpos(2,:)
            print*, "WAKECALCPOS", wakeveccalcpos(3,:)
         ENDDO
         windentrypos(i + 1, i + 1) = - (((SUM(wakeveccalcpos(:,i + 1)) ** 0.5) * windentrypos(1,1)) - windentrypos(1,1))
         print*, "VELOCITA IMBOCCO NEL PUNTO RICHIESTO", windentrypos(1,:)
         print*, "VELOCITA IMBOCCO NEL PUNTO RICHIESTO", windentrypos(2,:)
         print*, "VELOCITA IMBOCCO NEL PUNTO RICHIESTO", windentrypos(3,:)
      ENDDO
      read(*,*)


      DO i = 1, k(2)                            !  EVALUATING SPEED AT (Y,Z) coord required by USER               
      CALL RotoTransPoint(PositionXYZin, tmpwinddir, tmpPos)     ! ROTATE ASKED POINT FROM GLOBAL SDR TO WAKE SDR TO COMPUTE u(x,y,z)
         IF (tmpPos(1) > Sortlayout(i,1)) THEN
            CALL RotoTransPoint(PositionXYZin - ParamData%Layout(i,:), tmpwinddir, tmpPos)     ! ROTATE ASKED POINT FROM GLOBAL SDR TO WAKE SDR TO COMPUTE u(x,y,z)
            CALL WindCalc(Ct(i), gammat(i), ParamData%zhub(i), ParamData%drot(i), windentrypos(i,i), I0vec(i), ParamData%ka, &
            & ParamData%kb, ParamData%alpha, ParamData%beta, ParamData%WindVeer, tmpPos, tmpVel, d_wake, dist_wake)
            Velwake = VelWake + (1 - (tmpVel(1)/windentrypos(i,i))) ** 2
            print*, tmpvel, VelWake
            print*, windentrypos(i,i)
            print*, i
            print*, PositionXYZin - ParamData%Layout(i,:)
         END IF
      ENDDO
      VelWake = -(((VelWake**0.5) * windentrypos(1,1)) - windentrypos(1,1))
      !CALL TurbWind(I0mem(turb_loc(turb)), VelWake, tmpPos(3), z_hub/EXP(1/alpha_w), 0.005, 300.0, 15.0, &
      !& Phasevec(turb_loc(turb), (PointNum * 3) - 2:PointNum * 3,:), TurbVel) !z_hub/EXP(1/alpha_w)
      !CALL RotoTransPoint((/VelWake, 0.0, 0.0/) + TurbVel, - gammat(turb_loc(k(1))), tmpVel)     ! ROTATE ASKED POINT FROM WAKE SDR TO TURBINE(YAWED!!!!) SDR TO COMPUTE u(x,y,z)
      CALL RotoTransPoint((/VelWake, 0.0, 0.0/), - gammat(turb_loc(k(1))), tmpVel)     ! ROTATE ASKED POINT FROM WAKE SDR TO TURBINE(YAWED!!!!) SDR TO COMPUTE u(x,y,z)
      Velocity(:,PointNum) = tmpVel
      print*, "Punto RICHIESTO", PositionXYZin
      print*, "Punto RICHIESTO RUOTATO", tmpPos
      print*, "TOTAL TURBULENCE", I0vec
      print*, "VELOCITA NEL PUNTO RICHIESTO", VelWake
      !print*, "VELOCITA NEL PUNTO RICHIESTO: SDR LOCALE", (/VelWake, 0.0, 0.0/) + TurbVel
      print*, "VELOCITA NEL PUNTO RICHIESTO: SDR GLOBALE", tmpVel
      read(*,*)
   ENDDO

   DEALLOCATE(Ct)
   DEALLOCATE(a)
   DEALLOCATE(gammat)
   DEALLOCATE(turb_loc)
   DEALLOCATE(RotLayout)
   DEALLOCATE(SortLayout)
   DEALLOCATE(IaddTurb)
   DEALLOCATE(windentrypos)
   DEALLOCATE(wakeveccalcpos)
   DEALLOCATE(layoutpos)
   DEALLOCATE(I0vec)

      ! an average wind speed, required for AD14
   DiskVel = 0.0_ReKi

   RETURN

   CONTAINS
      SUBROUTINE WindCalc(Ct, gamma, z_hub, d_rot, Uinf_w, I0, ka, kb, alpha, beta, &
         & veer, PositionXYZ, Velocity, d_wake, dist_wake)

         IMPLICIT                                                       NONE
      
         CHARACTER(*),           PARAMETER                           :: RoutineName="WindCalc"


         REAL(ReKi),                             INTENT(IN   )  :: Ct, gamma, z_hub, d_rot, Uinf_w
         REAL(ReKi),                             INTENT(IN   )  :: I0, ka, kb, alpha, beta, veer     
         REAL(ReKi),                             INTENT(IN   )  :: PositionXYZ(:)  
         REAL(ReKi),                             INTENT(INOUT)  :: Velocity(:)
         REAL(ReKi), DIMENSION(2),               INTENT(  OUT)  :: d_wake
         REAL(ReKi),                             INTENT(  OUT)  :: dist_wake   
         

         REAL(ReKi)                                             :: ky, kz, C0, M0, E0, x0, theta, delta0
         REAL(ReKi)                                             :: U_init, U0, UR, sigmaz0, sigmay0, sigmaz, sigmay, C, delta
         REAL(ReKi)                                             :: deltalognum, deltalogdenum, a1, b1, c1, sy, sz
         REAL(ReKi)                                             :: y_pc, z_pc, y_pc_int, z_pc_int, delta_pc, a1_pc, b1_pc, c1_pc

         ky = ka*I0 + kb
         kz = ka*I0 + kb

         C0 = 1 - ((1 - (Ct * COS(gamma))) ** 0.5)
         M0 = C0 * (2 - C0)
         E0 = (C0 ** 2) - (3 * EXP(1.0/12.0) * C0) + (3 * EXP(1.0/3.0))

         x0 = (d_rot * COS(gamma) * ((1 + (1 - Ct) ** 0.5))) / ((2 ** 0.5) * (4 * alpha * I0 + 2 * beta * C0))
         theta = (0.3 * gamma * (1 - ((1- Ct * COS(gamma)) ** 0.5))) / COS(gamma)  !REMEMBER EVERYTHING IN RADIANS
         delta0 = x0 * TAN(theta)

         U_init = Uinf_w
         U0 = U_init * ((1 - Ct) ** 0.5)
         UR = (U_init * Ct * COS(gamma)) / (2 * (1 - ((1- Ct * COS(gamma)) ** 0.5)))

         sigmaz0 = d_rot * ((UR / (U_init + U0)) ** 0.5) / 2
         sigmay0 = sigmaz0 * COS(gamma) * COS(veer)
         sigmaz = kz * (PositionXYZ(1) - x0) + sigmaz0
         sigmay = ky * (PositionXYZ(1) - x0) + sigmay0

         C = 1 - ((1 - ((sigmay0 * sigmaz0 * M0) / (sigmay * sigmaz)) ) ** 0.5)
         deltalognum = (1.6 + (M0 ** 0.5)) * (1.6 * (((sigmay * sigmaz)/(sigmay0 * sigmaz0)) ** 0.5) - (M0 ** 0.5))

         deltalogdenum = (1.6 - (M0 ** 0.5)) * (1.6 * (((sigmay * sigmaz)/(sigmay0 * sigmaz0)) ** 0.5) + (M0 ** 0.5))
         delta = delta0 + (theta * E0 / 5.2) * (((sigmay0 * sigmaz0) / (ky * kz * M0)) ** 0.5) * LOG(deltalognum / deltalogdenum)

         a1 = ((COS(veer) ** 2) / (2 * (sigmay ** 2))) + ((SIN(veer) ** 2) / (2 * (sigmaz ** 2)))
         b1 = (-(SIN(2 * veer)) / (4 * (sigmay ** 2))) + ((SIN(2 * veer)) / (4 * (sigmaz ** 2)))
         c1 = ((SIN(veer) ** 2) / (2 * (sigmay ** 2))) + ((COS(veer) ** 2) / (2 * (sigmaz ** 2)))

         IF (PositionXYZ(1) <= x0 .AND. PositionXYZ(1) > 10.0) THEN

            ! NEAR-WAKE SECTION
            y_pc = (d_rot / 2) * COS(gamma) * ((UR/U0) ** 0.5)
            z_pc = (d_rot / 2) * ((UR/U0) ** 0.5)
            y_pc_int = ((x0 - PositionXYZ(1)) / x0) * y_pc
            z_pc_int = ((x0 - PositionXYZ(1)) / x0) * z_pc
            sy = PositionXYZ(1) * (sigmay0 / x0)
            sz = PositionXYZ(1) * (sigmaz0 / x0)
            delta_pc = PositionXYZ(1) * TAN(theta)
            a1_pc = ((COS(veer) ** 2) / (2 * (sy ** 2))) + ((SIN(veer) ** 2) / (2 * (sz ** 2)))
            b1_pc = (-(SIN(2 * veer)) / (4 * (sy ** 2))) + ((SIN(2 * veer)) / (4 * (sz ** 2)))
            c1_pc = ((SIN(veer) ** 2) / (2 * (sy ** 2))) + ((COS(veer) ** 2) / (2 * (sz ** 2)))

            IF ((ABS(PositionXYZ(2)) <= (y_pc_int + delta_pc)) .AND. ((ABS(PositionXYZ(3)) - z_hub <= z_pc_int))) THEN
               Velocity(1) = Uinf_w * (1 - C0)
               Velocity(2) = 0.0
               Velocity(3) = 0.0
            ELSEIF (ABS(PositionXYZ(2)) > y_pc_int + delta_pc) THEN
               Velocity(1) = Uinf_w * (1 - C0 * EXP(-(a1_pc * ((PositionXYZ(2) - y_pc_int - delta_pc) ** 2) )))
               Velocity(2) = 0.0
               Velocity(3) = 0.0
            ELSEIF (ABS(PositionXYZ(3)) - z_hub > z_pc_int) THEN
               Velocity(1) = Uinf_w * (1 - C0 * EXP(-(c1_pc * ((PositionXYZ(3) - z_pc_int - z_hub) ** 2) )))
               Velocity(2) = 0.0
               Velocity(3) = 0.0
            ELSE
               Velocity(1) = Uinf_w * (1 - C0 * EXP(-(a1_pc * ((PositionXYZ(2) - y_pc_int - delta_pc) ** 2) - 2 * b1_pc * (PositionXYZ(2) - y_pc_int - delta_pc) * (PositionXYZ(3) - z_pc_int - z_hub) + c1_pc * ((PositionXYZ(3) - z_pc_int - z_hub) ** 2))))
               Velocity(2) = 0.0
               Velocity(3) = 0.0
            END IF

            d_wake(1) = 4.0 * sy
            d_wake(2) = 4.0 * sz
            dist_wake = ABS(PositionXYZ(2) + delta_pc)

         ELSEIF (PositionXYZ(1) > x0) THEN

            ! FAR WAKE SECTION
            Velocity(1) = U_init * (1 - C * EXP(-(a1 * ((PositionXYZ(2) - delta) ** 2) - 2 * b1 * (PositionXYZ(2) - delta) * &
            &(PositionXYZ(3) - z_hub) + c1 * ((PositionXYZ(3) - z_hub) ** 2))))
            Velocity(2) = 0.0
            Velocity(3) = 0.0
            
            d_wake(1) = 4.0 * sigmay
            d_wake(2) = 4.0 * sigmaz
            dist_wake = ABS(PositionXYZ(2) + delta)

         ELSE
            
            Velocity(1) = U_init
            Velocity(2) = 0.0
            Velocity(3) = 0.0

            d_wake(1) = 0.0
            d_wake(2) = 0.0
            dist_wake = 2.5 * d_rot ! TO AVOID FAKE WAKE INTERSECTION


         END IF

         RETURN

      END SUBROUTINE WindCalc

      SUBROUTINE IntersectArea(r1, r2, d, gamma, IntArea, IntAreaTurb, Aint)
         IMPLICIT                                                       NONE

         CHARACTER(*),           PARAMETER                           :: RoutineName="IntersectArea"

         REAL(ReKi),                         INTENT(IN   )                 :: r2, d, gamma
         REAL(ReKi), DIMENSION(2),           INTENT(IN   )                 :: r1
         REAL(ReKi),                         INTENT(  OUT)                 :: IntArea, IntAreaTurb, Aint

         REAL(ReKi)                                                        :: d1, Area1, Area2, aeq, beq, ceq

         ! r1(:) is the wake axes > r2 turbine radius
         ! r1(1) is along y-direction, r2(2) is along z-direction
         ! Supposing Turbines have same hub height
         ! GAMMA IS relative angle between turbine 1 wake ellipsis plane and turbine 2 rotor ellipsis on the wake plane

         aeq = (r1(1) ** 2) - ((r1(2) * COS(gamma)) ** 2)
         beq = - 2 * d * (r1(1) ** 2)
         ceq = (r1(1) ** 2) * ((d ** 2) + (COS(gamma) ** 2) * ((r1(2) ** 2) - (r2 ** 2)))

         IF (ABS(aeq) <= 0.01 .AND. (ABS(d) >= 0.01)) THEN
            d1 = ((d ** 2) + ((r1(2) * COS(gamma)) ** 2) - ((r2 * COS(gamma)) ** 2)) / (2 * d)
         ELSEIF (ABS(d) <= 0.01) THEN
            d1 = MIN(r1(1), r2 * COS(gamma)) ! r1(:) > r2 Quindi prendo il raggio minimo
         ELSE
            d1 = (- (beq / (2 * aeq))) - (((beq ** 2) - (4 * aeq * ceq)) ** 0.5) / (2 * aeq)
         END IF

         IF (d >= (r1(1) + r2 * COS(gamma))) THEN
            IntArea = 0.0
            IntAreaTurb = 0.0
            Aint = 0.0
         ELSEIF (d <= (r1(1) - r2 * COS(gamma))) THEN
            IntArea = ACOS(-1.0) * (r2 * r2 * COS(gamma))
            IntAreaTurb = ACOS(-1.0) * (r2 * r2 * COS(gamma))
            Aint = 1.0
         ELSE
            Area1 = ((r1(1) * r1(2)) * ACOS(d1 / r1(1))) - ((d1 * r1(2)) / (r1(1))) * (((r1(1) ** 2) - (d1 ** 2)) ** 0.5)
            Area2 = ((r2 ** 2) * COS(gamma) * ACOS((d - d1) / (r2 * COS(gamma)))) - (d - d1) * (((((r2 * COS(gamma)) ** 2) - &
            & ((d - d1) ** 2)) / (COS(gamma) ** 2)) ** 0.5)
            IntArea = Area1 + Area2
            IntAreaTurb = Area2
            AInt = IntAreaTurb / (ACOS(-1.0) * (r2 * r2 * COS(gamma)))
         END IF

         RETURN

      END SUBROUTINE IntersectArea

      SUBROUTINE RotoTransPoint(Original, angle, Rotated, displ)
         IMPLICIT                                                       NONE

         CHARACTER(*),           PARAMETER                           :: RoutineName="RotatePoint"

         REAL(ReKi), DIMENSION(3),           INTENT(IN   )                 :: Original
         REAL(ReKi), DIMENSION(3), OPTIONAL, INTENT(IN   )                 :: displ
         REAL(ReKi),                         INTENT(IN   )                 :: angle
         REAL(ReKi), DIMENSION(3),           INTENT(  OUT)                 :: Rotated
         
         REAL(ReKi), DIMENSION(3)                                          :: disp

         IF (PRESENT(displ)) THEN
            disp = displ
         ELSE
            disp = 0.0
         END IF

         ! Rotation and Translation in z-plane

         Rotated(1) = disp(1) + Original(1) * COS(angle) - Original(2) * SIN(angle)
         Rotated(2) = disp(2) + Original(1) * SIN(angle) + Original(2) * COS(angle)
         Rotated(3) = disp(3) + Original(3)
         
         print*, "ORIGINAL", Original
         print*, "ROTATED", Rotated

         RETURN

      END SUBROUTINE RotoTransPoint

      SUBROUTINE AddedTurb(I0, x, d_rot, a, ti_par, Aint, Iadd)
         IMPLICIT                                                       NONE

         CHARACTER(*),           PARAMETER                           :: RoutineName="AddedTurb"

         REAL(ReKi),                     INTENT(IN   )                 :: I0, x, d_rot, a, Aint
         REAL(ReKi), DIMENSION(4),       INTENT(IN   )                 :: ti_par
         REAL(ReKi),                     INTENT(  OUT)                 :: Iadd
         
         ! ADDED TURBULENCE AT DOWNSTREAM TURBINES

         Iadd = (ti_par(1) * (a ** ti_par(2)) * (I0 ** ti_par(3)) * ((x / d_rot) ** ti_par(4))) * Aint

         RETURN

      END SUBROUTINE AddedTurb   
      
      SUBROUTINE RotLayoutAndSort(layout, winddir, Rotlayout, Sortlayout, Ctin, ain, gammain, Ctout, aout, &
         & gammaout, turb_loc)
         IMPLICIT                                                       NONE

         CHARACTER(*),           PARAMETER                           :: RoutineName="RotLayoutAndSort"

         REAL(ReKi),                     INTENT(IN   )                 :: layout(:,:), Ctin(:)
         REAL(ReKi),                     INTENT(IN   )                 :: winddir, ain(:), gammain(:)
         REAL(ReKi), DIMENSION(SIZE(layout(:,1)), SIZE(layout(:,2))),        INTENT(  OUT)                 :: Rotlayout
         REAL(ReKi), DIMENSION(SIZE(layout(:,1)), SIZE(layout(:,2))),        INTENT(  OUT)                 :: Sortlayout
         REAL(ReKi), DIMENSION(SIZE(layout(:,1))),                           INTENT(  OUT)                 :: Ctout, aout, gammaout
         INTEGER(IntKi), DIMENSION(SIZE(layout(:,1))),                        INTENT(  OUT)                 :: turb_loc

         INTEGER(IntKi)                                                 :: i
         INTEGER(IntKi), DIMENSION(SIZE(layout(:,1)))                   :: turb
         LOGICAL, DIMENSION(SIZE(layout(:,1)))                   :: SortInd
         
         ! Rotate turbines in wind direction
         ! Sort turbine based on x-axis-rotated to find upstream-downstream relations

         DO i = 1, SIZE(layout(:,1))
            CALL RotoTransPoint(layout(i,:), winddir, Rotlayout(i,:))
            turb(i) = i
         ENDDO

         sortInd = .TRUE.
         Sortlayout(:,3) = 0.0
         

         DO i = 1, SIZE(layout(:,1))
            Sortlayout(i,1) = MINVAL(Rotlayout(:,1), SortInd)
            Sortlayout(i,2) = Rotlayout(MINLOC(Rotlayout(:,1), 1, SortInd),2)
            Ctout(i) = Ctin(MINLOC(Rotlayout(:,1), 1, SortInd))
            aout(i) = ain(MINLOC(Rotlayout(:,1), 1, SortInd))
            gammaout(i) = gammain(MINLOC(Rotlayout(:,1), 1, SortInd))
            turb_loc(i) = turb(MINLOC(Rotlayout(:,1), 1, SortInd))
            SortInd(MINLOC(Rotlayout(:,1), 1, SortInd)) = .FALSE.
         END DO

         RETURN

      END SUBROUTINE RotLayoutAndSort  
      
      SUBROUTINE TurbWind(Iu, U, z, z0, dt, T, Time, Phasevec, TurbVel)
         IMPLICIT                                                       NONE

         CHARACTER(*),           PARAMETER                           :: RoutineName="TurbWind"

         REAL(ReKi),                     INTENT(IN   )                 :: Iu, U, z, z0, dt, T, Time, Phasevec(:,:)     !, Pos(:,:)
         REAL(ReKi),DIMENSION(3),        INTENT(  OUT)                 :: TurbVel !(:,:)
         
         REAL(ReKi), DIMENSION(3)                                      :: Ivec, sigmavec, Lvec
         REAL(ReKi)                                                    :: alpha, freq, fs, f0, dist
         INTEGER(IntKi)                                                 :: i
         REAL(ReKi), DIMENSION(INT(T/(dt * 2)))                        :: freqvec, coherence, Spectra
         REAL(ReKi), DIMENSION(3, INT(T/(dt * 2)))                     :: Spectravec, Ampvec

         ! EVALUATING THE TURBOLENCE VALUE AT TIME T_i in required position
         ! These parameters could be also assumed to be f(z_hub)
         ! dt = sampling rate    T = total simulation time    Time = actual time for which the sample is required
         ! U = hub height wind speed --> from this I apply on the whole rotor the coherence function to evaluate turbolences that are correlated in space

         fs = 1/dt
         f0 = 1/T

         Ivec(1) = Iu
         Ivec(2) = Ivec(1) * 0.75
         Ivec(3) = Ivec(1) * 0.5

         sigmavec(1) = Ivec(1) * U
         sigmavec(2) = sigmavec(1) * 0.75
         sigmavec(3) = sigmavec(1) * 0.5

         alpha = 0.67 + (0.05 * LOG(z0))
         Lvec(1) = 300 * ((z / 200) ** alpha)
         Lvec(2) = Lvec(1) * 0.25
         Lvec(3) = Lvec(1) * 0.1

         DO i = 1, SIZE(freqvec)     ! EVALUATING SPECTRA AND AMPLITUDES AT Pos = (0,0,z_hub) for current turbine
            freqvec(i) = i * f0
            Spectravec(1,i) = (4 * (sigmavec(1) ** 2) * (Lvec(1) / U)) / &
            & ((1 + (70.8 * (((freqvec(i) * Lvec(1)) / U) ** 2))) ** (5.0/6.0))
            Spectravec(2,i) = (4 * (sigmavec(2) ** 2) * (Lvec(2) / U) * (1 + (755.2 * (((freqvec(i) * Lvec(2)) / U) ** 2)))) / &
            & ((1 + (283.2 * (((freqvec(i) * Lvec(2)) / U) ** 2))) ** (11.0/6.0))
            Spectravec(3,i) = (4 * (sigmavec(3) ** 2) * (Lvec(3) / U) * (1 + (755.2 * (((freqvec(i) * Lvec(3)) / U) ** 2)))) / &
            & ((1 + (283.2 * (((freqvec(i) * Lvec(3)) / U) ** 2))) ** (11.0/6.0))
            Ampvec(1,i) = (Spectravec(1,i) * f0 * 2) ** 0.5
            Ampvec(2,i) = (Spectravec(2,i) * f0 * 2) ** 0.5
            Ampvec(3,i) = (Spectravec(3,i) * f0 * 2) ** 0.5
         ENDDO

         TurbVel(1) = SUM(AmpVec(1,:) * SIN(2 * ACOS(-1.0) * freqvec * Time + Phasevec(1,:)))
         TurbVel(2) = SUM(AmpVec(2,:) * SIN(2 * ACOS(-1.0) * freqvec * Time + Phasevec(2,:)))
         TurbVel(3) = SUM(AmpVec(3,:) * SIN(2 * ACOS(-1.0) * freqvec * Time + Phasevec(3,:)))
         print*, "TURBULENT VELOCITY ADDED                                          ", TurbVel

         RETURN

      END SUBROUTINE TurbWind

      SUBROUTINE RotAvgAxInd(AxIndR, BlPos, BlOutNd, AvgAxInd)
         IMPLICIT                                                       NONE

         CHARACTER(*),           PARAMETER                           :: RoutineName="RotAvgAxInd"

         REAL(ReKi),                     INTENT(IN   )               :: AxIndR(:), BlPos(:,:)
         INTEGER(IntKi),                 INTENT(IN   )               :: BlOutNd(:)
         REAL(ReKi),                     INTENT(  OUT)               :: AvgAxInd

         INTEGER(IntKi)                                              :: i, j
         INTEGER(IntKi)                                              :: NBl = 3
         INTEGER(IntKi)                                              :: NBlNodes
         REAL(ReKi), DIMENSION(3,9)                                  :: AxIndRBl
         REAL(ReKi)                                                  :: RSum
         
         ! ROTOR AVERAGED AXIAL INDUCTION FACTOR

         NBlNodes = SIZE(BlOutNd)
         AvgAxInd = 0.0
         RSum = 0.0
         AxIndRBl(1,:) = AxIndR(1:9)
         AxIndRBl(2,:) = AxIndR(10:18)
         AxIndRBl(3,:) = AxIndR(19:27)

         DO i = 1, NBl
            DO j = 1, NBlNodes
               AvgAxInd = AvgAxInd + AxIndRBl(i,j) * BlPos(i,BlOutNd(j))
               RSum = RSum +  BlPos(i,BlOutNd(j))
            ENDDO
         ENDDO

         AvgAxInd = AvgAxInd / RSum

         RETURN

      END SUBROUTINE RotAvgAxInd

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


END SUBROUTINE IfW_UserWind_End


!====================================================================================================
!====================================================================================================
!====================================================================================================
END MODULE IfW_UserWind
