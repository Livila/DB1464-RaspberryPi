
/*
** Variabler här
*/
format: .asciz	"Value: 0x%x\n"	// Formatsträng som i printf()
formatDown: .asciz	"ValueDown: %d\n"	// Formatsträng som i printf()
formatUp: .asciz	"ValueUp: %d\n"	// Formatsträng som i printf()
tmp:   .word	0		// Variabeln tmp initierad till 0
gpio_list:	.word	17, 18, 21, 22, 9, 10 // Array of variables.
gpio_curr_nr:	.word	0
gpio_addr:	.word	0

.text

//Ej testad
/*
short_wait:
	MOV r0, #150
	whileWait:
		ADD r0, r0, #2
		SUB r0, r0, #3
		BNE whileWait
bx lr
	
*/


/*
** Division
*/

idiv:
	/* r0 innehåller N */
	/* r1 innehåller D */
	mov r2, r1
	mov r1, r0
	mov r0, #0
	b .Lloop_check
	.Lloop:
		add r0, r0, #1
		sub r1, r1, r2
	.Lloop_check:
		cmp r1, r2
		bhs .Lloop
	/* r0 innehåller kvoten */
	/* r1 innehåller resten */
	bx lr

/*
** Avbrottsrutin som kallas när ett interrupt sker. Ska räkna uppåt
*/
.GLOBAL counter_isr_up
counter_isr_up:
PUSH	{lr}

	LDR	r0,=formatUp	// Laddar adressen till format
	LDR	r1,=tmp		// Laddar adressen till tmp
	LDR	r1,[r1]		// Laddar värdet av tmp
	BL printk		// Kallar på printk()

POP	{pc}

/*
** Avbrottsrutin som kallas när ett avbrott sker. Ska räkna neråt
*/
.GLOBAL counter_isr_down
counter_isr_down:
PUSH    {lr}

        LDR     r0,=formatDown      // Laddar adressen till format
        LDR     r1,=tmp         // Laddar adressen till tmp
        LDR     r1,[r1]         // Laddar värdet av tmp
        BL printk               // Kallar på printk()

POP     {pc}

/*
 * Sätt upp åtkomst till GPIO-pinnarnas minne
 */
.GLOBAL setup
setup:
PUSH	{r4, r5, r6, lr}
	BL setGPIO_addr

	// Load gpio address
	LDR r5, =gpio_addr
	LDR r5, [r5]

	// Load list of gpio nr
	LDR r4, =gpio_list

loop:
	LDR r0, [r4] // Load value from list
	CMP r0, #9
	BEQ next

	MOV r1, #10 // Divide by 10
	BL idiv // r0 = kvoten, r1 = resten
	MOV r3, #4
	MUL r0, r3
	LDR r0, [r0]
	ADD r2, r0, r5

	MOV r3, #3
	MUL r1, r3
	LSR r1, #1

	LDR r1, [r1]
	ORR r0, r1
	STR r0, [r6]		//Tvärtom, alltså r4 till addressen i r8.


	MOV r1, r0
	LDR	r0, =format	// Laddar adressen till format
	BL printk


	ADD r4, #4
	BL loop
next:
	

//Ej testad
/*
LDR r5, =gpio_addr
LDR r5, [r5]
pullUp:
LDR r0, [r4]
LDR r0, r0	
CMP r0, #0
BEQ awzomeName
	
	ADD r2, r5, #152
	LSL r1, r0, #1
	//Dividera innan LSL
	LDR r1, [r2]  //?
	
	
ADD r4, #4
//wait?
BL pullUp
awzomeName:
*/






//GPIO_NR till output
/*
	MOV r0, #0			//Reset r0
	LDR r0, =#0xf3200000
	ADD r6, #4
	LDR r0, [r6]
	ORR r0, #8
	STR r0, [r6]		//Tvärtom, alltså r4 till addressen i r8.
*/


// Sätta en GPIO pin till input
/*
	MOV r0, #0
	LDR r0, =#0xf3200000
	ADD r7, #4
	LDR r0, [r7]
	AND r0, #8
	STR r0, [r7]
*/


// Sätta en output till högt läge, 1.
/*
	MOV r0, #0
	LDR r0, =#0xf3200000
	ADD r7, #0x1c
	LDR r0, [r7]
	ADD r0, #400
	STR r0, [r7]
*/


// För att sätta en output-pin till lågt läge används följande:
/*
	MOV r0, #0
	LDR r0, =#0xf3200000
	ADD r6, #28
	LDR r0, [r6]
	ADD r0, #0x1c
	STR r0, [r6]
*/




//	STR r2, [r4]
//	MOV r2, #0x1c
//	AND r2, #0x190

	// LDR r2, [r4]
	// LSR r2, #0x1c
	// MOV r2, #0x190
	// STR r1, [r2]





	// ADD r5, r4, #1
	// LSR r5, r5, #4

	// MOV r6, #0x1c

	// LDR r7, [r6]
	// MOV r6, #0x1c
	// LDR r2, [r6], r7



	// LSR r1, #4
	//LDR r1, [r4]


//	ORR r2, r1, #8


	// ORR r1, r7, #190
//	STR r0, r2



// 2^3



/*
	LDR r4, =0x3F200000
	LDR r5, =0x00FFFFFF
	LDR r6, =0x0F000000
	LDR r7, =0xF0000000


	AND r4, r4, r5

	MOV r5, #66
	MOV r4, r5
*/

	//MOV r1, r0
	LDR r1, =gpio_addr
	LDR r1, [r1]

	LDR	r0, =format	// Laddar adressen till format
	//LDR	r1, =tmp		// Laddar adressen till tmp
	//LDR	r1, [r1]		// Laddar värdet av tmp
	BL printk


POP	{r4, r5, r6, pc}

setGPIO_addr:
PUSH {r4, r5, r6, r7, r8, lr}

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


POP {r4, r5, r6, r7, r8, pc}
/*
** Ta bort åtkomst till GPIO
*/
.GLOBAL setdown
setdown:

//Ej testad
//återställer pull up läget
/*
LDR r0, =gpio_addr
LDR r0, [r0]
ADD  r0, #148
MOV r1, #0
LDR  r1, [r0]
SUB r0, #4
LDR r1, [r0]
*/


