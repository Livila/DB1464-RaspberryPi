.data
/*
** Variabler här
*/
format: .asciz	"Value: 0x%x\n"	// Formatsträng som i printf()
formatDown: .asciz	"LightOff: %d\n"	// Formatsträng som i printf()
formatUp: .asciz	"LightOn: %d\n"	// Formatsträng som i printf()
light: .asciz	"Light: %d\n"
tmp:   .word	0		// Variabeln tmp initierad till 0
gpio_list:	.word	17, 18, 27, 22, 9, 10, 0 // Array of variables.
gpio_addr:	.word	0
curr_nr:	.word	1

.text

/*
** Division
*/

idiv:
	/* r0 innehåller N */
	/* r1 innehåller D */
	MOV r2, r1
	MOV r1, r0
	MOV r0, #0
	B .Lloop_check
	.Lloop:
		ADD r0, r0, #1
		SUB r1, r1, r2
	.Lloop_check:
		CMP r1, r2
		BHS .Lloop
	/* r0 innehåller kvoten */
	/* r1 innehåller resten */
	BX lr

/*
** Short wait
*/
short_wait:
	MOV r0, #150 // :)
whileWait:
	SUB r0, r0, #1
	ADD r0, r0, #1
	SUB r0, r0, #1
	CMP r0, #0
	BNE whileWait
BX lr

/*
** Avbrottsrutin som kallas när ett interrupt sker. Ska räkna uppåt
*/
.GLOBAL counter_isr_up
counter_isr_up:
PUSH	{lr}
	LDR r0, =curr_nr
	LDR r1, [r0]
	ADD r1, #1

	CMP r1, #16
	MOVEQ r1, #1
	STR r1, [r0]

	BL showNr


POP		{pc}

showNr:
PUSH	{r4, r5, lr}

	LDR r4, =gpio_list
setAllDark:
	LDR r0, [r4]
	CMP r0, #9
	BEQ exitSetAllDark

	BL setDark

	ADD r4, #4
	BL setAllDark
exitSetAllDark:

	LDR r3, =curr_nr
	LDR r3, [r3]


PUSH {r0, r1, r2, r3}
	MOV r1, r3
	LDR	r0, =format
	BL printk
POP {r0, r1, r2, r3}


	MOV r5, #0x01
	AND r5, r3, r5
	CMP r5, #1
	MOV r0, #17
	BLEQ setLight


PUSH {r0, r1, r2, r3}
	MOV r1, r5
	LDR	r0, =light
	BL printk
POP {r0, r1, r2, r3}


	MOV r5, #0x02
	AND r5, r3, r5
	CMP r5, #2
	MOV r0, #18
	BLEQ setLight


PUSH {r0, r1, r2, r3}
	MOV r1, r5
	LDR	r0, =light
	BL printk
POP {r0, r1, r2, r3}


	MOV r5, #0x04
	AND r5, r3, r5
	CMP r5, #4
	MOV r0, #27
	BLEQ setLight


PUSH {r0, r1, r2, r3}
	MOV r1, r5
	LDR	r0, =light
	BL printk
POP {r0, r1, r2, r3}


	MOV r5, #0x08
	AND r5, r3, r5
	CMP r5, #8
	MOV r0, #22
	BLEQ setLight


PUSH {r0, r1, r2, r3}
	MOV r1, r5
	LDR	r0, =light
	BL printk
POP {r0, r1, r2, r3}


POP		{r4, r5, pc}

/*
** Avbrottsrutin som kallas när ett avbrott sker. Ska räkna neråt
*/
.GLOBAL counter_isr_down
counter_isr_down:
PUSH	{lr}

	LDR r0, =curr_nr
	LDR r1, [r0]
	SUB r1, #1

	CMP r1, #0
	MOVEQ r1, #15
	STR r1, [r0]

	BL showNr

POP		{pc}

setGPIO_addr:
PUSH	{r4, r5, r6, r7, r8, lr}

	LDR r4, =0x3F200000
	LDR r5, =0x00FFFFFF
	AND r6, r4, r5			// (((addr) & 0x00FFFFFF)

	LDR r5, =0x0F000000
	LSR r4, #4			// (((addr) >> 4)
	AND r7, r4, r5		// ((addr) & 0x00FFFFFF) + (((addr) >> 4)

	ADD r0, r7, r6		//  (((addr) & 0x00FFFFFF) + (((addr) >> 4) &0x0F000000)

	LDR r8, =0xF0000000
	ADD r4, r0, r8		// (((addr) & 0x00FFFFFF) + (((addr) >> 4) &0x0F000000) + 0xF0000000)

	LDR r0, =gpio_addr
	STR r4, [r0]

POP		{r4, r5, r6, r7, r8, pc}

setOutputAndInput:
PUSH	{r4, r5, lr}
	// Load gpio address
	LDR r5, =gpio_addr
	LDR r5, [r5]

	// Load list of gpio nr
	LDR r4, =gpio_list

