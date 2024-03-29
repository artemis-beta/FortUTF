! --------------------------------------------------------------------------- !
!                                                                             !
!                          TEST UNFINISHED USER METHOD                        !
!                                                                             !
!   Must be run first! This tests that if no assertion has been added to      !
!   a test script, FORTRAN does not crash.                                    !
!                                                                             !
! --------------------------------------------------------------------------- !

SUBROUTINE TEST_UNFINISHED_TEST
    USE FORTUTF

    CALL TAG_TEST("TEST_UNFINISHED_TEST")

    CALL TEST_SUMMARY(.TRUE.)

    CALL SUCCEED

END SUBROUTINE TEST_UNFINISHED_TEST

SUBROUTINE TEST_UNTAGGED_TEST
    USE FORTUTF

    CALL FAIL

    CALL RESET_LAST_TEST_STATUS

END SUBROUTINE TEST_UNTAGGED_TEST
