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
include deps/analyzer/CMakeFiles/syntax.dir/depend.make

# Include the progress variables for this target.
include deps/analyzer/CMakeFiles/syntax.dir/progress.make

# Include the compile flags for this target's objects.
include deps/analyzer/CMakeFiles/syntax.dir/flags.make

deps/analyzer/CMakeFiles/syntax.dir/syntax_analyzer.tab.c.o: deps/analyzer/CMakeFiles/syntax.dir/flags.make
deps/analyzer/CMakeFiles/syntax.dir/syntax_analyzer.tab.c.o: ../deps/analyzer/syntax_analyzer.tab.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/david/compiler_cminus/lab3-1/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building C object deps/analyzer/CMakeFiles/syntax.dir/syntax_analyzer.tab.c.o"
	cd /home/david/compiler_cminus/lab3-1/build/deps/analyzer && /usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/syntax.dir/syntax_analyzer.tab.c.o   -c /home/david/compiler_cminus/lab3-1/deps/analyzer/syntax_analyzer.tab.c

deps/analyzer/CMakeFiles/syntax.dir/syntax_analyzer.tab.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/syntax.dir/syntax_analyzer.tab.c.i"
	cd /home/david/compiler_cminus/lab3-1/build/deps/analyzer && /usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/david/compiler_cminus/lab3-1/deps/analyzer/syntax_analyzer.tab.c > CMakeFiles/syntax.dir/syntax_analyzer.tab.c.i

deps/analyzer/CMakeFiles/syntax.dir/syntax_analyzer.tab.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/syntax.dir/syntax_analyzer.tab.c.s"
	cd /home/david/compiler_cminus/lab3-1/build/deps/analyzer && /usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/david/compiler_cminus/lab3-1/deps/analyzer/syntax_analyzer.tab.c -o CMakeFiles/syntax.dir/syntax_analyzer.tab.c.s

deps/analyzer/CMakeFiles/syntax.dir/syntax_analyzer.tab.c.o.requires:

.PHONY : deps/analyzer/CMakeFiles/syntax.dir/syntax_analyzer.tab.c.o.requires

deps/analyzer/CMakeFiles/syntax.dir/syntax_analyzer.tab.c.o.provides: deps/analyzer/CMakeFiles/syntax.dir/syntax_analyzer.tab.c.o.requires
	$(MAKE) -f deps/analyzer/CMakeFiles/syntax.dir/build.make deps/analyzer/CMakeFiles/syntax.dir/syntax_analyzer.tab.c.o.provides.build
.PHONY : deps/analyzer/CMakeFiles/syntax.dir/syntax_analyzer.tab.c.o.provides

deps/analyzer/CMakeFiles/syntax.dir/syntax_analyzer.tab.c.o.provides.build: deps/analyzer/CMakeFiles/syntax.dir/syntax_analyzer.tab.c.o


# Object files for target syntax
syntax_OBJECTS = \
"CMakeFiles/syntax.dir/syntax_analyzer.tab.c.o"

# External object files for target syntax
syntax_EXTERNAL_OBJECTS =

deps/analyzer/libsyntax.a: deps/analyzer/CMakeFiles/syntax.dir/syntax_analyzer.tab.c.o
deps/analyzer/libsyntax.a: deps/analyzer/CMakeFiles/syntax.dir/build.make
deps/analyzer/libsyntax.a: deps/analyzer/CMakeFiles/syntax.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/david/compiler_cminus/lab3-1/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking C static library libsyntax.a"
	cd /home/david/compiler_cminus/lab3-1/build/deps/analyzer && $(CMAKE_COMMAND) -P CMakeFiles/syntax.dir/cmake_clean_target.cmake
	cd /home/david/compiler_cminus/lab3-1/build/deps/analyzer && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/syntax.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
deps/analyzer/CMakeFiles/syntax.dir/build: deps/analyzer/libsyntax.a

.PHONY : deps/analyzer/CMakeFiles/syntax.dir/build

deps/analyzer/CMakeFiles/syntax.dir/requires: deps/analyzer/CMakeFiles/syntax.dir/syntax_analyzer.tab.c.o.requires

.PHONY : deps/analyzer/CMakeFiles/syntax.dir/requires

deps/analyzer/CMakeFiles/syntax.dir/clean:
	cd /home/david/compiler_cminus/lab3-1/build/deps/analyzer && $(CMAKE_COMMAND) -P CMakeFiles/syntax.dir/cmake_clean.cmake
.PHONY : deps/analyzer/CMakeFiles/syntax.dir/clean

deps/analyzer/CMakeFiles/syntax.dir/depend:
	cd /home/david/compiler_cminus/lab3-1/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/david/compiler_cminus/lab3-1 /home/david/compiler_cminus/lab3-1/deps/analyzer /home/david/compiler_cminus/lab3-1/build /home/david/compiler_cminus/lab3-1/build/deps/analyzer /home/david/compiler_cminus/lab3-1/build/deps/analyzer/CMakeFiles/syntax.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : deps/analyzer/CMakeFiles/syntax.dir/depend

