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
include modules/subdyn/CMakeFiles/subdyn_driver.dir/depend.make

# Include the progress variables for this target.
include modules/subdyn/CMakeFiles/subdyn_driver.dir/progress.make

# Include the compile flags for this target's objects.
include modules/subdyn/CMakeFiles/subdyn_driver.dir/flags.make

modules/subdyn/CMakeFiles/subdyn_driver.dir/src/SubDyn_Driver.f90.o: modules/subdyn/CMakeFiles/subdyn_driver.dir/flags.make
modules/subdyn/CMakeFiles/subdyn_driver.dir/src/SubDyn_Driver.f90.o: ../modules/subdyn/src/SubDyn_Driver.f90
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/antonio/OpenFAST/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building Fortran object modules/subdyn/CMakeFiles/subdyn_driver.dir/src/SubDyn_Driver.f90.o"
	cd /home/antonio/OpenFAST/build/modules/subdyn && /usr/bin/gfortran $(Fortran_DEFINES) $(Fortran_INCLUDES) $(Fortran_FLAGS) -c /home/antonio/OpenFAST/modules/subdyn/src/SubDyn_Driver.f90 -o CMakeFiles/subdyn_driver.dir/src/SubDyn_Driver.f90.o

modules/subdyn/CMakeFiles/subdyn_driver.dir/src/SubDyn_Driver.f90.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing Fortran source to CMakeFiles/subdyn_driver.dir/src/SubDyn_Driver.f90.i"
	cd /home/antonio/OpenFAST/build/modules/subdyn && /usr/bin/gfortran $(Fortran_DEFINES) $(Fortran_INCLUDES) $(Fortran_FLAGS) -E /home/antonio/OpenFAST/modules/subdyn/src/SubDyn_Driver.f90 > CMakeFiles/subdyn_driver.dir/src/SubDyn_Driver.f90.i

modules/subdyn/CMakeFiles/subdyn_driver.dir/src/SubDyn_Driver.f90.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling Fortran source to assembly CMakeFiles/subdyn_driver.dir/src/SubDyn_Driver.f90.s"
	cd /home/antonio/OpenFAST/build/modules/subdyn && /usr/bin/gfortran $(Fortran_DEFINES) $(Fortran_INCLUDES) $(Fortran_FLAGS) -S /home/antonio/OpenFAST/modules/subdyn/src/SubDyn_Driver.f90 -o CMakeFiles/subdyn_driver.dir/src/SubDyn_Driver.f90.s

# Object files for target subdyn_driver
subdyn_driver_OBJECTS = \
"CMakeFiles/subdyn_driver.dir/src/SubDyn_Driver.f90.o"

# External object files for target subdyn_driver
subdyn_driver_EXTERNAL_OBJECTS =

modules/subdyn/subdyn_driver: modules/subdyn/CMakeFiles/subdyn_driver.dir/src/SubDyn_Driver.f90.o
modules/subdyn/subdyn_driver: modules/subdyn/CMakeFiles/subdyn_driver.dir/build.make
modules/subdyn/subdyn_driver: modules/subdyn/libsubdynlib.a
modules/subdyn/subdyn_driver: modules/nwtc-library/libnwtclibs.a
modules/subdyn/subdyn_driver: modules/version/libversioninfolib.a
modules/subdyn/subdyn_driver: /usr/lib/x86_64-linux-gnu/liblapack.so
modules/subdyn/subdyn_driver: /usr/lib/x86_64-linux-gnu/libblas.so
modules/subdyn/subdyn_driver: modules/subdyn/CMakeFiles/subdyn_driver.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/antonio/OpenFAST/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking Fortran executable subdyn_driver"
	cd /home/antonio/OpenFAST/build/modules/subdyn && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/subdyn_driver.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
modules/subdyn/CMakeFiles/subdyn_driver.dir/build: modules/subdyn/subdyn_driver

.PHONY : modules/subdyn/CMakeFiles/subdyn_driver.dir/build

modules/subdyn/CMakeFiles/subdyn_driver.dir/clean:
	cd /home/antonio/OpenFAST/build/modules/subdyn && $(CMAKE_COMMAND) -P CMakeFiles/subdyn_driver.dir/cmake_clean.cmake
.PHONY : modules/subdyn/CMakeFiles/subdyn_driver.dir/clean

modules/subdyn/CMakeFiles/subdyn_driver.dir/depend:
	cd /home/antonio/OpenFAST/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/antonio/OpenFAST /home/antonio/OpenFAST/modules/subdyn /home/antonio/OpenFAST/build /home/antonio/OpenFAST/build/modules/subdyn /home/antonio/OpenFAST/build/modules/subdyn/CMakeFiles/subdyn_driver.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : modules/subdyn/CMakeFiles/subdyn_driver.dir/depend

