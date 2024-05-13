( * Forth Asm Extensions - Atari 800 XL * )

( - HYBRID ASM-FORTH words by J. Bielecki )
(   Jan Bielecki, "Jezyk Forth" WNT 1988  )
( req: CALL )
: SUB ( SUBROUTINE )
  ( optional? ) [COMPILE] ASSEMBLER
  <BUILDS DOES> CALL ;

( The ASSEMBLER vocabulary must be
( invoked before using SUBROUTINE to
( define words. )

: ASM(
  ( ... )
; IMMEDIATE

ASSEMBLER DEFINITIONS
: )FORTH 
  ( ... )
; 

ASSEMBLER DEFINITIONS CODE (NOP)
  NOP, NEXT JMP,
C;

ASSEMBLER DEFINITIONS : FORTH(
  ( ... )
;

FORTH DEFINITIONS : )ASM 
  ( ... )
; IMMEDIATE

;S
