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
include glue-codes/openfast-cpp/CMakeFiles/openfastcpplib.dir/depend.make

# Include the progress variables for this target.
include glue-codes/openfast-cpp/CMakeFiles/openfastcpplib.dir/progress.make

# Include the compile flags for this target's objects.
include glue-codes/openfast-cpp/CMakeFiles/openfastcpplib.dir/flags.make

glue-codes/openfast-cpp/CMakeFiles/openfastcpplib.dir/src/OpenFAST.cpp.o: glue-codes/openfast-cpp/CMakeFiles/openfastcpplib.dir/flags.make
glue-codes/openfast-cpp/CMakeFiles/openfastcpplib.dir/src/OpenFAST.cpp.o: ../glue-codes/openfast-cpp/src/OpenFAST.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/antonio/OpenFAST/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object glue-codes/openfast-cpp/CMakeFiles/openfastcpplib.dir/src/OpenFAST.cpp.o"
	cd /home/antonio/OpenFAST/build/glue-codes/openfast-cpp && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/openfastcpplib.dir/src/OpenFAST.cpp.o -c /home/antonio/OpenFAST/glue-codes/openfast-cpp/src/OpenFAST.cpp

glue-codes/openfast-cpp/CMakeFiles/openfastcpplib.dir/src/OpenFAST.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/openfastcpplib.dir/src/OpenFAST.cpp.i"
	cd /home/antonio/OpenFAST/build/glue-codes/openfast-cpp && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/antonio/OpenFAST/glue-codes/openfast-cpp/src/OpenFAST.cpp > CMakeFiles/openfastcpplib.dir/src/OpenFAST.cpp.i

glue-codes/openfast-cpp/CMakeFiles/openfastcpplib.dir/src/OpenFAST.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/openfastcpplib.dir/src/OpenFAST.cpp.s"
	cd /home/antonio/OpenFAST/build/glue-codes/openfast-cpp && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/antonio/OpenFAST/glue-codes/openfast-cpp/src/OpenFAST.cpp -o CMakeFiles/openfastcpplib.dir/src/OpenFAST.cpp.s

# Object files for target openfastcpplib
openfastcpplib_OBJECTS = \
"CMakeFiles/openfastcpplib.dir/src/OpenFAST.cpp.o"

# External object files for target openfastcpplib
openfastcpplib_EXTERNAL_OBJECTS =

glue-codes/openfast-cpp/libopenfastcpplib.a: glue-codes/openfast-cpp/CMakeFiles/openfastcpplib.dir/src/OpenFAST.cpp.o
glue-codes/openfast-cpp/libopenfastcpplib.a: glue-codes/openfast-cpp/CMakeFiles/openfastcpplib.dir/build.make
glue-codes/openfast-cpp/libopenfastcpplib.a: glue-codes/openfast-cpp/CMakeFiles/openfastcpplib.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/antonio/OpenFAST/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX static library libopenfastcpplib.a"
	cd /home/antonio/OpenFAST/build/glue-codes/openfast-cpp && $(CMAKE_COMMAND) -P CMakeFiles/openfastcpplib.dir/cmake_clean_target.cmake
	cd /home/antonio/OpenFAST/build/glue-codes/openfast-cpp && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/openfastcpplib.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
glue-codes/openfast-cpp/CMakeFiles/openfastcpplib.dir/build: glue-codes/openfast-cpp/libopenfastcpplib.a

.PHONY : glue-codes/openfast-cpp/CMakeFiles/openfastcpplib.dir/build

glue-codes/openfast-cpp/CMakeFiles/openfastcpplib.dir/clean:
	cd /home/antonio/OpenFAST/build/glue-codes/openfast-cpp && $(CMAKE_COMMAND) -P CMakeFiles/openfastcpplib.dir/cmake_clean.cmake
.PHONY : glue-codes/openfast-cpp/CMakeFiles/openfastcpplib.dir/clean

glue-codes/openfast-cpp/CMakeFiles/openfastcpplib.dir/depend:
	cd /home/antonio/OpenFAST/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/antonio/OpenFAST /home/antonio/OpenFAST/glue-codes/openfast-cpp /home/antonio/OpenFAST/build /home/antonio/OpenFAST/build/glue-codes/openfast-cpp /home/antonio/OpenFAST/build/glue-codes/openfast-cpp/CMakeFiles/openfastcpplib.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : glue-codes/openfast-cpp/CMakeFiles/openfastcpplib.dir/depend

