CMAKE_MINIMUM_REQUIRED(VERSION 3.12)

set( FORTUTF FortUTF )

PROJECT( ${FORTUTF} VERSION 0.1.1 LANGUAGES Fortran )

FILE(GLOB FUTF_SRCS ${CMAKE_CURRENT_SOURCE_DIR}/src/*.f90)

MESSAGE(STATUS "[Fortran Compiler]")
MESSAGE(STATUS "\tUsing compiler: ${CMAKE_Fortran_COMPILER}")
OPTION(BUILD_TESTS "Build the FortUTF Unit Tests" OFF)
OPTION(BUILD_EXAMPLES "Build the FortUTF Example Project" OFF)

IF(NOT BUILD_TESTS)
    ADD_LIBRARY(${FORTUTF} ${FUTF_SRCS})
    SET_TARGET_PROPERTIES(
        ${FORTUTF}
        PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
    )
    SET_TARGET_PROPERTIES(
        ${FORTUTF}
        PROPERTIES
        Fortran_MODULE_DIRECTORY ${CMAKE_BINARY_DIR}/modules
    )
ENDIF()

IF(BUILD_TESTS)
    SET(CMAKE_Fortran_FLAGS "-Wall -Wextra -Wno-compare-reals -Wno-maybe-uninitialized -Wno-uninitialized -O3 -g -fprofile-arcs -ftest-coverage")
    INCLUDE(${CMAKE_CURRENT_SOURCE_DIR}/cmake/fortutf.cmake)
	SET(FORTUTF_PROJECT_TEST_DIR ${CMAKE_CURRENT_SOURCE_DIR}/tests)
    SET(FORTUTF_PROJECT_SRC_FILES ${FUTF_SRCS})
    LIST(APPEND TEST_LIST ${CMAKE_SOURCE_DIR}/tests/test_suite/unfinished_test_check.f90)
    FortUTF_Find_Tests()
ENDIF()

IF(BUILD_EXAMPLES)
    ADD_SUBDIRECTORY(${CMAKE_CURRENT_SOURCE_DIR}/examples/demo_project)
ENDIF()