setOutput:
	LDR r0, [r4] // Load value from list
	CMP r0, #9
	BEQ setInput

	// (gpio_addr + (4*(GPIO_NR/10)))
	MOV r1, #10 // Divide by 10
	BL idiv // r0 = kvoten, r1 = resten

	MOV r3, #4
	MUL r0, r3
	ADD r2, r0, r5

	// (1<<(((GPIO_NR)%10)*3)
	MOV r3, #3
	MUL r1, r1, r3
	MOV r0, #1
	LSL r1, r0, r1

	LDR r3, [r2]
	ORR r3, r3, r1
	STR r3, [r2]		//Tvärtom, från VL till HL


	// Print info
	MOV r1, r3
	LDR	r0, =format
	BL printk


	ADD r4, #4
	BL setOutput

setInput:

	//(gpio_addr + 148) = 2
	ADD r2, r5, #148
	MOV r3, #2
	STR r3, [r2]
	BL short_wait

setPullUp:

	//(gpio_addr + 152) = (1<<(GPIO_NR%32))
	
	CMP r0, #0
	BEQ awzomeName

	ADD r2, r5, #152

	MOV r3, #1
	MOV r1, #32
	BL idiv
	LSL r1, r1, r3

	STR r1, [r2]

	BL short_wait

	ADD r4, #4
	LDR r0, [r4]
	BL setPullUp
awzomeName:
POP	{r4, r5, pc}


setHigh:
PUSH	{r4, r5, lr}

	LDR r5, =gpio_addr
	LDR r5, [r5]
	LDR r4, =gpio_list

setHighLoop:
	LDR r0, [r4]
	CMP r0, #9
	BEQ endHighLoop

	MOV r1, #32
	BL idiv

	ADD r0, #7
	MOV r2, #4
	MUL r0, r2
	ADD r0, r5	// Add gpio address

	MOV r3, #1
	LSL r3, r3, r1

	STR r3, [r0]

PUSH	{r0, r1, r2, r3}
	// Print info
	MOV r1, r3
	LDR	r0, =format
	BL printk
POP		{r0, r1, r2, r3}

	ADD r4, #4
	BL setHighLoop

endHighLoop:

POP		{r4, r5, pc}

setLow:
PUSH	{r4, r5, lr}

	LDR r5, =gpio_addr
	LDR r5, [r5]
	LDR r4, =gpio_list

setLowLoop:
	LDR r0, [r4]
	CMP r0, #9
	BEQ endLowLoop

	MOV r1, #32
	BL idiv

	ADD r0, #10
	MOV r2, #4
	MUL r0, r2
	ADD r0, r5	// Add gpio address

	MOV r3, #1
	LSL r3, r3, r1

	STR r3, [r0]

PUSH	{r0, r1, r2, r3}
	// Print info
	MOV r1, r3
	LDR	r0, =format
	BL printk
POP		{r0, r1, r2, r3}

	ADD r4, #4
	BL setLowLoop

endLowLoop:

POP		{r4, r5, pc}

setLight:
PUSH {r4, r5, r6, r8, lr}

PUSH {r0, r1, r2, r3}
	MOV r1, r0
	LDR	r0, =formatUp
	BL printk
POP {r0, r1, r2, r3}

	LDR r5, =gpio_addr
	LDR r5, [r5]
	MOV r4, r0

	MOV r1, #32
	BL idiv
	ADD r0, r0, #7
	MOV r1, #4
	MUL r0, r1
	ADD r8, r5, r0

	MOV r0, r4
	MOV r1, #32
	BL idiv
	MOV r0, #1
	LSL r6, r0, r1
	STR r6, [r8]

	BL short_wait
POP {r4, r5, r6, r8, pc}

setDark:
PUSH {r4, r5, r6, r8, lr}

PUSH {r0, r1, r2, r3}
	MOV r1, r0
	LDR	r0, =formatDown
	BL printk
POP {r0, r1, r2, r3}
	LDR r5, =gpio_addr
	LDR r5, [r5]
	MOV r4, r0

	MOV r1, #32
	BL idiv
	ADD r0, r0, #10
	MOV r1, #4
	MUL r0, r1
	ADD r8, r5, r0

	MOV r0, r4
	MOV r1, #32
	BL idiv
	MOV r0, #1
	LSL r6, r0, r1
	STR r6, [r8]

	BL short_wait
POP {r4, r5, r6, r8, pc}

/*
 * Sätt upp åtkomst till GPIO-pinnarnas minne
 */
.GLOBAL setup
setup:
PUSH	{lr}
	BL setGPIO_addr
	BL setOutputAndInput
	BL setHigh
	BL showNr
POP		{pc}

/*
** Ta bort åtkomst till GPIO
*/
.GLOBAL setdown
setdown:
PUSH	{lr}
	LDR r0, =gpio_addr
	LDR r0, [r0]

	ADD r0, #148
	MOV r1, #0
	STR r1, [r0]
	ADD r0, #4
	STR r1, [r0]

	BL short_wait

	BL setLow
POP		{pc}