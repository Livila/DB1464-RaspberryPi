.data
/*
** Variabler här
*/
format: .asciz	"Value: %d\n"	// Formatsträng som i printf()
formatDown: .asciz	"ValueDown: %d\n"	// Formatsträng som i printf()
formatUp: .asciz	"ValueUp: %d\n"	// Formatsträng som i printf()
tmp:   .word	0		// Variabeln tmp initierad till 0

.text
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
PUSH	{r6, r7, lr}


//GPIO_NR till output
	MOV r0, #0 //Reset r0
	LDR r0, =#0xf3200000
	ADD r6, #4
	LDR r0, [r6]
	ORR r0, #8
	STR r0, [r6]		//Tvärtom, alltså r4 till addressen i r8.

// Sätta en GPIO pin till input
	MOV r0, #0
	LDR r0, =#0xf3200000
	ADD r7, #4
	LDR r0, [r7]

	AND r0, #8
	//MOV r0, [r7]
	//AND r0, r7

	STR r0, [r7]

// Sätta en output till högt läge, 1.
	



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
	LDR	r0,=format	// Laddar adressen till format
	LDR	r1,=tmp		// Laddar adressen till tmp
	//LDR	r1,[r4]		// Laddar värdet av tmp
	BL printk


POP	{r6, r7, pc}

/*
** Ta bort åtkomst till GPIO
*/
.GLOBAL setdown
setdown:
	MOV r5, #0
	MOV r4, #0
	MOV r0, #0
	MOV r1, #0

