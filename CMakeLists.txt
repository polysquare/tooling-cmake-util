# /CMakeLists.txt
#
# Main entry point for PolysquareToolingUtil tests.
#
# See /LICENCE.md for Copyright information

if (NOT CMAKE_SCRIPT_MODE_FILE)

    project (PolsquareToolingUtilTest NONE)
    set (NEW_POLICIES CMP0025 CMP0056)

    foreach (POLICY ${NEW_POLICIES})

        if (POLICY ${POLICY})

            cmake_policy (SET ${POLICY} NEW)

        endif ()

    endforeach ()

endif ()

cmake_minimum_required (VERSION 2.8)

set (CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR};${CMAKE_MODULE_PATH}")
set (_CURRENT_LIST_FILE "${CMAKE_CURRENT_LIST_FILE}")

include ("smspillaz/cmake-unit/CMakeUnitRunner")
include ("smspillaz/cmake-unit/CMakeUnit")
include (PolysquareToolingUtil)

# Checks that our ON command line switch for a variable being true is added.
function (psq_test_add_switch_off)

    function (psq_configure)

        set (OPTION_IS_OFF OFF)
        psq_add_switch (OPTIONS OPTION_IS_OFF ON --on OFF --off)
        cmake_unit_assert_that (OPTIONS
                                list_contains_value STRING EQUAL "--off")

    endfunction ()

    cmake_unit_configure_config_only_test (CONFIGURE COMMAND psq_configure)

endfunction ()

# Checks that our ON command line switch for a variable being true is added.
function (psq_test_add_switch_on)

    function (psq_configure)

        set (OPTION_IS_ON ON)
        psq_add_switch (OPTIONS OPTION_IS_ON ON --on OFF --off)
        cmake_unit_assert_that (OPTIONS
                                list_contains_value STRING EQUAL "--on")

    endfunction ()

    cmake_unit_configure_config_only_test (CONFIGURE COMMAND psq_configure)

endfunction ()

# Checks that our list elements got added to the GLOBAL_PROPERTY
# global property.
function (psq_test_append_each_to_global_property)

    function (psq_configure)

        set (LIST_ELEMENTS ONE TWO)
        psq_append_to_global_property (GLOBAL_PROPERTY LIST ${LIST_ELEMENTS})
        cmake_unit_assert_that (GLOBAL item_has_property_containing_value
                                GLOBAL GLOBAL_PROPERTY STRING EQUAL ONE)
        cmake_unit_assert_that (GLOBAL item_has_property_containing_value
                                GLOBAL GLOBAL_PROPERTY STRING EQUAL TWO)

    endfunction ()

    cmake_unit_configure_config_only_test (CONFIGURE COMMAND psq_configure)

endfunction ()

# Checks that our list elements got added to the GLOBAL_PROPERTY
# global property.
function (psq_test_append_each_to_global_property_unique)

    function (psq_configure)

        set (LIST_ELEMENTS ONE ONE)
        psq_append_to_global_property_unique (GLOBAL_PROPERTY
                                              LIST ${LIST_ELEMENTS})
        get_property (GLOBAL_PROPERTY_LIST GLOBAL PROPERTY GLOBAL_PROPERTY)
        list (LENGTH GLOBAL_PROPERTY_LIST GLOBAL_PROPERTY_LIST_LENGTH)
        cmake_unit_assert_that (GLOBAL_PROPERTY_LIST_LENGTH
                                compare_as INTEGER EQUAL 1)

    endfunction ()

    cmake_unit_configure_config_only_test (CONFIGURE COMMAND psq_configure)

endfunction ()

# Checks that our list elements got added to the list with PREFIX before them.
function (psq_test_append_each_to_options_with_prefix)

    function (psq_configure)

        set (LIST_ELEMENTS ONE TWO)
        psq_append_each_to_options_with_prefix (OPTIONS PREFIX
                                                LIST ${LIST_ELEMENTS})
        cmake_unit_assert_that (OPTIONS
                                list_contains_value STRING EQUAL PREFIXONE)
        cmake_unit_assert_that (OPTIONS
                                list_contains_value STRING EQUAL PREFIXTWO)

    endfunction ()

    cmake_unit_configure_config_only_test (CONFIGURE COMMAND psq_configure)

endfunction ()

# Adds some source files, including a source file which is not a valid
# compilation unit or header source at all. The configure step should succeed.
function (psq_test_extraneous_non_header_sources_not_scanned)

    cmake_unit_get_dirs (BINARY_DIR SOURCE_DIR)

    function (psq_configure)

        set (SOURCE_DIR "${SOURCE_DIR}")
        set (BINARY_DIR "${BINARY_DIR}")
        set (CXX_SOURCE_FILE "Source.cpp")
        set (CXX_SOURCE_FILE_PATH "${SOURCE_DIR}/${CXX_SOURCE_FILE}")
        set (EXTRANEOUS_FILE "${BINARY_DIR}/Extraneous.nonstandard")
        cmake_unit_create_source_file_before_build (NAME
                                                    "${CXX_SOURCE_FILE}"
                                                    FUNCTIONS main
                                                    GENERATING_FILE
                                                    "${_CURRENT_LIST_FILE}")
        file (WRITE "${EXTRANEOUS_FILE}" "")
        set (TARGET executable)
        add_executable (${TARGET}
                        "${CXX_SOURCE_FILE_PATH}"
                        "${EXTRANEOUS_FILE}")
        psq_strip_extraneous_sources (FILTERED_SOURCES ${TARGET})
        psq_sort_sources_to_languages (C_SOURCES CXX_SOURCES HEADERS
                                       SOURCES ${FILTERED_SOURCES})
        cmake_unit_assert_that (C_SOURCES not list_contains_value
                                STRING EQUAL "${EXTRANEOUS_FILE}")
        cmake_unit_assert_that (CXX_SOURCES not list_contains_value
                                STRING EQUAL "${EXTRANEOUS_FILE}")
        cmake_unit_assert_that (HEADERS not list_contains_value
                                STRING EQUAL "${EXTRANEOUS_FILE}")

    endfunction ()

    cmake_unit_configure_config_only_test (CONFIGURE COMMAND psq_configure
                                           INVOKE_CONFIGURE OPTIONS
                                                            LANGUAGES
                                                            C
                                                            CXX)

endfunction ()

# Tests that we can filter out generated sources added with
# add_custom_command.
function (psq_test_filter_out_generated_sources)

    cmake_unit_get_dirs (BINARY_DIR SOURCE_DIR)

    function (psq_configure)

        set (SOURCE_FILE "${BINARY_DIR}/Source.cpp")
        set (GENERATED_FILE "${BINARY_DIR}/Generated.cpp")
        add_custom_command (OUTPUT "${GENERATED_FILE}"
                            COMMAND
                            "${CMAKE_COMMAND}"
                            -E
                            touch
                            "${GENERATED_FILE}")
        psq_filter_out_generated_sources (FILTERED_SOURCES
                                          SOURCES "${SOURCE_FILE}"
                                                  "${GENERATED_FILE}")
        cmake_unit_assert_that (FILTERED_SOURCES
                                list_contains_value STRING EQUAL
                                "${SOURCE_FILE}")
        cmake_unit_assert_that (FILTERED_SOURCES not list_contains_value
                                STRING EQUAL "${GENERATED_FILE}")

    endfunction ()

    cmake_unit_configure_config_only_test (CONFIGURE COMMAND psq_configure)

