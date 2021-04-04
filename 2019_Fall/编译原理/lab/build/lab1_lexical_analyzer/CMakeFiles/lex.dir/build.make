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
CMAKE_SOURCE_DIR = /home/david/compiler_cminus

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/david/compiler_cminus/build

# Include any dependencies generated for this target.
include lab1_lexical_analyzer/CMakeFiles/lex.dir/depend.make

# Include the progress variables for this target.
include lab1_lexical_analyzer/CMakeFiles/lex.dir/progress.make

# Include the compile flags for this target's objects.
include lab1_lexical_analyzer/CMakeFiles/lex.dir/flags.make

lab1_lexical_analyzer/syntax_analyzer.c: ../lab2_syntax_analyzer/syntax_analyzer.y
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --blue --bold --progress-dir=/home/david/compiler_cminus/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "[BISON][syntax] Building parser with bison 3.0.4"
	cd /home/david/compiler_cminus/lab1_lexical_analyzer && /usr/bin/bison -d -o /home/david/compiler_cminus/build/lab1_lexical_analyzer/syntax_analyzer.c /home/david/compiler_cminus/lab2_syntax_analyzer/syntax_analyzer.y

lab1_lexical_analyzer/syntax_analyzer.h: lab1_lexical_analyzer/syntax_analyzer.c
	@$(CMAKE_COMMAND) -E touch_nocreate lab1_lexical_analyzer/syntax_analyzer.h

lab1_lexical_analyzer/lex.yy.c: ../lab1_lexical_analyzer/lexical_analyzer.l
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --blue --bold --progress-dir=/home/david/compiler_cminus/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "[FLEX][lex] Building scanner with flex 2.6.0"
	cd /home/david/compiler_cminus/lab1_lexical_analyzer && /usr/bin/flex -o/home/david/compiler_cminus/build/lab1_lexical_analyzer/lex.yy.c lexical_analyzer.l

lab1_lexical_analyzer/CMakeFiles/lex.dir/lexical_analyzer.c.o: lab1_lexical_analyzer/CMakeFiles/lex.dir/flags.make
lab1_lexical_analyzer/CMakeFiles/lex.dir/lexical_analyzer.c.o: ../lab1_lexical_analyzer/lexical_analyzer.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/david/compiler_cminus/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Building C object lab1_lexical_analyzer/CMakeFiles/lex.dir/lexical_analyzer.c.o"
	cd /home/david/compiler_cminus/build/lab1_lexical_analyzer && /usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/lex.dir/lexical_analyzer.c.o   -c /home/david/compiler_cminus/lab1_lexical_analyzer/lexical_analyzer.c

lab1_lexical_analyzer/CMakeFiles/lex.dir/lexical_analyzer.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/lex.dir/lexical_analyzer.c.i"
	cd /home/david/compiler_cminus/build/lab1_lexical_analyzer && /usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/david/compiler_cminus/lab1_lexical_analyzer/lexical_analyzer.c > CMakeFiles/lex.dir/lexical_analyzer.c.i

lab1_lexical_analyzer/CMakeFiles/lex.dir/lexical_analyzer.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/lex.dir/lexical_analyzer.c.s"
	cd /home/david/compiler_cminus/build/lab1_lexical_analyzer && /usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/david/compiler_cminus/lab1_lexical_analyzer/lexical_analyzer.c -o CMakeFiles/lex.dir/lexical_analyzer.c.s

lab1_lexical_analyzer/CMakeFiles/lex.dir/lexical_analyzer.c.o.requires:

.PHONY : lab1_lexical_analyzer/CMakeFiles/lex.dir/lexical_analyzer.c.o.requires

lab1_lexical_analyzer/CMakeFiles/lex.dir/lexical_analyzer.c.o.provides: lab1_lexical_analyzer/CMakeFiles/lex.dir/lexical_analyzer.c.o.requires
	$(MAKE) -f lab1_lexical_analyzer/CMakeFiles/lex.dir/build.make lab1_lexical_analyzer/CMakeFiles/lex.dir/lexical_analyzer.c.o.provides.build
.PHONY : lab1_lexical_analyzer/CMakeFiles/lex.dir/lexical_analyzer.c.o.provides

lab1_lexical_analyzer/CMakeFiles/lex.dir/lexical_analyzer.c.o.provides.build: lab1_lexical_analyzer/CMakeFiles/lex.dir/lexical_analyzer.c.o


lab1_lexical_analyzer/CMakeFiles/lex.dir/lex.yy.c.o: lab1_lexical_analyzer/CMakeFiles/lex.dir/flags.make
lab1_lexical_analyzer/CMakeFiles/lex.dir/lex.yy.c.o: lab1_lexical_analyzer/lex.yy.c
lab1_lexical_analyzer/CMakeFiles/lex.dir/lex.yy.c.o: lab1_lexical_analyzer/syntax_analyzer.h
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/david/compiler_cminus/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_4) "Building C object lab1_lexical_analyzer/CMakeFiles/lex.dir/lex.yy.c.o"
	cd /home/david/compiler_cminus/build/lab1_lexical_analyzer && /usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/lex.dir/lex.yy.c.o   -c /home/david/compiler_cminus/build/lab1_lexical_analyzer/lex.yy.c

