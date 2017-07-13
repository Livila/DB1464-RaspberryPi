	.data

dbgStr:	.asciz	"Debug: %d\12\0" # \12 = line-feed character. \0 = null character
buf:	.space	64
bufPos:	.quad	0

	.text
	.global inImage
	.global getInt
	.global getText
	.global getChar
	.global getInPos
	.global setInPos
	.global outImage
	.global putInt
	.global putText
	.global putChar
	.global getOutPos
	.global setOutPos

inImage:
	movq $buf, %rdi
	movq $64, %rsi
	movq stdin, %rdx
	movq $0, bufPos
	call fgets

	movq $0, %rax
	movq $dbgStr, %rdi
	movq $buf, %rdx

	call printf

#	//movabsq = flytta imidiet värde
#	movabsq $0, %rdx
#	movq $buf, %rdi
#	movabsq $9223372036854775805, %rsi
#	movq stdin, %rdx
#	call fgets
#
#//	movl $10, %eax
#//	movl $12, %ebx
#	movq $dbgStr, %rdi
#	call printf




ret


getInt:


getText:


getChar:


getInPos:


setInPos:


outImage:


putInt:


putText:


putChar:


getOutPos:


setOutPos:
