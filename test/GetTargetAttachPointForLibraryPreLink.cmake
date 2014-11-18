# /test/GetTargetAttachPointForLibraryPreLink.cmake
#
# Adds a library and calls psq_get_target_command_attach_point
# on it. The result should be PRE_BUILD as opposed to PRE_LINK.
#
# See LICENCE.md for Copyright information

include (PolysquareToolingUtil)
include (CMakeUnit)

cmake_unit_create_simple_library (library SHARED)
psq_get_target_command_attach_point (library WHEN)

assert_variable_is (WHEN STRING EQUAL "PRE_LINK")
