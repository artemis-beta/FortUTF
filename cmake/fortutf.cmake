cmake_minimum_required(VERSION 3.21)

function(JOIN VALUES GLUE OUTPUT)
  string (REGEX REPLACE "([^\\]|^);" "\\1${GLUE}" _TMP_STR "${VALUES}")
  string (REGEX REPLACE "[\\](.)" "\\1" _TMP_STR "${_TMP_STR}")
  set (${OUTPUT} "${_TMP_STR}" PARENT_SCOPE)
endfunction()


function(DEDUCE_TYPE VAR_STR OUT_DECLARE OUT_INIT VARIABLE_NAME)
    string(REGEX MATCH "=\".+\"" STR_RESULT ${VAR_STR})
    string(REGEX MATCH "=[0-9\.]+D[0-9]+" REAL_RESULT ${VAR_STR})
    string(REGEX MATCH "=[0-9]+" INTEGER_RESULT ${VAR_STR})

    if(NOT ${STR_RESULT} STREQUAL "")
        string(REPLACE "=" "" STR_RESULT ${STR_RESULT})
        string(LENGTH "${STR_RESULT}" CHAR_LEN)
        string(REPLACE "${STR_RESULT}" "" VAR_NAME ${VAR_STR})
        string(REPLACE "=" "" VAR_NAME ${VAR_NAME})
        set(_TMP_DECLARE "CHARACTER(LEN=${CHAR_LEN}) :: ${VAR_NAME}")
        set(_TMP_INIT "${VAR_NAME} = \"${STR_RESULT}\"")
    elseif(NOT ${REAL_RESULT} STREQUAL "")
        string(REPLACE "=" "" REAL_RESULT ${REAL_RESULT})
        string(REPLACE "${REAL_RESULT}" "" VAR_NAME ${VAR_STR})
        string(REPLACE "=" "" VAR_NAME ${VAR_NAME})
        set(_TMP_DECLARE "REAL(8) :: ${VAR_NAME}")
        set(_TMP_INIT "${VAR_NAME} = ${REAL_RESULT}")
    elseif(NOT ${INTEGER_RESULT} STREQUAL "")
        string(REPLACE "${INTEGER_RESULT}" "" VAR_NAME ${VAR_STR})
        string(REPLACE "=" "" INTEGER_RESULT ${INTEGER_RESULT})
        string(REPLACE "=" "" VAR_NAME ${VAR_NAME})
        set(_TMP_DECLARE "INTEGER :: ${VAR_NAME}")
        set(_TMP_INIT "${VAR_NAME} = ${INTEGER_RESULT}")
    endif()
    set(${OUT_DECLARE} "${_TMP_DECLARE}" PARENT_SCOPE)
    set(${OUT_INIT} "${_TMP_INIT}" PARENT_SCOPE)
    set(${VARIABLE_NAME} "${VAR_NAME}" PARENT_SCOPE)
endfunction()


function(PARSE_FILE FILE_NAME FIXTURES_OUT STD_SUBROUTINES FIXTURED_SUBROUTINES ITER_LABELS MODULES TEST_DECLARE_LINES TEST_RUN_LINES)
    file(STRINGS "${FILE_NAME}" FILE_CONTENTS_LIST)
    set(CURRENT_TEST_CALLS "")
    foreach(LINE ${FILE_CONTENTS_LIST})
        set(VAR_NAMES "")
        string(TOUPPER "${LINE}" LINE)
        string(REGEX MATCH "!>SCENARIO\\(([a-zA-Z0-9\_]+=[a-zA-Z0-9\.]+,*)+\\)" SCENARIO_REGEX_RESULT ${LINE})
        string(REGEX MATCH "SUBROUTINE[ ]TEST_[a-zA-Z0-9\_]+\\([a-zA-Z0-9\_, ]+\\)" FIXTURE_SUBROUTINE_REGEX_RESULT ${LINE})
        string(REGEX MATCH "SUBROUTINE[ ]TEST_[a-zA-Z0-9\_]+" STD_SUBROUTINE_REGEX_RESULT ${LINE})
        string(REGEX MATCH "MODULE[ ]([a-zA-Z0-9\_]+)" MODULE_REGEX_RESULT ${LINE})
        if(NOT ${FIXTURE_SUBROUTINE_REGEX_RESULT} STREQUAL "")
            string(REGEX REPLACE "[ ]*SUBROUTINE " "" STD_SUBROUTINE_REGEX_RESULT "${STD_SUBROUTINE_REGEX_RESULT}")
            list(APPEND _TMP_FIXTURE_SUB_LIST "${STD_SUBROUTINE_REGEX_RESULT}")
            list(TRANSFORM CURRENT_TEST_CALLS PREPEND "CALL ${STD_SUBROUTINE_REGEX_RESULT}")
            list(REMOVE_DUPLICATES CURRENT_TEST_CALLS)
            foreach(INITS ${INIT_SET})
                join("${INITS}" "\n" OUT_INITS)
                join("${OUT_INITS}\n\t\t${CURRENT_TEST_CALLS}" "\n" OUT_LINE)
                list(APPEND _TMP_RUN_LINES ${OUT_LINE})
                list(APPEND _TMP_ITER_LABELS ${STD_SUBROUTINE_REGEX_RESULT})
            endforeach()
            set(INITS "")
            set(CURRENT_TEST_CALLS "")
        elseif(NOT ${STD_SUBROUTINE_REGEX_RESULT} STREQUAL "")
            string(REGEX REPLACE "[ ]*SUBROUTINE " " " STD_SUBROUTINE_REGEX_RESULT "${STD_SUBROUTINE_REGEX_RESULT}")
            if("${STD_SUBROUTINE_REGEX_RESULT}" IN_LIST _TMP_STD_SUB_LIST)
                continue()
            endif()
            list(APPEND _TMP_STD_SUB_LIST ${STD_SUBROUTINE_REGEX_RESULT})
            list(APPEND _TMP_RUN_LINES "CALL ${STD_SUBROUTINE_REGEX_RESULT}")
            list(APPEND _TMP_ITER_LABELS ${STD_SUBROUTINE_REGEX_RESULT})
        elseif(NOT ${MODULE_REGEX_RESULT} STREQUAL "")
            string(REGEX REPLACE " MODULE " " " MODULE_REGEX_RESULT "${MODULE_REGEX_RESULT}")
            list(APPEND _TMP_MODULE_LIST ${MODULE_REGEX_RESULT})
        elseif(NOT ${SCENARIO_REGEX_RESULT} STREQUAL "")
            message(STATUS ${SCENARIO_REGEX_RESULT})
            string(REGEX MATCHALL "[a-zA-Z0-9\_]+=[a-zA-Z0-9\_\"]+" VARS ${SCENARIO_REGEX_RESULT})
            set(VAR_SET "")
            foreach(VAR ${VARS})
                get_filename_component(UNIQ_ID ${FILE_NAME} NAME_WLE)
                string(TOUPPER ${UNIQ_ID} UNIQ_ID)
                deduce_type("${UNIQ_ID}_${VAR}" DEC_LINES INIT_LINES VAR_NAME)
                list(APPEND VAR_NAMES ${VAR_NAME})
                list(APPEND VAR_SET ${INIT_LINES})
                list(APPEND _TMP_DEC_LINES ${DEC_LINES})
            endforeach()
            join("${VAR_SET}" "\n\t\t" VAR_SET)
            list(APPEND INIT_SET ${VAR_SET})
            join("${VAR_NAMES}" "," VAR_NAMES)
            list(APPEND CURRENT_TEST_CALLS "(${VAR_NAMES})")
        endif()
    endforeach()
    set(${MODULES} "${_TMP_MODULE_LIST}" PARENT_SCOPE)
    set(${STD_SUBROUTINES} "${_TMP_STD_SUB_LIST}" PARENT_SCOPE)
    set(${TEST_DECLARE_LINES} "${_TMP_DEC_LINES}" PARENT_SCOPE)
    set(${FIXTURED_SUBROUTINES} "${_TMP_FIXTURE_SUB_LIST}" PARENT_SCOPE)
    set(${TEST_RUN_LINES} "${_TMP_RUN_LINES}" PARENT_SCOPE)
    set(${ITER_LABELS} "${_TMP_ITER_LABELS}" PARENT_SCOPE)
