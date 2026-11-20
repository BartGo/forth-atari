( * 1 * )
(  Thanks to Valpar International )
 for the use of this word. )
: SUB ( -- cc )
  0 VARIABLE -2 ALLOT [COMPILE] ASSEMBLER ?EXEC !CSP ;
( https://www.atarimagazines.com/software/displayfile.php?file=83-09/FORTHASM.4TH )
( use to call small pieces of ASM code - SUB - from another )

;S

( UNTESTED, FAULTY )
( * 2 * )
( another method )
( https://www.forth.org/fd/FD-V05N3.pdf )
FORTH DEFINITIONS ASSEMBLER HEX
CODE (CALL)
    XSAVE STX,    0 JSR,
    XSAVE LDX, NEXT JMP, C;
FORTH DEFINITIONS DECIMAL
: CALL
  [ ' (CALL) 3 + ]
  LITERAL ! (CALL) ;
( create a code subroutine useable either from colon or code definitions. )
: SUBROUTINE  [COMPILE] ASSEMBLER CREATE DOES> CALL ;

SUBROUTINE SUB1 
  NOP, NOP, RTS, C;
: TEST1 SUB1 ;
CODE TEST2
  ' SUB1 CALL ,
  NEXT JMP, C;
;S