lab1_lexical_analyzer/CMakeFiles/lex.dir/lex.yy.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/lex.dir/lex.yy.c.i"
	cd /home/david/compiler_cminus/build/lab1_lexical_analyzer && /usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/david/compiler_cminus/build/lab1_lexical_analyzer/lex.yy.c > CMakeFiles/lex.dir/lex.yy.c.i

lab1_lexical_analyzer/CMakeFiles/lex.dir/lex.yy.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/lex.dir/lex.yy.c.s"
	cd /home/david/compiler_cminus/build/lab1_lexical_analyzer && /usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/david/compiler_cminus/build/lab1_lexical_analyzer/lex.yy.c -o CMakeFiles/lex.dir/lex.yy.c.s

lab1_lexical_analyzer/CMakeFiles/lex.dir/lex.yy.c.o.requires:

.PHONY : lab1_lexical_analyzer/CMakeFiles/lex.dir/lex.yy.c.o.requires

lab1_lexical_analyzer/CMakeFiles/lex.dir/lex.yy.c.o.provides: lab1_lexical_analyzer/CMakeFiles/lex.dir/lex.yy.c.o.requires
	$(MAKE) -f lab1_lexical_analyzer/CMakeFiles/lex.dir/build.make lab1_lexical_analyzer/CMakeFiles/lex.dir/lex.yy.c.o.provides.build
.PHONY : lab1_lexical_analyzer/CMakeFiles/lex.dir/lex.yy.c.o.provides

lab1_lexical_analyzer/CMakeFiles/lex.dir/lex.yy.c.o.provides.build: lab1_lexical_analyzer/CMakeFiles/lex.dir/lex.yy.c.o


# Object files for target lex
lex_OBJECTS = \
"CMakeFiles/lex.dir/lexical_analyzer.c.o" \
"CMakeFiles/lex.dir/lex.yy.c.o"

# External object files for target lex
lex_EXTERNAL_OBJECTS =

lib/liblex.a: lab1_lexical_analyzer/CMakeFiles/lex.dir/lexical_analyzer.c.o
lib/liblex.a: lab1_lexical_analyzer/CMakeFiles/lex.dir/lex.yy.c.o
lib/liblex.a: lab1_lexical_analyzer/CMakeFiles/lex.dir/build.make
lib/liblex.a: lab1_lexical_analyzer/CMakeFiles/lex.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/david/compiler_cminus/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_5) "Linking C static library ../lib/liblex.a"
	cd /home/david/compiler_cminus/build/lab1_lexical_analyzer && $(CMAKE_COMMAND) -P CMakeFiles/lex.dir/cmake_clean_target.cmake
	cd /home/david/compiler_cminus/build/lab1_lexical_analyzer && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/lex.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
lab1_lexical_analyzer/CMakeFiles/lex.dir/build: lib/liblex.a

.PHONY : lab1_lexical_analyzer/CMakeFiles/lex.dir/build

lab1_lexical_analyzer/CMakeFiles/lex.dir/requires: lab1_lexical_analyzer/CMakeFiles/lex.dir/lexical_analyzer.c.o.requires
lab1_lexical_analyzer/CMakeFiles/lex.dir/requires: lab1_lexical_analyzer/CMakeFiles/lex.dir/lex.yy.c.o.requires

.PHONY : lab1_lexical_analyzer/CMakeFiles/lex.dir/requires

lab1_lexical_analyzer/CMakeFiles/lex.dir/clean:
	cd /home/david/compiler_cminus/build/lab1_lexical_analyzer && $(CMAKE_COMMAND) -P CMakeFiles/lex.dir/cmake_clean.cmake
.PHONY : lab1_lexical_analyzer/CMakeFiles/lex.dir/clean

lab1_lexical_analyzer/CMakeFiles/lex.dir/depend: lab1_lexical_analyzer/syntax_analyzer.c
lab1_lexical_analyzer/CMakeFiles/lex.dir/depend: lab1_lexical_analyzer/syntax_analyzer.h
lab1_lexical_analyzer/CMakeFiles/lex.dir/depend: lab1_lexical_analyzer/lex.yy.c
	cd /home/david/compiler_cminus/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/david/compiler_cminus /home/david/compiler_cminus/lab1_lexical_analyzer /home/david/compiler_cminus/build /home/david/compiler_cminus/build/lab1_lexical_analyzer /home/david/compiler_cminus/build/lab1_lexical_analyzer/CMakeFiles/lex.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : lab1_lexical_analyzer/CMakeFiles/lex.dir/depend

