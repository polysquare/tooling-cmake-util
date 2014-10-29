# /tests/RunToolOnSourceGeneratesStampfileWithSpaces.cmake
# Adds a custom target with a source and calls psq_run_tool_on_source
# on it (the "tool" in this case being ${CMAKE_COMMAND} -E echo ${SOURCE})
# and the tool name being "tool (tool)"
#
# See LICENCE.md for Copyright information

include (CMakeUnit)
include (PolysquareToolingUtil)

set (SOURCE_FILE ${CMAKE_CURRENT_BINARY_DIR}/Source.cpp)
file (WRITE ${SOURCE_FILE} "")

add_custom_target (target ALL SOURCES ${SOURCE_FILE})
psq_run_tool_on_source (target ${SOURCE_FILE} "tool (tool)"
                        COMMAND ${CMAKE_COMMAND} -E echo ${SOURCE_FILE})