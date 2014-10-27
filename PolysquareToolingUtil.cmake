# /PolysquareToolingUtil.cmake
#
# Utility functions polysquare tooling cmake macros.
#
# See LICENCE.md for Copyright information.

include (CMakeParseArguments)

set (DETERMINE_HEADER_LANGUAGE_DIR
     ${CMAKE_CURRENT_LIST_DIR}/determine-header-language/)
include (${DETERMINE_HEADER_LANGUAGE_DIR}DetermineHeaderLanguage.cmake)

function (psq_append_to_global_property_unique PROPERTY ITEM)

    get_property (GLOBAL_PROPERTY
                  GLOBAL
                  PROPERTY ${PROPERTY})

    set (LIST_CONTAINS_ITEM FALSE)

    foreach (LIST_ITEM ${GLOBAL_PROPERTY})

        if (LIST_ITEM STREQUAL ${ITEM})

            set (LIST_CONTAINS_ITEM TRUE)
            break ()

        endif (LIST_ITEM STREQUAL ${ITEM})

    endforeach ()

    if (NOT LIST_CONTAINS_ITEM)

        set_property (GLOBAL
                      APPEND
                      PROPERTY ${PROPERTY}
                      ${ITEM})

    endif (NOT LIST_CONTAINS_ITEM)

endfunction (psq_append_to_global_property_unique)

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

endfunction (psq_append_to_global_property)

function (psq_get_list_intersection DESTINATION)

    set (INTERSECT_MULTIVAR_ARGS SOURCE INTERSECTION)
    cmake_parse_arguments (INTERSECT
                           ""
                           ""
                           "${INTERSECT_MULTIVAR_ARGS}"
                           ${ARGN})

    foreach (SOURCE_ITEM ${INTERSECT_SOURCE})

        list (FIND INTERSECT_INTERSECTION ${SOURCE_ITEM} SOURCE_INDEX)

        if (NOT SOURCE_INDEX EQUAL -1)

            list (APPEND _DESTINATION ${SOURCE_ITEM})

        endif (NOT SOURCE_INDEX EQUAL -1)

    endforeach ()

    # Append and set in parent scope
    set (${DESTINATION}
         ${${DESTINATION}}
         ${_DESTINATION}
         PARENT_SCOPE)

endfunction (psq_get_list_intersection)

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

endfunction (psq_append_each_to_options_with_prefix)

function (psq_add_switch ALL_OPTIONS OPTION_NAME)

    set (ADD_SWITCH_SINGLEVAR_ARGS ON OFF)
    cmake_parse_arguments (ADD_SWITCH
                           ""
                           "${ADD_SWITCH_SINGLEVAR_ARGS}"
                           ""
                           ${ARGN})

    if (${OPTION_NAME})

        list (APPEND ${ALL_OPTIONS} ${ADD_SWITCH_ON})

    else (DEFINED ${OPTION_NAME})

        list (APPEND ${ALL_OPTIONS} ${ADD_SWITCH_OFF})

    endif (${OPTION_NAME})

    set (${ALL_OPTIONS} ${${ALL_OPTIONS}} PARENT_SCOPE)

endfunction (psq_add_switch)

function (psq_assert_set VARIABLE)

    if (NOT ${VARIABLE})

        string (REPLACE ";" "" MSG "${ARGN}")
        message (FATAL_ERROR "${MSG}")

    endif (NOT ${VARIABLE})

endfunction (psq_assert_set)

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

    # Option args - just forward the value of each set ${REFIX_OPTION_ARG}
    # as this will be set to the option or to ""
    foreach (OPTION_ARG ${FORWARD_OPTION_ARGS})

        set (PREFIXED_OPTION_ARG ${PREFIX}_${OPTION_ARG})

        if (${PREFIXED_OPTION_ARG})

             list (APPEND RETURN_LIST ${OPTION_ARG})

        endif (${PREFIXED_OPTION_ARG})

    endforeach ()

    # Single-variable args - add the name of the argument and its value to
    # the return list
    foreach (SINGLEVAR_ARG ${FORWARD_SINGLEVAR_ARGS})

        set (PREFIXED_SINGLEVAR_ARG ${PREFIX}_${SINGLEVAR_ARG})

        if (${PREFIXED_SINGLEVAR_ARG})

            list (APPEND RETURN_LIST ${SINGLEVAR_ARG})
            list (APPEND RETURN_LIST ${${PREFIXED_SINGLEVAR_ARG}})

        endif (${PREFIXED_SINGLEVAR_ARG})

    endforeach ()

    # Multi-variable args - add the name of the argument and all its values
    # to the return-list
    foreach (MULTIVAR_ARG ${FORWARD_MULTIVAR_ARGS})

        set (PREFIXED_MULTIVAR_ARG ${PREFIX}_${MULTIVAR_ARG})
        list (APPEND RETURN_LIST ${MULTIVAR_ARG})

        foreach (VALUE ${${PREFIXED_MULTIVAR_ARG}})

            list (APPEND RETURN_LIST ${VALUE})

        endforeach ()

    endforeach ()

    set (${RETURN_LIST_NAME} ${RETURN_LIST} PARENT_SCOPE)

