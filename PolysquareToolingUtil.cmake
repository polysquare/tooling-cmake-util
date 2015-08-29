# /PolysquareToolingUtil.cmake
#
# Utility functions polysquare tooling cmake macros.
#
# See /LICENCE.md for Copyright information

if (NOT BIICODE)

    set (CMAKE_MODULE_PATH
         "${CMAKE_SOURCE_DIR}/bii/deps"
         "${CMAKE_MODULE_PATH}")

endif ()

include ("smspillaz/cmake-include-guard/IncludeGuard")
cmake_include_guard (SET_MODULE_PATH)
include ("smspillaz/cmake-header-language/DetermineHeaderLanguage")
include (CMakeParseArguments)

function (psq_append_to_global_property_unique PROPERTY ITEM)

    get_property (GLOBAL_PROPERTY
                  GLOBAL
                  PROPERTY ${PROPERTY})

    set (LIST_CONTAINS_ITEM FALSE)

    foreach (LIST_ITEM ${GLOBAL_PROPERTY})

        if (LIST_ITEM STREQUAL ${ITEM})

            set (LIST_CONTAINS_ITEM TRUE)
            break ()

        endif ()

    endforeach ()

    if (NOT LIST_CONTAINS_ITEM)

        set_property (GLOBAL
                      APPEND
                      PROPERTY ${PROPERTY}
                      ${ITEM})

    endif ()

endfunction ()

function (psq_append_to_global_property PROPERTY)

    cmake_parse_arguments (APPEND
                           ""
                           ""
                           "LIST"
                           ${ARGN})

    foreach (ITEM ${APPEND_LIST})

        set_property (GLOBAL
                      APPEND
                      PROPERTY ${PROPERTY}
                      ${ITEM})

    endforeach ()

endfunction ()

function (psq_get_list_intersection DESTINATION)

    set (INTERSECT_MULTIVAR_ARGS SOURCE INTERSECTION)
    cmake_parse_arguments (INTERSECT
                           ""
                           ""
                           "${INTERSECT_MULTIVAR_ARGS}"
                           ${ARGN})

    # We don't want correctness/quotes here, since INTERSECT_SOURCE is
    # a list, not a file.
    foreach (SOURCE_ITEM ${INTERSECT_SOURCE})  # NOLINT:correctness/quotes

        list (FIND INTERSECT_INTERSECTION ${SOURCE_ITEM} SOURCE_INDEX)

        if (NOT SOURCE_INDEX EQUAL -1)

            list (APPEND _DESTINATION ${SOURCE_ITEM})

        endif ()

    endforeach ()

    # Append and set in parent scope
    set (${DESTINATION}
         ${${DESTINATION}}
         ${_DESTINATION}
         PARENT_SCOPE)

endfunction ()

function (psq_append_each_to_options_with_prefix MAIN_LIST PREFIX)

    cmake_parse_arguments (APPEND
                           ""
                           ""
                           "LIST"
                           ${ARGN})

    foreach (ITEM ${APPEND_LIST})

        list (APPEND ${MAIN_LIST} ${PREFIX}${ITEM})

    endforeach ()

    set (${MAIN_LIST} ${${MAIN_LIST}} PARENT_SCOPE)

endfunction ()

function (psq_add_switch ALL_OPTIONS OPTION_NAME)

    set (ADD_SWITCH_SINGLEVAR_ARGS ON OFF)
    cmake_parse_arguments (ADD_SWITCH
                           ""
                           "${ADD_SWITCH_SINGLEVAR_ARGS}"
                           ""
                           ${ARGN})

    if (${OPTION_NAME})

        list (APPEND ${ALL_OPTIONS} ${ADD_SWITCH_ON})

    else ()

        list (APPEND ${ALL_OPTIONS} ${ADD_SWITCH_OFF})

    endif ()

    set (${ALL_OPTIONS} ${${ALL_OPTIONS}} PARENT_SCOPE)

endfunction ()

function (psq_assert_set VARIABLE)

    if (NOT ${VARIABLE})

        string (REPLACE ";" "" MSG "${ARGN}")
        message (FATAL_ERROR "${MSG}")

    endif ()

endfunction ()

