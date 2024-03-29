MODULE FUTF_UTILITIES
    IMPLICIT NONE
    CONTAINS
    FUNCTION APPEND_CHAR(INPUT_ARRAY, ELEMENT, INT_LEN) RESULT(OUTPUT_ARRAY)
        INTEGER, INTENT(IN) :: INT_LEN
        INTEGER :: I, ISIZE
        CHARACTER(LEN=INT_LEN), DIMENSION(:), ALLOCATABLE, INTENT(IN) :: INPUT_ARRAY
        CHARACTER(LEN=INT_LEN), DIMENSION(:), ALLOCATABLE :: OUTPUT_ARRAY
        CHARACTER(LEN=INT_LEN), INTENT(IN) :: ELEMENT

        IF(.NOT. ALLOCATED(INPUT_ARRAY)) THEN
            ALLOCATE(OUTPUT_ARRAY(1))
            OUTPUT_ARRAY(1) = TRIM(ELEMENT)
            RETURN
        ENDIF


        ISIZE = SIZE(INPUT_ARRAY)
        ALLOCATE(OUTPUT_ARRAY(ISIZE+1))

        DO I=1, SIZE(INPUT_ARRAY)
            OUTPUT_ARRAY(I) = TRIM(INPUT_ARRAY(I))
        ENDDO

        OUTPUT_ARRAY(SIZE(OUTPUT_ARRAY)) = TRIM(ELEMENT)

    END FUNCTION APPEND_CHAR

    FUNCTION APPEND_INT(INPUT_ARRAY, ELEMENT) RESULT(OUTPUT_ARRAY)
        INTEGER, DIMENSION(:), ALLOCATABLE, INTENT(IN) :: INPUT_ARRAY
        INTEGER, DIMENSION(:), ALLOCATABLE :: OUTPUT_ARRAY
        INTEGER, INTENT(IN) :: ELEMENT

        IF(.NOT. ALLOCATED(INPUT_ARRAY)) THEN
            ALLOCATE(OUTPUT_ARRAY(1))
            OUTPUT_ARRAY(1) = ELEMENT
        ELSE
            ALLOCATE(OUTPUT_ARRAY(SIZE(INPUT_ARRAY)+1))
            OUTPUT_ARRAY(1:SIZE(INPUT_ARRAY)) = INPUT_ARRAY
            OUTPUT_ARRAY(SIZE(INPUT_ARRAY)+1) = ELEMENT
        ENDIF

    END FUNCTION APPEND_INT

    FUNCTION GET_INDEX_STRARRAY(INPUT_ARRAY, ELEMENT) RESULT(INDEX)
        CHARACTER(*), DIMENSION(:), ALLOCATABLE, INTENT(IN) :: INPUT_ARRAY
        CHARACTER(*), INTENT(IN) :: ELEMENT
        INTEGER :: INDEX

        DO INDEX=1, SIZE(INPUT_ARRAY)
            IF(TRIM(INPUT_ARRAY(INDEX)) == TRIM(ELEMENT)) THEN
                RETURN
            ENDIF
        ENDDO

        INDEX = 0
    END FUNCTION GET_INDEX_STRARRAY
END MODULE
