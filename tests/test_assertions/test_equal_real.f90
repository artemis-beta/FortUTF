SUBROUTINE TEST_ASSERT_EQ_PASS_REAL_4BYTE
    USE FORTUTF
    REAL(4) :: X, Y
    X = 4
    Y = 4

    CALL TAG_TEST("TEST_ASSERT_EQ_PASS_REAL_4BYTE")

    ! As this test should pass we can leave the
    ! exit code for the framework as is

    CALL ASSERT_EQUAL(X, Y)

END SUBROUTINE TEST_ASSERT_EQ_PASS_REAL_4BYTE

SUBROUTINE TEST_ASSERT_EQ_PASS_REAL_8BYTE
    USE FORTUTF
    REAL(8) :: X, Y
    X = 4
    Y = 4

    CALL TAG_TEST("TEST_ASSERT_EQ_PASS_REAL_8BYTE")

    ! As this test should pass we can leave the
    ! exit code for the framework as is

    CALL ASSERT_EQUAL(X, Y)

END SUBROUTINE TEST_ASSERT_EQ_PASS_REAL_8BYTE

