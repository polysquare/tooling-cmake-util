# /test/RunToolOnSourceGeneratesStampfile.cmake
#
# Adds a custom target with a source and calls psq_run_tool_on_source
# on it (the "tool" in this case being ${CMAKE_COMMAND} -E touch
# ${SOURCE_FILE}.ToolRun)
#
# See LICENCE.md for Copyright information

include (CMakeUnit)
include (PolysquareToolingUtil)

set (SOURCE_FILE_NAME "Source.cpp")
set (SOURCE_FILE_PATH
     "${CMAKE_CURRENT_SOURCE_DIR}/${SOURCE_FILE_NAME}")
cmake_unit_create_source_file_before_build (NAME
                                            "${SOURCE_FILE_NAME}")

add_custom_target (target ALL SOURCES "${SOURCE_FILE_PATH}")
psq_run_tool_on_source (target "${SOURCE_FILE_PATH}" "Tool"
                        COMMAND
                        "${CMAKE_COMMAND}" -E touch
                        "${SOURCE_FILE_PATH}.ToolRun")
