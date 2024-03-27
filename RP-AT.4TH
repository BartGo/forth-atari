
FORTH DEFINITIONS

: (SEGMENT BASE @ DECIMAL ; ( -- n )
: )SEGMENT BASE ! ; ( n -- )

(SEGMENT
	CODE RP@ ( -- ADDR RETURN STACK 1- )
	( from Blazin' Forth )
	  XSAVE STX,
	  TSX, TXA, PHA,
	  1 # LDA,
	  XSAVE LDX,
	PUSH JMP,
)SEGMENT

( ***** S0, R0 ***** )
( fig-FORTH_Installation_Manual_May79%20good.pdf )
( REQUIRES: NOTHING )

(SEGMENT
	: S0 TIB 4 - @ ; 
	: R0 TIB 2 - @ ; 
)SEGMENT


( ***** AUGMENTED TRACE ***** )
( https://www.forth.org/fd/FD-V06N5.pdf )
( REQUIRES: RP@, R0 )

(SEGMENT

: UNRAVEL ( -- ) ( BUG ) QUIT
  BEGIN 
  RP@ R0 = 0= WHILE
    R CR .
	R> 2 - @
	NFA ID.
  REPEAT
  QUIT ;
  
)SEGMENT
