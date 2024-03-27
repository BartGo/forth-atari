
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

( **** BREAK&GO **** )
( by Leo Brodie, FD )
( REQUIRES: RP@: S., S.: S0 ) ( TBD: R.N )

(SEGMENT
  0 VARIABLE RP*
  : S. SP@ S0 = 0= IF
    SP@ 2 - S0 2 - DO I @ . -2 +LOOP
  THEN ;
  : BREAK 
    CR ." BREAK S= " S. CR ( ." R= " R.N )
    RP@ 4 - RP* ! 0 BLK ! BEGIN
      QUERY INTERPRET ." aok" CR
    AGAIN ; : () BREAK ;
  : GO RP@ RP* @ = IF R> DROP R> DROP
    ELSE ." can't resume " QUIT THEN ;
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
