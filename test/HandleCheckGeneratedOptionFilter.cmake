# /test/HandleCheckGeneratedOptionFilter.cmake
#
# Tests that we can filter out generated sources added with
# add_custom_command if CHECK_GENERATED was not passed to
# psq_handle_check_generated_option
#
# See LICENCE.md for Copyright information

include (PolysquareToolingUtil)
include (CMakeUnit)

set (SOURCE_FILE ${CMAKE_CURRENT_BINARY_DIR}/Source.cpp)
set (GENERATED_FILE ${CMAKE_CURRENT_BINARY_DIR}/Generated.cpp)

add_custom_command (OUTPUT ${GENERATED_FILE}
                    COMMAND ${CMAKE_COMMAND} -E touch ${GENERATED_FILE})

function (add_tooling)

    cmake_parse_arguments (PREFIX "CHECK_GENERATED" "" "" ${ARGN})

    psq_handle_check_generated_option (PREFIX FILTERED_SOURCES
                                       SOURCES ${SOURCE_FILE} ${GENERATED_FILE})

    assert_list_contains_value (FILTERED_SOURCES STRING EQUAL ${SOURCE_FILE})
    assert_list_does_not_contain_value (FILTERED_SOURCES
                                        STRING EQUAL ${GENERATED_FILE})

endfunction ()

# Call without CHECK_GENERATED
add_tooling ()