function (psq_forward_options PREFIX RETURN_LIST_NAME)

    set (FORWARD_OPTION_ARGS "")
    set (FORWARD_SINGLEVAR_ARGS "")
    set (FORWARD_MULTIVAR_ARGS
         OPTION_ARGS
         SINGLEVAR_ARGS
         MULTIVAR_ARGS)

    cmake_parse_arguments (FORWARD
                           "${FORWARD_OPTION_ARGS}"
                           "${FORWARD_SINGLEVAR_ARGS}"
                           "${FORWARD_MULTIVAR_ARGS}"
                           ${ARGN})

    # Temporary accumulation of variables to forward
    set (RETURN_LIST)

    # Option arguments - just forward the value of each set
    # ${PREFIX_OPTION_ARG} as this will be set to the option or to ""
    foreach (OPTION_ARG ${FORWARD_OPTION_ARGS})

        set (PREFIXED_OPTION_ARG ${PREFIX}_${OPTION_ARG})

        if (${PREFIXED_OPTION_ARG})

            list (APPEND RETURN_LIST ${OPTION_ARG})

        endif ()

    endforeach ()

    # Single-variable arguments - add the name of the argument and its value to
    # the return list
    foreach (SINGLEVAR_ARG ${FORWARD_SINGLEVAR_ARGS})

        set (PREFIXED_SINGLEVAR_ARG ${PREFIX}_${SINGLEVAR_ARG})

        if (${PREFIXED_SINGLEVAR_ARG})

            list (APPEND RETURN_LIST ${SINGLEVAR_ARG})
            list (APPEND RETURN_LIST ${${PREFIXED_SINGLEVAR_ARG}})

        endif ()

    endforeach ()

    # Multi-variable arguments - add the name of the argument and all its values
    # to the return-list
    foreach (MULTIVAR_ARG ${FORWARD_MULTIVAR_ARGS})

        set (PREFIXED_MULTIVAR_ARG ${PREFIX}_${MULTIVAR_ARG})
        list (APPEND RETURN_LIST ${MULTIVAR_ARG})

        foreach (VALUE ${${PREFIXED_MULTIVAR_ARG}})

            list (APPEND RETURN_LIST ${VALUE})

        endforeach ()

    endforeach ()

    set (${RETURN_LIST_NAME} ${RETURN_LIST} PARENT_SCOPE)

endfunction ()

function (psq_sort_sources_to_languages C_SOURCES CXX_SOURCES HEADERS)

    set (SORT_SOURCES_SINGLEVAR_OPTIONS FORCE_LANGUAGE)
    set (SORT_SOURCES_MULTIVAR_OPTIONS
         SOURCES
         CPP_IDENTIFIERS
         INCLUDES)
    cmake_parse_arguments (SORT_SOURCES
                           ""
                           "${SORT_SOURCES_SINGLEVAR_OPTIONS}"
                           "${SORT_SOURCES_MULTIVAR_OPTIONS}"
                           ${ARGN})

    psq_forward_options (SORT_SOURCES
                         DETERMINE_LANG_OPTIONS
                         SINGLEVAR_ARGS FORCE_LANGUAGE
                         MULTIVAR_ARGS CPP_IDENTIFIERS INCLUDES)

    foreach (SOURCE ${SORT_SOURCES_SOURCES})

        set (INCLUDES ${SORT_SOURCES_INCLUDES})
        set (CPP_IDENTIFIERS ${SORT_SOURCES_CPP_IDENTIFIERS})
        psq_determine_language_for_source ("${SOURCE}"
                                           LANGUAGE
                                           SOURCE_WAS_HEADER
                                           ${DETERMINE_LANG_OPTIONS})

        # Scan this source for headers, we'll need them later
        if (NOT SOURCE_WAS_HEADER)

            psq_scan_source_for_headers (SOURCE "${SOURCE}"
                                                ${DETERMINE_LANG_OPTIONS})

        endif ()

        list (FIND LANGUAGE "C" C_INDEX)
        list (FIND LANGUAGE "CXX" CXX_INDEX)

        if (NOT C_INDEX EQUAL -1)

            list (APPEND _C_SOURCES "${SOURCE}")

        endif ()

        if (NOT CXX_INDEX EQUAL -1)

            list (APPEND _CXX_SOURCES "${SOURCE}")

        endif ()

        if (SOURCE_WAS_HEADER)

            list (APPEND _HEADERS "${SOURCE}")

        endif ()

    endforeach ()

    set (${C_SOURCES} ${_C_SOURCES} PARENT_SCOPE)
    set (${CXX_SOURCES} ${_CXX_SOURCES} PARENT_SCOPE)
    set (${HEADERS} ${_HEADERS} PARENT_SCOPE)

endfunction ()

