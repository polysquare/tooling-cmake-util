# /test/GetTargetAttachPointForUtilityPreBuild.cmake
#
# Adds a custom target and calls psq_get_target_command_attach_point
# on it. The result should be PRE_BUILD as opposed to PRE_LINK.
#
# See LICENCE.md for Copyright information

include (PolysquareToolingUtil)
include (CMakeUnit)

add_custom_target (my_custom_target ALL)

psq_get_target_command_attach_point (my_custom_target WHEN)

assert_variable_is (WHEN STRING EQUAL "PRE_BUILD")
