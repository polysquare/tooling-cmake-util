# /tests/RunToolOnSourceNotRunAgainIfStampfileExistsVerify.cmake
# Verifies that when we ran our tool on our source file, that
# ${CMAKE_COMMAND} -E touch "${SOURCE_FILE}.ToolRun" was not run
# (eg .*Source.cpp.ToolRun$) because we already have a stampfile
#
# See LICENCE.md for Copyright information

include (CMakeUnit)

set (BUILD_OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/BUILD.output")

cmake_unit_escape_string (ESCAPED_CMAKE_COMMAND "${CMAKE_COMMAND}")
set (TOOL_COMMAND_REGEX
     "^.*${ESCAPED_CMAKE_COMMAND} -E touch .*Source.cpp.ToolRun*$")
assert_file_does_not_have_line_matching (${BUILD_OUTPUT}
                                         "${TOOL_COMMAND_REGEX}")
