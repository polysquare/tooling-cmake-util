# /test/RunToolOnSourceAfterDependsVerify.cmake
#
# Verifies that our "custom_dependency" target got built. If it wasn't built
# then it was never run.
#
# See LICENCE.md for Copyright information

include (CMakeUnit)

set (BUILD_OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/BUILD.output")

assert_file_has_line_matching (${BUILD_OUTPUT} "^.*custom_dependency*$")
