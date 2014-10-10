# /tests/SpecialCompilationDBIncludes.cmake
# Add some sources and includes to a custom target.
# The includes should be passed into the compilation DB.
#
# See LICENCE.md for Copyright information

include (PolysquareToolingUtil)
include (CMakeUnit)

set (SOURCE_FILE ${CMAKE_CURRENT_BINARY_DIR}/Source.cpp)
set (SOURCE_FILE_CONTENTS
     "int main (void)\n"
     "{\n"
     "    return 0\;\n"
     "}\n")
set (SOURCE_INTERNAL_INCLUDE_DIRS ${CMAKE_CURRENT_SOURCE_DIR}/internal)
set (SOURCE_EXTERNAL_INCLUDE_DIRS ${CMAKE_CURRENT_SOURCE_DIR}/external)
set (TARGET target)

file (WRITE ${SOURCE_FILE} ${SOURCE_FILE_CONTENTS})

add_custom_target (${TARGET} ALL
                   SOURCES ${SOURCE_FILE})
psq_make_compilation_db (${TARGET}
                         COMPILATION_DB_DIR
                         CXX_SOURCES ${SOURCE_FILE}
                         INTERNAL_INCLUDE_DIRS
                         ${SOURCE_INTERNAL_INCLUDE_DIRS}
                         EXTERNAL_INCLUDE_DIRS
                         ${SOURCE_EXTERNAL_INCLUDE_DIRS})
set (COMPILE_COMMANDS
     ${COMPILATION_DB_DIR}/compile_commands.json)
assert_file_has_line_matching (${COMPILE_COMMANDS}
                               "^.*-isystem.*external.*$")
assert_file_has_line_matching (${COMPILE_COMMANDS}
                               "^.*-I.*internal.*$")