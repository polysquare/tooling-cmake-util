# /test/RunToolOnSourcesFilterGenerated.cmake
#
# Adds a custom target with a normal and generated source and calls
# psq_run_tool_for_each_source on it (the "tool" in this case being
# ${CMAKE_COMMAND} -E touch ${SOURCE}.ToolRun)
#
# See LICENCE.md for Copyright information

include (CMakeUnit)
include (PolysquareToolingUtil)

set (SOURCE_FILE_NAME "Source.cpp")
set (SOURCE_FILE_PATH
     "${CMAKE_CURRENT_SOURCE_DIR}/${SOURCE_FILE_NAME}")
cmake_unit_create_source_file_before_build (NAME
                                            "${SOURCE_FILE_NAME}")

set (GENERATED_SOURCE_FILE_NAME "Generated.cpp")
set (GENERATED_SOURCE_FILE_PATH
     "${CMAKE_CURRENT_BINARY_DIR}/${GENERATED_SOURCE_FILE_NAME}")
cmake_unit_generate_source_file_during_build (TARGET NAME
                                              "${GENERATED_SOURCE_FILE_NAME}")

add_custom_target (target ALL SOURCES
                   "${SOURCE_FILE_PATH}"
                   "${GENERATED_SOURCE_FILE_PATH}")
psq_run_tool_for_each_source (target "Tool"
                              COMMAND
                              "${CMAKE_COMMAND}" -E touch "@SOURCE@.ToolRun")
