! --------------------------------------------------------------------------- !
!                                                                             !
!                           FIXTURE UNIT TESTS                                !
!                                                                             !
! --------------------------------------------------------------------------- !

RECURSIVE FUNCTION FIBONACCI(X) RESULT(OUT_N)
    INTEGER, INTENT(IN) :: X
    INTEGER :: OUT_N

    IF (X .EQ. 0 .OR. X .EQ. 1) THEN
        OUT_N = X
        RETURN
    ENDIF
    
    OUT_N = FIBONACCI(X - 1) + FIBONACCI(X - 2)
    RETURN
END FUNCTION FIBONACCI

!>SCENARIO(X=0, EXPECT_X=0)
!>SCENARIO(X=1, EXPECT_X=1)
!>SCENARIO(X=6, EXPECT_X=8)
!>SCENARIO(X=8, EXPECT_X=21)
SUBROUTINE TEST_SCENARIO_FIXTURE(X, EXPECT_X)
    USE FORTUTF

    INTEGER(4), INTENT(IN) :: X, EXPECT_X
    INTEGER(4) :: FIBO

    FIBO = FIBONACCI(X)

    CALL TAG_TEST("TEST_SCENARIO_FIXTURE")
    CALL ASSERT_EQUAL(FIBO, EXPECT_X)

END SUBROUTINE TEST_SCENARIO_FIXTURE