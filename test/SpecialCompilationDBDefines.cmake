# /test/SpecialCompilationDBDefines.cmake
#
# Add some sources and defines to a custom target.
# The defines should be passed into the compilation DB.
#
# See LICENCE.md for Copyright information

include (PolysquareToolingUtil)
include (CMakeUnit)
include (MakeSpecialCompilationDBHelper)

test_make_sources_and_compilation_db ("Source.cpp" CXX
                                      DEFINES
                                      custom_define=1)

set (COMPILE_COMMANDS
     "${COMPILATION_DB_DIR}/compile_commands.json")
assert_file_has_line_matching ("${COMPILE_COMMANDS}"
                               "^.*-Dcustom_define=1.*$")