endfunction ()

# Checks that some multi-variable arguments passed in to a function with
# an argument prefix PREFIX get re-added to the forward options list
# as MUTLIVAR_ARGUMENT_NAME;Argument1;Argument2; etc.
function (psq_test_forward_multivar_args)

    function (psq_configure)

        set (PASSED_ARGUMENTS_ONE Argument1)
        set (PASSED_ARGUMENTS_TWO Argument2)
        set (PASSED_ARGUMENTS ${PASSED_ARGUMENTS_ONE} ${PASSED_ARGUMENTS_TWO})
        function (psq_called_function)
            cmake_parse_arguments (PREFIX "" "" "MULTIVAR_ARGUMENT_NAME"
                                   ${ARGN})

            psq_forward_options (PREFIX
                                 FORWARD_OPTIONS
                                 MULTIVAR_ARGS MULTIVAR_ARGUMENT_NAME)
            cmake_unit_assert_that (FORWARD_OPTIONS list_contains_value
                                    STRING EQUAL MULTIVAR_ARGUMENT_NAME)
            cmake_unit_assert_that (FORWARD_OPTIONS list_contains_value
                                    STRING EQUAL ${PASSED_ARGUMENTS_ONE})
            cmake_unit_assert_that (FORWARD_OPTIONS list_contains_value
                                    STRING EQUAL ${PASSED_ARGUMENTS_TWO})
        endfunction ()

        psq_called_function (MULTIVAR_ARGUMENT_NAME ${PASSED_ARGUMENTS})

    endfunction ()

    cmake_unit_configure_config_only_test (CONFIGURE COMMAND psq_configure)

endfunction ()

# Checks that option arguments passed to a function get put back into the
# forward options list with their original name, but only if they were
# set
function (psq_test_forward_option_args)

    function (psq_configure)

        function (psq_called_function)
            set (OPTION_ARGS PASSED NOT_PASSED)
            cmake_parse_arguments (PREFIX "${OPTION_ARGS}" "" "" ${ARGN})
            psq_forward_options (PREFIX
                                 FORWARD_OPTIONS OPTION_ARGS ${OPTION_ARGS})
            cmake_unit_assert_that (FORWARD_OPTIONS
                                    list_contains_value STRING EQUAL PASSED)
            cmake_unit_assert_that (FORWARD_OPTIONS not list_contains_value
                                    STRING EQUAL NOT_PASSED)
        endfunction ()

        psq_called_function (PASSED)

    endfunction ()

    cmake_unit_configure_config_only_test (CONFIGURE COMMAND psq_configure)

endfunction ()

# Checks that some single-variable arguments passed in to a function with
# an argument prefix PREFIX get re-added to the forward options list
# as SINGLEVAR_ARGUMENT_NAME_PASSED;Argument1 etc and
# SINGLEVAR_ARGUMENT_NAME_NOT_PASSED is not present in the forward options.
function (psq_test_forward_singlevar_args)

    function (psq_configure)

        set (PASSED_ARGUMENT Argument)
        function (psq_called_function)
            set (SINGLEVAR_ARGS SINGLEVAR_ARGUMENT_NAME_PASSED
                                SINGLEVAR_ARGUMENT_NAME_NOT_PASSED)
            cmake_parse_arguments (PREFIX "" "${SINGLEVAR_ARGS}" "" ${ARGN})
            psq_forward_options (PREFIX
                                 FORWARD_OPTIONS
                                 SINGLEVAR_ARGS ${SINGLEVAR_ARGS})
            cmake_unit_assert_that (FORWARD_OPTIONS list_contains_value
                                    STRING EQUAL SINGLEVAR_ARGUMENT_NAME_PASSED)
            cmake_unit_assert_that (FORWARD_OPTIONS list_contains_value
                                    STRING EQUAL ${PASSED_ARGUMENT})
            cmake_unit_assert_that (FORWARD_OPTIONS not list_contains_value
                                    STRING EQUAL
                                    SINGLEVAR_ARGUMENT_NAME_NOT_PASSED)
        endfunction ()

        psq_called_function (SINGLEVAR_ARGUMENT_NAME_PASSED ${PASSED_ARGUMENT})

    endfunction ()

    cmake_unit_configure_config_only_test (CONFIGURE COMMAND psq_configure)

endfunction ()

# Gets the intersection between lists A_LIST and B_LIST. Checks that only
# items contained in both are in DESTINATION_LIST
function (psq_test_get_list_intersection)

    function (psq_configure)

        set (A_LIST A B C)
        set (B_LIST B C D)
        psq_get_list_intersection (DESTINATION_LIST
                                   SOURCE ${A_LIST}
                                   INTERSECTION ${B_LIST})
        message (STATUS "Interseciton was ${DESTINATION_LIST}")
        cmake_unit_assert_that (DESTINATION_LIST list_contains_value
                                STRING EQUAL B)
        cmake_unit_assert_that (DESTINATION_LIST list_contains_value
                                STRING EQUAL C)
        cmake_unit_assert_that (DESTINATION_LIST not list_contains_value
                                STRING EQUAL A)
        cmake_unit_assert_that (DESTINATION_LIST not list_contains_value
                                STRING EQUAL D)

    endfunction ()

    cmake_unit_configure_config_only_test (CONFIGURE COMMAND psq_configure)

endfunction ()

# Adds a binary and calls psq_get_target_command_attach_point
# on it. The result should be PRE_BUILD as opposed to PRE_LINK.
function (psq_test_get_target_attach_point_for_binary_pre_link)

    function (psq_configure)

        cmake_unit_create_simple_executable (executable
                                             GENERATING_FILE
                                             "${_CURRENT_LIST_FILE}")
        psq_get_target_command_attach_point (executable WHEN)
        cmake_unit_assert_that (WHEN compare_as STRING EQUAL "PRE_LINK")

    endfunction ()

    cmake_unit_configure_config_only_test (CONFIGURE COMMAND psq_configure
                                           INVOKE_CONFIGURE OPTIONS
                                                            LANGUAGES
                                                            C
                                                            CXX)

endfunction ()

# Adds a library and calls psq_get_target_command_attach_point
# on it. The result should be PRE_BUILD as opposed to PRE_LINK.
function (psq_test_get_target_attach_point_for_library_pre_link)

    function (psq_configure)

        cmake_unit_create_simple_library (library SHARED
                                          GENERATING_FILE
                                          "${_CURRENT_LIST_FILE}")
        psq_get_target_command_attach_point (library WHEN)
        cmake_unit_assert_that (WHEN compare_as STRING EQUAL "PRE_LINK")

    endfunction ()

    cmake_unit_configure_config_only_test (CONFIGURE COMMAND psq_configure
                                           INVOKE_CONFIGURE OPTIONS
                                                            LANGUAGES
                                                            C
                                                            CXX)

endfunction ()

