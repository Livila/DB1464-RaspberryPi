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
	pushq $0
	movq $buf, %rdi				# Add buf to arg1.
	movq $5, %rsi				# Read 64-1 symbols, arg2.
	movq stdin, %rdx			# Read from console, arg3.
	movq $0, bufPos
	call fgets

	movq $buf, %rdi
	call printf

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
	movq bufPos, %rbx

.loop:
	cmpb $0, (%rdi) # Check if there is anything left in the buffer.
	je .end_loop

	movb (%rdi), %al
	movb %al, buf(, %rbx, 1)

	# Check for overflow.
	incq %rdi
	incq %rbx

	jmp .loop

.end_loop:
	movq %rbx, bufPos

ret

putChar:


getOutPos:


setOutPos:
