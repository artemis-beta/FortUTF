CMAKE_MINIMUM_REQUIRED(VERSION 3.12)

PROJECT(FortUTF)

ENABLE_LANGUAGE(Fortran)

FILE(GLOB FUTF_SRCS ${CMAKE_SOURCE_DIR}/src/*.f90)

IF(NOT CMAKE_Fortran_COMPILER)
    SET(CMAKE_Fortran_COMPILER gfortran)
ENDIF()

MESSAGE(STATUS "[Fortran Compiler]")
MESSAGE(STATUS "\tUsing compiler: ${CMAKE_Fortran_COMPILER}")
OPTION(BUILD_TESTS "Build the FortUTF Unit Tests" OFF)
OPTION(BUILD_EXAMPLES "Build the FortUTF Example Project" OFF)

IF(NOT BUILD_TESTS)
    ADD_LIBRARY(${PROJECT_NAME} ${FUTF_SRCS})
    SET_TARGET_PROPERTIES(
        ${PROJECT_NAME}
        PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
    )
    SET_TARGET_PROPERTIES(
        ${PROJECT_NAME}
        PROPERTIES
        Fortran_MODULE_DIRECTORY ${CMAKE_BINARY_DIR}/modules
    )
ENDIF()

IF(BUILD_TESTS)
    SET(CMAKE_Fortran_FLAGS "-Wall -Wextra -g -fprofile-arcs -ftest-coverage")
    INCLUDE(${CMAKE_SOURCE_DIR}/cmake/fortutf.cmake)
	SET(TEST_DIR ${CMAKE_SOURCE_DIR}/tests)
    SET(SRC_FILES ${FUTF_SRCS})
    LIST(APPEND TEST_LIST ${CMAKE_SOURCE_DIR}/tests/test_no_crash/unfinished_test_check.f90)
    FortUTF_Find_Tests()
ENDIF()

IF(BUILD_EXAMPLES)
    ADD_SUBDIRECTORY(${CMAKE_SOURCE_DIR}/examples/demo_project)
ENDIF()
