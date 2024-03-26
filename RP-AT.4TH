( ***** TRACE [COLON TRACING] ***** )
( https://www.forth.org/fd/FD-V03N2.pdf p. 58 )
( REQUIRES: NOTHING )

BASE @ DECIMAL : TASK ;
FORTH DEFINITIONS
0 VARIABLE TFLAG
: (TRACE)
  TFLAG @ IF
    CR R 2 - NFA DUP ID.
	C@ 31 AND 32 SWAP - SPACES
	-2 4 DO SP@ I + @
	6 .R
	-2 +LOOP
  THEN ;
: :
  ?EXEC !CSP CURRENT @ CONTEXT ! CREATE
  ' (TRACE) CFA DUP @ HERE 2 - ! , ] ; IMMEDIATE
: TRON 1 TFLAG ! ;
: TROFF 0 TFLAG ! ;
BASE !

( Example:               )
( TRON : ! ! ; : @ @ ;   )
( CR 710 @ 0 710 ! 710 ! )
( CR TROFF FORGET !      )

( ***** RP@ ***** )
( http://forum.6502.org/viewtopic.php?f=9&t=3706&start=53 )
( REQUIRES: 39 LOAD // MULLARKY'S FIG ASSEMBLER )

BASE @ HEX : TASK ;
FORTH DEFINITIONS
CODE RP@ ( -- ADDR RETURN STACK 1- ) ( from Blazin' Forth )
  XSAVE STX,
  TSX, TXA, PHA,
  1 # LDA,
  XSAVE LDX,
PUSH JMP,
BASE !

( ***** S0, R0 ***** )
( fig-FORTH_Installation_Manual_May79%20good.pdf )
( REQUIRES: NOTHING )
BASE @ HEX : TASK ;
1158 CONSTANT S0
1160 CONSTANT R0
BASE !

( ***** AUGMENTED TRACE ***** )
( https://www.forth.org/fd/FD-V06N5.pdf )
( REQUIRES: RP@, R0 )

: UNRAVEL ( -- ) ( BUG ) QUIT
  BEGIN 
  RP@ R0 @ = 0= WHILE
    R> 2 - @
	NFA ID.
  REPEAT
  QUIT ;

( UNRAVEL SPACE ) ( bug )

