# /test/SortCHeadersToCXXForceLanguage.cmake
#
# Checks that C headers are put in CXX_SOURCES when calling
# psq_sort_sources_to_languages with FORCE_LANGUAGE CXX
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
                                            "${HEADER_FILE}"
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
                               INCLUDES "${CMAKE_CURRENT_SOURCE_DIR}"
                               FORCE_LANGUAGE CXX)

assert_list_contains_value (CXX_SOURCES STRING EQUAL "${HEADER_FILE_PATH}")
assert_list_contains_value (HEADERS STRING EQUAL "${HEADER_FILE_PATH}")
