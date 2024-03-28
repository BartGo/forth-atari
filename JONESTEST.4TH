
( Trying to adapt from Jones Forth to APX )
( E.g. https://github.com/nornagon/jonesforth/blob/master/jonesforth.f )
: DEPTH S0 SP@ - 2 - 2 / ; 
: SLOW WORD -FIND CFA EXECUTE ; ( : DOUBLE DUP + ; 5 SLOW DOUBLE . CR ) ( FIXME )
: CELLS 2 * ;
: :NONAME 0 0 CREATE HERE @ DOCOL , ] ; ( REQ: ASSEMBLER ) ( FIXME )
( :NONAME ." anon word was called" CR ; DUP EXECUTE EXECUTE ) ( FIXME )
: ['] IMMEDIATE	' LIT , ;
: EXCEPTION-MARKER DROP 0 ; ( ? )
: CATCH	SP@ 2 + >R ' EXCEPTION-MARKER 2 + >R EXECUTE ;
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
