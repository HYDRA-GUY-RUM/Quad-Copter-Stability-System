.include "nios_macros.s"
.equ ADDR_JP1, 0x10000060			/* Address GPIO JP1 */
.equ RED_LEDS, 0x10000000

.global _start
_start:
	movia r8, ADDR_JP1				/* r8 temporarily holds address of JP1 */
	movia r15, RED_LEDS
	movia r9, 0x07f557ff			/* preset value for the DR */
	stwio r9, 0(r8)
	stwio r9, 4(r8)					/* initialize DIR as well */

	/* SET THRESHOLDS how? */


readSensorOne:
	movia r8, ADDR_JP1				/* r8 temporarily holds address of JP1 */
	movia r11, 0xffff0fff			/* enable sensor 1, keep all motors ON */
	and r9, r9, r11
	movia r11, 0x0000e000
	or r9, r9, r11
	
	stwio r9, 0(r8)
	ldwio r5, 0(r8)					/* check for valid data at sensor 1 */
	srli r5, r5, 13					/* bit 13 equals valid bit for sensor 1 */
	andi r5, r5, 0x1 				/* mask */
	bne r0, r5, readSensorOne		/* check if low indicated polling data at sensor 1 is valid */

	ldwio r10, 0(r8)				/* read sensor 1 value into r10 */
	srli r10, r10, 27
	andi r10, r10, 0x0f

readSensorTwo:
	/* assume r8 has JP1 */
	movia r11, 0xffff0fff			/* enable sensor 2, keep all motors ON */
	and r9, r9, r11
	movia r11, 0x0000b000
	or r9, r9, r11
	
	stwio r9, 0(r8)
	ldwio r5, 0(r8)					/* check for valid data at sensor 2 */
	srli r5, r5, 15					/* bit 15 equals valid bit for sensor 2 */
	andi r5, r5, 0x1 				/* mask */
	bne r0, r5, readSensorTwo		/* check if low indicated polling data at sensor 2 is valid */

	ldwio r12, 0(r8)				/* read sensor 2 value into r12 */
	srli r12, r12, 27
	andi r12, r12, 0x0f
	
	beq r10, r12, readSensorOne
	bgt r10, r12, LEFT_LED
	
RIGHT_LED:
	movia r15, RED_LEDS
	movia r3,0xaaaaa
	stwio r3,0(r15)
	movia	 r9, 0xffffffe        /* motor0 enabled (bit0=0), direction set to forward (bit1=0) */
	stwio	 r9, 0(r8)	
	br readSensorOne
	
LEFT_LED:
	movia r15, RED_LEDS
	movia r3, 0x55555
	stwio r3,0(r15)
	movia	 r9, 0xffffffc        /* motor0 enabled (bit0=0), direction set to forward (bit1=0) */
    stwio	 r9, 0(r8)	
	br readSensorOne