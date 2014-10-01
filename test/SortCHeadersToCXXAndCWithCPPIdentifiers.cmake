# /tests/SortCHeadersToCXXAndCWithCPPIdentifiersForceLanguage.cmake
#
# Checks that C headers are put in CXX_SOURCES when calling
# psq_sort_sources_to_languages with CPP_IDENTIFIERS that this header has.
#
# Check LICENCE.md for Copyright information.

include (${POLYSQUARE_TOOLING_CMAKE_DIRECTORY}/PolysquareToolingUtil.cmake)
include (${POLYSQUARE_TOOLING_CMAKE_TESTS_DIRECTORY}/CMakeUnit.cmake)

set (HEADER_FILE ${CMAKE_CURRENT_BINARY_DIR}/Header.h)
file (WRITE ${HEADER_FILE} "IS_CPP_AND_C")

set (CXX_SOURCE_FILE ${CMAKE_CURRENT_BINARY_DIR}/Source.cpp)
set (CXX_SOURCE_FILE_CONTENTS
     "#include <Header.h>\n")
file (WRITE ${CXX_SOURCE_FILE} ${CXX_SOURCE_FILE_CONTENTS})
set (C_SOURCE_FILE ${CMAKE_CURRENT_BINARY_DIR}/Source.c)
set (C_SOURCE_FILE_CONTENTS
     "#include <Header.h>\n")
file (WRITE ${C_SOURCE_FILE} ${C_SOURCE_FILE_CONTENTS})

psq_sort_sources_to_languages (C_SOURCES CXX_SOURCES
                               SOURCES
                               ${C_SOURCE_FILE}
                               ${CXX_SOURCE_FILE}
                               ${HEADER_FILE}
                               INCLUDES ${CMAKE_CURRENT_BINARY_DIR}
                               CPP_IDENTIFIERS IS_CPP_AND_C)

message ("C_SOURCES ${C_SOURCES} CXX_SOURCES ${CXX_SOURCES}")

assert_list_contains_value (CXX_SOURCES STRING EQUAL ${HEADER_FILE})
assert_list_contains_value (C_SOURCES STRING EQUAL ${HEADER_FILE})