# /tests/AppendEachToGlobalProperty.cmake
#
# Checks that our list elements got added to the GLOBAL_PROPERTY
# global property.
#
# See LICENCE.md for Copyright information.

include (${POLYSQUARE_TOOLING_CMAKE_DIRECTORY}/PolysquareToolingUtil.cmake)
include (${POLYSQUARE_TOOLING_CMAKE_TESTS_DIRECTORY}/CMakeUnit.cmake)

set (LIST_ELEMENTS ONE TWO)

psq_append_to_global_property (GLOBAL_PROPERTY LIST ${LIST_ELEMENTS})

assert_has_property_containing_value (GLOBAL GLOBAL GLOBAL_PROPERTY STRING
                                      EQUAL ONE)
assert_has_property_containing_value (GLOBAL GLOBAL GLOBAL_PROPERTY STRING
                                      EQUAL TWO)