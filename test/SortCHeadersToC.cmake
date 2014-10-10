# /tests/SortCHeadersToC.cmake
#
# Checks that C headers are put in C_SOURCES when calling
# psq_sort_sources_to_languages
#
# Check LICENCE.md for Copyright information.

include (PolysquareToolingUtil)
include (CMakeUnit)

set (HEADER_FILE ${CMAKE_CURRENT_BINARY_DIR}/Header.h)
file (WRITE ${HEADER_FILE} "")

set (CXX_SOURCE_FILE ${CMAKE_CURRENT_BINARY_DIR}/Source.cpp)
set (CXX_SOURCE_FILE_CONTENTS
     "#include <Header.h>\n")
file (WRITE ${CXX_SOURCE_FILE} ${CXX_SOURCE_FILE_CONTENTS})
set (C_SOURCE_FILE ${CMAKE_CURRENT_BINARY_DIR}/Source.c)
set (C_SOURCE_FILE_CONTENTS
     "#include <Header.h>\n")
file (WRITE ${C_SOURCE_FILE} ${C_SOURCE_FILE_CONTENTS})

psq_sort_sources_to_languages (C_SOURCES CXX_SOURCES HEADERS
                               SOURCES
                               ${C_SOURCE_FILE}
                               ${CXX_SOURCE_FILE}
                               ${HEADER_FILE}
                               INCLUDES ${CMAKE_CURRENT_BINARY_DIR})

assert_list_contains_value (C_SOURCES STRING EQUAL ${HEADER_FILE})
assert_list_does_not_contain_value (CXX_SOURCES STRING EQUAL ${HEADER_FILE})