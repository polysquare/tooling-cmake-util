# /tests/FilterOutGeneratedSources.cmake
#
# Tests that we can filter out generated sources added with
# add_custom_command.
#
# See LICENCE.md for Copyright information.

include (${POLYSQUARE_TOOLING_CMAKE_DIRECTORY}/PolysquareToolingUtil.cmake)
include (${POLYSQUARE_TOOLING_CMAKE_TESTS_DIRECTORY}/CMakeUnit.cmake)

set (SOURCE_FILE ${CMAKE_CURRENT_BINARY_DIR}/Source.cpp)
set (GENERATED_FILE ${CMAKE_CURRENT_BINARY_DIR}/Generated.cpp)

add_custom_command (OUTPUT ${GENERATED_FILE}
                    COMMAND ${CMAKE_COMMAND} -E touch ${GENERATED_FILE})

psq_filter_out_generated_sources (FILTERED_SOURCES
                                  SOURCES ${SOURCE_FILE} ${GENERATED_FILE})

assert_list_contains_value (FILTERED_SOURCES STRING EQUAL ${SOURCE_FILE})
assert_list_does_not_contain_value (FILTERED_SOURCES
                                    STRING EQUAL ${GENERATED_FILE})