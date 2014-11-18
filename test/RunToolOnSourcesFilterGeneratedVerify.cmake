# /test/RunToolOnSourcesFilterGeneratedVerify.cmake
#
# Verifies that when we ran our tool on our source file, that
# ${CMAKE_COMMAND} -E echo "${SOURCE_FILE}" was run only on the non-generated
# source (eg .*Source.cpp.*$)
#
# See LICENCE.md for Copyright information

include (CMakeUnit)

set (BUILD_OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/BUILD.output")

cmake_unit_escape_string (ESCAPED_CMAKE_COMMAND "${CMAKE_COMMAND}")
set (TOOL_COMMAND_REGEX
     "^.*${ESCAPED_CMAKE_COMMAND} .*touch .*Source.cpp.ToolRun*$")
assert_file_has_line_matching (${BUILD_OUTPUT}
                               "${TOOL_COMMAND_REGEX}")
assert_file_does_not_have_line_matching ("${BUILD_OUTPUT}"
                                         "^.*touch .*Generated.cpp.ToolRun*$")
