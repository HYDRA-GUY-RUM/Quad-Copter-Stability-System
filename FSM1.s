%r10 is sensor 1 (a)
%r12 is sensor 2 (b)
%r13 is sensor 3 (c)
%r14 is sensor 4 (d)

CheckIfAequaltoB:
	beq r10, r12, CheckIfBequaltoC		%if sensor a is equal to sensor b, go to the next state to check if b == c
	bgt r10, r12, MakeAequaltoB			%if sensor a is greater than sensor b, make a equal to b (make motor a slower)
	
	%else  b>a so make b slower
	br CheckIfBequalstoC
	
MakeAequaltoB:
	%code here for making motor a slower, then branch to CheckIFBequaltoC
	
	br CheckIfAequaltoB
	
CheckIfBequaltoC:
	beq r12,r13, CheckifCequaltoD	%if sensor b is equal to sensor c, go check if c == d
	bgt r12,r13, MakeBequaltoC		%take the lower value (C), so make motor b slower
	
	%else c>b so make c slower (change motor code here)
	br CheckifCequaltoD
	
MakeBequaltoC:
	%code here to make motor b slower (i.e. match the value of motor c)
	
	beq r12,r13, MakeAequaltoB
	br CheckIfBequaltoC

CheckifCequaltoD:
	beq r13, r14, CheckIfAequalstoB		%go back to the original state where we check again if sensor value a and b are equal
	bgt r13, r14, MakeCequaltoD			%if c is greater than d, then make c equal to d (make motor c slower)
	
	%else d>c so make d slower (write code to slow down motor here)
	br CheckIfAeqaulstoB
	
MakeCequaltoD:
	%write code here to make motor c slower
	
	beq r13, r14, MakeBequaltoC
	br CheckifCequaltoD