endfunction (psq_forward_options)

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
        polysquare_determine_language_for_source (${SOURCE}
                                                  LANGUAGE
                                                  SOURCE_WAS_HEADER
                                                  ${DETERMINE_LANG_OPTIONS})

        # Scan this source for headers, we'll need them later
        if (NOT SOURCE_WAS_HEADER)

            polysquare_scan_source_for_headers (SOURCE ${SOURCE}
                                                ${DETERMINE_LANG_OPTIONS})

        endif (NOT SOURCE_WAS_HEADER)

        list (FIND LANGUAGE "C" C_INDEX)
        list (FIND LANGUAGE "CXX" CXX_INDEX)

        if (NOT C_INDEX EQUAL -1)

            list (APPEND _C_SOURCES ${SOURCE})

        endif (NOT C_INDEX EQUAL -1)

        if (NOT CXX_INDEX EQUAL -1)

            list (APPEND _CXX_SOURCES ${SOURCE})

        endif (NOT CXX_INDEX EQUAL -1)

        if (SOURCE_WAS_HEADER)

            list (APPEND _HEADERS ${SOURCE})

        endif (SOURCE_WAS_HEADER)

    endforeach ()

    set (${C_SOURCES} ${_C_SOURCES} PARENT_SCOPE)
    set (${CXX_SOURCES} ${_CXX_SOURCES} PARENT_SCOPE)
    set (${HEADERS} ${_HEADERS} PARENT_SCOPE)

endfunction (psq_sort_sources_to_languages)

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
                      SOURCE ${SOURCE}
                      PROPERTY GENERATED)

        if (NOT SOURCE_IS_GENERATED)

            list (APPEND FILTERED_SOURCES ${SOURCE})

        endif (NOT SOURCE_IS_GENERATED)

    endforeach ()

    set (${RESULT_VARIABLE} ${FILTERED_SOURCES} PARENT_SCOPE)

endfunction (psq_filter_out_generated_sources)

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
    else (${PREFIX}_CHECK_GENERATED)

        psq_filter_out_generated_sources (_FILTERED_SOURCES
                                          SOURCES
                                          ${HANDLE_CHECK_GENERATED_SOURCES})

    endif (${PREFIX}_CHECK_GENERATED)

    set (${SOURCES_RETURN} ${_FILTERED_SOURCES} PARENT_SCOPE)

endfunction (psq_handle_check_generated_option)

function (psq_strip_add_custom_target_sources RETURN_SOURCES TARGET)

    get_target_property (_sources ${TARGET} SOURCES)
    list (GET _sources 0 _first_source)
    string (FIND "${_first_source}" "/" LAST_SLASH REVERSE)
    math (EXPR LAST_SLASH "${LAST_SLASH} + 1")
    string (SUBSTRING "${_first_source}" ${LAST_SLASH} -1 END_OF_SOURCE)

    if (END_OF_SOURCE STREQUAL "${TARGET}")

        list (REMOVE_AT _sources 0)

    endif (END_OF_SOURCE STREQUAL "${TARGET}")

    set (${RETURN_SOURCES} ${_sources} PARENT_SCOPE)

endfunction (psq_strip_add_custom_target_sources)

function (psq_get_target_command_attach_point TARGET ATTACH_POINT_RETURN)

    # Figure out if this target is linkable. If it is a UTILITY
    # target then we need to run the checks at the PRE_BUILD stage.
    set (_ATTACH_POINT PRE_LINK)

    get_property (TARGET_TYPE
                  TARGET ${TARGET}
                  PROPERTY TYPE)

    if (TARGET_TYPE STREQUAL "UTILITY")

        set (_ATTACH_POINT PRE_BUILD)

    endif (TARGET_TYPE STREQUAL "UTILITY")

    set (${ATTACH_POINT_RETURN} ${_ATTACH_POINT} PARENT_SCOPE)

