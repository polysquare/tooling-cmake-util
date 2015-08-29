# Polysquare CMake Tooling Utility Functions #

Utility and common library for all polysquare cmake tools.

## Status ##

| Travis CI (Ubuntu) | AppVeyor (Windows) | Coverage | Biicode | Licence |
|--------------------|--------------------|----------|---------|---------|
|[![Travis](https://img.shields.io/travis/polysquare/tooling-cmake-util.svg)](http://travis-ci.org/polysquare/tooling-cmake-util)|[![AppVeyor](https://img.shields.io/appveyor/ci/smspillaz/tooling-cmake-util.svg)](https://ci.appveyor.com/project/smspillaz/tooling-cmake-util)|[![Coveralls](https://img.shields.io/coveralls/polysquare/tooling-cmake-util.svg)](http://coveralls.io/polysquare/tooling-cmake-util)|[![Biicode](https://webapi.biicode.com/v1/badges/smspillaz/smspillaz/tooling-cmake-util/master)](https://www.biicode.com/smspillaz/tooling-cmake-util)|[![License](https://img.shields.io/github/license/polysquare/tooling-cmake-util.svg)](http://github.com/polysquare/tooling-cmake-util)|

## Description ##

`tooling-cmake-util` is used as a support library by modules like
`polysquare/veracpp-cmake`, `polysquare/cppcheck-target-cmake`and
`polysquare/clang-tidy-target-cmake`. It provides functions useful to modules
which provide integration with various static analysis tools for C++.

## Usage ##

### Running a static analysis tool on each source of a target ###

The most common pattern is to use `psq_run_tool_for_each_source`

#### `psq_run_tool_for_each_source` ####

Run a static analysis tool on each source file for `TARGET`. All of the
target's C and C++ sources are extracted from its definition and the
specified `COMMAND` is run on each of them. The string `@SOURCE@` is replaced
with the source file name in the arguments for `COMMAND`.

* `TARGET`: The target to run the tool for.
* `TOOL_NAME`: The name of the tool. This will be shown when the command
               runs as "Analyzing @SOURCE@ with ${TOOL_NAME}"
* `COMMAND`: The command to run to invoke this tool. @SOURCE@ is replaced
             with the source file path.
* [Optional] `CHECK_GENERATED`: Include generated files in the analysis.
                                Generated files are not included by default.
* [Optional] `DEPENDS`: Targets and sources running this tool depends on.

You can also run a tool on a single source file.

#### `psq_run_tool_on_source` ####

Run a static analysis tool on a source file during TARGET. All of the
target's C and C++ sources are extracted from its definition and the
specified COMMAND is run on each of them. The string @SOURCE@ is replaced
with the source file name in the arguments for COMMAND.

* `TARGET`: The target to run the tool for.
* `SOURCE`: The source file to check.
* `TOOL_NAME`: The name of the tool. This will be shown when the command
               runs as "Analyzing @SOURCE@ with ${TOOL_NAME}"
* `COMMAND`: The command to run to invoke this tool. @SOURCE@ is replaced
             with the source file path.
* [Optional] `DEPENDS`: Targets and sources running this tool depends on.

### Making a JSON Compilation Database ###

Some tools use the [CMake JSON Compilation Database](http://clang.llvm.org/docs/JSONCompilationDatabase.html)
standard in order to mimic compiler invocations. This can usually be generated
with `CMAKE_EXPORT_COMPILE_COMMANDS` but it doesn't capture everything. In
particular, it will miss generated files.

`tooling-cmake-util` provides a `psq_make_compilation_db` function to
ensure that a JSON compilation database is always written out in relation
to a particular target specified during the configure stage.

#### `psq_make_compilation_db` ####

Creates a JSON Compilation Database in relation to the specified TARGET.

`TARGET`: Target to create JSON compilation database for.
`CUSTOM_COMPILATION_DB_DIR_RETURN`: Variable to store location of compilation
                                    database for the specified TARGET
* [Optional] `C_SOURCES`: C-language sources to include.
* [Optional] `CXX_SOURCES`: C++-language sources to include.
* [Optional] `INTERNAL_INCLUDE_DIRS`: Non-system include directories.
* [Optional] `EXTERNAL_INCLUDE_DIRS`: System include directories.
* [Optional] `DEFINES`: Extra definitions to set.

### Filtering between source file types ###

Sometimes you need to distinguish between different types of source files
when running static analysis tools. For instance, you might wish to
avoid generated code when running style checks, or C source files
when running a tool that assumes the language is C++. `tooling-cmake-util`
provides helper functions for these cases.

#### `psq_filter_out_generated_sources` ####

Filter out generated sources from SOURCES and store the resulting
list of sources in `RESULT_VARIABLE`.

* `RESULT_VARIABLE`: Resultant list of sources, without generated sources.
* `SOURCES`: List of source files, including generated sources.

For most projects, the convention is to not filter source files
where `CHECK_GENERATED` is passed. A `psq_handle_check_generated_option`
with a similar signature, and the first argument being the `PREFIX` argument
passed to `cmake_parse_arguments` is provided. This detects if `CHECK_GENERATED`
has been set and filters source arguments accordingly.

#### `psq_sort_sources_to_languages` ####

Separate headers from non-headers and C++ source files from C source files.

* `C_SOURCES`: Variable to store list of C sources in.
* `CXX_SOURCES`: Variable to store list of C++ sources in.
* `HEADERS`: Variable to store list of headers in.
* `SOURCES`: List of source files to separate out.
* [Optional] `FORCE_LANGUAGE`: Force language of all sources to be either C
                               or CXX.
* [Optional] `CPP_IDENTIFIERS`: List of identifiers that indicate that a
                                source file is actually a C++ source file.
* [Optional] `INCLUDES`: Include directories to search.

### Utility functions ###

#### `psq_add_switch` ####

Specify certain command line switches depending on value of
boolean variable.

* `ALL_OPTIONS`: Existing list of command line switches.
* `OPTION_NAME`: Boolean variable to check.
* [Optional] `ON`: Switch to add if boolean variable is true.
* [Optional] `OFF`: Switch to add if boolean variable is false.

#### `psq_append_each_to_options_with_prefix` ####

Append items in `ARGN` to `MAIN_LIST`, giving each `PREFIX`.

* `MAIN_LIST`: List to append to.
* `PREFIX`: Prefix to append to each item.

#### `psq_get_list_intersection` ####

Get the logical intersection between two lists and store it in
`DESTINATION`.

* `DESTINATION`: Variable to store intersection in.
* `SOURCE`: Source list.
* `INTERSECTION`: List to intersect with.

#### `psq_append_to_global_property_unique` ####

Append `ITEM` to the global property `PROPERTY`, only if it is not
already part of the list.

`PROPERTY`: Global property to append to.
`ITEM`: Item to append, only if not present.