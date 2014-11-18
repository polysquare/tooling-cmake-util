# /test/SortCXXHeadersToCXX.cmake
#
# Checks that CXX headers are put in CXX_SOURCES when calling
# psq_sort_sources_to_languages
#
# See LICENCE.md for Copyright information

include (PolysquareToolingUtil)
include (CMakeUnit)

set (HEADER_FILE ${CMAKE_CURRENT_BINARY_DIR}/Header.h)
file (WRITE ${HEADER_FILE} "")

set (SOURCE_FILE ${CMAKE_CURRENT_BINARY_DIR}/Source.cpp)
set (SOURCE_FILE_CONTENTS
     "#include <Header.h>\n")
file (WRITE ${SOURCE_FILE} ${SOURCE_FILE_CONTENTS})

psq_sort_sources_to_languages (C_SOURCES CXX_SOURCES HEADERS
                               SOURCES ${SOURCE_FILE} ${HEADER_FILE}
                               INCLUDES ${CMAKE_CURRENT_BINARY_DIR})

assert_list_contains_value (CXX_SOURCES STRING EQUAL ${HEADER_FILE})
