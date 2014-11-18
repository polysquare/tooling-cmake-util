# /test/AppendEachToOptionsWithPrefix.cmake
#
# Checks that our list elements got added to the list with PREFIX before them.
#
# See LICENCE.md for Copyright information

include (PolysquareToolingUtil)
include (CMakeUnit)

set (LIST_ELEMENTS ONE TWO)

psq_append_each_to_options_with_prefix (OPTIONS PREFIX LIST ${LIST_ELEMENTS})

assert_list_contains_value (OPTIONS STRING EQUAL PREFIXONE)
assert_list_contains_value (OPTIONS STRING EQUAL PREFIXTWO)
