# /test/SpecialCompilationDBDefines.cmake
#
# Add some sources and defines to a custom target.
# The defines should be passed into the compilation DB.
#
# See LICENCE.md for Copyright information

include (PolysquareToolingUtil)
include (CMakeUnit)

set (SOURCE_FILE_NAME "Source.cpp")
set (SOURCE_FILE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/${SOURCE_FILE_NAME}")
cmake_unit_create_source_file_before_build (NAME
                                            "${SOURCE_FILE_NAME}"
                                            FUNCTIONS main)
set (SOURCE_DEFINES custom_define=1)
set (TARGET target)

add_custom_target (${TARGET} ALL
                   SOURCES "${SOURCE_FILE_PATH}")
psq_make_compilation_db (${TARGET}
                         COMPILATION_DB_DIR
                         CXX_SOURCES "${SOURCE_FILE_PATH}"
                         DEFINES ${SOURCE_DEFINES})

set (COMPILE_COMMANDS
     "${COMPILATION_DB_DIR}/compile_commands.json")
assert_file_has_line_matching ("${COMPILE_COMMANDS}"
                               "^.*-Dcustom_define=1.*$")
