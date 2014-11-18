# /test/MakeSpecialCompilationDBHelper.cmake
#
# Helper macro to generate a header and source file as
# well as a corresponding compilation database. Extra
# arguments get passed to psq_make_compilation_db.
#
# See LICENCE.md for Copyright information

# Leave as a macro as the value of COMPILATION_DB_DIR is useful
# in tests
macro (test_make_sources_and_compilation_db SOURCE_NAME LANGUAGE)

    set (HEADER_FILE_NAME "Header.h")
    set (HEADER_FILE_PATH
         "${CMAKE_CURRENT_SOURCE_DIR}/${HEADER_FILE_NAME}")
    cmake_unit_create_source_file_before_build (NAME
                                                "${HEADER_FILE_NAME}")
    set (SOURCE_FILE_NAME "${SOURCE_NAME}")
    set (SOURCE_FILE_PATH
         "${CMAKE_CURRENT_SOURCE_DIR}/${SOURCE_FILE_NAME}")
    cmake_unit_create_source_file_before_build (NAME
                                                "${SOURCE_FILE_NAME}"
                                                FUNCTIONS main)
    set (TARGET target)

    add_custom_target (${TARGET} ALL
                       SOURCES
                       "${SOURCE_FILE_PATH}"
                       "${HEADER_FILE_PATH}")
    psq_make_compilation_db (${TARGET}
                             COMPILATION_DB_DIR
                             ${LANGUAGE}_SOURCES
                             "${SOURCE_FILE_PATH}"
                             "${HEADER_FILE_PATH}"
                             INTERNAL_INCLUDE_DIRS
                             "${CMAKE_CURRENT_SOURCE_DIR}"
                             ${ARGN})

endmacro ()
