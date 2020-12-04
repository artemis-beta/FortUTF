MODULE FUTS_SUITE
    IMPLICIT NONE

    PUBLIC
    INTEGER :: FUTS_PASSED    = 0 ! Number of FUTS_PASSED Tests
    INTEGER :: FUTS_TOTAL     = 0 ! FUTS_TOTAL Number of Tests
    INTEGER :: FUTS_EXIT_CODE = 0 ! Test Suite Exit Code

    CHARACTER(LEN=100) :: IDENTIFIER ! String for Test Labels

END MODULE