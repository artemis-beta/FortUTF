# Assertions

Assertions can confirm the properties of a value, or where appropriate, those of all values within an array.

## Comparisons
|**Subroutine**|**Description**|
|----|----|
| `ASSERT_EQUAL(A, B)` | Assert that $A = B$ |
| `ASSERT_NOT_EQUAL(A, B)` | Assert that $A \neq B$ |
|`ASSERT_ALMOST_EQUAL(A, B, REL_TOL=1E-9)` | Assert that $A \approx B$<br>with a given relative tolerance,<br>the default being $10^{-9}$ if not specified|
| `ASSERT_GREATER_THAN(A, B)` | Assert that $A \gt B$ |
| `ASSERT_LESS_THAN(A, B)` | Assert that $A \lt B$ |
| `ASSERT_GREATER_THAN_EQUAL(A, B)` | Assert that $A \geq B$ |
| `ASSERT_LESS_THAN_EQUAL(A, B)` | Assert that $A \leq B$ |

## Logicals
|**Subroutine**|**Description**|
|----|----|
|`ASSERT_TRUE(A)` | Assert that $A$ returns `.TRUE.` |
|`ASSERT_FALSE(A)`| Assert that $A$ returns `.FALSE.`|

## Type Checking
|**Subroutine**|**Description**|
|----|----|
|`ASSERT_IS_REAL(A)` | Assert that $A$ is a `REAL` type |
|`ASSERT_IS_INT(A)` | Assert that $A$ is a `INTEGER` type |
|`ASSERT_IS_CHARACTER(A)` | Assert that $A$ is a `CHARACTER` type |
|`ASSERT_IS_COMPLEX(A)` | Assert that $A$ is a `COMPLEX` type |

## Array Checking
|**Subroutine**|**Description**|
|----|----|
|`ASSERT_ARRAY_CONTAINS(X, A)` | Assert that array $\textbf{X}$ contains $A$|

## Specials
|**Subroutine**|**Description**|
|----|----|
|`FAIL` | Register a failure in a test subroutine|
|`SUCCEED` | Register a pass in a test subroutine|