function (psq_filter_out_generated_sources RESULT_VARIABLE)

    set (FILTER_OUT_MUTLIVAR_OPTIONS SOURCES)

    cmake_parse_arguments (FILTER_OUT
                           ""
                           ""
                           "${FILTER_OUT_MUTLIVAR_OPTIONS}"
                           ${ARGN})

    set (${RESULT_VARIABLE} PARENT_SCOPE)
    set (FILTERED_SOURCES)

    foreach (SOURCE ${FILTER_OUT_SOURCES})

        get_property (SOURCE_IS_GENERATED
                      SOURCE "${SOURCE}"
                      PROPERTY GENERATED)

        if (NOT SOURCE_IS_GENERATED)

            list (APPEND FILTERED_SOURCES "${SOURCE}")

        endif ()

    endforeach ()

    set (${RESULT_VARIABLE} ${FILTERED_SOURCES} PARENT_SCOPE)

endfunction ()

function (psq_handle_check_generated_option PREFIX SOURCES_RETURN)

    cmake_parse_arguments (HANDLE_CHECK_GENERATED
                           ""
                           ""
                           "SOURCES"
                           ${ARGN})

    # First case: We're checking generated sources, so
    # we can just check all passed in sources.
    if (${PREFIX}_CHECK_GENERATED)

        set (_FILTERED_SOURCES ${HANDLE_CHECK_GENERATED_SOURCES})

    # Second case: We only want to check real sources,
    # so filter out generated ones.
    else ()

        psq_filter_out_generated_sources (_FILTERED_SOURCES
                                          SOURCES
                                          ${HANDLE_CHECK_GENERATED_SOURCES})

    endif ()

    set (${SOURCES_RETURN} ${_FILTERED_SOURCES} PARENT_SCOPE)

endfunction ()

# psq_strip_extraneous_sources
#
# Fetches the target's SOURCES property, but removes any non-linkable
# and non-header sources from it, storing the result in RETURN_SOURCES.
#
# Most tools choke on being passed these sources, so its better to strip
# them out as early as possible
#
# RETURN_SOURCES: Variable to store returned sources in
# TARGET: Target to fetch sources from
function (psq_strip_extraneous_sources RETURN_SOURCES TARGET)

    get_target_property (TARGET_SOURCES ${TARGET} SOURCES)

    foreach (SOURCE ${TARGET_SOURCES})

        psq_source_type_from_source_file_extension ("${SOURCE}"
                                                    SOURCE_TYPE)

        if (NOT SOURCE_TYPE STREQUAL "UNKNOWN")

            list (APPEND STRIPPED_SOURCES "${SOURCE}")

        endif ()

    endforeach ()

    set (${RETURN_SOURCES} ${STRIPPED_SOURCES} PARENT_SCOPE)

endfunction ()

function (psq_get_target_command_attach_point TARGET ATTACH_POINT_RETURN)

    # Figure out if this target is linkable. If it is a UTILITY
    # target then we need to run the checks at the PRE_BUILD stage.
    set (_ATTACH_POINT PRE_LINK)

    get_property (TARGET_TYPE
                  TARGET ${TARGET}
                  PROPERTY TYPE)

    if (TARGET_TYPE STREQUAL "UTILITY")

        set (_ATTACH_POINT PRE_BUILD)

    endif ()

    set (${ATTACH_POINT_RETURN} ${_ATTACH_POINT} PARENT_SCOPE)

endfunction ()

