	.data

dbgStr:		.asciz	"Debug: %d\12\0" # \12 = line-feed character. \0 = null character
printStr: .asciz "\0"
bufIn:		.space	64
bufInPos:	.quad	0
bufOut:		.space	64
bufOutPos:	.quad	0

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
	pushq $0					# The stack is set to 16 bytes aligned.
	movq $bufIn, %rdi			# Add buf to arg1.
	movq $64, %rsi				# Read 64-1 symbols, arg2.
	movq stdin, %rdx			# Read from console, arg3.
	movq $0, bufInPos
	call fgets

	# Print buffer for testing.
	# movq $bufIn, %rdi
	# call printf

#	//movabsq = flytta imidiet värde
#	movabsq $0, %rdx
#	movq $buf, %rdi
#	movabsq $9223372036854775805, %rsi
#	movq stdin, %rdx
#	call fgets

ret


getInt:
ret

getText:


getChar:


getInPos:


setInPos:


outImage:




# <FELIXTESTAR>

	movq bufOutPos, %rbx
	mov $0, %r8
	movq $bufOut, %rdi

.loop2:
	cmpb $0, (%rdi) # Check if there is anything left in the buffer.
	je .end_loop2

	movb (%rdi), %al
	movb %al, printStr(, %r8, 1)

	# Check for overflow.
	add $4, %rdi
	incq %r8

	jmp .loop2

.end_loop2:
	movq printStr, %rdi
	call printf

# </FELIXTESTAR>

	# cmpq $bufOutPos, %rdi
	# je .end

	# movq $0, bufOutPos

	# movq $bufOut, %rsi
	# mov $0, %eax


	# mov $bufOut, %rbx
	# mov (%rbx), %rdi

	#movq $bufOut, (%rdi)
	#mov $0, %eax

	#call printf


	# movq bufOut, %rdi
	# call print


.end:
	ret

putInt:


putText:

# call print
# ret

	movq bufOutPos, %rbx

.loop:
	cmpb $0, (%rdi) # Check if there is anything left in the buffer.
	je .end_loop

	movb (%rdi), %al
	movb %al, bufOut(, %rbx, 1)

	# Check for overflow.
	add $4, %rdi
	incq %rbx

	jmp .loop

.end_loop:
	movq %rbx, bufOutPos

#test

#end testvalue

ret

putChar:


getOutPos:


setOutPos:
ret



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
