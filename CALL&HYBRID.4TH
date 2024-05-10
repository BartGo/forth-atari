( * Forth Asm Extensions - Atari 800 XL * )
( - CALL for Atari 8-bit's APX Forth      )
(   David Held, Forth Dimension V/5 p. 22 )
(   David Held, Forth Dimension V/3 p. 23 )
( - HYBRID ASM-FORTH words by J. Bielecki )
(   Jan Bielecki, "Jezyk Forth" WNT 1988  )

FORTH DEFINITIONS ASSEMBLER CODE (CALL)
    XSAVE STX,    0 JSR,
    XSAVE LDX, NEXT JMP,
C; FORTH
  
' (CALL) 3 + CONSTANT CALL-ADDR

: CALL CALL-ADDR ! (CALL) ;

( ** TEST: SELF TEST ** )
( HEX         E471 CALL )



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
