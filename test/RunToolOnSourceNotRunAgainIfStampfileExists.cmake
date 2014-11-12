# /tests/RunToolOnSourceNotRunAgainIfStampfileExists.cmake
# Adds a custom target with a source and calls psq_run_tool_on_source
# on it (the "tool" in this case being ${CMAKE_COMMAND} -E touch
# ${SOURCE_FILE}.ToolRun), but writes the stampfile first before we get a chance
# to run the tool.
#
# See LICENCE.md for Copyright information

include (CMakeUnit)
include (PolysquareToolingUtil)

set (SOURCE_FILE "${CMAKE_CURRENT_BINARY_DIR}/Source.cpp")
file (WRITE "${SOURCE_FILE}" "")

set (STAMPFILE "${CMAKE_CURRENT_BINARY_DIR}/Source.cpp.Tool.stamp")
file (WRITE "${STAMPFILE}" "")

add_custom_target (target ALL SOURCES ${SOURCE_FILE})
psq_run_tool_on_source (target "${SOURCE_FILE}" "Tool"
                        COMMAND
                        "${CMAKE_COMMAND}" -E touch "${SOURCE_FILE}.ToolRun")
