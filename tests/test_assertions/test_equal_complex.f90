SUBROUTINE TEST_EQUAL_COMPLEX
    USE FORTUTF
    COMPLEX :: X, Y

    X = CMPLX(1, 2)
    Y = CMPLX(1, 2)

    CALL TAG_TEST("TEST_EQUAL_COMPLEX")

    CALL ASSERT_EQUAL(X, Y)

END SUBROUTINE TEST_EQUAL_COMPLEX

SUBROUTINE TEST_FAIL_EQUAL_COMPLEX
    USE FORTUTF
    COMPLEX :: X, Y

    X = CMPLX(1, 2)
    Y = CMPLX(1, 4)

    CALL TAG_TEST("TEST_FAIL_EQUAL_COMPLEX")

    CALL ASSERT_EQUAL(X, Y)

    CALL RESET_LAST_TEST_STATUS

END SUBROUTINE TEST_FAIL_EQUAL_COMPLEX