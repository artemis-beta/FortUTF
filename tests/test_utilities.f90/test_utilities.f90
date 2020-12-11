! --------------------------------------------------------------------------- !
!                                                                             !
!                              UTILITIES TESTS                                !
!                                                                             !
! --------------------------------------------------------------------------- !

SUBROUTINE TEST_APPEND_CHAR
    USE FORTUTF

    CHARACTER(LEN=100), DIMENSION(:), ALLOCATABLE :: TEST_ARR
    CHARACTER(LEN=100) :: APPENDEE

    TEST_ARR = (/"HELLO WORLD"/)
    APPENDEE = "TESTING"

    CALL TAG_TEST("TEST_APPEND_CHAR")

    TEST_ARR = APPEND_CHAR(TEST_ARR, APPENDEE, LEN(APPENDEE))

    CALL ASSERT_EQUAL(SIZE(TEST_ARR),  2)

END SUBROUTINE TEST_APPEND_CHAR

SUBROUTINE TEST_APPEND_INT
    USE FORTUTF

    INTEGER, DIMENSION(:), ALLOCATABLE :: TEST_ARR
    INTEGER :: APPENDEE

    TEST_ARR = (/3/)
    APPENDEE = 4

    CALL TAG_TEST("TEST_APPEND_INT")

    TEST_ARR = APPEND_INT(TEST_ARR, APPENDEE)

    CALL ASSERT_EQUAL(SIZE(TEST_ARR),  2)

END SUBROUTINE TEST_APPEND_INT
    