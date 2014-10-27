# /tests/RunToolOnSourcesCheckGenerated.cmake
# Adds a custom target with a normal and generated source and calls
# psq_run_tool_for_each_source on it (the "tool" in this case being
# ${CMAKE_COMMAND} -E echo ${SOURCE}). Pass CHECK_GENERATED to
# psq_run_tool_for_each_source
#
# See LICENCE.md for Copyright information

include (CMakeUnit)
include (PolysquareToolingUtil)

set (SOURCE_FILE ${CMAKE_CURRENT_BINARY_DIR}/Source.cpp)
file (WRITE ${SOURCE_FILE} "")

set (GENERATED_SOURCE_FILE ${CMAKE_CURRENT_BINARY_DIR}/Generated.cpp)
add_custom_command (OUTPUT ${GENERATED_SOURCE_FILE}
                    COMMAND ${CMAKE_COMMAND} -E touch ${GENERATED_SOURCE_FILE})

add_custom_target (target ALL SOURCES ${SOURCE_FILE} ${GENERATED_SOURCE_FILE})
psq_run_tool_for_each_source (target "Tool"
                              COMMAND ${CMAKE_COMMAND} -E echo @SOURCE@
                              CHECK_GENERATED)