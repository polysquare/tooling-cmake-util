# /test/RunToolOnGeneratedSourcesHelper.cmake
#
# Helper macro to call psq_run_tool_for_each_source
# on both a generated and a pre-existing source
#
# See LICENCE.md for Copyright information

function (test_run_tool_on_generated_sources)

    set (SOURCE_FILE_NAME "Source.cpp")
    set (SOURCE_FILE_PATH
         "${CMAKE_CURRENT_SOURCE_DIR}/${SOURCE_FILE_NAME}")
    cmake_unit_create_source_file_before_build (NAME
                                                "${SOURCE_FILE_NAME}")

    set (GENERATED_FILE_NAME "Generated.cpp")
    set (GENERATED_FILE_PATH
         "${CMAKE_CURRENT_BINARY_DIR}/${GENERATED_FILE_NAME}")
    cmake_unit_generate_source_file_during_build (TARGET NAME
                                                  "${GENERATED_FILE_NAME}")

    add_custom_target (target ALL SOURCES
                       "${SOURCE_FILE_PATH}"
                       "${GENERATED_FILE_PATH}")
    psq_run_tool_for_each_source (target "Tool"
                                  COMMAND
                                  "${CMAKE_COMMAND}" -E touch
                                  "@SOURCE@.ToolRun"
                                  ${ARGN})

endfunction ()