function (psq_run_tool_on_source TARGET SOURCE TOOL_NAME)

    set (RUN_TOOL_ON_SOURCE_SINGLEVAR_ARGS WORKING_DIRECTORY)
    set (RUN_TOOL_ON_SOURCE_MULTIVAR_ARGS COMMAND DEPENDS)
    cmake_parse_arguments (RUN_TOOL_ON_SOURCE
                           ""
                           "${RUN_TOOL_ON_SOURCE_SINGLEVAR_ARGS}"
                           "${RUN_TOOL_ON_SOURCE_MULTIVAR_ARGS}"
                           ${ARGN})

    # Replace @SOURCE@ with SOURCE in RUN_TOOL_ON_SOURCE_COMMAND here
    string (CONFIGURE "${RUN_TOOL_ON_SOURCE_COMMAND}" COMMAND @ONLY)

    # Get the basename of the file, used for the comment and stamp.
    get_filename_component (SRCNAME "${SOURCE}" NAME)
    set (STAMPFILE
         "${CMAKE_CURRENT_BINARY_DIR}/${SRCNAME}.${TOOL_NAME}.stamp")
    set (COMMENT "Analyzing ${SRCNAME} with ${TOOL_NAME}")

    if (RUN_TOOL_ON_SOURCE_WORKING_DIRECTORY)

        set (WORKING_DIRECTORY_OPTION
             WORKING_DIRECTORY "${RUN_TOOL_ON_SOURCE_WORKING_DIRECTORY}")

    endif ()

    # Get all the sources on this target and make the new check depend on all
    # of them. The reason why we depend on all of them instead of just the
    # source that we are checking is that the source might include  a header
    # file which is also generated. If the source includes that header file
    # that header file doesn't exist, then the build will fail.
    psq_strip_extraneous_sources (TARGET_SOURCES ${TARGET})

    add_custom_command (OUTPUT ${STAMPFILE}
                        COMMAND ${COMMAND}
                        COMMAND "${CMAKE_COMMAND}" -E touch "${STAMPFILE}"
                        DEPENDS ${TARGET_SOURCES} ${RUN_TOOL_ON_SOURCE_DEPENDS}
                        ${WORKING_DIRECTORY_OPTION}
                        COMMENT ${COMMENT}
                        VERBATIM)

    # Add the stampfile both to the SOURCES of TARGET
    # but also to the OBJECT_DEPENDS of any source files.
    #
    # On older CMake versions editing SOURCES post-facto for a linkable
    # target was a no-op.
    set_property (TARGET ${TARGET}
                  APPEND PROPERTY SOURCES ${STAMPFILE})
    set_property (SOURCE "${SOURCE}"
                  APPEND PROPERTY OBJECT_DEPENDS ${STAMPFILE})

endfunction ()

function (psq_run_tool_for_each_source TARGET TOOL_NAME)

    set (RUN_COMMAND_OPTION_ARGS CHECK_GENERATED)
    set (RUN_COMMAND_SINGLEVAR_ARGS WORKING_DIRECTORY)
    set (RUN_COMMAND_MULTIVAR_ARGS COMMAND DEPENDS)
    cmake_parse_arguments (RUN_COMMAND
                           "${RUN_COMMAND_OPTION_ARGS}"
                           "${RUN_COMMAND_SINGLEVAR_ARGS}"
                           "${RUN_COMMAND_MULTIVAR_ARGS}"
                           ${ARGN})

    psq_strip_extraneous_sources (FILTERED_SOURCES
                                  ${TARGET})
    psq_handle_check_generated_option (RUN_COMMAND FILTERED_SOURCES
                                       SOURCES ${FILTERED_SOURCES})

    psq_forward_options (RUN_COMMAND RUN_ON_SOURCE_FORWARD
                         SINGLEVAR_ARGS WORKING_DIRECTORY
                         MULTIVAR_ARGS COMMAND DEPENDS)

    # For each source file, add a new custom command which runs our
    # tool and generates a stampfile, depending on the generation of
    # the source file.
    foreach (SOURCE ${FILTERED_SOURCES})

        psq_run_tool_on_source (${TARGET} "${SOURCE}" ${TOOL_NAME}
                                ${RUN_ON_SOURCE_FORWARD})

    endforeach ()

endfunction ()

