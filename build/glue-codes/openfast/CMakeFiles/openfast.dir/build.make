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
include glue-codes/openfast/CMakeFiles/openfast.dir/depend.make

# Include the progress variables for this target.
include glue-codes/openfast/CMakeFiles/openfast.dir/progress.make

# Include the compile flags for this target's objects.
include glue-codes/openfast/CMakeFiles/openfast.dir/flags.make

glue-codes/openfast/CMakeFiles/openfast.dir/src/FAST_Prog.f90.o: glue-codes/openfast/CMakeFiles/openfast.dir/flags.make
glue-codes/openfast/CMakeFiles/openfast.dir/src/FAST_Prog.f90.o: ../glue-codes/openfast/src/FAST_Prog.f90
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/antonio/OpenFAST/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building Fortran object glue-codes/openfast/CMakeFiles/openfast.dir/src/FAST_Prog.f90.o"
	cd /home/antonio/OpenFAST/build/glue-codes/openfast && /usr/bin/gfortran $(Fortran_DEFINES) $(Fortran_INCLUDES) $(Fortran_FLAGS) -c /home/antonio/OpenFAST/glue-codes/openfast/src/FAST_Prog.f90 -o CMakeFiles/openfast.dir/src/FAST_Prog.f90.o

glue-codes/openfast/CMakeFiles/openfast.dir/src/FAST_Prog.f90.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing Fortran source to CMakeFiles/openfast.dir/src/FAST_Prog.f90.i"
	cd /home/antonio/OpenFAST/build/glue-codes/openfast && /usr/bin/gfortran $(Fortran_DEFINES) $(Fortran_INCLUDES) $(Fortran_FLAGS) -E /home/antonio/OpenFAST/glue-codes/openfast/src/FAST_Prog.f90 > CMakeFiles/openfast.dir/src/FAST_Prog.f90.i

glue-codes/openfast/CMakeFiles/openfast.dir/src/FAST_Prog.f90.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling Fortran source to assembly CMakeFiles/openfast.dir/src/FAST_Prog.f90.s"
	cd /home/antonio/OpenFAST/build/glue-codes/openfast && /usr/bin/gfortran $(Fortran_DEFINES) $(Fortran_INCLUDES) $(Fortran_FLAGS) -S /home/antonio/OpenFAST/glue-codes/openfast/src/FAST_Prog.f90 -o CMakeFiles/openfast.dir/src/FAST_Prog.f90.s

# Object files for target openfast
openfast_OBJECTS = \
"CMakeFiles/openfast.dir/src/FAST_Prog.f90.o"

# External object files for target openfast
openfast_EXTERNAL_OBJECTS =

glue-codes/openfast/openfast: glue-codes/openfast/CMakeFiles/openfast.dir/src/FAST_Prog.f90.o
glue-codes/openfast/openfast: glue-codes/openfast/CMakeFiles/openfast.dir/build.make
glue-codes/openfast/openfast: modules/openfast-library/libopenfast_postlib.a
glue-codes/openfast/openfast: modules/openfoam/libfoamfastlib.a
glue-codes/openfast/openfast: modules/supercontroller/libscfastlib.a
glue-codes/openfast/openfast: modules/openfast-library/libopenfast_prelib.a
glue-codes/openfast/openfast: modules/openfoam/libopenfoamtypeslib.a
glue-codes/openfast/openfast: modules/aerodyn/libaerodynlib.a
glue-codes/openfast/openfast: modules/aerodyn/libfvwlib.a
glue-codes/openfast/openfast: modules/aerodyn/libuaaerolib.a
glue-codes/openfast/openfast: modules/aerodyn/libaeroacoustics.a
glue-codes/openfast/openfast: modules/aerodyn/libafinfolib.a
glue-codes/openfast/openfast: modules/aerodyn14/libaerodyn14lib.a
glue-codes/openfast/openfast: modules/inflowwind/libifwlib.a
glue-codes/openfast/openfast: modules/elastodyn/libelastodynlib.a
glue-codes/openfast/openfast: modules/servodyn/libservodynlib.a
glue-codes/openfast/openfast: modules/beamdyn/libbeamdynlib.a
glue-codes/openfast/openfast: modules/subdyn/libsubdynlib.a
glue-codes/openfast/openfast: modules/hydrodyn/libhydrodynlib.a
glue-codes/openfast/openfast: modules/orcaflex-interface/liborcaflexlib.a
glue-codes/openfast/openfast: modules/extptfm/libextptfm_mckflib.a
glue-codes/openfast/openfast: modules/feamooring/libfeamlib.a
glue-codes/openfast/openfast: modules/moordyn/libmoordynlib.a
glue-codes/openfast/openfast: modules/icedyn/libicedynlib.a
glue-codes/openfast/openfast: modules/icefloe/libicefloelib.a
glue-codes/openfast/openfast: modules/map/libmaplib.a
glue-codes/openfast/openfast: modules/map/libmapcpplib.a
glue-codes/openfast/openfast: modules/supercontroller/libsctypeslib.a
glue-codes/openfast/openfast: modules/nwtc-library/libnwtclibs.a
glue-codes/openfast/openfast: /usr/lib/x86_64-linux-gnu/liblapack.so
glue-codes/openfast/openfast: /usr/lib/x86_64-linux-gnu/libblas.so
glue-codes/openfast/openfast: modules/version/libversioninfolib.a
glue-codes/openfast/openfast: glue-codes/openfast/CMakeFiles/openfast.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/antonio/OpenFAST/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking Fortran executable openfast"
	cd /home/antonio/OpenFAST/build/glue-codes/openfast && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/openfast.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
glue-codes/openfast/CMakeFiles/openfast.dir/build: glue-codes/openfast/openfast

.PHONY : glue-codes/openfast/CMakeFiles/openfast.dir/build

glue-codes/openfast/CMakeFiles/openfast.dir/clean:
	cd /home/antonio/OpenFAST/build/glue-codes/openfast && $(CMAKE_COMMAND) -P CMakeFiles/openfast.dir/cmake_clean.cmake
.PHONY : glue-codes/openfast/CMakeFiles/openfast.dir/clean

glue-codes/openfast/CMakeFiles/openfast.dir/depend:
	cd /home/antonio/OpenFAST/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/antonio/OpenFAST /home/antonio/OpenFAST/glue-codes/openfast /home/antonio/OpenFAST/build /home/antonio/OpenFAST/build/glue-codes/openfast /home/antonio/OpenFAST/build/glue-codes/openfast/CMakeFiles/openfast.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : glue-codes/openfast/CMakeFiles/openfast.dir/depend

