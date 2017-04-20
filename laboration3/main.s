.data
list:
	.word	1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 0

printText: .asciz "Factorial %d: %d\n"

.text
.global main
.extern printf


factorial:

PUSH	{lr}

again:
	MOV r1, #1

	CMP r0, #0
	BEQ finish

doFactoring:
	MUL r1, r1, r0
	SUB r0, r0, #1
	CMP r0, #0
	BNE doFactoring

finish:
	MOV r0, r1

POP	{pc}

main:
PUSH	{lr}


	LDR r4, =list

loop:
	LDR r0, [r4]
	CMP r0, #0
	BEQ endProgram

	BL	factorial
	LDR	r1, [r4]
	MOV	r2, r0
	LDR	r0, =printText
	BL	printf

	ADD r4, #4
	BL loop


endProgram:


	/* Return 0 at the end of the program. */
	MOV r0, #0

POP	{pc}
.end

