# /test/GetTargetAttachPointForBinaryPreLink.cmake
#
# Adds a binary and calls psq_get_target_command_attach_point
# on it. The result should be PRE_BUILD as opposed to PRE_LINK.
#
# See LICENCE.md for Copyright information

include (PolysquareToolingUtil)
include (CMakeUnit)

cmake_unit_create_simple_executable (executable)
psq_get_target_command_attach_point (executable WHEN)

assert_variable_is (WHEN STRING EQUAL "PRE_LINK")
