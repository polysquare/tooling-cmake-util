# /test/SortCXXHeadersToCXX.cmake
#
# Checks that CXX headers are put in CXX_SOURCES when calling
# psq_sort_sources_to_languages
#
# See LICENCE.md for Copyright information

include (PolysquareToolingUtil)
include (CMakeUnit)

set (HEADER_FILE_NAME "Header.h")
set (HEADER_FILE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/${HEADER_FILE_NAME}")
cmake_unit_create_source_file_before_build (NAME
                                            "${HEADER_FILE_NAME}")

set (SOURCE_FILE_NAME "Source.cpp")
set (SOURCE_FILE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/${SOURCE_FILE_NAME}")
cmake_unit_create_source_file_before_build (NAME
                                            "${SOURCE_FILE_NAME}"
                                            INCLUDES
                                            "${HEADER_FILE_PATH}"
                                            INCLUDE_DIRECTORIES
                                            "${CMAKE_CURRENT_SOURCE_DIR}")

psq_sort_sources_to_languages (C_SOURCES CXX_SOURCES HEADERS
                               SOURCES
                               "${SOURCE_FILE_PATH}"
                               "${HEADER_FILE_PATH}"
                               INCLUDES "${CMAKE_CURRENT_SOURCE_DIR}")

assert_list_contains_value (CXX_SOURCES STRING EQUAL
                            "${HEADER_FILE_PATH}")
