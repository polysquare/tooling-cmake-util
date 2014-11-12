# /tests/RunToolOnSources.cmake
# Adds a custom target with two sources and calls psq_run_tool_for_each_source
# on it (the "tool" in this case being ${CMAKE_COMMAND} -E touch
# ${SOURCE}.ToolRun)
#
# See LICENCE.md for Copyright information

include (CMakeUnit)
include (PolysquareToolingUtil)

set (SOURCE_FILE "${CMAKE_CURRENT_BINARY_DIR}/Source.cpp")
set (OTHER_SOURCE_FILE "${CMAKE_CURRENT_BINARY_DIR}/Other.cpp")
file (WRITE "${SOURCE_FILE}" "")
file (WRITE "${OTHER_SOURCE_FILE}" "")

add_custom_target (target ALL SOURCES "${SOURCE_FILE}" "${OTHER_SOURCE_FILE}")
psq_run_tool_for_each_source (target "Tool"
                              COMMAND
                              "${CMAKE_COMMAND}" -E touch "@SOURCE@.ToolRun")
