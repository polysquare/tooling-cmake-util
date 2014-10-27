# /tests/RunToolOnSourceNotRunAgainIfStampfileExistsVerify.cmake
# Verifies that when we ran our tool on our source file, that
# ${CMAKE_COMMAND} -E echo "${SOURCE_FILE}" was not run (eg .*Source.cpp.$)
# because we already have a stampfile
#
# See LICENCE.md for Copyright information

include (CMakeUnit)

set (BUILD_OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/BUILD.output)

set (TOOL_COMMAND_REGEX "^.*${CMAKE_COMMAND} -E echo .*Source.cpp.*$")
assert_file_does_not_have_line_matching (${BUILD_OUTPUT}
                                         "${TOOL_COMMAND_REGEX}")