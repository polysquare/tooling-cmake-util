# /test/SortHeadersToHeaders.cmake
#
# Checks that all headers are put into HEADERS.
#
# See LICENCE.md for Copyright information

include (PolysquareToolingUtil)
include (CMakeUnit)

set (C_HEADER_FILE_NAME "CHeader.h")
set (C_HEADER_FILE_PATH
     "${CMAKE_CURRENT_SOURCE_DIR}/${C_HEADER_FILE_NAME}")
cmake_unit_create_source_file_before_build (NAME
                                            "${C_HEADER_FILE_NAME}")

set (CXX_HEADER_FILE_NAME "CXXHeader.h")
set (CXX_HEADER_FILE_PATH
     "${CMAKE_CURRENT_SOURCE_DIR}/${CXX_HEADER_FILE_NAME}")
cmake_unit_create_source_file_before_build (NAME
                                            "${CXX_HEADER_FILE_NAME}")

set (CXX_SOURCE_FILE_NAME "Source.cpp")
set (CXX_SOURCE_FILE_PATH
     "${CMAKE_CURRENT_SOURCE_DIR}/${CXX_SOURCE_FILE_NAME}")
cmake_unit_create_source_file_before_build (NAME
                                            "${CXX_SOURCE_FILE_NAME}"
                                            INCLUDES
                                            "${CXX_HEADER_FILE_PATH}"
                                            INCLUDE_DIRECTORIES
                                            "${CMAKE_CURRENT_SOURCE_DIR}")

set (C_SOURCE_FILE_NAME "Source.c")
set (C_SOURCE_FILE_PATH
     "${CMAKE_CURRENT_SOURCE_DIR}/${C_SOURCE_FILE_NAME}")
cmake_unit_create_source_file_before_build (NAME
                                            "${C_SOURCE_FILE_NAME}"
                                            INCLUDES
                                            "${C_HEADER_FILE_PATH}"
                                            INCLUDE_DIRECTORIES
                                            "${CMAKE_CURRENT_SOURCE_DIR}")

psq_sort_sources_to_languages (C_SOURCES CXX_SOURCES HEADERS
                               SOURCES
                               "${C_SOURCE_FILE_PATH}"
                               "${CXX_SOURCE_FILE_PATH}"
                               "${C_HEADER_FILE_PATH}"
                               "${CXX_HEADER_FILE_PATH}"
                               INCLUDES "${CMAKE_CURRENT_SOURCE_DIR}")

assert_list_contains_value (HEADERS STRING EQUAL "${C_HEADER_FILE_PATH}")
assert_list_contains_value (HEADERS STRING EQUAL "${CXX_HEADER_FILE_PATH}")
