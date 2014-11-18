# /test/RunToolOnSourcesCheckGenerated.cmake
#
# Adds a custom target with a normal and generated source and calls
# psq_run_tool_for_each_source on it (the "tool" in this case being
# ${CMAKE_COMMAND} -E touch ${SOURCE}.ToolRun). Pass CHECK_GENERATED to
# psq_run_tool_for_each_source
#
# See LICENCE.md for Copyright information

include (CMakeUnit)
include (PolysquareToolingUtil)
include (RunToolOnGeneratedSourcesHelper)

test_run_tool_on_generated_sources (CHECK_GENERATED)
