# /tests/RunToolOnSourcesCheckGeneratedVerify.cmake
# Verifies that when we ran our tool on our source file, that
# ${CMAKE_COMMAND} -E echo "${SOURCE_FILE}" was run only on the non-generated
# source (eg .*Source.cpp.*$)
#
# See LICENCE.md for Copyright information

include (CMakeUnit)

set (BUILD_OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/BUILD.output)

assert_file_has_line_matching (${BUILD_OUTPUT}
                               "^.*${CMAKE_COMMAND} -E echo .*Source.cpp.*$")
assert_file_has_line_matching (${BUILD_OUTPUT}
                                "^.*-E echo .*Generated.cpp.*$")