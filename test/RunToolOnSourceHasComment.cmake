# /test/RunToolOnSourceHasComment.cmake
#
# Adds a custom target with a source and calls psq_run_tool_on_source
# on it (the "tool" in this case being ${CMAKE_COMMAND} -E touch
# ${SOURCE_FILE}.ToolRun)
#
# See LICENCE.md for Copyright information

include (CMakeUnit)
include (PolysquareToolingUtil)
include (RunToolOnPreexistingSourceHelper)

test_run_tool_on_preexisting_source ("Tool")
