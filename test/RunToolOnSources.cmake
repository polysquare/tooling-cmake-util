# /test/RunToolOnSources.cmake
#
# Adds a custom target with two sources and calls psq_run_tool_for_each_source
# on it (the "tool" in this case being ${CMAKE_COMMAND} -E touch
# ${SOURCE}.ToolRun)
#
# See LICENCE.md for Copyright information

include (CMakeUnit)
include (PolysquareToolingUtil)

set (SOURCE_FILE_NAME "Source.cpp")
set (OTHER_SOURCE_FILE_NAME "Other.cpp")
cmake_unit_create_source_file_before_build (NAME
                                            "${SOURCE_FILE_NAME}")
cmake_unit_create_source_file_before_build (NAME
                                            "${OTHER_SOURCE_FILE_NAME}")

add_custom_target (target ALL SOURCES
                   "${SOURCE_FILE_NAME}"
                   "${OTHER_SOURCE_FILE_NAME}")
psq_run_tool_for_each_source (target "Tool"
                              COMMAND
                              "${CMAKE_COMMAND}" -E touch "@SOURCE@.ToolRun")
