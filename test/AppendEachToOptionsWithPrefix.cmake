# /tests/AppendEachToOptionsWithPrefix.cmake
#
# Checks that our list elements got added to the list with PREFIX before them.
#
# See LICENCE.md for Copyright information.

include (${POLYSQUARE_TOOLING_CMAKE_DIRECTORY}/PolysquareToolingUtil.cmake)
include (${POLYSQUARE_TOOLING_CMAKE_TESTS_DIRECTORY}/CMakeUnit.cmake)

set (LIST_ELEMENTS ONE TWO)

psq_append_each_to_options_with_prefix (OPTIONS PREFIX LIST ${LIST_ELEMENTS})

assert_list_contains_value (OPTIONS STRING EQUAL PREFIXONE)
assert_list_contains_value (OPTIONS STRING EQUAL PREFIXTWO)