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

# Usage:
#  movq [value], %rdi
#  call print
print:
push %rbx

#x64
	lea (%rdi), %esi			# Move parameter value to %esi (output).
	lea dbgStr(%rip), %rdi		# Basically mov $dbgStr, %rbx ... mov (%rbx), %rdi
	xor %eax, %eax				# Writing to EAX zero extends to RAX.

#x32
#	mov %rdi, %rsi				# Value to be printed. %rdi contains the value.
#	mov $dbgStr, %rdi			# The text formatting.
#	mov $0, %eax				# Writing to EAX zero extends to RAX.

	call printf
pop %rbx
ret

inImage:
	movq $buf, %rdi
	movq $64, %rsi
	movq stdin, %rdx
	movq $0, bufPos
	call fgets

#       movq $5, %rdi  << This will print out 'Debug: 5'.
	movq buf, %rdi
	call print

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