endfunction()


function(FIND_COMPONENT FILE_NAME SEARCH_REGEX SET_OUT INDICES_LIST)
    file(STRINGS "${FILE_NAME}" FILE_CONTENTS_LIST)
    set(INDEX 0)
    foreach(LINE ${FILE_CONTENTS_LIST})
        string(TOUPPER "${LINE}" LINE)
        string(REGEX MATCH ${SEARCH_REGEX} REGEX_RESULT ${LINE})
        if(NOT ${REGEX_RESULT} STREQUAL "")
            list(APPEND _TMP_LIST ${REGEX_RESULT})
            list(APPEND _TMP_I_LIST ${INDEX})
        endif()
        math(EXPR INDEX "${INDEX}+1")
    endforeach()
    set(${SET_OUT} "${_TMP_LIST}" PARENT_SCOPE)
    set(${INDICES_LIST} "${_TMP_I_LIST}" PARENT_SCOPE)
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

    list(APPEND TEST_LIST ${TESTS} ${FORTUTF_PROJECT_TEST_FILES})

    list(LENGTH TEST_LIST NUM_FILES)

    message(STATUS "\t${NUM_FILES} Tests Files Found: ")
    foreach(TEST_NAME ${TEST_LIST})
        message(STATUS "\t  - ${TEST_NAME}")
        file(READ "${TEST_NAME}" TEST_FILE_CONTENTS)
        parse_file(${TEST_NAME} FIXTURES_OUT FILE_TEST_STD_SUBROUTINES FILE_TEST_SCENARIO_SUBROUTINES FILE_ITER_LABELS FILE_TEST_MODULES FILE_TEST_DECLARE_LINES FILE_TEST_RUN_LINES)
        list(APPEND TEST_STD_SUBROUTINES ${FILE_TEST_STD_SUBROUTINES})
        list(APPEND TEST_SCENARIO_SUBROUTINES ${FILE_TEST_SCENARIO_SUBROUTINES})
        list(APPEND TEST_DECLARE_LINES ${FILE_TEST_DECLARE_LINES})
        list(APPEND TEST_RUN_LINES ${FILE_TEST_RUN_LINES})
        list(APPEND TEST_MODULES ${FILE_TEST_MODULES})
        list(APPEND ITER_LABELS ${FILE_ITER_LABELS})
    endforeach()

    list(REMOVE_DUPLICATES TEST_STD_SUBROUTINES)
    list(REMOVE_DUPLICATES TEST_DECLARE_LINES)

    list(REMOVE_DUPLICATES TEST_SCENARIO_SUBROUTINES)
    list(REMOVE_DUPLICATES TEST_MODULES)
    list(LENGTH TEST_STD_SUBROUTINES NUM_TESTS)
    list(LENGTH TEST_MODULES NUM_MODULES)

    string(REGEX REPLACE "\n" " " TEST_STD_SUBROUTINES "${TEST_STD_SUBROUTINES}")
    string(REGEX REPLACE "\n" " " TEST_MODULES "${TEST_MODULES}")
    string(REGEX REPLACE " MODULE " " " TEST_MODULES "${TEST_MODULES}")
    string(REGEX REPLACE " SUBROUTINE " " " TEST_SCENARIO_SUBROUTINES "${TEST_SCENARIO_SUBROUTINES}")
    set(TEST_STD_SUBROUTINES_LIST "${TEST_STD_SUBROUTINES}")
    set(TEST_SCENARIO_SUBROUTINES_LIST "${TEST_SCENARIO_SUBROUTINES}")
    set(TEST_MODULES_LIST "${TEST_MODULES}")

    separate_arguments(TEST_STD_SUBROUTINES_LIST)
    separate_arguments(TEST_MODULES_LIST)
    separate_arguments(TEST_SCENARIO_SUBROUTINES_LIST)

    list(REMOVE_DUPLICATES TEST_SCENARIO_SUBROUTINES_LIST)
    list(REMOVE_DUPLICATES TEST_STD_SUBROUTINES_LIST)
    list(REMOVE_DUPLICATES TEST_MODULES_LIST)
    list(REMOVE_ITEM TEST_STD_SUBROUTINES_LIST SUBROUTINE)
    list(REMOVE_ITEM TEST_SCENARIO_SUBROUTINES_LIST SUBROUTINE)
    list(REMOVE_ITEM TEST_MODULES_LIST "MODULE")
    list(REMOVE_ITEM TEST_MODULES_LIST module)
    join("${TEST_STD_SUBROUTINES_LIST}" " " TEST_STD_SUBROUTINES)
    join("${TEST_SCENARIO_SUBROUTINES_LIST}" " " TEST_SCENARIO_SUBROUTINES)
    join("${TEST_MODULES_LIST}" " " TEST_MODULES)

    if(NOT TEST_STD_SUBROUTINES_LIST)
        message(FATAL_ERROR "\tNo Tests Found.")
    else()
        message(STATUS "\t${NUM_TESTS} Tests Found: ")
    endif()
    foreach(SUBROOT ${TEST_STD_SUBROUTINES_LIST})
        message(STATUS "\t  - ${SUBROOT}")
    endforeach()
    foreach(SUBROOT ${TEST_SCENARIO_SUBROUTINES})
        message(STATUS "\t  - ${SUBROOT} (parameterised)")
    endforeach()
    if(TEST_MODULES_LIST)
        message(STATUS "\tWill Include ${NUM_MODULES} Modules: ")
        foreach(MODULE ${TEST_MODULES_LIST})
            message(STATUS "\t  - ${MODULE}")
        endforeach()
    endif()

    set(FORTUTF_PROJECT_TEST_SCRIPT ${CMAKE_CURRENT_BINARY_DIR}/run_tests.f90)

    write_file( ${FORTUTF_PROJECT_TEST_SCRIPT} "! ================================================= " )
    write_file( ${FORTUTF_PROJECT_TEST_SCRIPT} "! This file was automatically generated by FortUTF " APPEND)
    write_file( ${FORTUTF_PROJECT_TEST_SCRIPT} "! please do not modify. " APPEND)
    write_file( ${FORTUTF_PROJECT_TEST_SCRIPT} "! ================================================= " APPEND)
    write_file( ${FORTUTF_PROJECT_TEST_SCRIPT} "PROGRAM TEST_${PROJECT_NAME}" APPEND)
    write_file( ${FORTUTF_PROJECT_TEST_SCRIPT} "    USE FORTUTF" APPEND )
    foreach( TEST_MODULE ${TEST_MODULES_LIST} )
        write_file( ${FORTUTF_PROJECT_TEST_SCRIPT} "    USE ${TEST_MODULE}" APPEND )
    endforeach()
    write_file( ${FORTUTF_PROJECT_TEST_SCRIPT} "    IMPLICIT NONE" APPEND )
    write_file( ${FORTUTF_PROJECT_TEST_SCRIPT} "    CHARACTER(100) :: TEST_ITER_NAME" APPEND )
    write_file( ${FORTUTF_PROJECT_TEST_SCRIPT} "    CHARACTER(100), DIMENSION(:), ALLOCATABLE :: TESTS_TO_RUN" APPEND)
    write_file( ${FORTUTF_PROJECT_TEST_SCRIPT} "    INTEGER :: NUM_ARGS, INDEX, SEARCH" APPEND)
    foreach( LINE ${TEST_DECLARE_LINES})
        write_file( ${FORTUTF_PROJECT_TEST_SCRIPT} "    ${LINE}" APPEND )
    endforeach()


    write_file( ${FORTUTF_PROJECT_TEST_SCRIPT} "    NUM_ARGS = COMMAND_ARGUMENT_COUNT()" APPEND)
    write_file( ${FORTUTF_PROJECT_TEST_SCRIPT} "    SEARCH = 0" APPEND)
    write_file( ${FORTUTF_PROJECT_TEST_SCRIPT} "    ALLOCATE(TESTS_TO_RUN(NUM_ARGS))" APPEND)
    write_file( ${FORTUTF_PROJECT_TEST_SCRIPT} "    IF(NUM_ARGS > 0) THEN" APPEND)
    write_file( ${FORTUTF_PROJECT_TEST_SCRIPT} "        DO INDEX=1, NUM_ARGS" APPEND)
    write_file( ${FORTUTF_PROJECT_TEST_SCRIPT} "            CALL GET_COMMAND_ARGUMENT(INDEX, TESTS_TO_RUN(INDEX))" APPEND)
    write_file( ${FORTUTF_PROJECT_TEST_SCRIPT} "        END DO" APPEND)
    write_file( ${FORTUTF_PROJECT_TEST_SCRIPT} "    ENDIF" APPEND)

    list(LENGTH ITER_LABELS NUM_LABELS)
    list(LENGTH TEST_RUN_LINES NUM_TEST_CASES)

    if(NOT ${NUM_LABELS} EQUAL ${NUM_TEST_CASES})
        message(FATAL_ERROR "Number of test cases did not match number of iteration labels ${NUM_LABELS} != ${NUM_TEST_CASES}")
    endif()

    math(EXPR len2 "${NUM_LABELS} - 1")

    foreach( INDEX RANGE ${len2} )
        list(GET ITER_LABELS ${INDEX} LABEL)
        list(GET TEST_RUN_LINES ${INDEX} RUN_LINES)
        write_file( ${FORTUTF_PROJECT_TEST_SCRIPT} "    IF(NUM_ARGS > 0) THEN" APPEND)
        write_file( ${FORTUTF_PROJECT_TEST_SCRIPT} "        TEST_ITER_NAME = \"${LABEL}\"" APPEND)
        write_file( ${FORTUTF_PROJECT_TEST_SCRIPT} "        SEARCH = GET_INDEX_STRARRAY(TESTS_TO_RUN, TEST_ITER_NAME)" APPEND)
        write_file( ${FORTUTF_PROJECT_TEST_SCRIPT} "    END IF" APPEND)
        write_file( ${FORTUTF_PROJECT_TEST_SCRIPT} "    IF(NUM_ARGS == 0 .OR. SEARCH .NE. 0) THEN" APPEND)
        write_file( ${FORTUTF_PROJECT_TEST_SCRIPT} "        ${RUN_LINES}" APPEND )
        write_file( ${FORTUTF_PROJECT_TEST_SCRIPT} "    END IF" APPEND )
    endforeach()

    write_file( ${FORTUTF_PROJECT_TEST_SCRIPT} "    CALL TEST_SUMMARY" APPEND )
    write_file( ${FORTUTF_PROJECT_TEST_SCRIPT} "END PROGRAM" APPEND )

    if(NOT DEFINED ${FORTUTF})
        set(FORTUTF FortUTF)
    endif()
    if(NOT TARGET ${FORTUTF})
        ADD_LIBRARY(${FORTUTF} ${FORTUTF_SRCS})
    endif()

    add_executable(${PROJECT_NAME}_Tests ${FORTUTF_PROJECT_SRC_FILES} ${TEST_LIST} ${FORTUTF_PROJECT_TEST_SCRIPT})

    target_include_directories(${PROJECT_NAME}_Tests PUBLIC ${Fortran_MODULE_DIRECTORY})

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
