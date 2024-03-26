( BUG!!!!) 

( 39 LOAD )

DECIMAL
FORTH DEFINITIONS FORTH

: .CON CONTEXT @ 4 - NFA ID. ;
: .CUR CURRENT @ 4 - NFA ID. ; 
: .CC CR ." Context, Current: " .CON .CUR CR ;

( RP@ is identical to SP@, but )
( starts with TSX,         /BG )

HEX 
FORTH DEFINITIONS ASSEMBLER

CODE RP@ ( -- ADDR RETURN STACK 1- )
XSAVE STX, TSX, TXA, PHA, 1 # LDA, XSAVE LDX, PUSH JMP, END-CODE

DECIMAL

: TEST 
  SP! RP@ DUP . CR ?
  CR ;
  
