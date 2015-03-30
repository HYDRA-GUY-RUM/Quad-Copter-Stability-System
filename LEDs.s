.equ ADDR_REDLEDS, 0x10000000

.global _start

_start:
  movia r2,ADDR_REDLEDS
  movia r3,0xaaaaa
  stwio r3,0(r2)        /* Write to LEDs */