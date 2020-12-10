SUBROUTINE TEST_ASSERT_LT_PASS_REAL_4BYTE
    USE FORTUTF
    REAL(4) :: Y, X
    X = 10
    Y = 4

    CALL TAG_TEST("TEST_ASSERT_LT_PASS_REAL_4BYTE")

    ! As this test should pass we can leave the
    ! exit code for the framework as is

    CALL ASSERT_LESS_THAN(Y, X)

END SUBROUTINE TEST_ASSERT_LT_PASS_REAL_4BYTE

SUBROUTINE TEST_ASSERT_LT_PASS_REAL_8BYTE
    USE FORTUTF
    REAL(8) :: Y, X
    X = 10
    Y = 4

    CALL TAG_TEST("TEST_ASSERT_LT_PASS_REAL_8BYTE")

    ! As this test should pass we can leave the
    ! exit code for the framework as is

    CALL ASSERT_LESS_THAN(Y, X)

END SUBROUTINE TEST_ASSERT_LT_PASS_REAL_8BYTE