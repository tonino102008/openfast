# Install script for directory: /home/antonio/OpenFAST

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/home/antonio/OpenFAST/install")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Release")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "1")
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  EXECUTE_PROCESS (COMMAND "/usr/bin/cmake" -E copy_directory "/home/antonio/OpenFAST/build/ftnmods" "/usr/local/include/openfast/")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/OpenFAST/OpenFASTLibraries.cmake")
    file(DIFFERENT EXPORT_FILE_CHANGED FILES
         "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/OpenFAST/OpenFASTLibraries.cmake"
         "/home/antonio/OpenFAST/build/CMakeFiles/Export/lib/cmake/OpenFAST/OpenFASTLibraries.cmake")
    if(EXPORT_FILE_CHANGED)
      file(GLOB OLD_CONFIG_FILES "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/OpenFAST/OpenFASTLibraries-*.cmake")
      if(OLD_CONFIG_FILES)
        message(STATUS "Old export file \"$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/OpenFAST/OpenFASTLibraries.cmake\" will be replaced.  Removing files [${OLD_CONFIG_FILES}].")
        file(REMOVE ${OLD_CONFIG_FILES})
      endif()
    endif()
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/OpenFAST" TYPE FILE FILES "/home/antonio/OpenFAST/build/CMakeFiles/Export/lib/cmake/OpenFAST/OpenFASTLibraries.cmake")
  if("${CMAKE_INSTALL_CONFIG_NAME}" MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/OpenFAST" TYPE FILE FILES "/home/antonio/OpenFAST/build/CMakeFiles/Export/lib/cmake/OpenFAST/OpenFASTLibraries-release.cmake")
  endif()
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/OpenFAST" TYPE FILE FILES "/home/antonio/OpenFAST/build/OpenFASTConfig.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  include("/home/antonio/OpenFAST/build/modules/openfast-registry/cmake_install.cmake")
  include("/home/antonio/OpenFAST/build/modules/nwtc-library/cmake_install.cmake")
  include("/home/antonio/OpenFAST/build/modules/inflowwind/cmake_install.cmake")
  include("/home/antonio/OpenFAST/build/modules/aerodyn/cmake_install.cmake")
  include("/home/antonio/OpenFAST/build/modules/aerodyn14/cmake_install.cmake")
  include("/home/antonio/OpenFAST/build/modules/servodyn/cmake_install.cmake")
  include("/home/antonio/OpenFAST/build/modules/elastodyn/cmake_install.cmake")
  include("/home/antonio/OpenFAST/build/modules/beamdyn/cmake_install.cmake")
  include("/home/antonio/OpenFAST/build/modules/subdyn/cmake_install.cmake")
  include("/home/antonio/OpenFAST/build/modules/hydrodyn/cmake_install.cmake")
  include("/home/antonio/OpenFAST/build/modules/orcaflex-interface/cmake_install.cmake")
  include("/home/antonio/OpenFAST/build/modules/extptfm/cmake_install.cmake")
  include("/home/antonio/OpenFAST/build/modules/openfoam/cmake_install.cmake")
  include("/home/antonio/OpenFAST/build/modules/supercontroller/cmake_install.cmake")
  include("/home/antonio/OpenFAST/build/modules/turbsim/cmake_install.cmake")
  include("/home/antonio/OpenFAST/build/modules/openfast-library/cmake_install.cmake")
  include("/home/antonio/OpenFAST/build/modules/version/cmake_install.cmake")
  include("/home/antonio/OpenFAST/build/modules/feamooring/cmake_install.cmake")
  include("/home/antonio/OpenFAST/build/modules/moordyn/cmake_install.cmake")
  include("/home/antonio/OpenFAST/build/modules/icedyn/cmake_install.cmake")
  include("/home/antonio/OpenFAST/build/modules/icefloe/cmake_install.cmake")
  include("/home/antonio/OpenFAST/build/modules/map/cmake_install.cmake")
  include("/home/antonio/OpenFAST/build/glue-codes/cmake_install.cmake")

endif()

if(CMAKE_INSTALL_COMPONENT)
  set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INSTALL_COMPONENT}.txt")
else()
  set(CMAKE_INSTALL_MANIFEST "install_manifest.txt")
endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
file(WRITE "/home/antonio/OpenFAST/build/${CMAKE_INSTALL_MANIFEST}"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
