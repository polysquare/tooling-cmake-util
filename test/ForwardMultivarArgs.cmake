# /tests/ForwardMultivarArgs.cmake
#
# Checks that some multi-variable arguments passed in to a function with
# an argument prefix PREFIX get re-added to the forward options list
# as MUTLIVAR_ARGUMENT_NAME;Argument1;Argument2; etc.
#
# See LICENCE.md for Copyright information.

include (${POLYSQUARE_TOOLING_CMAKE_DIRECTORY}/PolysquareToolingUtil.cmake)
include (${POLYSQUARE_TOOLING_CMAKE_TESTS_DIRECTORY}/CMakeUnit.cmake)

set (PASSED_ARGUMENTS_ONE Argument1)
set (PASSED_ARGUMENTS_TWO Argument2)

set (PASSED_ARGUMENTS ${PASSED_ARGUMENTS_ONE} ${PASSED_ARGUMENTS_TWO})

function (called_function)

    cmake_parse_arguments (PREFIX "" "" "MULTIVAR_ARGUMENT_NAME" ${ARGN})

    psq_forward_options (PREFIX FORWARD_OPTIONS
                         MULTIVAR_ARGS MULTIVAR_ARGUMENT_NAME)

    assert_list_contains_value (FORWARD_OPTIONS STRING EQUAL
                                MULTIVAR_ARGUMENT_NAME)
    assert_list_contains_value (FORWARD_OPTIONS STRING EQUAL
                                ${PASSED_ARGUMENTS_ONE})
    assert_list_contains_value (FORWARD_OPTIONS STRING EQUAL
                                ${PASSED_ARGUMENTS_TWO})

endfunction (called_function)

called_function (MULTIVAR_ARGUMENT_NAME ${PASSED_ARGUMENTS})