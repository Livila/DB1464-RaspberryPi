.data
list:
	.word	1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 0

printText: .asciz "Factorial: %d\n"

.text
.global main
.extern printf

main:
PUSH	{lr}

	LDR	r0, =printText
	BL	printf





POP	{pc}
.end

