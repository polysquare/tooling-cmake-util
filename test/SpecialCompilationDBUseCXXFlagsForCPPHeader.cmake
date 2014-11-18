# /test/SpecialCompilationDBUseCXXFlagsForCPPHeader.cmake
#
# Add some sources and defines to a custom target
# One of them is a C++ header. The CMAKE_CXX_FLAGS
# should be part of its compile commands.
#
# See LICENCE.md for Copyright information

include (PolysquareToolingUtil)
include (CMakeUnit)
include (MakeSpecialCompilationDBHelper)

set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DUSING_CXX_DEFINE")
set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DUSING_C_DEFINE")

test_make_sources_and_compilation_db ("Source.cpp" CXX)

set (COMPILE_COMMANDS
     "${COMPILATION_DB_DIR}/compile_commands.json")
assert_file_has_line_matching ("${COMPILE_COMMANDS}"
                               "^.*Header.h.*-DUSING_CXX_DEFINE.*$")
