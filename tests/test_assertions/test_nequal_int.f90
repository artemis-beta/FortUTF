SUBROUTINE TEST_ASSERT_NEQ_PASS_INT_1BYTE
    USE FORTUTF
    INTEGER(1) CODE_STATUS, X, Y
    X = 2
    Y = 4
    
    CALL TAG_TEST("TEST_ASSERT_NEQ_PASS_INT_1BYTE")

    ! As this test should pass we can leave the
    ! exit code for the framework as is

    CALL ASSERT_NOT_EQUAL(X, Y)

END SUBROUTINE TEST_ASSERT_NEQ_PASS_INT_1BYTE

SUBROUTINE TEST_ASSERT_NEQ_PASS_INT_2BYTE
    USE FORTUTF
    INTEGER CODE_STATUS
    INTEGER(2) :: X, Y
    X = 2
    Y = 4

    CALL TAG_TEST("TEST_ASSERT_NEQ_PASS_INT_2BYTE")

    ! As this test should pass we can leave the
    ! exit code for the framework as is

    CALL ASSERT_NOT_EQUAL(X, Y)

END SUBROUTINE TEST_ASSERT_NEQ_PASS_INT_2BYTE

SUBROUTINE TEST_ASSERT_NEQ_PASS_INT_4BYTE
    USE FORTUTF
    INTEGER CODE_STATUS
    INTEGER(4) :: X, Y
    X = 2
    Y = 4

    CALL TAG_TEST("TEST_ASSERT_NEQ_PASS_INT_4BYTE")

    ! As this test should pass we can leave the
    ! exit code for the framework as is

    CALL ASSERT_NOT_EQUAL(X, Y)

END SUBROUTINE TEST_ASSERT_NEQ_PASS_INT_4BYTE

SUBROUTINE TEST_ASSERT_NEQ_PASS_INT_8BYTE
    USE FORTUTF
    INTEGER CODE_STATUS
    INTEGER(8) :: X, Y
    X = 2
    Y = 4

    CALL TAG_TEST("TEST_ASSERT_NEQ_PASS_INT_8BYTE")

    ! As this test should pass we can leave the
    ! exit code for the framework as is

    CALL ASSERT_NOT_EQUAL(X, Y)

END SUBROUTINE TEST_ASSERT_NEQ_PASS_INT_8BYTE
