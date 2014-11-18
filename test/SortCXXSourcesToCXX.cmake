# /test/SortCXXSourcesToCXX.cmake
#
# Checks that CXX sources are put in CXX_SOURCES when calling
# psq_sort_sources_to_languages
#
# See LICENCE.md for Copyright information

include (PolysquareToolingUtil)
include (CMakeUnit)

set (SOURCE_FILE_NAME "Source.cpp")
set (SOURCE_FILE_PATH
     "${CMAKE_CURRENT_SOURCE_DIR}/${SOURCE_FILE_NAME}")
cmake_unit_create_source_file_before_build (NAME
                                            "${SOURCE_FILE_NAME}")

psq_sort_sources_to_languages (C_SOURCES CXX_SOURCES HEADERS
                               SOURCES "${SOURCE_FILE_PATH}")

assert_list_contains_value (CXX_SOURCES STRING EQUAL
                            "${SOURCE_FILE_PATH}")
