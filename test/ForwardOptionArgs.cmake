# /tests/ForwardOptionArgs.cmake
#
# Checks that option arguments passed to a function get put back into the
# forward options list with their original name, but only if they were
# set
#
# See LICENCE.md for Copyright information.

include (${POLYSQUARE_TOOLING_CMAKE_DIRECTORY}/PolysquareToolingUtil.cmake)
include (${POLYSQUARE_TOOLING_CMAKE_TESTS_DIRECTORY}/CMakeUnit.cmake)

set (PASSED_ARGUMENT Argument)

set (PASSED_ARGUMENTS ${PASSED_ARGUMENTS_ONE} ${PASSED_ARGUMENTS_TWO})

function (called_function)

    set (OPTION_ARGS PASSED NOT_PASSED)
    cmake_parse_arguments (PREFIX "${OPTION_ARGS}" "" "" ${ARGN})

    psq_forward_options (PREFIX FORWARD_OPTIONS
                         OPTION_ARGS ${OPTION_ARGS})

    assert_list_contains_value (FORWARD_OPTIONS STRING EQUAL
                                PASSED)
    assert_list_does_not_contain_value (FORWARD_OPTIONS STRING EQUAL
                                        NOT_PASSED)

endfunction (called_function)

called_function (PASSED)