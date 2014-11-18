# /test/GetListIntersection.cmake
#
# Gets the intersection between lists A_LIST and B_LIST. Checks that only
# items containsed in both are in DESTINATION_LIST
#
# See LICENCE.md for Copyright information

include (PolysquareToolingUtil)
include (CMakeUnit)

set (A_LIST A B C)
set (B_LIST B C D)

psq_get_list_intersection (DESTINATION_LIST
                           SOURCE ${A_LIST}
                           INTERSECTION ${B_LIST})

assert_list_contains_value (DESTINATION_LIST STRING EQUAL B)
assert_list_contains_value (DESTINATION_LIST STRING EQUAL C)
assert_list_does_not_contain_value (DESTINATION_LIST STRING EQUAL A)
assert_list_does_not_contain_value (DESTINATION_LIST STRING EQUAL D)