# Adds a custom target and calls psq_get_target_command_attach_point
# on it. The result should be PRE_BUILD as opposed to PRE_LINK.
function (psq_test_get_target_attach_point_for_utility_pre_build)

    function (psq_configure)

        add_custom_target (my_custom_target ALL)
        psq_get_target_command_attach_point (my_custom_target WHEN)
        cmake_unit_assert_that (WHEN compare_as STRING EQUAL "PRE_BUILD")

    endfunction ()

    cmake_unit_configure_config_only_test (CONFIGURE COMMAND psq_configure)

endfunction ()

# Tests that we can filter out generated sources added with
# add_custom_command if CHECK_GENERATED was not passed to
# psq_handle_check_generated_option
function (psq_test_handle_check_generated_option_filter)

    cmake_unit_get_dirs (BINARY_DIR SOURCE_DIR)

    function (psq_configure)

        set (SOURCE_FILE "${BINARY_DIR}/Source.cpp")
        set (GENERATED_FILE "${BINARY_DIR}/Generated.cpp")
        add_custom_command (OUTPUT "${GENERATED_FILE}"
                            COMMAND "${CMAKE_COMMAND}"
                                    -E
                                    touch
                                    "${GENERATED_FILE}")
        function (psq_add_tooling)
            cmake_parse_arguments (PREFIX "CHECK_GENERATED" "" "" ${ARGN})
            psq_handle_check_generated_option (PREFIX FILTERED_SOURCES
                                               SOURCES "${SOURCE_FILE}"
                                                       "${GENERATED_FILE}")
            cmake_unit_assert_that (FILTERED_SOURCES list_contains_value
                                    STRING EQUAL "${SOURCE_FILE}")
            cmake_unit_assert_that (FILTERED_SOURCES not list_contains_value
                                    STRING EQUAL "${GENERATED_FILE}")
        endfunction ()

        psq_add_tooling ()

    endfunction ()

    cmake_unit_configure_config_only_test (CONFIGURE COMMAND psq_configure)

endfunction ()

# Tests that we can filter out generated sources added with
# add_custom_command if CHECK_GENERATED was not passed to
# psq_handle_check_generated_option
function (psq_test_handle_check_generated_option_no_filter)

    cmake_unit_get_dirs (BINARY_DIR SOURCE_DIR)

    function (psq_configure)

        set (SOURCE_FILE "${BINARY_DIR}/Source.cpp")
        set (GENERATED_FILE "${BINARY_DIR}/Generated.cpp")
        add_custom_command (OUTPUT "${GENERATED_FILE}"
                            COMMAND "${CMAKE_COMMAND}"
                                    -E
                                    touch
                                    "${GENERATED_FILE}")
        function (psq_add_tooling)
            cmake_parse_arguments (PREFIX "CHECK_GENERATED" "" "" ${ARGN})
            psq_handle_check_generated_option (PREFIX FILTERED_SOURCES
                                               SOURCES "${SOURCE_FILE}"
                                                       "${GENERATED_FILE}")
            cmake_unit_assert_that (FILTERED_SOURCES list_contains_value
                                    STRING EQUAL "${SOURCE_FILE}")
            cmake_unit_assert_that (FILTERED_SOURCES list_contains_value
                                    STRING EQUAL "${GENERATED_FILE}")
        endfunction ()

        psq_add_tooling (CHECK_GENERATED)

    endfunction ()

    cmake_unit_configure_config_only_test (CONFIGURE COMMAND psq_configure)

endfunction ()

