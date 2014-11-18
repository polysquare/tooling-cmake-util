# /test/RunToolOnSourceNotRunAgainIfStampfileExists.cmake
#
# Adds a custom target with a source and calls psq_run_tool_on_source
# on it (the "tool" in this case being ${CMAKE_COMMAND} -E touch
# ${SOURCE_FILE}.ToolRun), but writes the stampfile first before we get a chance
# to run the tool.
#
# See LICENCE.md for Copyright information

include (CMakeUnit)
include (PolysquareToolingUtil)
include (RunToolOnPreexistingSourceHelper)

set (STAMPFILE "${CMAKE_CURRENT_BINARY_DIR}/Source.cpp.Tool.stamp")
file (WRITE "${STAMPFILE}" "")

test_run_tool_on_preexisting_source ("Tool")
