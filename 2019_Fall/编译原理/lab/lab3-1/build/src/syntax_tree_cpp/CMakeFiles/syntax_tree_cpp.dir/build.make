# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.5

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
CMAKE_SOURCE_DIR = /home/david/compiler_cminus/lab3-1

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/david/compiler_cminus/lab3-1/build

# Include any dependencies generated for this target.
include src/syntax_tree_cpp/CMakeFiles/syntax_tree_cpp.dir/depend.make

# Include the progress variables for this target.
include src/syntax_tree_cpp/CMakeFiles/syntax_tree_cpp.dir/progress.make

# Include the compile flags for this target's objects.
include src/syntax_tree_cpp/CMakeFiles/syntax_tree_cpp.dir/flags.make

src/syntax_tree_cpp/CMakeFiles/syntax_tree_cpp.dir/syntax_tree.cpp.o: src/syntax_tree_cpp/CMakeFiles/syntax_tree_cpp.dir/flags.make
src/syntax_tree_cpp/CMakeFiles/syntax_tree_cpp.dir/syntax_tree.cpp.o: ../src/syntax_tree_cpp/syntax_tree.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/david/compiler_cminus/lab3-1/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object src/syntax_tree_cpp/CMakeFiles/syntax_tree_cpp.dir/syntax_tree.cpp.o"
	cd /home/david/compiler_cminus/lab3-1/build/src/syntax_tree_cpp && /usr/bin/c++   $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/syntax_tree_cpp.dir/syntax_tree.cpp.o -c /home/david/compiler_cminus/lab3-1/src/syntax_tree_cpp/syntax_tree.cpp

src/syntax_tree_cpp/CMakeFiles/syntax_tree_cpp.dir/syntax_tree.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/syntax_tree_cpp.dir/syntax_tree.cpp.i"
	cd /home/david/compiler_cminus/lab3-1/build/src/syntax_tree_cpp && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/david/compiler_cminus/lab3-1/src/syntax_tree_cpp/syntax_tree.cpp > CMakeFiles/syntax_tree_cpp.dir/syntax_tree.cpp.i

src/syntax_tree_cpp/CMakeFiles/syntax_tree_cpp.dir/syntax_tree.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/syntax_tree_cpp.dir/syntax_tree.cpp.s"
	cd /home/david/compiler_cminus/lab3-1/build/src/syntax_tree_cpp && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/david/compiler_cminus/lab3-1/src/syntax_tree_cpp/syntax_tree.cpp -o CMakeFiles/syntax_tree_cpp.dir/syntax_tree.cpp.s

src/syntax_tree_cpp/CMakeFiles/syntax_tree_cpp.dir/syntax_tree.cpp.o.requires:

.PHONY : src/syntax_tree_cpp/CMakeFiles/syntax_tree_cpp.dir/syntax_tree.cpp.o.requires

src/syntax_tree_cpp/CMakeFiles/syntax_tree_cpp.dir/syntax_tree.cpp.o.provides: src/syntax_tree_cpp/CMakeFiles/syntax_tree_cpp.dir/syntax_tree.cpp.o.requires
	$(MAKE) -f src/syntax_tree_cpp/CMakeFiles/syntax_tree_cpp.dir/build.make src/syntax_tree_cpp/CMakeFiles/syntax_tree_cpp.dir/syntax_tree.cpp.o.provides.build
.PHONY : src/syntax_tree_cpp/CMakeFiles/syntax_tree_cpp.dir/syntax_tree.cpp.o.provides

src/syntax_tree_cpp/CMakeFiles/syntax_tree_cpp.dir/syntax_tree.cpp.o.provides.build: src/syntax_tree_cpp/CMakeFiles/syntax_tree_cpp.dir/syntax_tree.cpp.o


# Object files for target syntax_tree_cpp
syntax_tree_cpp_OBJECTS = \
"CMakeFiles/syntax_tree_cpp.dir/syntax_tree.cpp.o"

# External object files for target syntax_tree_cpp
syntax_tree_cpp_EXTERNAL_OBJECTS =

libsyntax_tree_cpp.a: src/syntax_tree_cpp/CMakeFiles/syntax_tree_cpp.dir/syntax_tree.cpp.o
libsyntax_tree_cpp.a: src/syntax_tree_cpp/CMakeFiles/syntax_tree_cpp.dir/build.make
libsyntax_tree_cpp.a: src/syntax_tree_cpp/CMakeFiles/syntax_tree_cpp.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/david/compiler_cminus/lab3-1/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX static library ../../libsyntax_tree_cpp.a"
	cd /home/david/compiler_cminus/lab3-1/build/src/syntax_tree_cpp && $(CMAKE_COMMAND) -P CMakeFiles/syntax_tree_cpp.dir/cmake_clean_target.cmake
	cd /home/david/compiler_cminus/lab3-1/build/src/syntax_tree_cpp && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/syntax_tree_cpp.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
src/syntax_tree_cpp/CMakeFiles/syntax_tree_cpp.dir/build: libsyntax_tree_cpp.a

.PHONY : src/syntax_tree_cpp/CMakeFiles/syntax_tree_cpp.dir/build

src/syntax_tree_cpp/CMakeFiles/syntax_tree_cpp.dir/requires: src/syntax_tree_cpp/CMakeFiles/syntax_tree_cpp.dir/syntax_tree.cpp.o.requires

.PHONY : src/syntax_tree_cpp/CMakeFiles/syntax_tree_cpp.dir/requires

src/syntax_tree_cpp/CMakeFiles/syntax_tree_cpp.dir/clean:
	cd /home/david/compiler_cminus/lab3-1/build/src/syntax_tree_cpp && $(CMAKE_COMMAND) -P CMakeFiles/syntax_tree_cpp.dir/cmake_clean.cmake
.PHONY : src/syntax_tree_cpp/CMakeFiles/syntax_tree_cpp.dir/clean

src/syntax_tree_cpp/CMakeFiles/syntax_tree_cpp.dir/depend:
	cd /home/david/compiler_cminus/lab3-1/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/david/compiler_cminus/lab3-1 /home/david/compiler_cminus/lab3-1/src/syntax_tree_cpp /home/david/compiler_cminus/lab3-1/build /home/david/compiler_cminus/lab3-1/build/src/syntax_tree_cpp /home/david/compiler_cminus/lab3-1/build/src/syntax_tree_cpp/CMakeFiles/syntax_tree_cpp.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : src/syntax_tree_cpp/CMakeFiles/syntax_tree_cpp.dir/depend

