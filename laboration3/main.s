.data
list:
	.word	1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 0

printText: .asciz "Factorial: %d\n"

.text
.global main
.extern printf


factorial:

PUSH	{lr}
/*
again:
	MOV r1, #1

	LDR r2, [r0]

	CMP r2, #0
	BEQ finish
	STR r2, [r0]
	BL factorial

finish:
	MUL r2, r1
	MOV r0, r2
*/

	MOV r0, #3

POP	{pc}

main:
PUSH	{lr}

	MOV	r0, #4
	BL	factorial
	MOV	r1, r0
	LDR	r0, =printText
	BL	printf



	/* Return 0 at the end of the program. */
	MOV r0, #0

POP	{pc}
.end

