MODULE FUTS_SUITE
    IMPLICIT NONE

    PUBLIC
    INTEGER :: PASSED = 0 ! Number of Passed Tests
    INTEGER :: TOTAL  = 0 ! Total Number of Tests

    CHARACTER(LEN=100) :: IDENTIFIER ! String for Test Labels

END MODULE