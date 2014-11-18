# /test/SpecialCompilationDBUseCFlagsForCHeader.cmake
#
# Add some sources and defines to a custom target
# One of them is a C++ header. The CMAKE_C_FLAGS
# should be part of its compile commands.
#
# See LICENCE.md for Copyright information

include (PolysquareToolingUtil)
include (CMakeUnit)

set (HEADER_FILE_NAME "Header.h")
set (HEADER_FILE_PATH
     "${CMAKE_CURRENT_SOURCE_DIR}/${HEADER_FILE_NAME}")
cmake_unit_create_source_file_before_build (NAME
                                            "${HEADER_FILE_NAME}")
set (C_SOURCE_FILE "Source.c")
set (C_SOURCE_FILE_PATH
     "${CMAKE_CURRENT_SOURCE_DIR}/${C_SOURCE_FILE_NAME}")
cmake_unit_create_source_file_before_build (NAME
                                            "${C_SOURCE_FILE_NAME}"
                                            FUNCTIONS main)
set (TARGET target)

set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DUSING_CXX_DEFINE")
set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DUSING_C_DEFINE")

add_custom_target (${TARGET} ALL
                   SOURCES
                   "${C_SOURCE_FILE_PATH}"
                   "${HEADER_FILE_PATH}")
psq_make_compilation_db (${TARGET}
                         COMPILATION_DB_DIR
                         C_SOURCES
                         "${C_SOURCE_FILE_PATH}"
                         "${HEADER_FILE_PATH}"
                         INTERNAL_INCLUDE_DIRS
                         "${CMAKE_CURRENT_SOURCE_DIR}")

set (COMPILE_COMMANDS
     "${COMPILATION_DB_DIR}/compile_commands.json")
assert_file_has_line_matching ("${COMPILE_COMMANDS}"
                               "^.*Header.h.*-DUSING_C_DEFINE.*$")
