( Precious words for Atari APX Extended Fig-Forth )

FORTH DEFINITIONS DECIMAL

( ***** S0, R0 ***** )
( fig-FORTH_Installation_Manual_May79%20good.pdf )
( REQUIRES: NOTHING )
: S0 TIB 4 - @ ; 
: R0 TIB 2 - @ ; 

( As written in Jones Forth )
( E.g. https://github.com/nornagon/jonesforth/blob/master/jonesforth.f )
: DEPTH S0 @ SP@ - 2 - ;
: SLOW WORD FIND CFA EXECUTE ;
: CELLS 2 * ;
: :NONAME 0 0 CREATE HERE @	DOCOL ,	] ;
: ['] IMMEDIATE	' LIT , ;
: EXCEPTION-MARKER DROP 0 ; ( ? )
: CATCH	( xt -- exn? )
  SP@ 2 + >R ' EXCEPTION-MARKER 2 + >R	EXECUTE ; ( 2+ or 4+ ? )
: THROW		( n -- )
	?DUP IF
		RP@
    BEGIN	DUP R0 2 - <
		WHILE
			DUP @
			' EXCEPTION-MARKER 2 + = IF
				2 + RP! DUP DUP DUP
				R> 2 -
				SWAP OVER ! SP! EXIT
      THEN
      2 +
		REPEAT
		DROP
		CASE
		  0 1 - OF ." ABORTED" CR	ENDOF
		  ." UNCAUGHT THROW "	DUP . CR
		ENDCASE	QUIT THEN ;
: ABORT	( -- ) 0 1 - THROW ;
: PRINT-STACK-TRACE ( -- )
	RP@
	BEGIN	DUP R0 2 - <
	WHILE
		DUP @
		CASE
		' EXCEPTION-MARKER 2 + OF
			." CATCH ( DSP=" 2 + DUP @ U.	." ) "
		ENDOF
			DUP	CFA ?DUP IF
				2DUP
				ID.
				[ CHAR + ] LITERAL EMIT
				SWAP DFA 2 + - .
			THEN
		ENDCASE
		2 +
	REPEAT
	DROP CR ;

( ******* RP@ ****** )
( from Blazin' Forth )
( REQUIRES: assembler [39 LOAD] )
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
: BREAK 
  CR ." BREAK S= " S. CR ( ." R= " R.N )
  RP@ 4 - RP* ! 0 BLK ! BEGIN
    QUERY INTERPRET ." aok" CR
  AGAIN ; : () BREAK ;
: GO RP@ RP* @ = IF R> DROP R> DROP
  ELSE ." can't resume " QUIT THEN ;

( ***** AUGMENTED TRACE ***** )
( https://www.forth.org/fd/FD-V06N5.pdf )
( REQUIRES: RP@, R0 ) ( FIXME )
: UNRAVEL ( -- ) 
  BEGIN RP@ R0 = 0=
  WHILE
    R CR .
    R> 2 - @
    NFA ID.
  REPEAT
  QUIT ;  
