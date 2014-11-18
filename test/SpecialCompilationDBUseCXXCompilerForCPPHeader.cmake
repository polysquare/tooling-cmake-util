# /test/SpecialCompilationDBUseCXXCompilerForCPPHeader.cmake
#
# Add some sources and defines to a custom target
# One of them is a C++ header.
#
# See LICENCE.md for Copyright information

include (PolysquareToolingUtil)
include (CMakeUnit)
include (MakeSpecialCompilationDBHelper)

test_make_sources_and_compilation_db ("Source.cpp" CXX)

set (COMPILE_COMMANDS
     "${COMPILATION_DB_DIR}/compile_commands.json")

# Replace + first since passing escapes all the way down the call
# chain is not something that can be done with any stability
cmake_unit_escape_string ("${CMAKE_CXX_COMPILER}"
                          ESCAPED_CXX_COMPILER)
string (REPLACE "+" "." ESCAPED_CXX_COMPILER "${CMAKE_CXX_COMPILER}")
assert_file_has_line_matching ("${COMPILE_COMMANDS}"
                               "^.*${ESCAPED_CXX_COMPILER}.*Header.h.*$")
