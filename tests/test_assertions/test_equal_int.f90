SUBROUTINE TEST_ASSERT_EQ_PASS_INT_1BYTE
    USE FORTUTF
    INTEGER(1) CODE_STATUS, X, Y
    X = 4
    Y = 4
    
    CALL TAG_TEST("TEST_ASSERT_EQ_PASS_INT_4BYTE")

    CODE_STATUS = FUTF_PASSED

    ! As this test should pass we can leave the
    ! exit code for the framework as is

    CALL ASSERT_EQUAL(X, Y)

END SUBROUTINE TEST_ASSERT_EQ_PASS_INT_1BYTE

SUBROUTINE TEST_ASSERT_EQ_PASS_INT_2BYTE
    USE FORTUTF
    INTEGER CODE_STATUS
    INTEGER(2) :: X, Y
    X = 4
    Y = 4
    CODE_STATUS = FUTF_PASSED

    ! As this test should pass we can leave the
    ! exit code for the framework as is

    CALL ASSERT_EQUAL(X, Y)

END SUBROUTINE TEST_ASSERT_EQ_PASS_INT_2BYTE

SUBROUTINE TEST_ASSERT_EQ_PASS_INT_4BYTE
    USE FORTUTF
    INTEGER CODE_STATUS
    INTEGER(4) :: X, Y
    X = 4
    Y = 4
    CODE_STATUS = FUTF_PASSED

    ! As this test should pass we can leave the
    ! exit code for the framework as is

    CALL ASSERT_EQUAL(X, Y)

END SUBROUTINE TEST_ASSERT_EQ_PASS_INT_4BYTE

SUBROUTINE TEST_ASSERT_EQ_PASS_INT_8BYTE
    USE FORTUTF
    INTEGER CODE_STATUS
    INTEGER(8) :: X, Y
    X = 4
    Y = 4
    CODE_STATUS = FUTF_PASSED

    ! As this test should pass we can leave the
    ! exit code for the framework as is

    CALL ASSERT_EQUAL(X, Y)

END SUBROUTINE TEST_ASSERT_EQ_PASS_INT_8BYTE
