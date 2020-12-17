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

    TEST_ARR = APPEND_CHAR(TEST_ARR, APPENDEE, LEN(APPENDEE))
    TEST_ARR = APPEND_CHAR(TEST_ARR, APPENDEE, LEN(APPENDEE))

    CALL TAG_TEST("TEST_APPEND_CHAR_SIZE")
    CALL ASSERT_EQUAL(SIZE(TEST_ARR),  3)
    CALL TAG_TEST("TEST_APPEND_CHAR_RETENTION")
    CALL ASSERT_EQUAL(TRIM(TEST_ARR(1)), "HELLO WORLD")

END SUBROUTINE TEST_APPEND_CHAR

SUBROUTINE TEST_APPEND_INT
    USE FORTUTF

    INTEGER, DIMENSION(:), ALLOCATABLE :: TEST_ARR
    INTEGER, DIMENSION(3) :: EXPECTED
    INTEGER :: APPENDEE

    TEST_ARR = (/3/)
    APPENDEE = 4
    EXPECTED = (/3, 4, 4/)

    CALL TAG_TEST("TEST_APPEND_INT_SIZE")

    TEST_ARR = APPEND_INT(TEST_ARR, APPENDEE)
    TEST_ARR = APPEND_INT(TEST_ARR, APPENDEE)

    CALL ASSERT_EQUAL(SIZE(TEST_ARR),  3)

    CALL TAG_TEST("TEST_APPEND_INT_RETENTION")

    CALL ASSERT_EQUAL(TEST_ARR,  EXPECTED)

END SUBROUTINE TEST_APPEND_INT
    