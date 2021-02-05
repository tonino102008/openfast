#----------------------------------------------------------------
# Generated CMake target import file for configuration "Release".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "nwtclibs" for configuration "Release"
set_property(TARGET nwtclibs APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(nwtclibs PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "Fortran"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libnwtclibs.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS nwtclibs )
list(APPEND _IMPORT_CHECK_FILES_FOR_nwtclibs "${_IMPORT_PREFIX}/lib/libnwtclibs.a" )

# Import target "inflowwind_driver" for configuration "Release"
set_property(TARGET inflowwind_driver APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(inflowwind_driver PROPERTIES
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/bin/inflowwind_driver"
  )

list(APPEND _IMPORT_CHECK_TARGETS inflowwind_driver )
list(APPEND _IMPORT_CHECK_FILES_FOR_inflowwind_driver "${_IMPORT_PREFIX}/bin/inflowwind_driver" )

# Import target "ifwlib" for configuration "Release"
set_property(TARGET ifwlib APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(ifwlib PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "Fortran"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libifwlib.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS ifwlib )
list(APPEND _IMPORT_CHECK_FILES_FOR_ifwlib "${_IMPORT_PREFIX}/lib/libifwlib.a" )

# Import target "unsteadyaero_driver" for configuration "Release"
set_property(TARGET unsteadyaero_driver APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(unsteadyaero_driver PROPERTIES
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/bin/unsteadyaero_driver"
  )

list(APPEND _IMPORT_CHECK_TARGETS unsteadyaero_driver )
list(APPEND _IMPORT_CHECK_FILES_FOR_unsteadyaero_driver "${_IMPORT_PREFIX}/bin/unsteadyaero_driver" )

# Import target "aerodyn_driver" for configuration "Release"
set_property(TARGET aerodyn_driver APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(aerodyn_driver PROPERTIES
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/bin/aerodyn_driver"
  )

list(APPEND _IMPORT_CHECK_TARGETS aerodyn_driver )
list(APPEND _IMPORT_CHECK_FILES_FOR_aerodyn_driver "${_IMPORT_PREFIX}/bin/aerodyn_driver" )

# Import target "aerodynlib" for configuration "Release"
set_property(TARGET aerodynlib APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(aerodynlib PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "Fortran"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libaerodynlib.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS aerodynlib )
list(APPEND _IMPORT_CHECK_FILES_FOR_aerodynlib "${_IMPORT_PREFIX}/lib/libaerodynlib.a" )

# Import target "fvwlib" for configuration "Release"
set_property(TARGET fvwlib APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(fvwlib PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "Fortran"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libfvwlib.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS fvwlib )
list(APPEND _IMPORT_CHECK_FILES_FOR_fvwlib "${_IMPORT_PREFIX}/lib/libfvwlib.a" )

# Import target "uaaerolib" for configuration "Release"
set_property(TARGET uaaerolib APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(uaaerolib PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "Fortran"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libuaaerolib.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS uaaerolib )
list(APPEND _IMPORT_CHECK_FILES_FOR_uaaerolib "${_IMPORT_PREFIX}/lib/libuaaerolib.a" )

# Import target "afinfolib" for configuration "Release"
set_property(TARGET afinfolib APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(afinfolib PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "Fortran"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libafinfolib.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS afinfolib )
list(APPEND _IMPORT_CHECK_FILES_FOR_afinfolib "${_IMPORT_PREFIX}/lib/libafinfolib.a" )

# Import target "aeroacoustics" for configuration "Release"
set_property(TARGET aeroacoustics APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(aeroacoustics PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "Fortran"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libaeroacoustics.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS aeroacoustics )
list(APPEND _IMPORT_CHECK_FILES_FOR_aeroacoustics "${_IMPORT_PREFIX}/lib/libaeroacoustics.a" )

# Import target "aerodyn14lib" for configuration "Release"
set_property(TARGET aerodyn14lib APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(aerodyn14lib PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "Fortran"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libaerodyn14lib.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS aerodyn14lib )
list(APPEND _IMPORT_CHECK_FILES_FOR_aerodyn14lib "${_IMPORT_PREFIX}/lib/libaerodyn14lib.a" )

# Import target "servodynlib" for configuration "Release"
set_property(TARGET servodynlib APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(servodynlib PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "Fortran"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libservodynlib.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS servodynlib )
list(APPEND _IMPORT_CHECK_FILES_FOR_servodynlib "${_IMPORT_PREFIX}/lib/libservodynlib.a" )

# Import target "servodyn_driver" for configuration "Release"
set_property(TARGET servodyn_driver APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(servodyn_driver PROPERTIES
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/bin/servodyn_driver"
  )

list(APPEND _IMPORT_CHECK_TARGETS servodyn_driver )
list(APPEND _IMPORT_CHECK_FILES_FOR_servodyn_driver "${_IMPORT_PREFIX}/bin/servodyn_driver" )

# Import target "TMD" for configuration "Release"
set_property(TARGET TMD APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(TMD PROPERTIES
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/bin/TMD"
  )

list(APPEND _IMPORT_CHECK_TARGETS TMD )
list(APPEND _IMPORT_CHECK_FILES_FOR_TMD "${_IMPORT_PREFIX}/bin/TMD" )

# Import target "elastodynlib" for configuration "Release"
set_property(TARGET elastodynlib APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(elastodynlib PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "Fortran"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libelastodynlib.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS elastodynlib )
list(APPEND _IMPORT_CHECK_FILES_FOR_elastodynlib "${_IMPORT_PREFIX}/lib/libelastodynlib.a" )

# Import target "beamdynlib" for configuration "Release"
set_property(TARGET beamdynlib APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(beamdynlib PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "Fortran"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libbeamdynlib.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS beamdynlib )
list(APPEND _IMPORT_CHECK_FILES_FOR_beamdynlib "${_IMPORT_PREFIX}/lib/libbeamdynlib.a" )

# Import target "subdynlib" for configuration "Release"
set_property(TARGET subdynlib APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(subdynlib PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "Fortran"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libsubdynlib.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS subdynlib )
list(APPEND _IMPORT_CHECK_FILES_FOR_subdynlib "${_IMPORT_PREFIX}/lib/libsubdynlib.a" )

# Import target "subdyn_driver" for configuration "Release"
set_property(TARGET subdyn_driver APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(subdyn_driver PROPERTIES
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/bin/subdyn_driver"
  )

list(APPEND _IMPORT_CHECK_TARGETS subdyn_driver )
list(APPEND _IMPORT_CHECK_FILES_FOR_subdyn_driver "${_IMPORT_PREFIX}/bin/subdyn_driver" )

# Import target "hydrodynlib" for configuration "Release"
set_property(TARGET hydrodynlib APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(hydrodynlib PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "Fortran"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libhydrodynlib.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS hydrodynlib )
list(APPEND _IMPORT_CHECK_FILES_FOR_hydrodynlib "${_IMPORT_PREFIX}/lib/libhydrodynlib.a" )

# Import target "hydrodyn_driver" for configuration "Release"
set_property(TARGET hydrodyn_driver APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(hydrodyn_driver PROPERTIES
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/bin/hydrodyn_driver"
  )

list(APPEND _IMPORT_CHECK_TARGETS hydrodyn_driver )
list(APPEND _IMPORT_CHECK_FILES_FOR_hydrodyn_driver "${_IMPORT_PREFIX}/bin/hydrodyn_driver" )

# Import target "orcaflexlib" for configuration "Release"
set_property(TARGET orcaflexlib APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(orcaflexlib PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "Fortran"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/liborcaflexlib.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS orcaflexlib )
list(APPEND _IMPORT_CHECK_FILES_FOR_orcaflexlib "${_IMPORT_PREFIX}/lib/liborcaflexlib.a" )

# Import target "orca_driver" for configuration "Release"
set_property(TARGET orca_driver APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(orca_driver PROPERTIES
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/bin/orca_driver"
  )

list(APPEND _IMPORT_CHECK_TARGETS orca_driver )
list(APPEND _IMPORT_CHECK_FILES_FOR_orca_driver "${_IMPORT_PREFIX}/bin/orca_driver" )

# Import target "extptfm_mckflib" for configuration "Release"
set_property(TARGET extptfm_mckflib APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(extptfm_mckflib PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "Fortran"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libextptfm_mckflib.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS extptfm_mckflib )
list(APPEND _IMPORT_CHECK_FILES_FOR_extptfm_mckflib "${_IMPORT_PREFIX}/lib/libextptfm_mckflib.a" )

# Import target "openfoamtypeslib" for configuration "Release"
set_property(TARGET openfoamtypeslib APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(openfoamtypeslib PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "Fortran"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libopenfoamtypeslib.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS openfoamtypeslib )
list(APPEND _IMPORT_CHECK_FILES_FOR_openfoamtypeslib "${_IMPORT_PREFIX}/lib/libopenfoamtypeslib.a" )

# Import target "foamfastlib" for configuration "Release"
set_property(TARGET foamfastlib APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(foamfastlib PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "Fortran"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libfoamfastlib.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS foamfastlib )
list(APPEND _IMPORT_CHECK_FILES_FOR_foamfastlib "${_IMPORT_PREFIX}/lib/libfoamfastlib.a" )

# Import target "sctypeslib" for configuration "Release"
set_property(TARGET sctypeslib APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(sctypeslib PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "Fortran"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libsctypeslib.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS sctypeslib )
list(APPEND _IMPORT_CHECK_FILES_FOR_sctypeslib "${_IMPORT_PREFIX}/lib/libsctypeslib.a" )

# Import target "scfastlib" for configuration "Release"
set_property(TARGET scfastlib APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(scfastlib PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "Fortran"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libscfastlib.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS scfastlib )
list(APPEND _IMPORT_CHECK_FILES_FOR_scfastlib "${_IMPORT_PREFIX}/lib/libscfastlib.a" )

# Import target "openfastlib" for configuration "Release"
set_property(TARGET openfastlib APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(openfastlib PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "Fortran"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libopenfastlib.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS openfastlib )
list(APPEND _IMPORT_CHECK_FILES_FOR_openfastlib "${_IMPORT_PREFIX}/lib/libopenfastlib.a" )

# Import target "openfast_prelib" for configuration "Release"
set_property(TARGET openfast_prelib APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(openfast_prelib PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "Fortran"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libopenfast_prelib.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS openfast_prelib )
list(APPEND _IMPORT_CHECK_FILES_FOR_openfast_prelib "${_IMPORT_PREFIX}/lib/libopenfast_prelib.a" )

# Import target "openfast_postlib" for configuration "Release"
set_property(TARGET openfast_postlib APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(openfast_postlib PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "Fortran"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libopenfast_postlib.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS openfast_postlib )
list(APPEND _IMPORT_CHECK_FILES_FOR_openfast_postlib "${_IMPORT_PREFIX}/lib/libopenfast_postlib.a" )

# Import target "versioninfolib" for configuration "Release"
set_property(TARGET versioninfolib APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(versioninfolib PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "Fortran"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libversioninfolib.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS versioninfolib )
list(APPEND _IMPORT_CHECK_FILES_FOR_versioninfolib "${_IMPORT_PREFIX}/lib/libversioninfolib.a" )

# Import target "feamlib" for configuration "Release"
set_property(TARGET feamlib APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(feamlib PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "Fortran"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libfeamlib.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS feamlib )
list(APPEND _IMPORT_CHECK_FILES_FOR_feamlib "${_IMPORT_PREFIX}/lib/libfeamlib.a" )

# Import target "feam_driver" for configuration "Release"
set_property(TARGET feam_driver APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(feam_driver PROPERTIES
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/bin/feam_driver"
  )

list(APPEND _IMPORT_CHECK_TARGETS feam_driver )
list(APPEND _IMPORT_CHECK_FILES_FOR_feam_driver "${_IMPORT_PREFIX}/bin/feam_driver" )

# Import target "moordynlib" for configuration "Release"
set_property(TARGET moordynlib APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(moordynlib PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "Fortran"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libmoordynlib.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS moordynlib )
list(APPEND _IMPORT_CHECK_FILES_FOR_moordynlib "${_IMPORT_PREFIX}/lib/libmoordynlib.a" )

# Import target "icedynlib" for configuration "Release"
set_property(TARGET icedynlib APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(icedynlib PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "Fortran"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libicedynlib.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS icedynlib )
list(APPEND _IMPORT_CHECK_FILES_FOR_icedynlib "${_IMPORT_PREFIX}/lib/libicedynlib.a" )

# Import target "icefloelib" for configuration "Release"
set_property(TARGET icefloelib APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(icefloelib PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "Fortran"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libicefloelib.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS icefloelib )
list(APPEND _IMPORT_CHECK_FILES_FOR_icefloelib "${_IMPORT_PREFIX}/lib/libicefloelib.a" )

# Import target "maplib" for configuration "Release"
set_property(TARGET maplib APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(maplib PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "Fortran"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libmaplib.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS maplib )
list(APPEND _IMPORT_CHECK_FILES_FOR_maplib "${_IMPORT_PREFIX}/lib/libmaplib.a" )

# Import target "mapcpplib" for configuration "Release"
set_property(TARGET mapcpplib APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(mapcpplib PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "C;CXX;Fortran"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libmapcpplib.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS mapcpplib )
list(APPEND _IMPORT_CHECK_FILES_FOR_mapcpplib "${_IMPORT_PREFIX}/lib/libmapcpplib.a" )

# Import target "openfastcpplib" for configuration "Release"
set_property(TARGET openfastcpplib APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(openfastcpplib PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "CXX"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libopenfastcpplib.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS openfastcpplib )
list(APPEND _IMPORT_CHECK_FILES_FOR_openfastcpplib "${_IMPORT_PREFIX}/lib/libopenfastcpplib.a" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
