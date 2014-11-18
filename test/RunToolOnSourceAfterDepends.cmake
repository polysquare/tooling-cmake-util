# /test/RunToolOnSourceAfterDepends.cmake
#
# Adds a custom target with a source and calls psq_run_tool_on_source
# on it (the "tool" in this case being ${CMAKE_COMMAND} -E touch
# ${SOURCE_FILE}.ToolRun) and
# add a custom target "custom_dependency" not put on ALL to DEPENDS
#
# See LICENCE.md for Copyright information

include (CMakeUnit)
include (PolysquareToolingUtil)

set (SOURCE_FILE "${CMAKE_CURRENT_BINARY_DIR}/Source.cpp")
file (WRITE "${SOURCE_FILE}" "")

add_custom_target (custom_dependency
                   COMMAND cmake -E echo "ran custom_dependency")
add_custom_target (target ALL SOURCES "${SOURCE_FILE}")
psq_run_tool_on_source (target "${SOURCE_FILE}" "Tool"
                        COMMAND
                        "${CMAKE_COMMAND}" -E touch "${SOURCE_FILE}.ToolRun"
                        DEPENDS custom_dependency)
