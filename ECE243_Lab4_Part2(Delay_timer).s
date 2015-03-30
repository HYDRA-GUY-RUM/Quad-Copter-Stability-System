.global delay_timer

delay_timer:
	/* takes in argument unsigned int N (r4), counts that many cycles and then returns 0 if success */
	movia r7, 0x10002000			/* timer regs address */


	stwio r0, 0(r7)					/* clear the timeout bit */
	stwio r4, 8(r7)					/* set lower period to 50000 */
	stwio r0, 12(r7)				/* set upper period to 0 */

	movui r2, 4						/* start */
	stwio r2, 4(r7)

CHECK_DELAY:
	ldwio r5, 0(r7)
	andi r5, r5, 0x1
	beq r5, r0, CHECK_DELAY			/* if 0, keep waiting */

	stwio r0, 0(r7)					/* clear the timeout bit */
	movi r2, 0
	movi r3, 0
	ret
