# FORTRAN Unit Test Framework

A purely FORTRANic framework for testing FORTRAN code

![FortUTF Linux](https://github.com/artemis-beta/FortUTF/workflows/FortUTF%20Linux/badge.svg) ![FortUTF macOS](https://github.com/artemis-beta/FortUTF/workflows/FortUTF%20macOS/badge.svg)

[![codecov](https://codecov.io/gh/artemis-beta/FortUTF/branch/master/graph/badge.svg?token=tIwLkKYQ98)](https://codecov.io/gh/artemis-beta/FortUTF)

## Introduction

FortUTF is Unit Test framework written purely in FORTRAN to be compatible with as many projects as possible. The framework is still in development so documentation is limited, but I promise once it is complete documentation will be a priority. For now I will introduce the basics.


## Writing Tests

All assertions in the current state can be found in the file `src/assertions.f90`. To write a test you only need to create a file containing one a subroutine for each test you wish to run. You can use the available macro script contained within FortUTF which will construct a main script to build and run the tests.

### Example Project

Contained within this repository is an example project which demonstrates usage of the framework in the form:

```bash
demo_project/
├── CMakeLists.txt
├── src
│   └── demo_functions.f90
└── tests
    └── test_functions.f90
```

the functions which we would like to test are contained within the project `src` folder. When building tests it is important that you give this location, or the name of a compiled library to FortUTF using either the variable `SRC_FILES` or `SRC_LIBRARY`, the contents of the `CMakeLists.txt` shows this in practice, and point it to the location of our tests using the `TEST_DIR` variable.

```cmake
CMAKE_MINIMUM_REQUIRED(VERSION 3.12)

PROJECT(DEMO_PROJ)

ENABLE_LANGUAGE(Fortran)

SET(CMAKE_Fortran_COMPILER gfortran)

MESSAGE(STATUS "[FortUTF Example Project Build]")
MESSAGE(STATUS "\tProject Source Directory: ${PROJECT_ROOT}")

GET_FILENAME_COMPONENT(FORTUTF_ROOT ../../ ABSOLUTE)

SET(TEST_DIR ${CMAKE_SOURCE_DIR}/tests)
FILE(GLOB SRC_FILES ${CMAKE_SOURCE_DIR}/src/*.f90)

INCLUDE(${FORTUTF_ROOT}/cmake/fortutf.cmake)
FortUTF_Find_Tests()
```

by including the file `cmake/fortutf.cmake` from within this repository we have access to the `FortUTF_Find_Tests` macro. We can place as many scripts in our `TEST_DIR` location. An example script for this project is:

```fortran
MODULE TEST_DEMO_FUNCTIONS
    USE FORTUTF
    USE DEMO_FUNCTIONS

    CONTAINS
    SUBROUTINE TEST_DEMO_FUNC_1
        USE DEMO_FUNCTIONS, ONLY: DEMO_FUNC_1
        CALL TAG_TEST("TEST_DEMO_FUNC_1")
        CALL ASSERT_EQUAL(DEMO_FUNC_1(10), 95)
    END SUBROUTINE
    SUBROUTINE TEST_DEMO_FUNC_2
        USE DEMO_FUNCTIONS, ONLY: DEMO_FUNC_2
        CALL TAG_TEST("TEST_DEMO_FUNC_2")
        CALL ASSERT_EQUAL(DEMO_FUNC_2(11D0), 32D0)
    END SUBROUTINE
END MODULE TEST_DEMO_FUNCTIONS
```

Firstly we must include the `FORTUTF` module in every test script, then in order for FortUFT to be able to provide labels to any failing tests we tag using the `TAG_TEST` subroutine. Finally we call a test subroutine, and that's it! Including tests within a module is optional.

To build this example we would then just run `cmake` within the project directory:

```bash
cmake -H. -Bbuild
cmake --build build
```

this will create a script `run_tests.f90` in `TEST_DIR` and compile it into a binary.
