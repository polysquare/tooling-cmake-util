# /tests/AppendEachToGlobalPropertyUnique.cmake
#
# Checks that our list elements got added to the GLOBAL_PROPERTY
# global property.
#
# See LICENCE.md for Copyright information.

include (${POLYSQUARE_TOOLING_CMAKE_DIRECTORY}/PolysquareToolingUtil.cmake)
include (${POLYSQUARE_TOOLING_CMAKE_TESTS_DIRECTORY}/CMakeUnit.cmake)

set (LIST_ELEMENTS ONE ONE)

psq_append_to_global_property_unique (GLOBAL_PROPERTY LIST ${LIST_ELEMENTS})

get_property (GLOBAL_PROPERTY_LIST GLOBAL PROPERTY GLOBAL_PROPERTY)
list (LENGTH GLOBAL_PROPERTY_LIST GLOBAL_PROPERTY_LIST_LENGTH)

assert_variable_is (${GLOBAL_PROPERTY_LIST_LENGTH} INTEGER EQUAL 1)