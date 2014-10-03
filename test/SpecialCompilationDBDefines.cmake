# /tests/SpecialCompilationDBDefines.cmake
# Add some sources and defines to a custom target.
# The defines should be passed into the compilation DB.
#
# See LICENCE.md for Copyright information

include (${POLYSQUARE_TOOLING_CMAKE_DIRECTORY}/PolysquareToolingUtil.cmake)
include (${POLYSQUARE_TOOLING_CMAKE_TESTS_DIRECTORY}/CMakeUnit.cmake)

set (SOURCE_FILE ${CMAKE_CURRENT_BINARY_DIR}/Source.cpp)
set (SOURCE_FILE_CONTENTS
     "int main (void)\n"
     "{\n"
     "    return 0\;\n"
     "}\n")
set (SOURCE_DEFINES custom_define=1)
set (TARGET target)

file (WRITE ${SOURCE_FILE} ${SOURCE_FILE_CONTENTS})

add_custom_target (${TARGET} ALL
                   SOURCES ${SOURCE_FILE})
psq_make_compilation_db (${TARGET}
                         COMPILATION_DB_DIR
                         CXX_SOURCES ${SOURCE_FILE}
                         DEFINES ${SOURCE_DEFINES})

set (COMPILE_COMMANDS
     ${COMPILATION_DB_DIR}/compile_commands.json)
assert_file_has_line_matching (${COMPILE_COMMANDS}
                               "^.*-Dcustom_define=1.*$")