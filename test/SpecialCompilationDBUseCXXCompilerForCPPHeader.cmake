# /test/SpecialCompilationDBUseCXXCompilerForCPPHeader.cmake
#
# Add some sources and defines to a custom target
# One of them is a C++ header.
#
# See LICENCE.md for Copyright information

include (PolysquareToolingUtil)
include (CMakeUnit)

set (HEADER_FILE_NAME "Header.h")
set (HEADER_FILE_PATH
     "${CMAKE_CURRENT_SOURCE_DIR}/${HEADER_FILE_NAME}")
cmake_unit_create_source_file_before_build (NAME
                                            "${HEADER_FILE_NAME}")
set (CXX_SOURCE_FILE "Source.cpp")
set (CXX_SOURCE_FILE_PATH
     "${CMAKE_CURRENT_SOURCE_DIR}/${CXX_SOURCE_FILE_NAME}")
cmake_unit_create_source_file_before_build (NAME
                                            "${CXX_SOURCE_FILE_NAME}"
                                            FUNCTIONS main)
set (TARGET target)

add_custom_target (${TARGET} ALL
                   SOURCES
                   "${CXX_SOURCE_FILE_PATH}"
                   "${HEADER_FILE_PATH}")
psq_make_compilation_db (${TARGET}
                         COMPILATION_DB_DIR
                         CXX_SOURCES
                         "${CXX_SOURCE_FILE_PATH}"
                         "${HEADER_FILE_PATH}"
                         INTERNAL_INCLUDE_DIRS
                         "${CMAKE_CURRENT_SOURCE_DIR}")

cmake_unit_escape_string ("${CMAKE_CXX_COMPILER}"
                          ESCAPED_CXX_COMPILER)

set (COMPILE_COMMANDS
     "${COMPILATION_DB_DIR}/compile_commands.json")

# Replace + first since passing escapes all the way down the call
# chain is not something that can be done with any stability
cmake_unit_escape_string ("${CMAKE_CXX_COMPILER}"
                          ESCAPED_CXX_COMPILER)
string (REPLACE "+" "." ESCAPED_CXX_COMPILER "${CMAKE_CXX_COMPILER}")
assert_file_has_line_matching ("${COMPILE_COMMANDS}"
                               "^.*${ESCAPED_CXX_COMPILER}.*Header.h.*$")
