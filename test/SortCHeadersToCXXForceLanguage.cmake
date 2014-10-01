# /tests/SortCHeadersToCXXForceLanguage.cmake
#
# Checks that C headers are put in CXX_SOURCES when calling
# psq_sort_sources_to_languages with FORCE_LANGUAGE CXX
#
# Check LICENCE.md for Copyright information.

include (${POLYSQUARE_TOOLING_CMAKE_DIRECTORY}/PolysquareToolingUtil.cmake)
include (${POLYSQUARE_TOOLING_CMAKE_TESTS_DIRECTORY}/CMakeUnit.cmake)

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

psq_sort_sources_to_languages (C_SOURCES CXX_SOURCES
                               SOURCES
                               ${C_SOURCE_FILE}
                               ${CXX_SOURCE_FILE}
                               ${HEADER_FILE}
                               INCLUDES ${CMAKE_CURRENT_BINARY_DIR}
                               FORCE_LANGUAGE CXX)

assert_list_contains_value (CXX_SOURCES STRING EQUAL ${HEADER_FILE})