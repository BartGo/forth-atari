( Debugging words for Atari APX Extended Fig-Forth )
( Using return stack pointer RP@                   )

FORTH DEFINITIONS DECIMAL

( ***** S0, R0 ***** )
( fig-FORTH_Installation_Manual_May79%20good.pdf )
( REQUIRES: NOTHING )
: S0 TIB 4 - @ ; 
: R0 TIB 2 - @ ; 

( ***** -EXECUTE ***** )
( REQUIRES: NOTHING )
: -EXECUTE -FIND IF DROP CFA EXECUTE THEN ; IMMEDIATE

( ******* RP@ ****** )
( from Blazin' Forth )
( REQUIRES: assembler [39 LOAD] )
( TO DO: machine code version )
CODE RP@ ( -- ADDR RETURN STACK 1- )
  XSAVE STX,
  TSX, TXA, PHA,
  1 # LDA,
  XSAVE LDX,
PUSH JMP,

( **** BREAK&GO **** )
( https://www.forth.org/fd/FD-V05N1.pdf )
( REQUIRES: RP@: S., S.: S0 ) ( TBD: R.N )
0 VARIABLE RP*
: S. SP@ S0 = 0= IF
  SP@ 2 - S0 2 - DO I @ . -2 +LOOP
THEN ;
: R.N RP@ R0 = 0= IF ( TEST ME )
  RP@ 2 - R0 2 - DO I @ U. -2 +LOOP
THEN ;
: BREAK 
  CR ." (BREAK hit, GO to proceed)"
  CR ." S= " S.
  CR ." R= " R.N CR 
  RP@ 4 - RP* ! 0 BLK ! BEGIN
    QUERY INTERPRET ." aok" CR
  AGAIN ; : () BREAK ;
: GO RP@ RP* @ = IF R> DROP R> DROP
  ELSE ." can't resume " QUIT THEN ;

( ***** AUGMENTED TRACE ***** )
( https://www.forth.org/fd/FD-V06N5.pdf )
( REQUIRES: RP@, R0 ) 
: UNRAVEL ( -- ) 
  BEGIN RP@ R0 = 0=
  WHILE
    R CR . R> 2 - @ NFA ID. ( FIX ME )
  REPEAT QUIT ; : (U) UNRAVEL ; 
;S

DEBUGGING TECHNIQUES: pt 1 / UNRAVEL
https://archive.org/details/Forth_Dimension_Volume_06_Number_2/page/n37/mode/2up?q=unravel
DEBUGGING TECHNIQUES: pt 2 / TRACE
https://archive.org/details/Forth_Dimension_Volume_06_Number_3/page/n31/mode/2up?q=unravel
HIGH-LEVEL SINGLE STEPPER
https://archive.org/details/Forth_Dimension_Volume_10_Number_6/page/n14/mode/1up?q=unravel



( TEST UNRAVEL ) ( FIXME: SHORT WORDS )
  : (TEST-UNRAVEL3) (U) ;
  : (TEST-UNRAVEL2) (TEST-UNRAVEL3) ;
  : (TEST-UNRAVEL1) (TEST-UNRAVEL2) ;
: TEST-UNRAVEL (TEST-UNRAVEL1) ;