function (psq_make_compilation_db TARGET
                                  CUSTOM_COMPILATION_DB_DIR_RETURN)

    set (COMPDB_OPTIONS)
    set (COMPDB_SINGLEVAR_OPTIONS)
    set (COMPDB_MULTIVAR_OPTIONS
         C_SOURCES
         CXX_SOURCES
         INTERNAL_INCLUDE_DIRS
         EXTERNAL_INCLUDE_DIRS
         DEFINES)

    cmake_parse_arguments (COMPDB
                           "${COMPDB_OPTIONS}"
                           "${COMPDB_SINGLEVAR_OPTIONS}"
                           "${COMPDB_MULTIVAR_OPTIONS}"
                           ${ARGN})

    # Don't write anything if we don't have to
    if (NOT COMPDB_C_SOURCES AND NOT COMPDB_CXX_SOURCES)

        return ()

    endif ()

    set (CUSTOM_COMPILATION_DB_DIR
         "${CMAKE_CURRENT_BINARY_DIR}/${TARGET}_compile_commands/")
    set (COMPILATION_DB_FILE
         "${CUSTOM_COMPILATION_DB_DIR}/compile_commands.json")

    set (COMPILATION_DB_FILE_CONTENTS
         "[")

    foreach (C_SOURCE ${COMPDB_C_SOURCES})

        list (APPEND SOURCES_LANGUAGES "C,${C_SOURCE}")

    endforeach ()

    foreach (CXX_SOURCE ${COMPDB_CXX_SOURCES})

        list (APPEND SOURCES_LANGUAGES "CXX,${CXX_SOURCE}")

    endforeach ()

    foreach (SOURCE_LANGUAGE ${SOURCES_LANGUAGES})

        string (REPLACE "," ";" SOURCE_LANGUAGE "${SOURCE_LANGUAGE}")

        list (GET SOURCE_LANGUAGE 0 LANGUAGE)
        list (GET SOURCE_LANGUAGE 1 SOURCE)

        get_filename_component (FULL_PATH "${SOURCE}" ABSOLUTE)
        get_filename_component (BASENAME "${SOURCE}" NAME)

        set (COMPILATION_DB_FILE_CONTENTS
             "${COMPILATION_DB_FILE_CONTENTS}\n{\n"
             "\"directory\": \"${CMAKE_CURRENT_BINARY_DIR}\",\n"
             "\"command\": \"")
        unset (COMPILER_COMMAND_LINE)

        # Compiler and language options
        if (LANGUAGE STREQUAL "CXX")

            list (APPEND COMPILER_COMMAND_LINE
                  ${CMAKE_CXX_COMPILER}
                  -x
                  c++)

        elseif (LANGUAGE STREQUAL "C")

            list (APPEND COMPILER_COMMAND_LINE
                  ${CMAKE_C_COMPILER})

        endif ()

        # Fake output file etc.
        list (APPEND COMPILER_COMMAND_LINE
              -o
              "CMakeFiles/${TARGET}.dir/${BASENAME}.o"
              -c
              "${FULL_PATH}")

        # All includes
        psq_append_each_to_options_with_prefix (COMPILER_COMMAND_LINE
                                                -isystem
                                                LIST
                                                ${COMPDB_EXTERNAL_INCLUDE_DIRS})
        psq_append_each_to_options_with_prefix (COMPILER_COMMAND_LINE
                                                -I
                                                LIST
                                                ${COMPDB_INTERNAL_INCLUDE_DIRS})

        # All defines
        psq_append_each_to_options_with_prefix (COMPILER_COMMAND_LINE
                                                -D
                                                LIST ${COMPDB_DEFINES})


        # CXXFLAGS / CFLAGS
        if (LANGUAGE STREQUAL "CXX")

            list (APPEND COMPILER_COMMAND_LINE
                  ${CMAKE_CXX_FLAGS})

        elseif (LANGUAGE STREQUAL "C")

            list (APPEND COMPILER_COMMAND_LINE
                  ${CMAKE_C_FLAGS})

        endif ()

        string (REPLACE ";" " "
                COMPILER_COMMAND_LINE "${COMPILER_COMMAND_LINE}")
        set (COMPILATION_DB_FILE_CONTENTS
             "${COMPILATION_DB_FILE_CONTENTS}${COMPILER_COMMAND_LINE}")

        set (COMPILATION_DB_FILE_CONTENTS
             "${COMPILATION_DB_FILE_CONTENTS}\",\n"
             "\"file\": \"${FULL_PATH}\"\n"
             "},")

    endforeach ()

    # Get rid of all the semicolons
    string (REPLACE ";" ""
            COMPILATION_DB_FILE_CONTENTS
            "${COMPILATION_DB_FILE_CONTENTS}")

    # Take away the last comma
    string (LENGTH
            "${COMPILATION_DB_FILE_CONTENTS}"
            COMPILATION_DB_FILE_LENGTH)
    math (EXPR TRIMMED_COMPILATION_DB_FILE_LENGTH
          "${COMPILATION_DB_FILE_LENGTH} - 1")
    string (SUBSTRING "${COMPILATION_DB_FILE_CONTENTS}"
            0
            ${TRIMMED_COMPILATION_DB_FILE_LENGTH}
            COMPILATION_DB_FILE_CONTENTS)

    # Final "]"
    set (COMPILATION_DB_FILE_CONTENTS
         "${COMPILATION_DB_FILE_CONTENTS}\n]\n")

    # Write out
    file (WRITE "${COMPILATION_DB_FILE}"
          ${COMPILATION_DB_FILE_CONTENTS})

    set (${CUSTOM_COMPILATION_DB_DIR_RETURN}
         "${CUSTOM_COMPILATION_DB_DIR}"
         PARENT_SCOPE)

endfunction ()
