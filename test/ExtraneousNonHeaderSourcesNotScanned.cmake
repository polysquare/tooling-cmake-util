# /test/ExtraneousNonHeaderSourcesNotScanned.cmake
#
# Adds some source files, including a source file which is not
# a compilable or header source at all. The configure step should succeed.
#
# See LICENCE.md for Copyright information

include (PolysquareToolingUtil)
include (CMakeUnit)

set (CXX_SOURCE_FILE_NAME "Source.cpp")
set (CXX_SOURCE_FILE_PATH
     "${CMAKE_CURRENT_SOURCE_DIR}/${CXX_SOURCE_FILE_NAME}")
set (EXTRANEOUS_FILE "${CMAKE_CURRENT_BINARY_DIR}/Extraneous.nonstandard")

cmake_unit_create_source_file_before_build (NAME "${CXX_SOURCE_FILE_NAME}")
file (WRITE "${EXTRANEOUS_FILE}" "")

set (TARGET executable)
add_executable (${TARGET} "${CXX_SOURCE_FILE_PATH}" "${EXTRANEOUS_FILE}")

# Regular usage of this command. Will strip extraneous sources
psq_strip_extraneous_sources (FILTERED_SOURCES ${TARGET})
psq_sort_sources_to_languages (C_SOURCES CXX_SOURCES HEADERS
                               SOURCES ${FILTERED_SOURCES})

assert_list_does_not_contain_value (C_SOURCES STRING EQUAL
                                    "${EXTRANEOUS_FILE}")
assert_list_does_not_contain_value (CXX_SOURCES STRING EQUAL
                                    "${EXTRANEOUS_FILE}")
assert_list_does_not_contain_value (HEADERS STRING EQUAL
                                    "${EXTRANEOUS_FILE}")
