# /test/SpecialCompilationDBUseCLanguageOptForCHeader.cmake
#
# Add some sources and defines to a custom target
# One of them is a C header.
#
# See LICENCE.md for Copyright information

include (PolysquareToolingUtil)
include (CMakeUnit)
include (MakeSpecialCompilationDBHelper)

test_make_sources_and_compilation_db ("Source.c" C)

# FIXME: Only true for gcc and clang
set (COMPILE_COMMANDS
     "${COMPILATION_DB_DIR}/compile_commands.json")
assert_file_does_not_have_line_matching ("${COMPILE_COMMANDS}"
                                         "^.*-x c...*Header.h.*$")
