# /test/SortCXXSourcesToCXX.cmake
#
# Checks that CXX sources are put in CXX_SOURCES when calling
# psq_sort_sources_to_languages
#
# See LICENCE.md for Copyright information

include (PolysquareToolingUtil)
include (CMakeUnit)

set (SOURCE_FILE ${CMAKE_CURRENT_SOURCE_DIR}/Source.cpp)
file (WRITE ${SOURCE_FILE} "")

psq_sort_sources_to_languages (C_SOURCES CXX_SOURCES HEADERS
                               SOURCES ${SOURCE_FILE})

assert_list_contains_value (CXX_SOURCES STRING EQUAL ${SOURCE_FILE})
