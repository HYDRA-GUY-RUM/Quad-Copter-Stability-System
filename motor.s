 .equ ADDR_JP1, 0x10000060   /*Address GPIO JP1*/
 .global main
 main:
  movia  r8, ADDR_JP1     

  movia  r9, 0x07f557ff        /* set direction for motors to all output */
  stwio  r9, 4(r8)
  
  movia	 r9, 0xffffffe        /* motor0 enabled (bit0=0), direction set to forward (bit1=0) */
  stwio	 r9, 0(r8)	
