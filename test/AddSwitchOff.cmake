# /tests/AddSwitchOn.cmake
#
# Checks that our ON command line switch for a variable being true is added.
#
# See LICENCE.md for Copyright information.

include (${POLYSQUARE_TOOLING_CMAKE_DIRECTORY}/PolysquareToolingUtil.cmake)
include (${POLYSQUARE_TOOLING_CMAKE_TESTS_DIRECTORY}/CMakeUnit.cmake)

set (OPTION_IS_OFF OFF)

psq_add_switch (OPTIONS OPTION_IS_OFF ON --on OFF --off)

assert_list_contains_value (OPTIONS STRING EQUAL "--off")