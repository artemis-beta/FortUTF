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

    get_filename_component(FORTUTF_DIR ${CMAKE_CURRENT_FUNCTION_LIST_FILE} DIRECTORY)
    get_filename_component(FORTUTF_DIR ${FORTUTF_DIR} DIRECTORY)

    FILE(GLOB FORTUTF_SRCS ${FORTUTF_DIR}/src/*.f90)

    if(NOT FORTUTF_PROJECT_SRC_FILES AND NOT FORTUTF_PROJECT_SRC_LIBRARY)
        message(FATAL_ERROR "Variable SRC_FILES or SRC_LIBRARY must be set")
    endif()

    FILE(GLOB_RECURSE TESTS ${FORTUTF_PROJECT_TEST_DIR}/test_*.f90)

    list(APPEND TEST_LIST ${TESTS})

    list(LENGTH TEST_LIST NUM_FILES)
    message(STATUS "\t${NUM_FILES} Tests Files Found: ")
    foreach(TEST_NAME ${TEST_LIST})
        message(STATUS "\t  - ${TEST_NAME}")
        file(READ "${TEST_NAME}" TEST_FILE_CONTENTS)
        string(TOUPPER "${TEST_FILE_CONTENTS}" TEST_FILE_CONTENTS)
        string(REGEX MATCHALL "SUBROUTINE[ ]([a-zA-Z0-9\_]+)" TEST_SUBROUTINES_REGMATCH ${TEST_FILE_CONTENTS})
        list(APPEND TEST_SUBROUTINES ${TEST_SUBROUTINES_REGMATCH})
        string(REGEX MATCHALL "MODULE[ ]([a-zA-Z0-9\_]+)" TEST_MODULES_REGMATCH ${TEST_FILE_CONTENTS})
        list(APPEND TEST_MODULES ${TEST_MODULES_REGMATCH})
    endforeach()

    list(REMOVE_DUPLICATES TEST_SUBROUTINES)
    list(REMOVE_DUPLICATES TEST_MODULES)
    list(LENGTH TEST_SUBROUTINES NUM_TESTS)
    list(LENGTH TEST_MODULES NUM_MODULES)

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

    if(NOT TEST_SUBROUTINES_LIST)
        message(FATAL_ERROR "\tNo Tests Found.")
    else()
        message(STATUS "\t${NUM_TESTS} Tests Found: ")
    endif()
    foreach(SUBROOT ${TEST_SUBROUTINES_LIST})
        message(STATUS "\t  - ${SUBROOT}")
    endforeach()
    if(TEST_MODULES_LIST)
        message(STATUS "\tWill Include ${NUM_MODULES} Modules: ")
        foreach(MODULE ${TEST_MODULES_LIST})
            message(STATUS "\t  - ${MODULE}")
        endforeach()
    endif()

    write_file( ${FORTUTF_PROJECT_TEST_DIR}/run_tests.f90 "PROGRAM TEST_${PROJECT_NAME}" )
    write_file( ${FORTUTF_PROJECT_TEST_DIR}/run_tests.f90 "    USE FORTUTF" APPEND )

    foreach( TEST_MODULE ${TEST_MODULES_LIST} )
        write_file( ${FORTUTF_PROJECT_TEST_DIR}/run_tests.f90 "    USE ${TEST_MODULE}" APPEND )
    endforeach()

    foreach( SUBROUTINE ${TEST_SUBROUTINES_LIST} )
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
