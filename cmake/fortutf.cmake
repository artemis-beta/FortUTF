function(JOIN VALUES GLUE OUTPUT)
  string (REGEX REPLACE "([^\\]|^);" "\\1${GLUE}" _TMP_STR "${VALUES}")
  string (REGEX REPLACE "[\\](.)" "\\1" _TMP_STR "${_TMP_STR}")
  set (${OUTPUT} "${_TMP_STR}" PARENT_SCOPE)
endfunction()

function(FortUTF_Find_Tests)
    message(STATUS "[FortUTF]")
    message(STATUS "\tFinding tests in directory: ${FORTUTF_PROJECT_TEST_DIR}")
    if(NOT FORTUTF_PROJECT_TEST_DIR)
        set(FORTUTF_PROJECT_TEST_DIR ${CMAKE_SOURCE_DIR}/tests)
    endif()

    GET_FILENAME_COMPONENT(FORTUTF_DIR ${CMAKE_CURRENT_function_LIST_FILE} DIRECTORY)
    GET_FILENAME_COMPONENT(FORTUTF_DIR ${FORTUTF_DIR} DIRECTORY)

    FILE(GLOB FORTUTF_SRCS ${FORTUTF_DIR}/src/*.f90)

    if(NOT FORTUTF_PROJECT_SRC_FILES AND NOT FORTUTF_PROJECT_SRC_LIBRARY)
        message(FATAL_ERROR "Variable SRC_FILES or SRC_LIBRARY must be set")
    endif()

    FILE(GLOB_RECURSE TESTS ${FORTUTF_PROJECT_TEST_DIR}/test_*.f90)

    list(APPEND TEST_LIST ${TESTS})

    join("${TEST_LIST}" " " TEST_LIST_ARG)

    message(STATUS "\tTests Files Found: ")
    foreach(TEST_NAME ${TEST_LIST})
        message(STATUS "\t  - ${TEST_NAME}")
    endforeach()

    EXECUTE_PROCESS(
        COMMAND bash -c "for i in ${TEST_LIST_ARG}; do cat $i | grep -i \"^[[:space:]]*SUBROUTINE\" | rev | cut -d ' ' -f 1 | rev; done"
        OUTPUT_VARIABLE TEST_SUBROUTINES
    )

    EXECUTE_PROCESS(
        COMMAND bash -c "for i in ${TEST_LIST_ARG}; do cat $i | grep -i \"^[[:space:]]*MODULE\" | rev | cut -d ' ' -f 1 | rev; done"
        OUTPUT_VARIABLE TEST_MODULES
    )

    string(REGEX REPLACE "\n" " " TEST_SUBROUTINES "${TEST_SUBROUTINES}")
    string(REGEX REPLACE "\n" " " TEST_MODULES "${TEST_MODULES}")
    string(REGEX REPLACE " SUBROUTINE " " " TEST_SUBROUTINES "${TEST_SUBROUTINES}")
    string(REGEX REPLACE " subroutine " " " TEST_SUBROUTINES "${TEST_SUBROUTINES}")
    string(REGEX REPLACE " MODULE " " " TEST_MODULES "${TEST_MODULES}")
    string(REGEX REPLACE " module " " " TEST_MODULES "${TEST_MODULES}")
    set(TEST_SUBROUTINES_LIST "${TEST_SUBROUTINES}")
    set(TEST_MODULES_LIST "${TEST_MODULES}")
    separate_arguments(TEST_SUBROUTINES_LIST)
    separate_arguments(TEST_MODULES_LIST)
    list(REMOVE_DUPLICATES TEST_SUBROUTINES_LIST)
    list(REMOVE_DUPLICATES TEST_MODULES_LIST)
    list(REMOVE_ITEM TEST_SUBROUTINES_LIST SUBROUTINE)
    list(REMOVE_ITEM TEST_SUBROUTINES_LIST subroutine)
    list(REMOVE_ITEM TEST_MODULES_LIST "MODULE")
    list(REMOVE_ITEM TEST_MODULES_LIST module)
    join("${TEST_SUBROUTINES_LIST}" " " TEST_SUBROUTINES)
    join("${TEST_MODULES_LIST}" " " TEST_MODULES)
    message(STATUS "\tTests Found: ")
    foreach(SUBROOT ${TEST_SUBROUTINES_LIST})
        message(STATUS "\t  - ${SUBROOT}")
    endforeach()
    if(TEST_MODULES_LIST)
        message(STATUS "\tWill Include Modules: ")
        foreach(MODULE ${TEST_MODULES_LIST})
            message(STATUS "\t  - ${MODULE}")
        endforeach()
    endif()

    message(STATUS ${FORTUTF_PROJECT_TEST_DIR}/run_tests.f90 )

    write_file( ${FORTUTF_PROJECT_TEST_DIR}/run_tests.f90 "PROGRAM TEST_${PROJECT_NAME}" )
    write_file( ${FORTUTF_PROJECT_TEST_DIR}/run_tests.f90 "    USE FORTUTF" APPEND )

    foreach( TEST_MODULE ${TEST_MODULES_LIST} )
        write_file( ${FORTUTF_PROJECT_TEST_DIR}/run_tests.f90 "    USE ${TEST_MODULE}" APPEND )
    endforeach()

    foreach( SUBROUTINE ${TEST_SUBROUTINES} )
        write_file( ${FORTUTF_PROJECT_TEST_DIR}/run_tests.f90 "    CALL ${SUBROUTINE}" APPEND )
    endforeach()

    write_file( ${FORTUTF_PROJECT_TEST_DIR}/run_tests.f90 "    CALL TEST_SUMMARY" APPEND )
    write_file( ${FORTUTF_PROJECT_TEST_DIR}/run_tests.f90 "END PROGRAM" APPEND )

    if(NOT TARGET ${FORTUTF})
        if(NOT DEFINED ${FORTUTF})
            set(FORTUTF FortUTF)
        endif()
        ADD_LIBRARY(${FORTUTF} ${FORTUTF_SRCS})
    endif()

    add_executable(${PROJECT_NAME}_Tests ${FORTUTF_PROJECT_SRC_FILES} ${FORTUTF_SRCS} ${TEST_LIST} ${FORTUTF_PROJECT_TEST_DIR}/run_tests.f90)

    if(FORTUTF_PROJECT_MOD_DIR)
        message(STATUS "\tIncluding library: ${FORTUTF_PROJECT_MOD_DIR}")
        TARGET_INCLUDE_DIRECTORIES(
            ${PROJECT_NAME}_Tests
            PUBLIC
            ${FORTUTF_PROJECT_MOD_DIR}
        )
    endif()

    if(FORTUTF_PROJECT_SRC_LIBRARY)
        message(STATUS "\tLinking library: ${FORTUTF_PROJECT_SRC_LIBRARY}")

        target_link_libraries(
            ${PROJECT_NAME}_Tests ${FORTUTF_PROJECT_SRC_LIBRARY}
        )
    endif()

    message(STATUS "\tCompiler Flags: ${CMAKE_Fortran_FLAGS}")

    target_link_libraries(
        ${PROJECT_NAME}_Tests ${FORTUTF}
    )

endfunction()
