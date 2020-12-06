MODULE FUTS_ASSERTIONS
    USE FUTS_SUITE, ONLY: FUTS_PASSED, FUTS_EXIT_CODE, &
            REGISTER_PASSED, REGISTER_FAILED, INFO_STRINGS
    USE FUTS_UTILITIES, ONLY: APPEND_CHAR
    
    IMPLICIT NONE

    CHARACTER(LEN=200), PRIVATE :: INFO

    INTERFACE ASSERT_EQUAL
        MODULE PROCEDURE ASSERT_EQUAL_INT
        MODULE PROCEDURE ASSERT_EQUAL_INT_2BYTE
        MODULE PROCEDURE ASSERT_EQUAL_LOGICAL
        MODULE PROCEDURE ASSERT_EQUAL_REAL_8BYTE
        MODULE PROCEDURE ASSERT_EQUAL_REAL_4BYTE
        MODULE PROCEDURE ASSERT_EQUAL_COMPLEX
        MODULE PROCEDURE ASSERT_EQUAL_CHAR
    END INTERFACE ASSERT_EQUAL

    INTERFACE ASSERT_ALMOST_EQUAL
        MODULE PROCEDURE ASSERT_ALMOST_EQUAL_INT
        MODULE PROCEDURE ASSERT_ALMOST_EQUAL_INT_2BYTE
        MODULE PROCEDURE ASSERT_ALMOST_EQUAL_REAL_8BYTE
        MODULE PROCEDURE ASSERT_ALMOST_EQUAL_REAL_4BYTE
    END INTERFACE ASSERT_ALMOST_EQUAL

    INTERFACE ASSERT_NOT_EQUAL
        MODULE PROCEDURE ASSERT_NOT_EQUAL_INT
        MODULE PROCEDURE ASSERT_NOT_EQUAL_INT_2BYTE
        MODULE PROCEDURE ASSERT_NOT_EQUAL_LOGICAL
        MODULE PROCEDURE ASSERT_NOT_EQUAL_REAL_8BYTE
        MODULE PROCEDURE ASSERT_NOT_EQUAL_REAL_4BYTE
        MODULE PROCEDURE ASSERT_NOT_EQUAL_COMPLEX
        MODULE PROCEDURE ASSERT_NOT_EQUAL_CHAR
    END INTERFACE ASSERT_NOT_EQUAL

    INTERFACE ASSERT_LESS_THAN
        MODULE PROCEDURE ASSERT_LESS_THAN_INT
        MODULE PROCEDURE ASSERT_LESS_THAN_INT_2BYTE
        MODULE PROCEDURE ASSERT_LESS_THAN_REAL_8BYTE
        MODULE PROCEDURE ASSERT_LESS_THAN_REAL_4BYTE
    END INTERFACE ASSERT_LESS_THAN

    INTERFACE ASSERT_LESS_THAN_EQUAL
        MODULE PROCEDURE ASSERT_LESS_THAN_EQUAL_INT
        MODULE PROCEDURE ASSERT_LESS_THAN_EQUAL_INT_2BYTE
        MODULE PROCEDURE ASSERT_LESS_THAN_EQUAL_REAL_8BYTE
        MODULE PROCEDURE ASSERT_LESS_THAN_EQUAL_REAL_4BYTE
    END INTERFACE ASSERT_LESS_THAN_EQUAL

    INTERFACE ASSERT_GREATER_THAN
        MODULE PROCEDURE ASSERT_GREATER_THAN_INT
        MODULE PROCEDURE ASSERT_GREATER_THAN_INT_2BYTE
        MODULE PROCEDURE ASSERT_GREATER_THAN_REAL_8BYTE
        MODULE PROCEDURE ASSERT_GREATER_THAN_REAL_4BYTE
    END INTERFACE ASSERT_GREATER_THAN

    INTERFACE ASSERT_GREATER_THAN_EQUAL
        MODULE PROCEDURE ASSERT_GREATER_THAN_EQUAL_INT
        MODULE PROCEDURE ASSERT_GREATER_THAN_EQUAL_INT_2BYTE
        MODULE PROCEDURE ASSERT_GREATER_THAN_EQUAL_REAL_8BYTE
        MODULE PROCEDURE ASSERT_GREATER_THAN_EQUAL_REAL_4BYTE
    END INTERFACE ASSERT_GREATER_THAN_EQUAL

    INTERFACE ASSERT_IS_REAL
        MODULE PROCEDURE ASSERT_IS_REAL_INT
        MODULE PROCEDURE ASSERT_IS_REAL_INT_2BYTE
        MODULE PROCEDURE ASSERT_IS_REAL_REAL_8BYTE
        MODULE PROCEDURE ASSERT_IS_REAL_REAL_4BYTE
        MODULE PROCEDURE ASSERT_IS_REAL_COMPLEX
        MODULE PROCEDURE ASSERT_IS_REAL_CHAR
        MODULE PROCEDURE ASSERT_IS_REAL_BOOL
    END INTERFACE ASSERT_IS_REAL
    
    CONTAINS

    !-------------------------------------------------------------------------!
    !                                                                         !
    !                          COMPARISON OPERATIONS                          !
    !                                                                         !
    !-------------------------------------------------------------------------!

    !--------------------- EQUIVALENCE: VAR_1 == VAR_2 -----------------------!

    ! - INTEGER
    SUBROUTINE ASSERT_EQUAL_INT(INT_1, INT_2)
        INTEGER, INTENT(IN) :: INT_1, INT_2

        IF(INT_1 == INT_2) THEN
            CALL REGISTER_PASSED
            WRITE(INFO, '(A, I0, A, I0)') "ASSERT_EQUAL: ", INT_1, " == ", INT_2 
        ELSE
            CALL REGISTER_FAILED
            WRITE(INFO, '(A, I0, A, I0)') "ASSERT_EQUAL: ", INT_1, " != ", INT_2 
        END IF   
        INFO_STRINGS = APPEND_CHAR(INFO_STRINGS, TRIM(INFO), LEN(TRIM(INFO)))
    END SUBROUTINE ASSERT_EQUAL_INT

    ! - INTEGER(2)
    SUBROUTINE ASSERT_EQUAL_INT_2BYTE(INT_1, INT_2)
        INTEGER(2), INTENT(IN) :: INT_1, INT_2

        IF(INT_1 == INT_2) THEN
            CALL REGISTER_PASSED
            WRITE(INFO, '(A, F0.5, A, F0.5)') "ASSERT_EQUAL: ", INT_1, " == ", INT_2
        ELSE
            CALL REGISTER_FAILED
            WRITE(INFO, '(A, F0.5, A, F0.5)') "ASSERT_EQUAL: ", INT_1, " != ", INT_2 
        END IF   
    END SUBROUTINE ASSERT_EQUAL_INT_2BYTE

    ! - REAL(8)
    SUBROUTINE ASSERT_EQUAL_REAL_8BYTE(REAL_1, REAL_2)
        REAL(8), INTENT(IN) :: REAL_1, REAL_2

        IF(REAL_1 == REAL_2) THEN
            CALL REGISTER_PASSED
            WRITE(INFO, '(A, F0.5, A, F0.5)') "ASSERT_EQUAL: ", REAL_1, " == ", REAL_2 
        ELSE
            CALL REGISTER_FAILED
            WRITE(INFO, '(A, F0.5, A, F0.5)') "ASSERT_EQUAL: ", REAL_1, " != ", REAL_2 
        END IF
        INFO_STRINGS = APPEND_CHAR(INFO_STRINGS, TRIM(INFO), LEN(TRIM(INFO)))
    END SUBROUTINE ASSERT_EQUAL_REAL_8BYTE

    ! - REAL(4)
    SUBROUTINE ASSERT_EQUAL_REAL_4BYTE(REAL_1, REAL_2)
        REAL(4), INTENT(IN) :: REAL_1, REAL_2

        IF(REAL_1 == REAL_2) THEN
            CALL REGISTER_PASSED
            WRITE(INFO, '(A, F0.5, A, F0.5)') "ASSERT_EQUAL: ", REAL_1, " == ", REAL_2 
        ELSE
            CALL REGISTER_FAILED
            WRITE(INFO, '(A, F0.5, A, F0.5)') "ASSERT_EQUAL: ", REAL_1, " != ", REAL_2 
        END IF   
        INFO_STRINGS = APPEND_CHAR(INFO_STRINGS, TRIM(INFO), LEN(TRIM(INFO)))
    END SUBROUTINE ASSERT_EQUAL_REAL_4BYTE

    ! - COMPLEX
    SUBROUTINE ASSERT_EQUAL_COMPLEX(COMP_1, COMP_2)
        COMPLEX, INTENT(IN) :: COMP_1, COMP_2

        IF(COMP_1 == COMP_2) THEN
            CALL REGISTER_PASSED
            WRITE(INFO, '(A, F0.5, A, F0.5)') "ASSERT_EQUAL: ", COMP_1, " == ", COMP_2 
        ELSE
            CALL REGISTER_FAILED
            WRITE(INFO, '(A, F0.5, A, F0.5)') "ASSERT_EQUAL: ", COMP_1, " != ", COMP_2 
        END IF   
    END SUBROUTINE ASSERT_EQUAL_COMPLEX

    ! - LOGICAL
    SUBROUTINE ASSERT_EQUAL_LOGICAL(BOOL_1, BOOL_2)
        LOGICAL, INTENT(IN) :: BOOL_1, BOOL_2

        IF(BOOL_1 .EQV. BOOL_2) THEN
            CALL REGISTER_PASSED
            WRITE(INFO, '(A, F0.5, A, F0.5)') "ASSERT_EQUAL: ", BOOL_1, " == ", BOOL_2 
        ELSE
            CALL REGISTER_FAILED
            WRITE(INFO, '(A, F0.5, A, F0.5)') "ASSERT_EQUAL: ", BOOL_1, " != ", BOOL_2 
        END IF   
    END SUBROUTINE ASSERT_EQUAL_LOGICAL

    ! - CHARACTER
    SUBROUTINE ASSERT_EQUAL_CHAR(CHAR_1, CHAR_2)
        CHARACTER, INTENT(IN) :: CHAR_1, CHAR_2

        IF(CHAR_1 == CHAR_2) THEN
            CALL REGISTER_PASSED
        ELSE
            CALL REGISTER_FAILED
        END IF   
    END SUBROUTINE ASSERT_EQUAL_CHAR
    
    SUBROUTINE ASSERT_ALMOST_EQUAL_INT(INT_1, INT_2, REL_TOL)
        INTEGER, INTENT(IN) :: INT_1, INT_2
        REAL(8), OPTIONAL :: REL_TOL

        REAL(8) :: TOLERANCE
        LOGICAL PASSES

        IF(PRESENT(REL_TOL)) THEN
            TOLERANCE = REL_TOL
        ELSE
            TOLERANCE = 1D-9
        ENDIF

        PASSES = .FALSE.

        IF(TOLERANCE > 1) THEN
            PASSES = 100*ABS(1D0*INT_1-INT_2)/INT_1 <= TOLERANCE
        ELSE
            PASSES = ABS(1D0*INT_1-INT_2)/INT_1 <= TOLERANCE
        ENDIF

        IF(PASSES) THEN
            CALL REGISTER_PASSED
        ELSE
            CALL REGISTER_FAILED
        ENDIF
    END SUBROUTINE ASSERT_ALMOST_EQUAL_INT

    SUBROUTINE ASSERT_ALMOST_EQUAL_INT_2BYTE(INT_1, INT_2, REL_TOL)
        INTEGER(2), INTENT(IN) :: INT_1, INT_2
        REAL(8), OPTIONAL :: REL_TOL

        REAL(8) :: TOLERANCE
        LOGICAL PASSES

        IF(PRESENT(REL_TOL)) THEN
            TOLERANCE = REL_TOL
        ELSE
            TOLERANCE = 1D-9
        ENDIF

        PASSES = .FALSE.

        IF(TOLERANCE > 1) THEN
            PASSES = 100*ABS(1D0*INT_1-INT_2)/INT_1 <= TOLERANCE
        ELSE
            PASSES = ABS(1D0*INT_1-INT_2)/INT_1 <= TOLERANCE
        ENDIF

        IF(PASSES) THEN
            CALL REGISTER_PASSED
        ELSE
            CALL REGISTER_FAILED
        ENDIF
    END SUBROUTINE ASSERT_ALMOST_EQUAL_INT_2BYTE

    SUBROUTINE ASSERT_ALMOST_EQUAL_REAL_8BYTE(REAL_1, REAL_2, REL_TOL)
        REAL(8), INTENT(IN) :: REAL_1, REAL_2
        REAL(8), OPTIONAL :: REL_TOL

        REAL(8) :: TOLERANCE
        LOGICAL PASSES

        IF(PRESENT(REL_TOL)) THEN
            TOLERANCE = REL_TOL
        ELSE
            TOLERANCE = 1D-9
        ENDIF

        PASSES = .FALSE.

        IF(TOLERANCE > 1) THEN
            PASSES = 100*ABS(REAL_1-REAL_2)/REAL_1 <= TOLERANCE
        ELSE
            PASSES = ABS(REAL_1-REAL_2)/REAL_1 <= TOLERANCE
        ENDIF

        IF(PASSES) THEN
            CALL REGISTER_PASSED
        ELSE
            CALL REGISTER_FAILED
        ENDIF
    END SUBROUTINE ASSERT_ALMOST_EQUAL_REAL_8BYTE

    SUBROUTINE ASSERT_ALMOST_EQUAL_REAL_4BYTE(REAL_1, REAL_2, REL_TOL)
        REAL(4), INTENT(IN) :: REAL_1, REAL_2
        REAL(4), OPTIONAL :: REL_TOL

        REAL(4) :: TOLERANCE
        LOGICAL PASSES

        IF(PRESENT(REL_TOL)) THEN
            TOLERANCE = REL_TOL
        ELSE
            TOLERANCE = 1E-9
        ENDIF

        PASSES = .FALSE.

        IF(TOLERANCE > 1) THEN
            PASSES = 100*ABS(REAL_1-REAL_2)/REAL_1 <= TOLERANCE
        ELSE
            PASSES = ABS(REAL_1-REAL_2)/REAL_1 <= TOLERANCE
        ENDIF

        IF(PASSES) THEN
            CALL REGISTER_PASSED
        ELSE
            CALL REGISTER_FAILED
        ENDIF
    END SUBROUTINE ASSERT_ALMOST_EQUAL_REAL_4BYTE

    SUBROUTINE ASSERT_TRUE(STATEMENT)
        LOGICAL, INTENT(IN) :: STATEMENT

        IF(STATEMENT) THEN
            CALL REGISTER_PASSED
        ELSE
            CALL REGISTER_FAILED
        ENDIF

    END SUBROUTINE ASSERT_TRUE

    SUBROUTINE ASSERT_FALSE(STATEMENT)
        LOGICAL, INTENT(IN) :: STATEMENT

        IF(.NOT. STATEMENT) THEN
            CALL REGISTER_PASSED
        ELSE
            CALL REGISTER_FAILED
        ENDIF

    END SUBROUTINE ASSERT_FALSE

    SUBROUTINE ASSERT_NOT_EQUAL_INT(INT_1, INT_2)
        INTEGER, INTENT(IN) :: INT_1, INT_2      

        IF(INT_1 /= INT_2) THEN
            CALL REGISTER_PASSED
        ELSE
            CALL REGISTER_FAILED
        END IF   
    END SUBROUTINE ASSERT_NOT_EQUAL_INT

    SUBROUTINE ASSERT_NOT_EQUAL_INT_2BYTE(INT_1, INT_2)
        INTEGER(2), INTENT(IN) :: INT_1, INT_2      

        IF(INT_1 /= INT_2) THEN
            CALL REGISTER_PASSED
        ELSE
            CALL REGISTER_FAILED
        END IF   
    END SUBROUTINE ASSERT_NOT_EQUAL_INT_2BYTE

    SUBROUTINE ASSERT_NOT_EQUAL_REAL_8BYTE(REAL_1, REAL_2)
        REAL(8), INTENT(IN) :: REAL_1, REAL_2

        IF(REAL_1 /= REAL_2) THEN
            CALL REGISTER_PASSED
        ELSE
            CALL REGISTER_FAILED
        END IF   
    END SUBROUTINE ASSERT_NOT_EQUAL_REAL_8BYTE

    SUBROUTINE ASSERT_NOT_EQUAL_LOGICAL(BOOL_1, BOOL_2)
        LOGICAL, INTENT(IN) :: BOOL_1, BOOL_2

        IF(BOOL_1 .NEQV. BOOL_2) THEN
            CALL REGISTER_PASSED
        ELSE
            CALL REGISTER_FAILED
        END IF   
    END SUBROUTINE ASSERT_NOT_EQUAL_LOGICAL

    SUBROUTINE ASSERT_NOT_EQUAL_REAL_4BYTE(REAL_1, REAL_2)
        REAL(4), INTENT(IN) :: REAL_1, REAL_2

        IF(REAL_1 /= REAL_2) THEN
            CALL REGISTER_PASSED
        ELSE
            CALL REGISTER_FAILED
        END IF   
    END SUBROUTINE ASSERT_NOT_EQUAL_REAL_4BYTE

    SUBROUTINE ASSERT_NOT_EQUAL_CHAR(CHAR_1, CHAR_2)
        CHARACTER, INTENT(IN) :: CHAR_1, CHAR_2

        IF(CHAR_1 /= CHAR_2) THEN
            CALL REGISTER_PASSED
        ELSE
            CALL REGISTER_FAILED
        END IF   
    END SUBROUTINE ASSERT_NOT_EQUAL_CHAR

    SUBROUTINE ASSERT_NOT_EQUAL_COMPLEX(COMP_1, COMP_2)
        COMPLEX, INTENT(IN) :: COMP_1, COMP_2

        IF(COMP_1 /= COMP_2) THEN
            CALL REGISTER_PASSED
        ELSE
            CALL REGISTER_FAILED
        END IF   
    END SUBROUTINE ASSERT_NOT_EQUAL_COMPLEX

    SUBROUTINE ASSERT_GREATER_THAN_INT(INT_1, INT_2)
        INTEGER, INTENT(IN) :: INT_1, INT_2      

        IF(INT_1 > INT_2) THEN
            CALL REGISTER_PASSED
        ELSE
            CALL REGISTER_FAILED
        END IF   
    END SUBROUTINE ASSERT_GREATER_THAN_INT

    SUBROUTINE ASSERT_GREATER_THAN_INT_2BYTE(INT_1, INT_2)
        INTEGER(2), INTENT(IN) :: INT_1, INT_2      

        IF(INT_1 > INT_2) THEN
            CALL REGISTER_PASSED
        ELSE
            CALL REGISTER_FAILED
        END IF   
    END SUBROUTINE ASSERT_GREATER_THAN_INT_2BYTE

    SUBROUTINE ASSERT_GREATER_THAN_REAL_4BYTE(REAL_1, REAL_2)
        REAL(4), INTENT(IN) :: REAL_1, REAL_2

        IF(REAL_1 > REAL_2) THEN
            CALL REGISTER_PASSED
        ELSE
            CALL REGISTER_FAILED
        END IF   
    END SUBROUTINE ASSERT_GREATER_THAN_REAL_4BYTE

    SUBROUTINE ASSERT_GREATER_THAN_REAL_8BYTE(REAL_1, REAL_2)
        REAL(8), INTENT(IN) :: REAL_1, REAL_2

        IF(REAL_1 > REAL_2) THEN
            CALL REGISTER_PASSED
        ELSE
            CALL REGISTER_FAILED
        END IF   
    END SUBROUTINE ASSERT_GREATER_THAN_REAL_8BYTE

    SUBROUTINE ASSERT_LESS_THAN_INT(INT_1, INT_2)
        INTEGER, INTENT(IN) :: INT_1, INT_2      

        IF(INT_1 < INT_2) THEN
            CALL REGISTER_PASSED
        ELSE
            CALL REGISTER_FAILED
        END IF   
    END SUBROUTINE ASSERT_LESS_THAN_INT

    SUBROUTINE ASSERT_LESS_THAN_INT_2BYTE(INT_1, INT_2)
        INTEGER(2), INTENT(IN) :: INT_1, INT_2      

        IF(INT_1 < INT_2) THEN
            CALL REGISTER_PASSED
        ELSE
            CALL REGISTER_FAILED
        END IF   
    END SUBROUTINE ASSERT_LESS_THAN_INT_2BYTE

    SUBROUTINE ASSERT_LESS_THAN_REAL_8BYTE(REAL_1, REAL_2)
        REAL(8), INTENT(IN) :: REAL_1, REAL_2

        IF(REAL_1 < REAL_2) THEN
            CALL REGISTER_PASSED
        ELSE
            CALL REGISTER_FAILED
        END IF   
    END SUBROUTINE ASSERT_LESS_THAN_REAL_8BYTE

    SUBROUTINE ASSERT_LESS_THAN_REAL_4BYTE(REAL_1, REAL_2)
        REAL(4), INTENT(IN) :: REAL_1, REAL_2

        IF(REAL_1 < REAL_2) THEN
            CALL REGISTER_PASSED
        ELSE
            CALL REGISTER_FAILED
        END IF   
    END SUBROUTINE ASSERT_LESS_THAN_REAL_4BYTE

    SUBROUTINE ASSERT_GREATER_THAN_EQUAL_INT(INT_1, INT_2)
        INTEGER, INTENT(IN) :: INT_1, INT_2      

        IF(INT_1 >= INT_2) THEN
            CALL REGISTER_PASSED
        ELSE
            CALL REGISTER_FAILED
        END IF   
    END SUBROUTINE ASSERT_GREATER_THAN_EQUAL_INT

    SUBROUTINE ASSERT_GREATER_THAN_EQUAL_INT_2BYTE(INT_1, INT_2)
        INTEGER(2), INTENT(IN) :: INT_1, INT_2      

        IF(INT_1 >= INT_2) THEN
            CALL REGISTER_PASSED
        ELSE
            CALL REGISTER_FAILED
        END IF   
    END SUBROUTINE ASSERT_GREATER_THAN_EQUAL_INT_2BYTE

    SUBROUTINE ASSERT_GREATER_THAN_EQUAL_REAL_8BYTE(INT_1, INT_2)
        REAL(8), INTENT(IN) :: INT_1, INT_2      

        IF(INT_1 >= INT_2) THEN
            CALL REGISTER_PASSED
        ELSE
            CALL REGISTER_FAILED
        END IF   
    END SUBROUTINE ASSERT_GREATER_THAN_EQUAL_REAL_8BYTE

    SUBROUTINE ASSERT_GREATER_THAN_EQUAL_REAL_4BYTE(INT_1, INT_2)
        REAL(4), INTENT(IN) :: INT_1, INT_2      

        IF(INT_1 >= INT_2) THEN
            CALL REGISTER_PASSED
        ELSE
            CALL REGISTER_FAILED
        END IF   
    END SUBROUTINE ASSERT_GREATER_THAN_EQUAL_REAL_4BYTE

    SUBROUTINE ASSERT_LESS_THAN_EQUAL_INT(INT_1, INT_2)
        INTEGER, INTENT(IN) :: INT_1, INT_2      

        IF(INT_1 <= INT_2) THEN
            CALL REGISTER_PASSED
        ELSE
            CALL REGISTER_FAILED
        END IF   
    END SUBROUTINE ASSERT_LESS_THAN_EQUAL_INT

    SUBROUTINE ASSERT_LESS_THAN_EQUAL_INT_2BYTE(INT_1, INT_2)
        INTEGER(2), INTENT(IN) :: INT_1, INT_2      

        IF(INT_1 <= INT_2) THEN
            CALL REGISTER_PASSED
        ELSE
            CALL REGISTER_FAILED
        END IF   
    END SUBROUTINE ASSERT_LESS_THAN_EQUAL_INT_2BYTE

    SUBROUTINE ASSERT_LESS_THAN_EQUAL_REAL_4BYTE(REAL_1, REAL_2)
        REAL(4), INTENT(IN) :: REAL_1, REAL_2

        IF(REAL_1 <= REAL_2) THEN
            CALL REGISTER_PASSED
        ELSE
            CALL REGISTER_FAILED
        END IF   
    END SUBROUTINE ASSERT_LESS_THAN_EQUAL_REAL_4BYTE

    SUBROUTINE ASSERT_LESS_THAN_EQUAL_REAL_8BYTE(REAL_1, REAL_2)
        REAL(8), INTENT(IN) :: REAL_1, REAL_2

        IF(REAL_1 <= REAL_2) THEN
            CALL REGISTER_PASSED
        ELSE
            CALL REGISTER_FAILED
        END IF   
    END SUBROUTINE ASSERT_LESS_THAN_EQUAL_REAL_8BYTE

    SUBROUTINE ASSERT_IS_REAL_REAL_4BYTE(REAL_VAR)
        REAL(4), INTENT(IN) :: REAL_VAR
        CALL REGISTER_PASSED
    END SUBROUTINE ASSERT_IS_REAL_REAL_4BYTE

    SUBROUTINE ASSERT_IS_REAL_REAL_8BYTE(REAL_VAR)
        REAL(8), INTENT(IN) :: REAL_VAR
        CALL REGISTER_FAILED
    END SUBROUTINE ASSERT_IS_REAL_REAL_8BYTE

    SUBROUTINE ASSERT_IS_REAL_INT(INT_VAR)
        INTEGER, INTENT(IN) :: INT_VAR
        CALL REGISTER_FAILED
    END SUBROUTINE ASSERT_IS_REAL_INT

    SUBROUTINE ASSERT_IS_REAL_INT_2BYTE(INT_VAR)
        INTEGER(2), INTENT(IN) :: INT_VAR
        CALL REGISTER_FAILED
    END SUBROUTINE ASSERT_IS_REAL_INT_2BYTE

    SUBROUTINE ASSERT_IS_REAL_CHAR(CHAR_VAR)
        CHARACTER(*), INTENT(IN) :: CHAR_VAR
        CALL REGISTER_FAILED
    END SUBROUTINE ASSERT_IS_REAL_CHAR

    SUBROUTINE ASSERT_IS_REAL_BOOL(BOOL_VAR)
        LOGICAL, INTENT(IN) :: BOOL_VAR
        CALL REGISTER_FAILED
    END SUBROUTINE ASSERT_IS_REAL_BOOL

    SUBROUTINE ASSERT_IS_REAL_COMPLEX(COMP_VAR)
        COMPLEX, INTENT(IN) :: COMP_VAR
        CALL REGISTER_FAILED
    END SUBROUTINE ASSERT_IS_REAL_COMPLEX
    
END MODULE
