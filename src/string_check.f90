MODULE FTF_STRING_CHECK
    USE FUTF_SUITE, ONLY: REGISTER_FAILED, REGISTER_PASSED, INFO_STRINGS
    USE FUTF_UTILITIES, ONLY: APPEND_CHAR
    IMPLICIT NONE

    CHARACTER(LEN=300), PRIVATE :: INFO

    CONTAINS

    SUBROUTINE STRING_CONTAINS(INPUT_STRING, PHRASE)
        CHARACTER(*), INTENT(IN) :: INPUT_STRING, PHRASE

        IF(INDEX(INPUT_STRING, TRIM(PHRASE)) .NE. 0) THEN
            CALL REGISTER_PASSED
            WRITE(INFO, '(A, A, A, A)') "STRING_CONTAINS: ", PHRASE, " in ", INPUT_STRING
        ELSE
            CALL REGISTER_FAILED
            WRITE(INFO, '(A, A, A, A)') "STRING_CONTAINS: ", PHRASE, " not in ", INPUT_STRING
        END IF
        INFO_STRINGS = APPEND_CHAR(INFO_STRINGS, INFO, LEN(INFO))
    END SUBROUTINE STRING_CONTAINS

    SUBROUTINE STRING_HAS_SUFFIX(INPUT_STRING, SUFFIX)
        CHARACTER(*), INTENT(IN) :: INPUT_STRING, SUFFIX
        INTEGER :: SUFFIX_LEN, PHRASE_LEN

        PHRASE_LEN = LEN(TRIM(INPUT_STRING))
        SUFFIX_LEN = LEN(TRIM(SUFFIX))

        IF(INPUT_STRING(PHRASE_LEN - SUFFIX_LEN+1:) .EQ. TRIM(SUFFIX)) THEN
            CALL REGISTER_PASSED
            WRITE(INFO, '(A, A, A, A)') "STRING_HAS_SUFFIX: ", INPUT_STRING, " has suffix ", SUFFIX
        ELSE
            CALL REGISTER_FAILED
            WRITE(INFO, '(A, A, A, A)') "STRING_HAS_SUFFIX: ", INPUT_STRING, " doesn't have suffix ", SUFFIX
        END IF
        INFO_STRINGS = APPEND_CHAR(INFO_STRINGS, INFO, LEN(INFO))
    END SUBROUTINE STRING_HAS_SUFFIX

    SUBROUTINE STRING_HAS_PREFIX(INPUT_STRING, PREFIX)
        CHARACTER(*), INTENT(IN) :: INPUT_STRING, PREFIX
        INTEGER :: PREFIX_LEN

        PREFIX_LEN = LEN(TRIM(PREFIX))

        IF(INPUT_STRING(:PREFIX_LEN) .EQ. TRIM(PREFIX)) THEN
            CALL REGISTER_PASSED
            WRITE(INFO, '(A, A, A, A)') "STRING_HAS_SUFFIX: ", INPUT_STRING, " has prefix ", PREFIX
        ELSE
            CALL REGISTER_FAILED
            WRITE(INFO, '(A, A, A, A)') "STRING_HAS_SUFFIX: ", INPUT_STRING, " doesn't have prefix ", PREFIX
        END IF
        INFO_STRINGS = APPEND_CHAR(INFO_STRINGS, INFO, LEN(INFO))
    END SUBROUTINE STRING_HAS_PREFIX
END MODULE FTF_STRING_CHECK
