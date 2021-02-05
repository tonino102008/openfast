# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.13

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/antonio/OpenFAST

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/antonio/OpenFAST/build

# Include any dependencies generated for this target.
include modules/openfoam/CMakeFiles/openfoamtypeslib.dir/depend.make

# Include the progress variables for this target.
include modules/openfoam/CMakeFiles/openfoamtypeslib.dir/progress.make

# Include the compile flags for this target's objects.
include modules/openfoam/CMakeFiles/openfoamtypeslib.dir/flags.make

modules/openfoam/OpenFOAM_Types.f90: modules/openfast-registry/openfast_registry
modules/openfoam/OpenFOAM_Types.f90: ../modules/openfoam/src/OpenFOAM_Registry.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --blue --bold --progress-dir=/home/antonio/OpenFAST/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Generating OpenFOAM_Types.f90"
	cd /home/antonio/OpenFAST/build/modules/openfoam && ../openfast-registry/openfast_registry /home/antonio/OpenFAST/modules/openfoam/src/OpenFOAM_Registry.txt -I /home/antonio/OpenFAST/modules/nwtc-library/src -I /home/antonio/OpenFAST/modules/inflowwind/src -I /home/antonio/OpenFAST/modules/aerodyn/src -I /home/antonio/OpenFAST/modules/aerodyn14/src -I /home/antonio/OpenFAST/modules/servodyn/src -I /home/antonio/OpenFAST/modules/elastodyn/src -I /home/antonio/OpenFAST/modules/beamdyn/src -I /home/antonio/OpenFAST/modules/subdyn/src -I /home/antonio/OpenFAST/modules/hydrodyn/src -I /home/antonio/OpenFAST/modules/orcaflex-interface/src -I /home/antonio/OpenFAST/modules/extptfm/src -I /home/antonio/OpenFAST/modules/openfoam/src -I /home/antonio/OpenFAST/modules/supercontroller/src -I /home/antonio/OpenFAST/modules/turbsim/src -I /home/antonio/OpenFAST/modules/openfast-library/src -I /home/antonio/OpenFAST/modules/version/src -I /home/antonio/OpenFAST/modules/feamooring/src -I /home/antonio/OpenFAST/modules/moordyn/src -I /home/antonio/OpenFAST/modules/icedyn/src -I /home/antonio/OpenFAST/modules/icefloe/src -I /home/antonio/OpenFAST/modules/map/src -I /home/antonio/OpenFAST/modules/icefloe/src/interfaces/FAST/ -ccode

modules/openfoam/CMakeFiles/openfoamtypeslib.dir/OpenFOAM_Types.f90.o: modules/openfoam/CMakeFiles/openfoamtypeslib.dir/flags.make
modules/openfoam/CMakeFiles/openfoamtypeslib.dir/OpenFOAM_Types.f90.o: modules/openfoam/OpenFOAM_Types.f90
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/antonio/OpenFAST/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building Fortran object modules/openfoam/CMakeFiles/openfoamtypeslib.dir/OpenFOAM_Types.f90.o"
	cd /home/antonio/OpenFAST/build/modules/openfoam && /usr/bin/gfortran $(Fortran_DEFINES) $(Fortran_INCLUDES) $(Fortran_FLAGS) -c /home/antonio/OpenFAST/build/modules/openfoam/OpenFOAM_Types.f90 -o CMakeFiles/openfoamtypeslib.dir/OpenFOAM_Types.f90.o

modules/openfoam/CMakeFiles/openfoamtypeslib.dir/OpenFOAM_Types.f90.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing Fortran source to CMakeFiles/openfoamtypeslib.dir/OpenFOAM_Types.f90.i"
	cd /home/antonio/OpenFAST/build/modules/openfoam && /usr/bin/gfortran $(Fortran_DEFINES) $(Fortran_INCLUDES) $(Fortran_FLAGS) -E /home/antonio/OpenFAST/build/modules/openfoam/OpenFOAM_Types.f90 > CMakeFiles/openfoamtypeslib.dir/OpenFOAM_Types.f90.i

modules/openfoam/CMakeFiles/openfoamtypeslib.dir/OpenFOAM_Types.f90.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling Fortran source to assembly CMakeFiles/openfoamtypeslib.dir/OpenFOAM_Types.f90.s"
	cd /home/antonio/OpenFAST/build/modules/openfoam && /usr/bin/gfortran $(Fortran_DEFINES) $(Fortran_INCLUDES) $(Fortran_FLAGS) -S /home/antonio/OpenFAST/build/modules/openfoam/OpenFOAM_Types.f90 -o CMakeFiles/openfoamtypeslib.dir/OpenFOAM_Types.f90.s

# Object files for target openfoamtypeslib
openfoamtypeslib_OBJECTS = \
"CMakeFiles/openfoamtypeslib.dir/OpenFOAM_Types.f90.o"

# External object files for target openfoamtypeslib
openfoamtypeslib_EXTERNAL_OBJECTS =

modules/openfoam/libopenfoamtypeslib.a: modules/openfoam/CMakeFiles/openfoamtypeslib.dir/OpenFOAM_Types.f90.o
modules/openfoam/libopenfoamtypeslib.a: modules/openfoam/CMakeFiles/openfoamtypeslib.dir/build.make
modules/openfoam/libopenfoamtypeslib.a: modules/openfoam/CMakeFiles/openfoamtypeslib.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/antonio/OpenFAST/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Linking Fortran static library libopenfoamtypeslib.a"
	cd /home/antonio/OpenFAST/build/modules/openfoam && $(CMAKE_COMMAND) -P CMakeFiles/openfoamtypeslib.dir/cmake_clean_target.cmake
	cd /home/antonio/OpenFAST/build/modules/openfoam && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/openfoamtypeslib.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
modules/openfoam/CMakeFiles/openfoamtypeslib.dir/build: modules/openfoam/libopenfoamtypeslib.a

.PHONY : modules/openfoam/CMakeFiles/openfoamtypeslib.dir/build

modules/openfoam/CMakeFiles/openfoamtypeslib.dir/clean:
	cd /home/antonio/OpenFAST/build/modules/openfoam && $(CMAKE_COMMAND) -P CMakeFiles/openfoamtypeslib.dir/cmake_clean.cmake
.PHONY : modules/openfoam/CMakeFiles/openfoamtypeslib.dir/clean

modules/openfoam/CMakeFiles/openfoamtypeslib.dir/depend: modules/openfoam/OpenFOAM_Types.f90
	cd /home/antonio/OpenFAST/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/antonio/OpenFAST /home/antonio/OpenFAST/modules/openfoam /home/antonio/OpenFAST/build /home/antonio/OpenFAST/build/modules/openfoam /home/antonio/OpenFAST/build/modules/openfoam/CMakeFiles/openfoamtypeslib.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : modules/openfoam/CMakeFiles/openfoamtypeslib.dir/depend

