.include "nios_macros.s"
.equ ADDR_JP1, 0x10000060			/* Address GPIO JP1 */
.equ RED_LEDS, 0x10000000

/* 
	SensorOne - sensor on the left
	SensorTwo - sensor on the right
*/

.global _start
.global delay_timer
_start:
	movia r8, ADDR_JP1				/* r8 temporarily holds address of JP1 */
	movia r9, 0x07f557ff			/* preset value for the DR */
	stwio r9, 0(r8)
	stwio r9, 4(r8)					/* initialize DIR as well */

	/* SET THRESHOLDS how? */


readSensorOne:
	/* assume r8 has JP1 */
	movia r11, 0xffffefff			/* enable sensor 1, disable all motors */
	stwio r11, 0(r8)
	ldwio r5, 0(r8)					/* check for valid data at sensor 1 */
	srli r5, r5, 13					/* bit 13 equals valid bit for sensor 1 */
	andi r5, r5, 0x1 				/* mask */
	bne r0, r5, readSensorOne		/* check if low indicated polling data at sensor 1 is valid */

	ldwio r10, 0(r8)				/* read sensor 1 value into r10 */
	srli r10, r10, 27
	andi r10, r10, 0x0f

readSensorTwo:
	/* assume r8 has JP1 */
	movia r11, 0xffffbfff			/* enable sensor 2, disable all motors */
	stwio r11, 0(r8)
	ldwio r5, 0(r8)					/* check for valid data at sensor 2 */
	srli r5, r5, 15					/* bit 15 equals valid bit for sensor 2 */
	andi r5, r5, 0x1 				/* mask */
	bne r0, r5, readSensorTwo		/* check if low indicated polling data at sensor 2 is valid */

	ldwio r12, 0(r8)				/* read sensor 2 value into r12 */
	srli r12, r12, 27
	andi r12, r12, 0x0f

	#turn the motors on before comparing
	
	/* compare the values of sensor 1 (r10) and sensor 2 (r12) */
	beq r10, r12, readSensorOne
	bgt r10, r12, motor0turnLeft

	
	#turn one on at a time
motor0turnRight:
	#movia r8, ADDR_JP1				/* r8 temporarily holds address of JP1 */

	#movia r9, 0x07f557ff			/* set direction for motors to all output */
	#stwio r9, 4(r8)

	#movia r9, 0xfffffffe			/* motor0 enabled (bit0 = 0), direction set to backward(bit1 = 1) */
	#stwio r9, 0(r8)
	movia r8, ADDR_JP1				/* r8 temporarily holds address of JP1 */

	movia r9, 0x07f557ff			/* set direction for motors to all output */
	stwio r9, 4(r8)

	movia r9, 0xfffffffc			/* motor0 enabled (bit0 = 0), direction set to backward(bit1 = 1) */
	stwio r9, 0(r8)
	movia r15, RED_LEDS
	movia r3,0xaaaaa
	stwio r3,0(r15)
	br motor0turnOff

motor0turnLeft:
	#movia r8, ADDR_JP1				/* r8 temporarily holds address of JP1 */

	#movia r9, 0x07f557ff			/* set direction for motors to all output */
	#stwio r9, 4(r8)

	#movia r9, 0xfffffffb			/* motor0 enabled (bit0 = 0), direction set to forward(bit1 = 0) */
	#stwio r9, 0(r8)
	movia r8, ADDR_JP1				/* r8 temporarily holds address of JP1 */

	movia r9, 0x07f557ff			/* set direction for motors to all output */
	stwio r9, 4(r8)

	movia r9, 0xfffffff3			/* motor0 enabled (bit0 = 0), direction set to backward(bit1 = 1) */
	stwio r9, 0(r8)
	movia r15, RED_LEDS
	movia r3,0x5555
	stwio r3,0(r15)
	br motor1turnOff
	
motor0turnOff:
	/* call the delay_timer  subroutine HERE and AFTER motor has been turned off */
	addi sp, sp, -4
	stw ra, 0(sp)
	movui r4, 100		/* TIMER PERIOD */
	call delay_timer

	movia r9, 0xfffffffc			/* motor0 disabled (bit0 = 1), direction set to forward(bit1 = 1) */
	stwio r9, 0(r8)
	br readSensorOne

	movui r4, 500		/* TIMER PERIOD */
	call delay_timer
	ldw ra, 0(sp)
	addi sp, sp, 4
	
motor1turnOff:
	/* call the delay_timer  subroutine HERE and AFTER motor has been turned off */
	addi sp, sp, -4
	stw ra, 0(sp)
	movui r4, 100		/* TIMER PERIOD */
	call delay_timer

	movia r9, 0xfffffff3			/* motor0 disabled (bit0 = 1), direction set to forward(bit1 = 1) */
	stwio r9, 0(r8)
	br readSensorOne

	movui r4, 500		/* TIMER PERIOD */
	call delay_timer
	ldw ra, 0(sp)
	addi sp, sp, 4


	/* the motorOff part is only useful if we put in a delay, since we set motor off when we read the sensors */
	/* also storing ADDR_JP1 every time is redundant, so long we dont change r8 */