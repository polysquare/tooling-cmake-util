# /tests/StripExtraneousSources.cmake
#
# Adds a custom target with some SOURCES and call
# psq_strip_add_custom_target_sources on it. The returned list should
# only contain the passed sources and nothing else (like the target name).
#
# See LICENCE.md for Copyright information.

include (PolysquareToolingUtil)
include (CMakeUnit)

set (SOURCE_FILE ${CMAKE_CURRENT_BINARY_DIR}/Source.cpp)
file (WRITE ${SOURCE_FILE} "")

add_custom_target (my_custom_target ALL
                   SOURCES ${SOURCE_FILE})

psq_strip_extraneous_sources (FILTERED_SOURCES my_custom_target)

assert_list_contains_value (FILTERED_SOURCES STRING EQUAL ${SOURCE_FILE})

list (LENGTH FILTERED_SOURCES FILTERED_SOURCES_LENGTH)
assert_variable_is (FILTERED_SOURCES_LENGTH INTEGER EQUAL 1)