endfunction (psq_get_target_command_attach_point)

function (psq_run_tool_on_source TARGET SOURCE TOOL_NAME)

    set (RUN_TOOL_ON_SOURCE_SINGLEVAR_ARGS WORKING_DIRECTORY)
    set (RUN_TOOL_ON_SOURCE_MULTIVAR_ARGS COMMAND)
    cmake_parse_arguments (RUN_TOOL_ON_SOURCE
                           ""
                           "${RUN_TOOL_ON_SOURCE_SINGLEVAR_ARGS}"
                           "${RUN_TOOL_ON_SOURCE_MULTIVAR_ARGS}"
                           ${ARGN})

    # Replace @SOURCE@ with SOURCE in RUN_COMMAND_COMMAND here
    string (CONFIGURE "${RUN_TOOL_ON_SOURCE_COMMAND}" COMMAND @ONLY)

    # Get the basename of the file, used for the comment and stamp.
    get_filename_component (SRCNAME ${SOURCE} NAME)
    set (STAMPFILE
         ${CMAKE_CURRENT_BINARY_DIR}/${SRCNAME}.${TOOL_NAME}.stamp)
    set (COMMENT "Analyzing ${SRCNAME} with ${TOOL_NAME}")

    if (RUN_TOOL_ON_SOURCE_WORKING_DIRECTORY)

        set (WORKING_DIRECTORY_OPTION
             WORKING_DIRECTORY ${RUN_TOOL_ON_SOURCE_WORKING_DIRECTORY})

    endif (RUN_TOOL_ON_SOURCE_WORKING_DIRECTORY)

    add_custom_command (OUTPUT ${STAMPFILE}
                        COMMAND ${COMMAND}
                        COMMAND ${CMAKE_COMMAND} -E touch ${STAMPFILE}
                        DEPENDS ${SOURCE}
                        ${WORKING_DIRECTORY_OPTION}
                        COMMENT ${COMMENT})

    # Add the stampfile both to the SOURCES of TARGET
    # but also to the OBJECT_DEPENDS of any source files.
    #
    # On older CMake verisons editing SOURCES post-facto for a linkable
    # target was a no-op.
    set_property (TARGET ${TARGET}
                  APPEND PROPERTY SOURCES ${STAMPFILE})
    set_property (SOURCE ${SOURCE}
                  APPEND PROPERTY OBJECT_DEPENDS ${STAMPFILE})

endfunction (psq_run_tool_on_source)

function (psq_run_tool_for_each_source TARGET TOOL_NAME)

    set (RUN_COMMAND_OPTION_ARGS CHECK_GENERATED)
    set (RUN_COMMAND_SINGLEVAR_ARGS WORKING_DIRECTORY)
    set (RUN_COMMAND_MULTIVAR_ARGS COMMAND)
    cmake_parse_arguments (RUN_COMMAND
                           "${RUN_COMMAND_OPTION_ARGS}"
                           "${RUN_COMMAND_SINGLEVAR_ARGS}"
                           "${RUN_COMMAND_MULTIVAR_ARGS}"
                           ${ARGN})

    psq_strip_add_custom_target_sources (FILTERED_SOURCES
                                         ${TARGET})
    psq_handle_check_generated_option (RUN_COMMAND FILTERED_SOURCES
                                       SOURCES ${FILTERED_SOURCES})

    psq_forward_options (RUN_COMMAND RUN_ON_SOURCE_FORWARD
                         SINGLEVAR_ARGS WORKING_DIRECTORY
                         MULTIVAR_ARGS COMMAND)

    # For each source file, add a new custom command which runs our
    # tool and generates a stampfile, depending on the generation of
    # the source file.
    foreach (SOURCE ${FILTERED_SOURCES})

        psq_run_tool_on_source (${TARGET} ${SOURCE} ${TOOL_NAME}
                                ${RUN_ON_SOURCE_FORWARD})

    endforeach ()

endfunction (psq_run_tool_for_each_source)

