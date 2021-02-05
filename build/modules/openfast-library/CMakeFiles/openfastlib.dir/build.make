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
include modules/openfast-library/CMakeFiles/openfastlib.dir/depend.make

# Include the progress variables for this target.
include modules/openfast-library/CMakeFiles/openfastlib.dir/progress.make

# Include the compile flags for this target's objects.
include modules/openfast-library/CMakeFiles/openfastlib.dir/flags.make

modules/openfast-library/CMakeFiles/openfastlib.dir/src/FAST_Library.f90.o: modules/openfast-library/CMakeFiles/openfastlib.dir/flags.make
modules/openfast-library/CMakeFiles/openfastlib.dir/src/FAST_Library.f90.o: ../modules/openfast-library/src/FAST_Library.f90
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/antonio/OpenFAST/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building Fortran object modules/openfast-library/CMakeFiles/openfastlib.dir/src/FAST_Library.f90.o"
	cd /home/antonio/OpenFAST/build/modules/openfast-library && /usr/bin/gfortran $(Fortran_DEFINES) $(Fortran_INCLUDES) $(Fortran_FLAGS) -c /home/antonio/OpenFAST/modules/openfast-library/src/FAST_Library.f90 -o CMakeFiles/openfastlib.dir/src/FAST_Library.f90.o

modules/openfast-library/CMakeFiles/openfastlib.dir/src/FAST_Library.f90.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing Fortran source to CMakeFiles/openfastlib.dir/src/FAST_Library.f90.i"
	cd /home/antonio/OpenFAST/build/modules/openfast-library && /usr/bin/gfortran $(Fortran_DEFINES) $(Fortran_INCLUDES) $(Fortran_FLAGS) -E /home/antonio/OpenFAST/modules/openfast-library/src/FAST_Library.f90 > CMakeFiles/openfastlib.dir/src/FAST_Library.f90.i

modules/openfast-library/CMakeFiles/openfastlib.dir/src/FAST_Library.f90.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling Fortran source to assembly CMakeFiles/openfastlib.dir/src/FAST_Library.f90.s"
	cd /home/antonio/OpenFAST/build/modules/openfast-library && /usr/bin/gfortran $(Fortran_DEFINES) $(Fortran_INCLUDES) $(Fortran_FLAGS) -S /home/antonio/OpenFAST/modules/openfast-library/src/FAST_Library.f90 -o CMakeFiles/openfastlib.dir/src/FAST_Library.f90.s

# Object files for target openfastlib
openfastlib_OBJECTS = \
"CMakeFiles/openfastlib.dir/src/FAST_Library.f90.o"

# External object files for target openfastlib
openfastlib_EXTERNAL_OBJECTS =

modules/openfast-library/libopenfastlib.a: modules/openfast-library/CMakeFiles/openfastlib.dir/src/FAST_Library.f90.o
modules/openfast-library/libopenfastlib.a: modules/openfast-library/CMakeFiles/openfastlib.dir/build.make
modules/openfast-library/libopenfastlib.a: modules/openfast-library/CMakeFiles/openfastlib.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/antonio/OpenFAST/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX static library libopenfastlib.a"
	cd /home/antonio/OpenFAST/build/modules/openfast-library && $(CMAKE_COMMAND) -P CMakeFiles/openfastlib.dir/cmake_clean_target.cmake
	cd /home/antonio/OpenFAST/build/modules/openfast-library && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/openfastlib.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
modules/openfast-library/CMakeFiles/openfastlib.dir/build: modules/openfast-library/libopenfastlib.a

.PHONY : modules/openfast-library/CMakeFiles/openfastlib.dir/build

modules/openfast-library/CMakeFiles/openfastlib.dir/clean:
	cd /home/antonio/OpenFAST/build/modules/openfast-library && $(CMAKE_COMMAND) -P CMakeFiles/openfastlib.dir/cmake_clean.cmake
.PHONY : modules/openfast-library/CMakeFiles/openfastlib.dir/clean

modules/openfast-library/CMakeFiles/openfastlib.dir/depend:
	cd /home/antonio/OpenFAST/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/antonio/OpenFAST /home/antonio/OpenFAST/modules/openfast-library /home/antonio/OpenFAST/build /home/antonio/OpenFAST/build/modules/openfast-library /home/antonio/OpenFAST/build/modules/openfast-library/CMakeFiles/openfastlib.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : modules/openfast-library/CMakeFiles/openfastlib.dir/depend

