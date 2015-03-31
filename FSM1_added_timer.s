#r10 is sensor 1 (a)
#r12 is sensor 2 (b)
#r13 is sensor 3 (c)
#r14 is sensor 4 (d)

.equ HALF_A_SEC,  25000000

Start_Timer_1st:
	#START A TIMER
	movia r16, 0x10002000			/* timer regs address */
	stwio r0, 0(r16)					/* clear the timeout bit */
	
	#set up the timer for half a second
	addi r17, r0, lo%(HALF_A_SEC)
	stwio r17, 8(r16)
	addi r17, r0, hi%(HALF_A_SEC)
	stwio r17, 12(r19)

	#start the timer
	movui r17, 4
	stwio r17, 4(r16)

CheckIfAequaltoB:

	beq r10, r12, CheckIfBequaltoC		#if sensor a is equal to sensor b, go to the next state to check if b == c
	bgt r10, r12, MakeAequaltoB			#if sensor a is greater than sensor b, make a equal to b (make motor a slower)
	
	#else  b>a so make b slower

	#CHECK IF 0.5 SECONDS HAS PASSED HERE ALSO
	ldwio r17, 0(r7)
	andi r17, r17, 0x1
	beq r17, r0, Start_Timer_2nd			#CHECK IF HALF A SECOND HAS PASSED. IF IT HAS, GO TO THE NEXT STATE/LOOP, AND START THE NEXT TIMER
	br CheckIfAequaltoB		#ELSE STAY HERE FOR ANOTHER ITERATION
	
MakeAequaltoB:

	#code here for making motor a slower, then branch to CheckIFBequaltoC
	
	ldwio r17, 0(r7)
	andi r17, r17, 0x1
	beq r17, r0, Start_Timer_2nd			#CHECK IF HALF A SECOND HAS PASSED. IF IT HAS, GO TO THE NEXT STATE/LOOP, AND START THE NEXT TIMER
	br CheckIfAequaltoB				#ELSE STAY AT THIS STATE/LOOP THINGY

Start_Timer_2nd:
	#START A TIMER
	movia r16, 0x10002000			/* timer regs address */
	stwio r0, 0(r16)					/* clear the timeout bit */
	
	#set up the timer for half a second
	addi r17, r0, lo%(HALF_A_SEC)
	stwio r17, 8(r16)
	addi r17, r0, hi%(HALF_A_SEC)
	stwio r17, 12(r19)

	#start the timer
	movui r17, 4
	stwio r17, 4(r16)

CheckIfBequaltoC:

	beq r12,r13, CheckifCequaltoD	#if sensor b is equal to sensor c, go check if c == d
	bgt r12,r13, MakeBequaltoC		#take the lower value (C), so make motor b slower
	
	#else c>b so make c slower (change motor code here)
	
	#CHECK IF 0.5 SECONDS HAS PASSED HERE ALSO
	ldwio r17, 0(r7)
	andi r17, r17, 0x1
	beq r17, r0, Start_Timer_3Rd			#CHECK IF HALF A SECOND HAS PASSED. IF IT HAS, GO TO THE NEXT STATE/LOOP, AND START THE NEXT TIMER
	br CheckifCequaltoD
	
MakeBequaltoC:
	#code here to make motor b slower (i.e. match the value of motor c)
	
	ldwio r17, 0(r7)
	andi r17, r17, 0x1
	beq r17, r0, Start_Timer_3rd			#CHECK IF HALF A SECOND HAS PASSED. IF IT HAS, GO TO THE NEXT STATE/LOOP, AND START THE NEXT TIMER
	
	beq r12,r13, MakeAequaltoB			#else if the timer hasn't timed out
	br CheckIfBequaltoC

Start_Timer_3rd:
	#START A TIMER
	movia r16, 0x10002000			/* timer regs address */
	stwio r0, 0(r16)					/* clear the timeout bit */
	
	#set up the timer for half a second
	addi r17, r0, lo%(HALF_A_SEC)
	stwio r17, 8(r16)
	addi r17, r0, hi%(HALF_A_SEC)
	stwio r17, 12(r19)

	#start the timer
	movui r17, 4
	stwio r17, 4(r16)

CheckifCequaltoD:
	beq r13, r14, CheckIfAequalstoB		#go back to the original state where we check again if sensor value a and b are equal
	bgt r13, r14, MakeCequaltoD			#if c is greater than d, then make c equal to d (make motor c slower)
	
	#else d>c so make d slower (write code to slow down motor here)

	#CHECK IF 0.5 SECONDS HAS PASSED HERE ALSO
	ldwio r17, 0(r7)
	andi r17, r17, 0x1
	beq r17, r0, Start_Timer_1st			#CHECK IF HALF A SECOND HAS PASSED. IF IT HAS, GO TO THE NEXT STATE/LOOP, AND START THE NEXT TIMER
	
	br CheckIfCeqaulstoD		#still time left on the clock, stay at this state
	
MakeCequaltoD:
	#write code here to make motor c slower
	
	#CHECK IF 0.5 SECONDS HAS PASSED HERE ALSO
	ldwio r17, 0(r7)
	andi r17, r17, 0x1
	beq r17, r0, Start_Timer_1st			#CHECK IF HALF A SECOND HAS PASSED. IF IT HAS, GO TO THE NEXT STATE/LOOP, AND START THE NEXT TIMER
	
	beq r13, r14, MakeBequaltoC
	br CheckifCequaltoD