SUBROUTINE TEST_ASSERT_LT_PASS_REAL_4BYTE
    USE FORTUTF
    REAL(REAL_KIND_4BYTE) :: Y, X
    X = 10
    Y = 4

    CALL TAG_TEST("TEST_ASSERT_LT_PASS_REAL_4BYTE")

    ! As this test should pass we can leave the
    ! exit code for the framework as is

    CALL ASSERT_LESS_THAN(Y, X)

END SUBROUTINE TEST_ASSERT_LT_PASS_REAL_4BYTE

SUBROUTINE TEST_ASSERT_LT_PASS_REAL_8BYTE
    USE FORTUTF
    REAL(REAL_KIND_8BYTE) :: Y, X
    X = 10
    Y = 4

    CALL TAG_TEST("TEST_ASSERT_LT_PASS_REAL_8BYTE")

    ! As this test should pass we can leave the
    ! exit code for the framework as is

    CALL ASSERT_LESS_THAN(Y, X)

END SUBROUTINE TEST_ASSERT_LT_PASS_REAL_8BYTE

SUBROUTINE TEST_ASSERT_LT_FAIL_REAL_4BYTE
    USE FORTUTF
    REAL(REAL_KIND_4BYTE) :: Y, X
    X = 1
    Y = 4

    CALL TAG_TEST("TEST_ASSERT_LT_FAIL_REAL_4BYTE")

    CALL ASSERT_LESS_THAN(Y, X)

    CALL RESET_LAST_TEST_STATUS

END SUBROUTINE TEST_ASSERT_LT_FAIL_REAL_4BYTE

SUBROUTINE TEST_ASSERT_LT_FAIL_REAL_8BYTE
    USE FORTUTF
    REAL(REAL_KIND_8BYTE) :: Y, X
    X = 1
    Y = 4

    CALL TAG_TEST("TEST_ASSERT_LT_FAIL_REAL_8BYTE")

    CALL ASSERT_LESS_THAN(Y, X)

    CALL RESET_LAST_TEST_STATUS

END SUBROUTINE TEST_ASSERT_LT_FAIL_REAL_8BYTE