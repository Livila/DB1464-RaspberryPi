	.data

dbgStr:		.asciz	"Debug: %d\12\0" # \12 = line-feed character. \0 = null character
textFormat:	.asciz	"%d\n\0"
printStr:	.asciz "\0"
bufIn:		.space	64
bufInPos:	.quad	0
bufOut:		.space	64
bufOutPos:	.quad	0
MAXPOS:		.quad	63

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
	mov $0, %rax

	leaq bufIn, %r8 # load buf
	movq bufInPos, %r9 # get bufinPos
	movq bufInPos, %r12 # get bufinPos

	addq %r9, %r8

	movq $1, %r10 # positive

#check if it is  space before
checkIfSpace:
	cmpb $' ', (%r8)
	jne endCheckIfSpace
	incq %r8 # get next char
	incq %r12 # increase bufInPos
	jmp checkIfSpace
endCheckIfSpace:

	cmpb $45, (%r8, 1) # check if char are -
	jne cont
	movq $-1, %r10 # negative

cont:
	cmpb	 $43, (%r8, 1) # check if char is positive
	jne cont1
	incq %r8 # skip the + sign
	incq %r12


cont1:
	cmpq $-1, %r10
	jne checkIfAtEndAndCallInImage
	incq %r8 # skip the - sign
	incq %r12  

#check if the string is to short
checkIfAtEndAndCallInImage:
#check if r8 = \n
	cmpq $10, (%r8, 1)
	jne luuuup

	call inImage
	jmp getInt
	
# check if it is at the end of the buffert
luuuup:
	cmpq $64, %r9
	jne luuup
	call inImage
	jmp getInt

#check if it is  space before is done further up
luuup:


luup:

	
	# Check if it's a number.
	# is the value between ascii 0 and 9
	cmpb $'0', (%r8)
	jl finluup
	cmpb $'9', (%r8)
	jg finluup

	movzbq (%r8), %r9
	# save number
	subq $48, %r9 # convert from ascii to int
	imulq $10, %rax # make space for new number in returnvalue
	add %r9, %rax # add to return value

	incq %r8 # get next char
	incq %r12 # increase bufInPos
	jmp luup
finluup:

# update bufInPos
movq %r12, bufInPos

imulq %r10, %rax # make the value negative if specified

# incq %rsi # say you reed the first character that is not a number


ret

getText:
ret	

#TODO: not tested
getChar:
#get character fom inBuf
	movq $bufOut, %rax
# check if the character is 0
	cmpq $0, %rax
	je inImage
	cmpq $0, %rax
	je getChar
#jump back to start if true and get a new char
#return charactr
ret

getInPos:
movq bufInPos, %rax
ret

setInPos:
#check if lower than 0 and if set to zero
cmp $0, %rdi
jl setToZero
#check if higher thn 64 and if set to 64
cmp $64, %rdi
jg setToMax

setToZero:
	movq $0, %rdi
	jmp setInPosFin
setToMax:
	movq $64, %rdi

setInPosFin:

	movq %rdi, bufInPos
ret

outImage:
	movq $bufOut, %rdi
	call puts

	#move bufOutPos to register
	movq bufOutPos, %rbx

	loopOutImage:

	#move null to current regpos
	movb $0, bufOut(, %rbx, 1)
	#decrease regpos
	decq %rbx
	#check if smaller than 0
	cmpq $0, %rbx
	jg loopOutImage
	movq $0, bufOutPos

	ret
#get int in rdi and put on outBuf and update pos
putInt:
	#convert int to ascii
	#get the lasyt char by dividing with 10 and get the rest

	#	divq S D
	#		Unsigned divide S/D
	#		Quotient stored in %rax
	#		Remainder Stored in %rdx

cmp $-1, %rdi
jg notMinus
movq $-1, %r11
imulq %r11, %rdi
jmp continuePutInt

notMinus:
movq $1, %r11

continuePutInt:

	#how many times to pop
	mov $0, %r8
	#div with 10
	mov $10, %r9

	#outbufPos
	mov bufOutPos, %rbx

	mov %rdi, %rax

loopPutInt:
	#divide rdx:rax by 10
	mov $0, %rdx
	 
	divq %r9
	#save remainder as char
	push %rdx

	#count up pop
	incq %r8

	#if  Quotient == 0 jump to end
	cmpq $0, %rax
	je endPutInt
#TODO: smarter jmp
	jmp loopPutInt

endPutInt:

#if it was minus input a '-' character
cmpq $-1, %r11
jne notMinusSigne
movb $'-', bufOut(, %rbx, 1)
incq %rbx
notMinusSigne:

#pop the latest char
pop %r9

#convert to ascii
addb $48, %r9b
# add char to buf
movb %r9b, bufOut(, %rbx, 1)
#increase bufOutPos
incq %rbx
#decrease r8
decq %r8
#check if r8 == 0
cmpq $0, %r8
jne endPutInt

#null terminated
#movb $0, %r9b
# add char to buf
#movb %r9b, bufOut(, %rbx, 1)

mov %rbx, bufOutPos
	#movq bufOut, %r8
	#addq bufOutPos, %r8
	#movq %rdi, %r8


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

	movq bufOutPos, %rbx
	movb %dil, bufOut(, %rbx, 1)
	incq %rbx
	movq %rbx, bufOutPos

ret

getOutPos:
	movq bufOutPos, %rax
ret

setOutPos:
	movq %rdi, bufOutPos
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
