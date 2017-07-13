	.data

.text
debugString: .asciz "eax=%d, ebx=%d\12\0" // \12 = line-feed character. \0 = null character
buf: .space 64


.GLOBAL inImage
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


.GLOBAL getInt
getInt:


.GLOBAL getText
getText:


.GLOBAL getChar
getChar:


.GLOBAL getInPos
getInPos:


.GLOBAL setInPos
setInPos:


.GLOBAL outImage
outImage:


.GLOBAL putInt
putInt:


.GLOBAL putText
putText:


.GLOBAL putChar
putChar:


.GLOBAL getOutPos
getOutPos:


.GLOBAL setOutPos
setOutPos:
