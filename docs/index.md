---
title: Index Page
summary: Site welcome page.
authors:
    - Kristian Zarebski
date: 2022-08-17
---
# FORTRAN Unit Test Framework

FortUTF is a purely FORTRAN-ic unit test framework compatible with FORTRAN 90 code. It contains a set of subroutines which can be used to check outputs of methods. Note FortUTF makes use of subroutines available in Fortran-2008 so a compatible compiler is required.

FortUTF has been confirmed to work under Linux, macOS and Windows via MSYS.

## How it works

FortUTF is based on the generation of scripts during the configuration stage of a CMake build, as such a version of CMake >= 3.20 is recommended. All test subroutines are added to a generated FORTRAN script along with additional functionality required to handle selection of tests from the command line, visual feedback and correct exit status.
