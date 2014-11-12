# /tests/SpecialCompilationDBUseCXXCompilerForCPPHeader.cmake
# Add some sources and defines to a custom target
# One of them is a C++ header.
#
# See LICENCE.md for Copyright information

include (PolysquareToolingUtil)
include (CMakeUnit)

set (HEADER_FILE ${CMAKE_CURRENT_BINARY_DIR}/Header.h)
set (CPP_SOURCE_FILE ${CMAKE_CURRENT_BINARY_DIR}/Source.cpp)
set (HEADER_FILE_CONTENTS
     "#ifndef HEADER_H\n"
     "#define HEADER_H\n"
     "extern const int i\;\n"
     "#endif")
set (CPP_SOURCE_FILE_CONTENTS
     "#include <Header.h>\n"
     "const int i = 1\;\n"
     "int main (void)\n"
     "{\n"
     "    return 0\;\n"
     "}\n")
set (TARGET target)

file (WRITE ${HEADER_FILE} ${HEADER_FILE_CONTENTS})
file (WRITE ${CPP_SOURCE_FILE} ${CPP_SOURCE_FILE_CONTENTS})

add_custom_target (${TARGET} ALL
                   SOURCES
                   ${CPP_SOURCE_FILE}
                   ${HEADER_FILE})
psq_make_compilation_db (${TARGET}
                         COMPILATION_DB_DIR
                         CXX_SOURCES ${CPP_SOURCE_FILE} ${HEADER_FILE}
                         INTERNAL_INCLUDE_DIRS
                         ${CMAKE_CURRENT_BINARY_DIR})

set (COMPILE_COMMANDS
     ${COMPILATION_DB_DIR}/compile_commands.json)

# Replace + first since passing escapes all the way down the call
# chain is not something that can be done with any stability
string (REPLACE "+" "." ESCAPED_CXX_COMPILER "${CMAKE_CXX_COMPILER}")
cmake_unit_escape_string ("${CMAKE_CXX_COMPILER}" ESCAPED_CXX_COMPILER)

assert_file_has_line_matching (${COMPILE_COMMANDS}
                               "^.*${ESCAPED_CXX_COMPILER}.*Header.h.*$")