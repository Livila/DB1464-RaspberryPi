	.data


debugString: .string "eax=%d, ebx=%d"
buf: .space 64

	.text

	.GLOBAL inImage
	.GLOBAL getInt
	.GLOBAL getText
	.GLOBAL getChar
	.GLOBAL getInPos
	.GLOBAL setInPos
	.GLOBAL outImage
	.GLOBAL putInt
	.GLOBAL putText
	.GLOBAL putChar
	.GLOBAL getOutPos
	.GLOBAL setOutPos

inImage:
	//movabsq = flytta imidiet värde
	movabsq $0, %rdx
	movq $buf, %rdi
	movabsq $9223372036854775805, %rsi
	movq stdin, %rdx
	call fgets

//	movl $10, %eax
//	movl $12, %ebx
	movq $debugString, %rdi
	call printf

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