# Helper macro to generate a header and source file as
# well as a corresponding compilation database. Extra
# arguments get passed to psq_make_compilation_db.
macro (psq_make_sources_and_compilation_db SOURCE_NAME LANGUAGE)
    set (HEADER_FILE "Header.h")
    set (HEADER_FILE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/${HEADER_FILE}")
    cmake_unit_create_source_file_before_build (NAME "${HEADER_FILE}"
                                                GENERATING_FILE
                                                "${_CURRENT_LIST_FILE}")
    set (SOURCE_FILE_NAME "${SOURCE_NAME}")
    set (SOURCE_FILE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/${SOURCE_FILE_NAME}")
    cmake_unit_create_source_file_before_build (NAME "${SOURCE_FILE_NAME}"
                                                FUNCTIONS main
                                                GENERATING_FILE
                                                "${_CURRENT_LIST_FILE}")
    set (TARGET target)
    add_custom_target (${TARGET} ALL
                       SOURCES "${SOURCE_FILE_PATH}" "${HEADER_FILE_PATH}")
    psq_make_compilation_db (${TARGET} COMPILATION_DB_DIR
                             ${LANGUAGE}_SOURCES
                             "${SOURCE_FILE_PATH}"
                             "${HEADER_FILE_PATH}"
                             INTERNAL_INCLUDE_DIRS "${CMAKE_CURRENT_SOURCE_DIR}"
                             ${ARGN})
endmacro ()

# Helper macro to call psq_run_tool_for_each_source
# on both a generated and a pre-existing source
function (psq_run_tool_on_generated_sources)
    set (SOURCE_FILE_NAME "Source.cpp")
    set (SOURCE_FILE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/${SOURCE_FILE_NAME}")
    cmake_unit_create_source_file_before_build (NAME "${SOURCE_FILE_NAME}"
                                                GENERATING_FILE
                                                "${_CURRENT_LIST_FILE}")
    set (GENERATED_FILE_NAME "Generated.cpp")
    set (GENERATED_FILE_PATH
         "${CMAKE_CURRENT_BINARY_DIR}/${GENERATED_FILE_NAME}")
    cmake_unit_generate_source_file_during_build (TARGET
                                                  NAME "${GENERATED_FILE_NAME}")
    add_custom_target (target ALL
                       SOURCES "${SOURCE_FILE_PATH}" "${GENERATED_FILE_PATH}")
    psq_run_tool_for_each_source (target
                                  "Tool"
                                  COMMAND "${CMAKE_COMMAND}"
                                          -E
                                          touch
                                          "@SOURCE@.ToolRun"
                                  ${ARGN})
endfunction ()

# Helper macro to add call psq_run_tool_on_source for a
# pre-existing source.
function (psq_run_tool_on_preexisting_source TOOL_NAME)
    set (SOURCE_FILE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/Source.cpp")
    set (STAMP_FILE_PATH "${CMAKE_CURRENT_BINARY_DIR}/Source.cpp")
    cmake_unit_create_source_file_before_build (NAME "${SOURCE_FILE}"
                                                GENERATING_FILE
                                                "${_CURRENT_LIST_FILE}")
    add_custom_target (target ALL SOURCES "${SOURCE_FILE_PATH}")
    psq_run_tool_on_source (target "${SOURCE_FILE_PATH}" "${TOOL_NAME}"
                            COMMAND "${CMAKE_COMMAND}"
                                    -E
                                    touch
                                    "${STAMP_FILE_PATH}.ToolRun")
endfunction ()

# Adds a custom target with a source and calls psq_run_tool_on_source
# on it (the "tool" in this case being ${CMAKE_COMMAND} -E touch
# /${SOURCE_FILE}.ToolRun)
function (psq_test_run_tool_on_source)

    function (psq_configure)

        psq_run_tool_on_preexisting_source ("ool")

    endfunction ()

    function (psq_verify)

        cmake_unit_get_log_for (INVOKE_BUILD OUTPUT BUILD_OUTPUT)
        cmake_unit_escape_string (ESCAPED_CMAKE_COMMAND "${CMAKE_COMMAND}")
        set (TOOL_COMMAND_REGEX
             "^.*${ESCAPED_CMAKE_COMMAND} -E touch .*Source.cpp.ToolRun*$")
        cmake_unit_assert_that ("${BUILD_OUTPUT}"
                                file_contents any_line matches_regex
                                "${TOOL_COMMAND_REGEX}")

    endfunction ()

    cmake_unit_configure_config_only_test (CONFIGURE COMMAND psq_configure)
endfunction ()

# Adds a custom target with a source and calls psq_run_tool_on_source
# on it (the "tool" in this case being ${CMAKE_COMMAND} -E touch
# /${SOURCE_FILE}.ToolRun) and
# add a custom target "custom_dependency" not put on ALL to DEPENDS
function (psq_test_run_tool_on_source_after_depends)

    cmake_unit_get_dirs (BINARY_DIR SOURCE_DIR)

    function (psq_configure)

        set (SOURCE_FILE_NAME "Source.cpp")
        set (SOURCE_FILE_PATH "${SOURCE_DIR}/${SOURCE_FILE_NAME}")
        set (STAMP_FILE_PATH "${BINARY_DIR}/${SOURCE_FILE_NAME}")
        cmake_unit_create_source_file_before_build (NAME "${SOURCE_FILE_NAME}"
                                                    GENERATING_FILE
                                                    "${_CURRENT_LIST_FILE}")
        add_custom_target (custom_dependency
                           COMMAND cmake -E echo "ran custom_dependency")
        add_custom_target (target ALL SOURCES "${SOURCE_FILE_PATH}")
        psq_run_tool_on_source (target "${SOURCE_FILE_PATH}" "Tool"
                                COMMAND "${CMAKE_COMMAND}"
                                        -E
                                        touch
                                        "${STAMP_FILE_PATH}.ToolRun"
                                DEPENDS custom_dependency)

    endfunction ()

    function (psq_verify)

        cmake_unit_get_log_for (INVOKE_BUILD OUTPUT BUILD_OUTPUT)
        message (STATUS "Reading ${BUILD_OUTPUT}")
        cmake_unit_assert_that (${BUILD_OUTPUT}
                                file_contents any_line matches_regex
                                "^.*custom_dependency*$")

    endfunction ()

    cmake_unit_configure_test (CONFIGURE COMMAND psq_configure
                               VERIFY COMMAND psq_verify
                               INVOKE_CONFIGURE OPTIONS LANGUAGES C CXX)
endfunction ()

# Adds a custom target with a source and calls psq_run_tool_on_source
# on it (the "tool" in this case being ${CMAKE_COMMAND} -E touch
# /${SOURCE_FILE}.ToolRun)
function (psq_test_run_tool_on_source_generates_stampfile)

    function (psq_configure)

        psq_run_tool_on_preexisting_source ("Tool")

    endfunction ()

    function (psq_verify)

        cmake_unit_get_dirs (BINARY_DIR SOURCE_DIR)
        cmake_unit_assert_that ("${BINARY_DIR}/Source.cpp.Tool.stamp"
                                exists_as_file)

    endfunction ()

    cmake_unit_configure_test (CONFIGURE COMMAND psq_configure
                               VERIFY COMMAND psq_verify
                               INVOKE_CONFIGURE OPTIONS LANGUAGES C CXX)
endfunction ()

# Adds a custom target with a source and calls psq_run_tool_on_source
# on it (the "tool" in this case being ${CMAKE_COMMAND} -E
# touch /${SOURCE_FILE}.ToolRun)
# and the tool name being "tool (tool)"
function (psq_test_run_tool_on_source_generates_stampfile_with_spaces)

    function (psq_configure)

        psq_run_tool_on_preexisting_source ("tool (tool)")

    endfunction ()

    function (psq_verify)

        cmake_unit_get_dirs (BINARY_DIR SOURCE_DIR)
        cmake_unit_assert_that ("${BINARY_DIR}/Source.cpp.tool (tool).stamp"
                                exists_as_file)

    endfunction ()

    cmake_unit_configure_test (CONFIGURE COMMAND psq_configure
                               VERIFY COMMAND psq_verify)
endfunction ()

# Adds a custom target with a source and calls psq_run_tool_on_source
# on it (the "tool" in this case being ${CMAKE_COMMAND} -E touch
# ${SOURCE_FILE}.ToolRun)
function (psq_test_run_tool_on_source_has_comment)

    function (psq_configure)

        psq_run_tool_on_preexisting_source ("Tool")

    endfunction ()

    function (psq_verify)

        cmake_unit_get_log_for (INVOKE_BUILD OUTPUT BUILD_OUTPUT)
        cmake_unit_assert_that (${BUILD_OUTPUT}
                                file_contents any_line matches_regex
                                "^.*Analyzing.*Source.cpp.* with Tool.*$")

    endfunction ()

    cmake_unit_configure_test (PRECONFIGURE OPTIONS
                                            SKIP_GENERATOR_REGEX
                                            "^.*Ninja.*$"
                               CONFIGURE COMMAND psq_configure
                               VERIFY COMMAND psq_verify
                               INVOKE_CONFIGURE OPTIONS LANGUAGES C CXX)
endfunction ()

# Adds a custom target with a source and calls psq_run_tool_on_source
# on it (the "tool" in this case being ${CMAKE_COMMAND} -E touch
# /${SOURCE_FILE}.ToolRun), but writes the stampfile first before we get a
# chance to run the tool.
function (psq_test_run_tool_on_source_not_run_again_if_stampfile_exists)

    cmake_unit_get_dirs (BINARY_DIR SOURCE_DIR)

    function (psq_configure)

        set (STAMPFILE "${BINARY_DIR}/Source.cpp.Tool.stamp")
        file (WRITE "${STAMPFILE}" "")
        psq_run_tool_on_preexisting_source ("Tool")

    endfunction ()

    function (psq_verify)

        cmake_unit_get_log_for (INVOKE_BUILD OUTPUT BUILD_OUTPUT)
        cmake_unit_escape_string (ESCAPED_CMAKE_COMMAND "${CMAKE_COMMAND}")
        set (TOOL_COMMAND_REGEX
             "^.*${ESCAPED_CMAKE_COMMAND} -E touch .*Source.cpp.ToolRun*$")
        cmake_unit_assert_that ("${BUILD_OUTPUT}"
                                not file_contents any_line matches_regex
                                "${TOOL_COMMAND_REGEX}")

    endfunction ()

    cmake_unit_configure_test (PRECONFIGURE OPTIONS
                                            SKIP_GENERATOR_REGEX
                                            "^.*Visual Studio.*$"
                                            "^.*Ninja.*$"
                               CONFIGURE COMMAND psq_configure
                               VERIFY COMMAND psq_verify)
endfunction ()

# Adds a custom target with two sources and calls psq_run_tool_for_each_source
# on it (the "tool" in this case being ${CMAKE_COMMAND} -E touch
# /${SOURCE}.ToolRun)
function (psq_test_run_tool_on_sources)

    function (psq_configure)

        set (SOURCE_FILE_NAME "Source.cpp")
        set (OTHER_SOURCE_FILE_NAME "Other.cpp")
        cmake_unit_create_source_file_before_build (NAME "${SOURCE_FILE_NAME}"
                                                    GENERATING_FILE
                                                    "${_CURRENT_LIST_FILE}")
        cmake_unit_create_source_file_before_build (NAME
                                                    "${OTHER_SOURCE_FILE_NAME}"
                                                    GENERATING_FILE
                                                    "${_CURRENT_LIST_FILE}")
        add_custom_target (target ALL
                           SOURCES "${SOURCE_FILE_NAME}"
                                   "${OTHER_SOURCE_FILE_NAME}")
        psq_run_tool_for_each_source (target "Tool"
                                      COMMAND "${CMAKE_COMMAND}"
                                              -E
                                              touch
                                              "@SOURCE@.ToolRun")

    endfunction ()

    function (psq_verify)

        cmake_unit_get_log_for (INVOKE_BUILD OUTPUT BUILD_OUTPUT)
        cmake_unit_escape_string (ESCAPED_CMAKE_COMMAND "${CMAKE_COMMAND}")
        set (TOOL_SOURCE_COMMAND_REGEX
             "^.*${ESCAPED_CMAKE_COMMAND} -E touch .*Source.cpp.ToolRun*$")
        cmake_unit_assert_that (${BUILD_OUTPUT}
                                file_contents any_line matches_regex
                                "${TOOL_SOURCE_COMMAND_REGEX}")
        cmake_unit_escape_string (ESCAPED_CMAKE_COMMAND "${CMAKE_COMMAND}")
        set (TOOL_OTHER_COMMAND_REGEX
             "^.*${ESCAPED_CMAKE_COMMAND} -E touch .*Other.cpp.ToolRun*$")
        cmake_unit_assert_that ("${BUILD_OUTPUT}"
                                file_contents any_line matches_regex
                                "${TOOL_OTHER_COMMAND_REGEX}")

    endfunction ()

    cmake_unit_configure_test (CONFIGURE COMMAND psq_configure
                               VERIFY COMMAND psq_verify
                               INVOKE_CONFIGURE OPTIONS LANGUAGES C CXX)
endfunction ()

# Adds a custom target with a normal and generated source and calls
# psq_run_tool_for_each_source on it (the "tool" in this case being
# ${CMAKE_COMMAND} -E touch /${SOURCE}.ToolRun). Pass CHECK_GENERATED to
# psq_run_tool_for_each_source
function (psq_test_run_tool_on_sources_check_generated)

    cmake_unit_get_dirs (BINARY_DIR SOURCE_DIR)

    function (psq_configure)

        psq_run_tool_on_generated_sources (CHECK_GENERATED)

    endfunction ()

    function (psq_verify)

        cmake_unit_get_log_for (INVOKE_BUILD OUTPUT BUILD_OUTPUT)
        cmake_unit_escape_string (ESCAPED_CMAKE_COMMAND "${CMAKE_COMMAND}")
        set (TOOL_COMMAND_REGEX
             "^.*${ESCAPED_CMAKE_COMMAND} -E touch .*Source.cpp.ToolRun*$")
        cmake_unit_assert_that (${BUILD_OUTPUT}
                                file_contents any_line matches_regex
                                "${TOOL_COMMAND_REGEX}")
        cmake_unit_assert_that (${BUILD_OUTPUT}
                                file_contents any_line matches_regex
                                "^.*-E touch .*Generated.cpp.ToolRun*$")

        file (REMOVE "${SOURCE_DIR}/Source.cpp.ToolRun")

    endfunction ()

    cmake_unit_configure_test (CONFIGURE COMMAND psq_configure
                               VERIFY COMMAND psq_verify
                               INVOKE_CONFIGURE OPTIONS LANGUAGES C CXX)
endfunction ()

# Adds a custom target with a normal and generated source and calls
# psq_run_tool_for_each_source on it (the "tool" in this case being
# ${CMAKE_COMMAND} -E touch /${SOURCE}.ToolRun)
function (psq_test_run_tool_on_sources_filter_generated)

    cmake_unit_get_dirs (BINARY_DIR SOURCE_DIR)

    function (psq_configure)

        psq_run_tool_on_generated_sources ()

    endfunction ()

    function (psq_verify)

        cmake_unit_get_log_for (INVOKE_BUILD OUTPUT BUILD_OUTPUT)
        cmake_unit_escape_string (ESCAPED_CMAKE_COMMAND "${CMAKE_COMMAND}")
        set (TOOL_COMMAND_REGEX
             "^.*${ESCAPED_CMAKE_COMMAND} .*touch .*Source.cpp.ToolRun*$")
        cmake_unit_assert_that (${BUILD_OUTPUT}
                                file_contents any_line matches_regex
                                "${TOOL_COMMAND_REGEX}")
        cmake_unit_assert_that ("${BUILD_OUTPUT}"
                                not file_contents any_line matches_regex
                                "^.*touch .*Generated.cpp.ToolRun*$")

        file (REMOVE "${SOURCE_DIR}/Source.cpp.ToolRun")

    endfunction ()

    cmake_unit_configure_test (CONFIGURE COMMAND psq_configure
                               VERIFY COMMAND psq_verify
                               INVOKE_CONFIGURE OPTIONS LANGUAGES C CXX)
endfunction ()

# Checks that C headers are put in C_SOURCES when calling
# psq_sort_sources_to_languages
function (psq_test_sort_c_headers_to_c)

    cmake_unit_get_dirs (BINARY_DIR SOURCE_DIR)

    function (psq_configure)

        set (HEADER_FILE "Header.h")
        set (HEADER_FILE_PATH "${SOURCE_DIR}/${HEADER_FILE}")
        cmake_unit_create_source_file_before_build (NAME "${HEADER_FILE}"
                                                    GENERATING_FILE
                                                    "${_CURRENT_LIST_FILE}")
        set (CXX_SOURCE_FILE "Source.cpp")
        set (CXX_SOURCE_FILE_PATH "${SOURCE_DIR}/${CXX_SOURCE_FILE}")
        cmake_unit_create_source_file_before_build (NAME "${CXX_SOURCE_FILE}"
                                                    INCLUDES
                                                    "${HEADER_FILE_PATH}"
                                                    INCLUDE_DIRECTORIES
                                                    "${SOURCE_DIR}"
                                                    GENERATING_FILE
                                                    "${_CURRENT_LIST_FILE}")
        set (C_SOURCE_FILE "Source.c")
        set (C_SOURCE_FILE_PATH "${SOURCE_DIR}/${C_SOURCE_FILE}")
        cmake_unit_create_source_file_before_build (NAME "${C_SOURCE_FILE}"
                                                    INCLUDES
                                                    "${HEADER_FILE_PATH}"
                                                    INCLUDE_DIRECTORIES
                                                    "${SOURCE_DIR}"
                                                    GENERATING_FILE
                                                    "${_CURRENT_LIST_FILE}")
        psq_sort_sources_to_languages (C_SOURCES CXX_SOURCES HEADERS
                                       SOURCES "${C_SOURCE_FILE_PATH}"
                                               "${CXX_SOURCE_FILE_PATH}"
                                               "${HEADER_FILE_PATH}"
                                       INCLUDES "${SOURCE_DIR}")
        cmake_unit_assert_that (C_SOURCES list_contains_value
                                STRING EQUAL "${HEADER_FILE_PATH}")
        cmake_unit_assert_that (CXX_SOURCES not list_contains_value
                                STRING EQUAL "${HEADER_FILE_PATH}")

    endfunction ()

    cmake_unit_configure_config_only_test (CONFIGURE COMMAND psq_configure
                                           INVOKE_CONFIGURE OPTIONS
                                                            LANGUAGES
                                                            C
                                                            CXX)

endfunction ()

# Checks that C headers are put in CXX_SOURCES when calling
# psq_sort_sources_to_languages with CPP_IDENTIFIERS that this header has.
function (psq_test_sort_c_headers_to_cxx_and_c_with_cpp_identifiers)

    cmake_unit_get_dirs (BINARY_DIR SOURCE_DIR)

    function (psq_configure)

        set (HEADER_FILE "Header.h")
        set (HEADER_FILE_PATH "${SOURCE_DIR}/${HEADER_FILE}")
        cmake_unit_create_source_file_before_build (NAME "${HEADER_FILE}"
                                                    DEFINES IS_CPP_AND_C
                                                    GENERATING_FILE
                                                    "${_CURRENT_LIST_FILE}")
        set (CXX_SOURCE_FILE "Source.cpp")
        set (CXX_SOURCE_FILE_PATH "${SOURCE_DIR}/${CXX_SOURCE_FILE}")
        cmake_unit_create_source_file_before_build (NAME "${CXX_SOURCE_FILE}"
                                                    INCLUDES
                                                    "${HEADER_FILE_PATH}"
                                                    INCLUDE_DIRECTORIES
                                                    "${SOURCE_DIR}"
                                                    GENERATING_FILE
                                                    "${_CURRENT_LIST_FILE}")
        set (C_SOURCE_FILE "Source.c")
        set (C_SOURCE_FILE_PATH "${SOURCE_DIR}/${C_SOURCE_FILE}")
        cmake_unit_create_source_file_before_build (NAME "${C_SOURCE_FILE}"
                                                    INCLUDES
                                                    "${HEADER_FILE_PATH}"
                                                    INCLUDE_DIRECTORIES
                                                    "${SOURCE_DIR}"
                                                    GENERATING_FILE
                                                    "${_CURRENT_LIST_FILE}")
        psq_sort_sources_to_languages (C_SOURCES CXX_SOURCES HEADERS
                                       SOURCES "${C_SOURCE_FILE_PATH}"
                                               "${CXX_SOURCE_FILE_PATH}"
                                               "${HEADER_FILE_PATH}"
                                       INCLUDES "${SOURCE_DIR}"
                                       CPP_IDENTIFIERS IS_CPP_AND_C)
        cmake_unit_assert_that (CXX_SOURCES list_contains_value
                                STRING EQUAL "${HEADER_FILE_PATH}")
        cmake_unit_assert_that (C_SOURCES list_contains_value
                                STRING EQUAL "${HEADER_FILE_PATH}")

    endfunction ()

    cmake_unit_configure_config_only_test (CONFIGURE COMMAND psq_configure
                                           INVOKE_CONFIGURE OPTIONS
                                                            LANGUAGES
                                                            C
                                                            CXX)

endfunction ()

# Checks that C headers are put in CXX_SOURCES when calling
# psq_sort_sources_to_languages with FORCE_LANGUAGE CXX
function (psq_test_sort_c_headers_to_cxx_force_language)

    cmake_unit_get_dirs (BINARY_DIR SOURCE_DIR)

    function (psq_configure)

        set (HEADER_FILE "Header.h")
        set (HEADER_FILE_PATH "${SOURCE_DIR}/${HEADER_FILE}")
        cmake_unit_create_source_file_before_build (NAME "${HEADER_FILE}"
                                                    GENERATING_FILE
                                                    "${_CURRENT_LIST_FILE}")
        set (CXX_SOURCE_FILE "Source.cpp")
        set (CXX_SOURCE_FILE_PATH
             "${SOURCE_DIR}/${CXX_SOURCE_FILE}")
        cmake_unit_create_source_file_before_build (NAME "${CXX_SOURCE_FILE}"
                                                    INCLUDES "${HEADER_FILE}"
                                                    INCLUDE_DIRECTORIES
                                                    "${SOURCE_DIR}"
                                                    GENERATING_FILE
                                                    "${_CURRENT_LIST_FILE}")
        set (C_SOURCE_FILE "Source.c")
        set (C_SOURCE_FILE_PATH "${SOURCE_DIR}/${C_SOURCE_FILE}")
        cmake_unit_create_source_file_before_build (NAME "${C_SOURCE_FILE}"
                                                    INCLUDES
                                                    "${HEADER_FILE_PATH}"
                                                    INCLUDE_DIRECTORIES
                                                    "${SOURCE_DIR}"
                                                    GENERATING_FILE
                                                    "${_CURRENT_LIST_FILE}")
        psq_sort_sources_to_languages (C_SOURCES CXX_SOURCES HEADERS
                                       SOURCES "${C_SOURCE_FILE_PATH}"
                                               "${CXX_SOURCE_FILE_PATH}"
                                               "${HEADER_FILE_PATH}"
                                       INCLUDES "${SOURCE_DIR}"
                                       FORCE_LANGUAGE CXX)
        cmake_unit_assert_that (CXX_SOURCES list_contains_value
                                STRING EQUAL "${HEADER_FILE_PATH}")
        cmake_unit_assert_that (HEADERS list_contains_value
                                STRING EQUAL "${HEADER_FILE_PATH}")

    endfunction ()

    cmake_unit_configure_config_only_test (CONFIGURE COMMAND psq_configure
                                           INVOKE_CONFIGURE OPTIONS
                                                            LANGUAGES
                                                            C
                                                            CXX)

endfunction ()

# Checks that C sources are put in C_SOURCES when calling
# psq_sort_sources_to_languages
function (psq_test_sort_c_sources_to_c)

    cmake_unit_get_dirs (BINARY_DIR SOURCE_DIR)

    function (psq_configure)

        set (SOURCE_FILE_NAME "Source.c")
        set (SOURCE_FILE_PATH "${SOURCE_DIR}/${SOURCE_FILE_NAME}")
        cmake_unit_create_source_file_before_build (NAME "${SOURCE_FILE_NAME}"
                                                    GENERATING_FILE
                                                    "${_CURRENT_LIST_FILE}")
        psq_sort_sources_to_languages (C_SOURCES CXX_SOURCES HEADERS
                                       SOURCES "${SOURCE_FILE_PATH}")
        cmake_unit_assert_that (C_SOURCES list_contains_value
                                STRING EQUAL "${SOURCE_FILE_PATH}")

    endfunction ()

    cmake_unit_configure_config_only_test (CONFIGURE COMMAND psq_configure
                                           INVOKE_CONFIGURE OPTIONS
                                                            LANGUAGES
                                                            C
                                                            CXX)

endfunction ()

# Checks that CXX headers are put in CXX_SOURCES when calling
# psq_sort_sources_to_languages
function (psq_test_sort_cxx_headers_to_cxx)

    cmake_unit_get_dirs (BINARY_DIR SOURCE_DIR)

    function (psq_configure)

        set (HEADER_FILE "Header.h")
        set (HEADER_FILE_PATH "${SOURCE_DIR}/${HEADER_FILE}")
        cmake_unit_create_source_file_before_build (NAME "${HEADER_FILE}"
                                                    GENERATING_FILE
                                                    "${_CURRENT_LIST_FILE}")
        set (SOURCE_FILE_NAME "Source.cpp")
        set (SOURCE_FILE_PATH "${SOURCE_DIR}/${SOURCE_FILE_NAME}")
        cmake_unit_create_source_file_before_build (NAME "${SOURCE_FILE_NAME}"
                                                    INCLUDES
                                                    "${HEADER_FILE_PATH}"
                                                    INCLUDE_DIRECTORIES
                                                    "${SOURCE_DIR}"
                                                    GENERATING_FILE
                                                    "${_CURRENT_LIST_FILE}")
        psq_sort_sources_to_languages (C_SOURCES CXX_SOURCES HEADERS
                                       SOURCES "${SOURCE_FILE_PATH}"
                                               "${HEADER_FILE_PATH}"
                                       INCLUDES "${SOURCE_DIR}")
        cmake_unit_assert_that (CXX_SOURCES list_contains_value
                                STRING EQUAL "${HEADER_FILE_PATH}")

    endfunction ()

    cmake_unit_configure_config_only_test (CONFIGURE COMMAND psq_configure
                                           INVOKE_CONFIGURE OPTIONS
                                                            LANGUAGES
                                                            C
                                                            CXX)

endfunction ()

# Checks that CXX sources are put in CXX_SOURCES when calling
# psq_sort_sources_to_languages
function (psq_test_sort_cxx_sources_to_cxx)

    cmake_unit_get_dirs (BINARY_DIR SOURCE_DIR)

    function (psq_configure)

        set (SOURCE_FILE_NAME "Source.cpp")
        set (SOURCE_FILE_PATH "${SOURCE_DIR}/${SOURCE_FILE_NAME}")
        cmake_unit_create_source_file_before_build (NAME "${SOURCE_FILE_NAME}"
                                                    GENERATING_FILE
                                                    "${_CURRENT_LIST_FILE}")
        psq_sort_sources_to_languages (C_SOURCES CXX_SOURCES HEADERS
                                       SOURCES "${SOURCE_FILE_PATH}")
        cmake_unit_assert_that (CXX_SOURCES list_contains_value
                                STRING EQUAL "${SOURCE_FILE_PATH}")

    endfunction ()

    cmake_unit_configure_config_only_test (CONFIGURE COMMAND psq_configure
                                           INVOKE_CONFIGURE OPTIONS
                                                            LANGUAGES
                                                            C
                                                            CXX)

endfunction ()

# Checks that all headers are put into HEADERS.
function (psq_test_sort_headers_to_headers)

    cmake_unit_get_dirs (BINARY_DIR SOURCE_DIR)

    function (psq_configure)

        set (C_HEADER_FILE "CHeader.h")
        set (C_HEADER_FILE_PATH "${SOURCE_DIR}/${C_HEADER_FILE}")
        cmake_unit_create_source_file_before_build (NAME "${C_HEADER_FILE}"
                                                    GENERATING_FILE
                                                    "${_CURRENT_LIST_FILE}")
        set (CXX_HEADER_FILE "CXXHeader.h")
        set (CXX_HEADER_FILE_PATH "${SOURCE_DIR}/${CXX_HEADER_FILE}")
        cmake_unit_create_source_file_before_build (NAME "${CXX_HEADER_FILE}"
                                                    GENERATING_FILE
                                                    "${_CURRENT_LIST_FILE}")
        set (CXX_SOURCE_FILE "Source.cpp")
        set (CXX_SOURCE_FILE_PATH "${SOURCE_DIR}/${CXX_SOURCE_FILE}")
        cmake_unit_create_source_file_before_build (NAME "${CXX_SOURCE_FILE}"
                                                    INCLUDES
                                                    "${CXX_HEADER_FILE_PATH}"
                                                    INCLUDE_DIRECTORIES
                                                    "${SOURCE_DIR}"
                                                    GENERATING_FILE
                                                    "${_CURRENT_LIST_FILE}")
        set (C_SOURCE_FILE "Source.c")
        set (C_SOURCE_FILE_PATH "${SOURCE_DIR}/${C_SOURCE_FILE}")
        cmake_unit_create_source_file_before_build (NAME "${C_SOURCE_FILE}"
                                                    INCLUDES
                                                    "${C_HEADER_FILE_PATH}"
                                                    INCLUDE_DIRECTORIES
                                                    "${SOURCE_DIR}"
                                                    GENERATING_FILE
                                                    "${_CURRENT_LIST_FILE}")
        psq_sort_sources_to_languages (C_SOURCES CXX_SOURCES HEADERS
                                       SOURCES "${C_SOURCE_FILE_PATH}"
                                               "${CXX_SOURCE_FILE_PATH}"
                                               "${C_HEADER_FILE_PATH}"
                                               "${CXX_HEADER_FILE_PATH}"
                                       INCLUDES "${SOURCE_DIR}")
        cmake_unit_assert_that (HEADERS list_contains_value
                                STRING EQUAL "${C_HEADER_FILE_PATH}")
        cmake_unit_assert_that (HEADERS list_contains_value
                                STRING EQUAL "${CXX_HEADER_FILE_PATH}")

    endfunction ()

    cmake_unit_configure_config_only_test (CONFIGURE COMMAND psq_configure
                                           INVOKE_CONFIGURE OPTIONS
                                                            LANGUAGES
                                                            C
                                                            CXX)

endfunction ()

# Add some sources and defines to a custom target.
# The defines should be passed into the compilation DB.
function (psq_test_special_compilation_d_b_defines)

    cmake_unit_get_dirs (BINARY_DIR SOURCE_DIR)

    function (psq_configure)

        psq_make_sources_and_compilation_db ("Source.cpp" CXX
                                             DEFINES custom_define=1)
        set (COMPILE_COMMANDS "${COMPILATION_DB_DIR}/compile_commands.json")
        cmake_unit_assert_that ("${COMPILE_COMMANDS}"
                                file_contents any_line matches_regex
                                "^.*-Dcustom_define=1.*$")

    endfunction ()

    cmake_unit_configure_test (CONFIGURE COMMAND psq_configure)

endfunction ()

# Add some sources and includes to a custom target.
# The includes should be passed into the compilation DB.
function (psq_test_special_compilation_d_b_includes)

    function (psq_configure)

        set (SOURCE_INTERNAL_INCLUDE_DIRS "${SOURCE_DIR}/internal")
        set (SOURCE_EXTERNAL_INCLUDE_DIRS "${SOURCE_DIR}/external")
        psq_make_sources_and_compilation_db ("Source.cpp" CXX
                                             DEFINES custom_define=1
                                             INTERNAL_INCLUDE_DIRS
                                             "${SOURCE_INTERNAL_INCLUDE_DIRS}"
                                             EXTERNAL_INCLUDE_DIRS
                                             "${SOURCE_EXTERNAL_INCLUDE_DIRS}")
        set (COMPILE_COMMANDS "${COMPILATION_DB_DIR}/compile_commands.json")
        cmake_unit_assert_that ("${COMPILE_COMMANDS}"
                                file_contents any_line matches_regex
                                "^.*-isystem.*external.*$")
        cmake_unit_assert_that ("${COMPILE_COMMANDS}"
                                file_contents any_line matches_regex
                                "^.*-I.*internal.*$")

    endfunction ()

    cmake_unit_configure_config_only_test (CONFIGURE COMMAND psq_configure)

endfunction ()

# Add some sources and defines to a custom target.
# One of them is a C header.
function (psq_test_special_compilation_d_b_use_c_compiler_for_c_header)

    function (psq_configure)

        psq_make_sources_and_compilation_db ("Source.c" C)
        cmake_unit_escape_string ("${CMAKE_C_COMPILER}" ESCAPED_C_COMPILER)
        set (COMPILE_COMMANDS "${COMPILATION_DB_DIR}/compile_commands.json")
        cmake_unit_assert_that ("${COMPILE_COMMANDS}"
                                file_contents any_line matches_regex
                                "^.*${ESCAPED_C_COMPILER}.*Header.h.*$")

    endfunction ()

    cmake_unit_configure_config_only_test (CONFIGURE COMMAND psq_configure)

endfunction ()

# Add some sources and defines to a custom target
# One of them is a C++ header. The CMAKE_C_FLAGS
# should be part of its compile commands.
function (psq_test_special_compilation_d_b_use_c_flags_for_c_header)

    function (psq_configure)

        set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DUSING_CXX_DEFINE")
        set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DUSING_C_DEFINE")
        psq_make_sources_and_compilation_db ("Source.c" C)
        set (COMPILE_COMMANDS "${COMPILATION_DB_DIR}/compile_commands.json")
        cmake_unit_assert_that ("${COMPILE_COMMANDS}"
                                file_contents any_line matches_regex
                                "^.*Header.h.*-DUSING_C_DEFINE.*$")

    endfunction ()

    cmake_unit_configure_config_only_test (CONFIGURE COMMAND psq_configure)

endfunction ()

# Add some sources and defines to a custom target
# One of them is a C header.
function (psq_test_special_compilation_d_b_use_c_language_opt_for_c_header)

    function (psq_configure)

        psq_make_sources_and_compilation_db ("Source.c" C)
        set (COMPILE_COMMANDS "${COMPILATION_DB_DIR}/compile_commands.json")
        cmake_unit_assert_that ("${COMPILE_COMMANDS}"
                                not file_contents any_line matches_regex
                                "^.*-x c...*Header.h.*$")

    endfunction ()

    cmake_unit_configure_config_only_test (CONFIGURE COMMAND psq_configure)

endfunction ()

# Add some sources and defines to a custom target
# One of them is a C++ header.
function (psq_test_special_compilation_d_b_use_cxx_compiler_for_cpp_header)

    function (psq_configure)

        psq_make_sources_and_compilation_db ("Source.cpp" CXX)
        set (COMPILE_COMMANDS "${COMPILATION_DB_DIR}/compile_commands.json")
        cmake_unit_escape_string ("${CXX_COMPILER_BASE}" ESCAPED_CXX_COMPILER)
        cmake_unit_assert_that ("${COMPILE_COMMANDS}"
                                file_contents any_line matches_regex
                                "^.*${ESCAPED_CXX_COMPILER}.*Header.h.*$")

    endfunction ()

    cmake_unit_configure_config_only_test (CONFIGURE COMMAND psq_configure)

endfunction ()

# Add some sources and defines to a custom target
# One of them is a C++ header. The CMAKE_CXX_FLAGS
# should be part of its compile commands.
function (psq_test_special_compilation_d_b_use_cxx_flags_for_cpp_header)

    function (psq_configure)

        set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DUSING_CXX_DEFINE")
        set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DUSING_C_DEFINE")
        psq_make_sources_and_compilation_db ("Source.cpp" CXX)
        set (COMPILE_COMMANDS "${COMPILATION_DB_DIR}/compile_commands.json")
        cmake_unit_assert_that ("${COMPILE_COMMANDS}"
                                file_contents any_line matches_regex
                                "^.*Header.h.*-DUSING_CXX_DEFINE.*$")

    endfunction ()

    cmake_unit_configure_config_only_test (CONFIGURE COMMAND psq_configure)

endfunction ()

# Add some sources and defines to a custom target.
# One of them is a C++ header.
function (psq_test_special_compilation_d_b_use_cxx_language_opt_for_cpp_header)

    function (psq_configure)

        psq_make_sources_and_compilation_db ("Source.cpp" CXX)
        set (COMPILE_COMMANDS "${COMPILATION_DB_DIR}/compile_commands.json")
        cmake_unit_assert_that ("${COMPILE_COMMANDS}"
                                file_contents any_line matches_regex
                                "^.*-x c...*Header.h.*$")

    endfunction ()

    cmake_unit_configure_config_only_test (CONFIGURE COMMAND psq_configure)

endfunction ()

# Adds a custom target with some SOURCES and call
# psq_strip_extraneous_sources on it. The returned list should
# only contain the passed sources and nothing else (like the target name).
function (psq_test_strip_extraneous_sources)

    cmake_unit_get_dirs (BINARY_DIR SOURCE_DIR)

    function (psq_configure)

        set (SOURCE_FILE "${BINARY_DIR}/Source.cpp")
        file (WRITE "${SOURCE_FILE}" "")
        add_custom_target (my_custom_target ALL SOURCES "${SOURCE_FILE}")
        psq_strip_extraneous_sources (FILTERED_SOURCES my_custom_target)
        cmake_unit_assert_that (FILTERED_SOURCES list_contains_value
                                STRING EQUAL "${SOURCE_FILE}")
        list (LENGTH FILTERED_SOURCES FILTERED_SOURCES_LENGTH)
        cmake_unit_assert_that (FILTERED_SOURCES_LENGTH compare_as
                                INTEGER EQUAL 1)

    endfunction ()

    cmake_unit_configure_config_only_test (CONFIGURE COMMAND psq_configure
                                           INVOKE_CONFIGURE OPTIONS
                                                            LANGUAGES
                                                            C
                                                            CXX)

endfunction ()

cmake_unit_init (NAMESPACE "psq"
                 COVERAGE_FILES
                 "${CMAKE_CURRENT_LIST_DIR}/PolysquareToolingUtil.cmake")

if (BIICODE)

    add_bii_targets ()

endif ()
