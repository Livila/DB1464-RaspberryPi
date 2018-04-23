	.data

dbgStr:		.asciz	"Debug: %d\12\0" # \12 = line-feed character. \0 = null character
textFormat:	.asciz	"%d\n\0"
printStr:	.asciz "\0"
bufIn:		.space	64
bufInPos:	.quad	0
bufOut:		.space	64
bufOutPos:	.quad	0
MAXPOS:		.quad 64

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
	#	//movabsq = flytta imidiet värde
	movq $bufIn, %rdi			# The stack is set to 16 bytes aligned.
	movabsq $65, %rsi			# Add buf to arg1.
	movq stdin, %rdx			# Read 64-1 symbols, arg2.
								# 	64 bytes chars.
								# 	1 byte \0 to end the buff stream.
	movq $0, bufInPos			# Read from console, arg3.
	call fgets					# Read input from user.

ret


getInt:
	#return val
	mov $0, %rdi

	leaq bufIn, %rcx # load buf
	movq bufInPos, %r9 # get bufinPos
	movq bufInPos, %rsi # get bufinPos
	#imulq $4, %r9 # get first byte to read
			
	movq 0(%rcx), %r8 # get first character to look at

	moveToBufPos:
		movq 4(%rcx), %r8 # get first character to look at
		decq %r9

	

	movq $1, %r10 # positive

	cmpq $'-', (%r8) # check if char are -
	jne cont
	movq $-1, %r10 # negative

cont:
	cmpq $'+', (%r8) # check if char is positive
	jne cont1
	movq 4(%rcx), %r8 # skip the + sign


cont1:
	cmpq $-1, %r10
	jne luup
	movq 4(%rcx), %r8 # skip the - sign


.luup:
	# Check if it's a number.
	# is the value between ascii 0 and 9
	cmpq $'0', (%r8)
	jl finluup
	cmpq $'9', (%r8)
	jg finluup

	# save number
	subq $'0', (%r8) # convert from ascii to int
	imulq $10, %rdi # make space for new number in returnvalue
	add %r8, %rdi # add to return value


	movq 4(%rcx), %r8 # get next char
	incq %rsi # increase bufInPos
	jmp luup
.finluup:

imulq %r10, %rdi # make the value negative if specified

# update bufInPos
movq %rsi, bufInPos

ret

getText:
ret

getChar:
ret

getInPos:
ret

setInPos:
ret

outImage:
	movq $bufOut, %rdi
	call puts

	movq $0, bufOutPos
	movq bufOutPos, %rbx
	movq MAXPOS, %rax
	incq %rax
resetBufLoop:
	cmpq %rax, %rbx
	je end

	movb $0, bufOutPos(, %rbx, 1)
	incq %rbx
	jmp	resetBufLoop
.end:
	movq $0, bufOutPos

	ret

putInt:
ret

putText:
	



# </testPrint>
# <TestPrintBuff>  
	movq 	bufOutPos, %rbx
putTLoop:

	cmpb 	$0, (%rdi)
	je 	finT
	movb 	(%rdi), %al

	movb 	%al, bufOut(, %rbx, 1)

	incq 	%rdi
	incq 	%rbx
	jmp 	putTLoop

finT:
	movq 	%rbx, bufOutPos



	
	
# </TestPrintBuff>
	


# <TestPrintBuff>
	#push %rbx

	
# </TestPrintBuff>

# print


#test

#end testvalue

ret

putChar:
ret

getOutPos:
ret

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
