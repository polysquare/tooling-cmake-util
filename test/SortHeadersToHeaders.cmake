# /tests/SortHeadersToHeaders.cmake
#
# Checks that all headers are put into HEADERS.
#
# Check LICENCE.md for Copyright information.

include (PolysquareToolingUtil)
include (CMakeUnit)

set (C_HEADER_FILE ${CMAKE_CURRENT_BINARY_DIR}/CHeader.h)
file (WRITE ${C_HEADER_FILE} "")

set (CXX_HEADER_FILE ${CMAKE_CURRENT_BINARY_DIR}/CXXHeader.h)
file (WRITE ${CXX_HEADER_FILE} "")

set (CXX_SOURCE_FILE ${CMAKE_CURRENT_BINARY_DIR}/Source.cpp)
set (CXX_SOURCE_FILE_CONTENTS
     "#include <CXXHeader.h>\n")
file (WRITE ${CXX_SOURCE_FILE} ${CXX_SOURCE_FILE_CONTENTS})

set (C_SOURCE_FILE ${CMAKE_CURRENT_BINARY_DIR}/Source.c)
set (C_SOURCE_FILE_CONTENTS
     "#include <CHeader.h>\n")
file (WRITE ${C_SOURCE_FILE} ${C_SOURCE_FILE_CONTENTS})

psq_sort_sources_to_languages (C_SOURCES CXX_SOURCES HEADERS
                               SOURCES
                               ${C_SOURCE_FILE}
                               ${CXX_SOURCE_FILE}
                               ${C_HEADER_FILE}
                               ${CXX_HEADER_FILE}
                               INCLUDES ${CMAKE_CURRENT_BINARY_DIR})

assert_list_contains_value (HEADERS STRING EQUAL ${C_HEADER_FILE})
assert_list_contains_value (HEADERS STRING EQUAL ${CXX_HEADER_FILE})