function (psq_make_compilation_db TARGET
                                  CUSTOM_COMPILATION_DB_DIR_RETURN)

    set (MAKE_COMP_DB_OPTIONS)
    set (MAKE_COMP_DB_SINGLEVAR_OPTIONS)
    set (MAKE_COMP_DB_MULTIVAR_OPTIONS
         C_SOURCES
         CXX_SOURCES
         INTERNAL_INCLUDE_DIRS
         EXTERNAL_INCLUDE_DIRS
         DEFINES)

    cmake_parse_arguments (MAKE_COMP_DB
                           "${MAKE_COMP_DB_OPTIONS}"
                           "${MAKE_COMP_DB_SINGLEVAR_OPTIONS}"
                           "${MAKE_COMP_DB_MULTIVAR_OPTIONS}"
                           ${ARGN})

    # Don't write anything if we don't have to
    if (NOT MAKE_COMP_DB_C_SOURCES AND NOT MAKE_COMP_DB_CXX_SOURCES)

        return ()

    endif (NOT MAKE_COMP_DB_C_SOURCES AND NOT MAKE_COMP_DB_CXX_SOURCES)

    set (CUSTOM_COMPILATION_DB_DIR
         ${CMAKE_CURRENT_BINARY_DIR}/${TARGET}_compile_commands/)
    set (COMPILATION_DB_FILE
         ${CUSTOM_COMPILATION_DB_DIR}/compile_commands.json)

    set (COMPILATION_DB_FILE_CONTENTS
         "[")

    foreach (C_SOURCE ${MAKE_COMP_DB_C_SOURCES})

        list (APPEND SOURCES_LANGUAGES "C,${C_SOURCE}")

    endforeach ()

    foreach (CXX_SOURCE ${MAKE_COMP_DB_CXX_SOURCES})

        list (APPEND SOURCES_LANGUAGES "CXX,${CXX_SOURCE}")

    endforeach ()

    foreach (SOURCE_LANGUAGE ${SOURCES_LANGUAGES})

        string (REPLACE "," ";" SOURCE_LANGUAGE "${SOURCE_LANGUAGE}")

        list (GET SOURCE_LANGUAGE 0 LANGUAGE)
        list (GET SOURCE_LANGUAGE 1 SOURCE)

        get_filename_component (FULL_PATH ${SOURCE} ABSOLUTE)
        get_filename_component (BASENAME ${SOURCE} NAME)

        set (COMPILATION_DB_FILE_CONTENTS
             "${COMPILATION_DB_FILE_CONTENTS}\n{\n"
             "\"directory\": \"${CMAKE_CURRENT_BINARY_DIR}\",\n"
             "\"command\": \"")

        # Compiler and language options
        if (LANGUAGE STREQUAL "CXX")

             list (APPEND COMPILER_COMMAND_LINE
                   ${CMAKE_CXX_COMPILER}
                   -x
                   c++)

        elseif (LANGUAGE STREQUAL "C")

            list (APPEND COMPILER_COMMAND_LINE
                  ${CMAKE_C_COMPILER})

        endif (LANGUAGE STREQUAL "CXX")

        # Fake output file etc.
        list (APPEND COMPILER_COMMAND_LINE
              -o
              "CMakeFiles/${TARGET}.dir/${BASENAME}.o"
              -c
              ${FULL_PATH})

        # All includes
        psq_append_each_to_options_with_prefix (COMPILER_COMMAND_LINE
                                                -isystem
                                                LIST ${MAKE_COMP_DB_EXTERNAL_INCLUDE_DIRS})
        psq_append_each_to_options_with_prefix (COMPILER_COMMAND_LINE
                                                -I
                                                LIST ${MAKE_COMP_DB_INTERNAL_INCLUDE_DIRS})

        # All defines
        psq_append_each_to_options_with_prefix (COMPILER_COMMAND_LINE
                                                -D
                                                LIST ${MAKE_COMP_DB_DEFINES})


        # CXXFLAGS / CFLAGS
        if (LANGUAGE STREQUAL "CXX")

            list (APPEND COMPILER_COMMAND_LINE
                  ${CMAKE_CXX_FLAGS})

        elseif (LANGUAGE STREQUAL "C")

            list (APPEND COMPILER_COMMAND_LINE
                  ${CMAKE_C_FLAGS})

        endif (LANGUAGE STREQUAL "CXX")

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
            0 ${TRIMMED_COMPILATION_DB_FILE_LENGTH}
            COMPILATION_DB_FILE_CONTENTS)

    # Final "]"
    set (COMPILATION_DB_FILE_CONTENTS
         "${COMPILATION_DB_FILE_CONTENTS}\n]\n")

    # Write out
    file (WRITE ${COMPILATION_DB_FILE}
          ${COMPILATION_DB_FILE_CONTENTS})

    set (${CUSTOM_COMPILATION_DB_DIR_RETURN}
         ${CUSTOM_COMPILATION_DB_DIR} PARENT_SCOPE)

endfunction (psq_make_compilation_db)