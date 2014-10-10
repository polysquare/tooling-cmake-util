# /tests/AddSwitchOn.cmake
#
# Checks that our ON command line switch for a variable being true is added.
#
# See LICENCE.md for Copyright information.

include (PolysquareToolingUtil)
include (CMakeUnit)

set (OPTION_IS_ON ON)

psq_add_switch (OPTIONS OPTION_IS_ON ON --on OFF --off)

assert_list_contains_value (OPTIONS STRING EQUAL "--on")