# /test/RunToolOnSourceHasCommentVerify.cmake
#
# Verifies that when we ran our tool on our source file, that
# a string "Analyzing ${SOURCE_FILE} with Tool" was printed
#
# See LICENCE.md for Copyright information

include (CMakeUnit)

set (BUILD_OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/BUILD.output")

assert_file_has_line_matching (${BUILD_OUTPUT}
                               "^.*Analyzing.*Source.cpp.* with Tool*$")
