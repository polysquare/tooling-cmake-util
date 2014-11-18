# /test/SpecialCompilationDBIncludes.cmake
#
# Add some sources and includes to a custom target.
# The includes should be passed into the compilation DB.
#
# See LICENCE.md for Copyright information

include (PolysquareToolingUtil)
include (CMakeUnit)
include (MakeSpecialCompilationDBHelper)

set (SOURCE_INTERNAL_INCLUDE_DIRS "${CMAKE_CURRENT_SOURCE_DIR}/internal")
set (SOURCE_EXTERNAL_INCLUDE_DIRS "${CMAKE_CURRENT_SOURCE_DIR}/external")

test_make_sources_and_compilation_db ("Source.cpp" CXX
                                      DEFINES
                                      custom_define=1
                                      INTERNAL_INCLUDE_DIRS
                                      "${SOURCE_INTERNAL_INCLUDE_DIRS}"
                                      EXTERNAL_INCLUDE_DIRS
                                      "${SOURCE_EXTERNAL_INCLUDE_DIRS}")

set (COMPILE_COMMANDS
     "${COMPILATION_DB_DIR}/compile_commands.json")
assert_file_has_line_matching ("${COMPILE_COMMANDS}"
                               "^.*-isystem.*external.*$")
assert_file_has_line_matching ("${COMPILE_COMMANDS}"
                               "^.*-I.*internal.*$")
