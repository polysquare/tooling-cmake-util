# /tests/SortCSourcesToC.cmake
#
# Checks that C sources are put in C_SOURCES when calling
# psq_sort_sources_to_languages
#
# Check LICENCE.md for Copyright information.

include (PolysquareToolingUtil)
include (CMakeUnit)

set (SOURCE_FILE ${CMAKE_CURRENT_BINARY_DIR}/Source.c)
file (WRITE ${SOURCE_FILE} "")

psq_sort_sources_to_languages (C_SOURCES CXX_SOURCES HEADERS
                               SOURCES ${SOURCE_FILE})

assert_list_contains_value (C_SOURCES STRING EQUAL ${SOURCE_FILE})