FUNCTION(JOIN VALUES GLUE OUTPUT)
  STRING (REGEX REPLACE "([^\\]|^);" "\\1${GLUE}" _TMP_STR "${VALUES}")
  STRING (REGEX REPLACE "[\\](.)" "\\1" _TMP_STR "${_TMP_STR}")
  SET (${OUTPUT} "${_TMP_STR}" PARENT_SCOPE)
ENDFUNCTION()

FUNCTION(FortUTF_Find_Tests)
        MESSAGE(STATUS "[FortUTF]")
        MESSAGE(STATUS "\tFinding tests in directory: ${TEST_DIR}")
        IF(NOT TEST_DIR)
                SET(TEST_DIR ${CMAKE_SOURCE_DIR}/tests)
        ENDIF()

        GET_FILENAME_COMPONENT(FORTUTF_DIR ${CMAKE_CURRENT_FUNCTION_LIST_FILE} DIRECTORY)
        GET_FILENAME_COMPONENT(FORTUTF_DIR ${FORTUTF_DIR} DIRECTORY)

        FILE(GLOB FORTUTF_SRCS ${FORTUTF_DIR}/src/*.f90)

        IF(NOT SRC_FILES AND NOT SRC_LIBRARY)
                MESSAGE(FATAL_ERROR "Variable SRC_FILES or SRC_LIBRARY must be set")
        ENDIF()

        FILE(GLOB_RECURSE TESTS ${TEST_DIR}/test_*.f90)

        LIST(APPEND TEST_LIST ${TESTS})

        JOIN("${TEST_LIST}" " " TEST_LIST_ARG)

        MESSAGE(STATUS "\tTests Files Found: ")
        FOREACH(TEST_NAME ${TEST_LIST})
                MESSAGE(STATUS "\t  - ${TEST_NAME}")
        ENDFOREACH()

        EXECUTE_PROCESS(
                COMMAND bash -c "for i in ${TEST_LIST_ARG}; do cat $i | grep -i \"SUBROUTINE\" | rev | cut -d ' ' -f 1 | rev; done"
                OUTPUT_VARIABLE TEST_SUBROUTINES
        )

        EXECUTE_PROCESS(
                COMMAND bash -c "for i in ${TEST_LIST_ARG}; do cat $i | grep -i \"MODULE\" | rev | cut -d ' ' -f 1 | rev; done"
                OUTPUT_VARIABLE TEST_MODULES
        )

        STRING(REGEX REPLACE "\n" " " TEST_SUBROUTINES "${TEST_SUBROUTINES}")
        STRING(REGEX REPLACE "\n" " " TEST_MODULES "${TEST_MODULES}")
        STRING(REGEX REPLACE " SUBROUTINE " " " TEST_SUBROUTINES "${TEST_SUBROUTINES}")
        STRING(REGEX REPLACE " subroutine " " " TEST_SUBROUTINES "${TEST_SUBROUTINES}")
        STRING(REGEX REPLACE " MODULE " " " TEST_MODULES "${TEST_MODULES}")
        STRING(REGEX REPLACE " module " " " TEST_MODULES "${TEST_MODULES}")
        SET(TEST_SUBROUTINES_LIST "${TEST_SUBROUTINES}")
        SET(TEST_MODULES_LIST "${TEST_MODULES}")
        SEPARATE_ARGUMENTS(TEST_SUBROUTINES_LIST)
        SEPARATE_ARGUMENTS(TEST_MODULES_LIST)
        LIST(REMOVE_DUPLICATES TEST_SUBROUTINES_LIST)
        LIST(REMOVE_DUPLICATES TEST_MODULES_LIST)
        LIST(REMOVE_ITEM TEST_SUBROUTINES_LIST SUBROUTINE)
        LIST(REMOVE_ITEM TEST_SUBROUTINES_LIST subroutine)
        LIST(REMOVE_ITEM TEST_MODULES_LIST "MODULE")
        LIST(REMOVE_ITEM TEST_MODULES_LIST module)
        JOIN("${TEST_SUBROUTINES_LIST}" " " TEST_SUBROUTINES)
        JOIN("${TEST_MODULES_LIST}" " " TEST_MODULES)
        MESSAGE(STATUS "\tTests Found: ")
        FOREACH(SUBROOT ${TEST_SUBROUTINES_LIST})
                MESSAGE(STATUS "\t  - ${SUBROOT}")
        ENDFOREACH()

        EXECUTE_PROCESS(
                COMMAND bash -c "rm -f ${TEST_DIR}/run_tests.f90;echo \"PROGRAM TEST_${PROJECT_NAME}\" >> ${TEST_DIR}/run_tests.f90; \
                                echo \"    USE FORTUTF\" >> ${TEST_DIR}/run_tests.f90; \
                                for i in ${TEST_MODULES}; do echo \"    USE $i\" >> ${TEST_DIR}/run_tests.f90; done; \
                                for i in ${TEST_SUBROUTINES}; do echo \"    CALL $i\" >> ${TEST_DIR}/run_tests.f90; done; \
                                echo \"    CALL TEST_SUMMARY\" >> ${TEST_DIR}/run_tests.f90; \
                                echo \"END PROGRAM\" >> ${TEST_DIR}/run_tests.f90"
        )

        ADD_LIBRARY(FORTUTF ${FORTUTF_SRCS})

        ADD_EXECUTABLE(${PROJECT_NAME}_Tests ${SRC_FILES} ${FORTUTF_SRCS} ${TEST_LIST} ${TEST_DIR}/run_tests.f90)

        IF(MOD_DIR)
                MESSAGE(STATUS "\tIncluding library: ${MOD_DIR}")
                TARGET_INCLUDE_DIRECTORIES(
                        ${PROJECT_NAME}_Tests
                        PUBLIC
                        ${MOD_DIR}
                )
        ENDIF()

        IF(SRC_LIBRARY)
                MESSAGE(STATUS "\tLinking library: ${SRC_LIBRARY}")

                TARGET_LINK_LIBRARIES(
                        ${PROJECT_NAME}_Tests ${SRC_LIBRARY}
                )
        ENDIF()

        MESSAGE(STATUS "\tCompiler Flags: ${CMAKE_Fortran_FLAGS}")

        TARGET_LINK_LIBRARIES(
                ${PROJECT_NAME}_Tests FORTUTF
        )

ENDFUNCTION()
