# /tests/ForwardSinglevarArgs.cmake
#
# Checks that some single-variable arguments passed in to a function with
# an argument prefix PREFIX get re-added to the forward options list
# as SINGLEVAR_ARGUMENT_NAME_PASSED;Argument1 etc and
# SINGLEVAR_ARGUMENT_NAME_NOT_PASSED is not present in the forward options.
#
# See LICENCE.md for Copyright information.

include (PolysquareToolingUtil)
include (CMakeUnit)

set (PASSED_ARGUMENT Argument)

set (PASSED_ARGUMENTS ${PASSED_ARGUMENTS_ONE} ${PASSED_ARGUMENTS_TWO})

function (called_function)

    set (SINGLEVAR_ARGS
         SINGLEVAR_ARGUMENT_NAME_PASSED
         SINGLEVAR_ARGUMENT_NAME_NOT_PASSED)
    cmake_parse_arguments (PREFIX "" "${SINGLEVAR_ARGS}" "" ${ARGN})

    psq_forward_options (PREFIX FORWARD_OPTIONS
                         SINGLEVAR_ARGS ${SINGLEVAR_ARGS})

    assert_list_contains_value (FORWARD_OPTIONS STRING EQUAL
                                SINGLEVAR_ARGUMENT_NAME_PASSED)
    assert_list_contains_value (FORWARD_OPTIONS STRING EQUAL
                                ${PASSED_ARGUMENT})
    assert_list_does_not_contain_value (FORWARD_OPTIONS STRING EQUAL
                                        SINGLEVAR_ARGUMENT_NAME_NOT_PASSED)

endfunction (called_function)

called_function (SINGLEVAR_ARGUMENT_NAME_PASSED ${PASSED_ARGUMENT})