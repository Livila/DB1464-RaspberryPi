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

push %rbx
	lea dbgStr(%rip), %rdi
	mov bufPos, %esi
	xor %eax, %eax

	call printf
pop %rbx

#	//movabsq = flytta imidiet värde
#	movabsq $0, %rdx
#	movq $buf, %rdi
#	movabsq $9223372036854775805, %rsi
#	movq stdin, %rdx
#	call fgets

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
