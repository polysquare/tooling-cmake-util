# /test/RunToolOnPreexistingSourceHelper.cmake
#
# Helper macro to add call psq_run_tool_on_source for a
# pre-existing source.
#
# See LICENCE.md for Copyright information

function (test_run_tool_on_preexisting_source TOOL_NAME)

    set (SOURCE_FILE_NAME "Source.cpp")
    set (SOURCE_FILE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/Source.cpp")
    cmake_unit_create_source_file_before_build (NAME
                                                "${SOURCE_FILE}")


    add_custom_target (target ALL SOURCES "${SOURCE_FILE_PATH}")
    psq_run_tool_on_source (target "${SOURCE_FILE_PATH}"
                            "${TOOL_NAME}"
                            COMMAND
                            "${CMAKE_COMMAND}" -E touch
                            "${SOURCE_FILE_PATH}.ToolRun")

endfunction ()
