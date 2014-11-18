# /test/SortCHeadersToC.cmake
#
# Checks that C headers are put in C_SOURCES when calling
# psq_sort_sources_to_languages
#
# See LICENCE.md for Copyright information

include (PolysquareToolingUtil)
include (CMakeUnit)

set (HEADER_FILE_NAME "Header.h")
set (HEADER_FILE_PATH
     "${CMAKE_CURRENT_SOURCE_DIR}/${HEADER_FILE_NAME}")
cmake_unit_create_source_file_before_build (NAME
                                            "${HEADER_FILE_NAME}")


set (CXX_SOURCE_FILE_NAME "Source.cpp")
set (CXX_SOURCE_FILE_PATH
     "${CMAKE_CURRENT_SOURCE_DIR}/${CXX_SOURCE_FILE_NAME}")
cmake_unit_create_source_file_before_build (NAME
                                            "${CXX_SOURCE_FILE_NAME}"
                                            INCLUDES
                                            "${HEADER_FILE_PATH}"
                                            INCLUDE_DIRECTORIES
                                            "${CMAKE_CURRENT_SOURCE_DIR}")

set (C_SOURCE_FILE_NAME "Source.c")
set (C_SOURCE_FILE_PATH
     "${CMAKE_CURRENT_SOURCE_DIR}/${C_SOURCE_FILE_NAME}")
cmake_unit_create_source_file_before_build (NAME
                                            "${C_SOURCE_FILE_NAME}"
                                            INCLUDES
                                            "${HEADER_FILE_PATH}"
                                            INCLUDE_DIRECTORIES
                                            "${CMAKE_CURRENT_SOURCE_DIR}")

psq_sort_sources_to_languages (C_SOURCES CXX_SOURCES HEADERS
                               SOURCES
                               "${C_SOURCE_FILE_PATH}"
                               "${CXX_SOURCE_FILE_PATH}"
                               "${HEADER_FILE_PATH}"
                               INCLUDES "${CMAKE_CURRENT_SOURCE_DIR}")

assert_list_contains_value (C_SOURCES STRING EQUAL
                            "${HEADER_FILE_PATH}")
assert_list_does_not_contain_value (CXX_SOURCES STRING EQUAL
                                    "${HEADER_FILE_PATH}")
