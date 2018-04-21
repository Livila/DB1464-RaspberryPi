.data
outBuf: .space 64
inBuf:	.space 64
inBufPos: .quad 0
outBufPos:.quad 0
MAXPOS: .quad 63
charTemp: .quad ''
intTemp: .quad 0
	.text
	.global inImage
	.global getInt
	.global getText
	.global getChar
	.global getInPos
	.global setInPos

	.global inBufOut
	.global outImage
	.global putInt
	.global putText
	.global putChar
	.global getOutPos
	.global setOutPos

inImage:
	movq 	$inBuf, %rdi
	movq	$65, %rsi	
	movq 	stdin, %rdx
	movq	$0, inBufPos
	call 	fgets

ret


getInt:
	movq	$inBuf, %rdi
	movq	inBufPos, %rax

        cmpq    MAXPOS, %rax
        je      inImage
        cmpb    $0, (%rdi)
        je      inImage
loop:
	cmpq	$0, %rax
	je	getIntCont
	incq	%rdi
	decq	%rax
	jmp	loop
getIntCont:
	movq	$0, %rax
	movq	$0, %r11	/* Teckenindikator */
lBlancCheck:
	cmpb	$' ', (%rdi)
	jne	lSignPlus
	incq	%rdi
	incq    inBufPos
	jmp	lBlancCheck
lSignPlus:
	cmpb	$'+', (%rdi)
	jne	lSignMinus
	incq	%rdi
	incq    inBufPos
	jmp	lNumber
lSignMinus:
	cmpb	$'-', (%rdi)
	jne	lNumber
	movq	$1, %r11	
/* håll reda på att talet är negativt */
	incq	%rdi
	incq    inBufPos
lNumber:
	cmpb	$'0', (%rdi)
	jl	lNAN
	cmpb	$'9', (%rdi)
	jg	lNAN
	movzbq	(%rdi), %r10
	subq	$'0', %r10
	imulq	$10, %rax
	addq	%r10, %rax
	incq	%rdi
	incq	inBufPos
	jmp	lNumber
lNAN:
	cmpq	$1, %r11
	jne	lEnd
	negq	%rax
lEnd:
	ret


getText:
	movq	inBufPos, %rax
	movq	$inBuf, %rbx
	movq	$1, %rcx
	movq	%rsi, %rdx

	cmpq 	MAXPOS, %rax
	je	inImage
	cmpb	$0, (%rbx)
	je	inImage
getTextLoop:
        cmpq    $0, (%rbx)
        je      finT2
	cmpq	%rcx, %rdx
	je	finT2

        movb   	inBuf(, %rax, 1), %sil
	movb	%sil, (%rdi)

	incq	%rcx
       	incq	%rax
	incq	%rdi
        jmp     getTextLoop

finT2:
      	movq	%rax, inBufPos
	movq	%rcx, %rax
ret


getChar:
	movq    $inBuf, %rdi
        movq    inBufPos, %rax

	cmpq	MAXPOS, %rax
	je	inImage
	cmpb	$0, (%rdi)
	je	inImage
Cloop:
        cmpq    $0, %rax
        je      getCharCont
        incq    %rdi
        decq    %rax
        jmp     Cloop
getCharCont:
	movq	%rdi, %rax
	incq	inBufPos
ret


getInPos:
	movq 	inBufPos, %rax
ret


setInPos:
	cmpq 	MAXPOS, %rdi
	jg 	setInMax
	cmpq 	$0, %rdi
	jl 	setInMin
	movq 	%rdi, inBufPos
	jmp 	finSIP

setInMax:
	movq 	MAXPOS, %rdi
	movq 	%rdi, inBufPos
	jmp 	finSIP

setInMin:
	movq 	$0, inBufPos
	jmp 	finSIP

finSIP:
ret


inBufOut:
	movq	$inBuf, %rdi
	call 	puts
ret

outImage:
	movq 	$outBuf, %rdi
	call 	puts

	movq	$0, outBufPos
	movq	outBufPos, %rbx
	movq	MAXPOS, %rax
	incq	%rax
resetBufLoop:
	cmpq	%rax, %rbx
	je 	finL

	movb	$0, outBuf(, %rbx, 1)
	incq	%rbx
	jmp	resetBufLoop
finL:
	movq	$0, outBufPos
ret

putInt:
	movq    outBufPos, %r10
	movq 	%rdi, %rax
	movq 	$10, %r11
	movq 	$0, %rsi
testL:	
	cmpq	$0, %rax
	jge	divide
	movq	$'-', %rdi
	call	putChar
	negq	%rax
	movq    outBufPos, %r10

divide:
	xorq 	%rdx, %rdx
	idivq 	%r11
	pushq 	%rdx
	incq 	%rsi
	cmpq 	$0, %rax
	jne 	divide

	movq 	$0, %rcx
next_digit:
	popq 	%rax
	addb 	$'0', %al
	movb 	%al, outBuf(, %r10, 1)
	incq	outBufPos
	incq 	%r10
	incq 	%rcx
	cmpq 	%rcx, %rsi
	jne 	next_digit

ret


putText:
/*movq $outBuf, %rbx*/
	movq 	outBufPos, %rbx
putTLoop:
/*movq $outBufPos, %rax*/
	cmpb 	$0, (%rdi)
	je 	finT
	movb 	(%rdi), %al

	movb 	%al, outBuf(, %rbx, 1)

	incq 	%rdi
	incq 	%rbx
	jmp 	putTLoop

finT:
	movq 	%rbx, outBufPos
ret


putChar:
	pushq	%rbx
	pushq	%rax
	movq 	outBufPos, %rbx

	movq	MAXPOS, %rax

	cmpq 	%rbx, %rax
	jne 	contChar
	call 	outImage

contChar:
	movq 	$charTemp, %rax

	movq 	%rdi, (%rax)

	movb 	(%rax), %al

	movb 	%al, outBuf(, %rbx, 1)

	incq 	%rbx
	movq 	%rbx, outBufPos
	popq	%rax
	popq	%rbx
ret	
getOutPos:
	movq 	outBufPos, %rax
ret


setOutPos:
	cmpq 	MAXPOS, %rdi
	jg 	setOutMax
	cmpq 	$0, %rdi
	jl 	setOutMin
	movq 	%rdi, outBufPos
	jmp 	finSOP

setOutMax:
	movq 	MAXPOS, %rdi
	movq 	%rdi, outBufPos
	jmp 	finSOP

setOutMin:
	movq 	$0, outBufPos
	jmp 	finSOP

finSOP:
ret