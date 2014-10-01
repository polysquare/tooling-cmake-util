# /tests/SortCXXSourcesToCXX.cmake
#
# Checks that CXX sources are put in CXX_SOURCES when calling
# psq_sort_sources_to_languages
#
# Check LICENCE.md for Copyright information.

include (${POLYSQUARE_TOOLING_CMAKE_DIRECTORY}/PolysquareToolingUtil.cmake)
include (${POLYSQUARE_TOOLING_CMAKE_TESTS_DIRECTORY}/CMakeUnit.cmake)

set (SOURCE_FILE ${CMAKE_CURRENT_SOURCE_DIR}/Source.cpp)
file (WRITE ${SOURCE_FILE} "")

psq_sort_sources_to_languages (C_SOURCES CXX_SOURCES
                               SOURCES ${SOURCE_FILE})

assert_list_contains_value (CXX_SOURCES STRING EQUAL ${SOURCE_FILE})