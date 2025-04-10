( FIXME: adapt to APX's )
( QUERY and INTERPRET )

( tracing colon definitions )
( FD-V05N6 )
( another version in FD-V05N2 )
( another version in FD-V10N2 )


( * Tracing colon definition * )
( - shows stack, R and ID. of  )
(   each compiled word         )
( Bruce W. Walker - FDv05n6p10 )
( see also FDv05n2 & FDv10n2   )

1 VARIABLE TRACE : NOP ;
: .S 40 EMIT SPACE SP@ 188 = 0=
  IF SP@ 2 - 186 DO I @ . -2
  +LOOP THEN 41 EMIT SPACE ; 
: ['] [COMPILE] ' ; IMMEDIATE
: (TR) CR ." > " .S R . R 4 - @
  2 + NFA ID. ?TERMINAL IF
  KEY 27 = IF ABORT THEN THEN ;
: TRC CFA , TRACE @ IF ['] (TR)
  CFA , THEN ;
' NOP CFA 7610 ! ( ex: CFA )
' TRC CFA 7612 ! ( ex: ,   )


 ( ----------- )

1 VARIABLE TRACE

: ['] [COMPILE] ' ;

: OUTX 
  BASE @ HEX SWAP 6 .R
  SPACE BASE ! ;

: TRACE.SUB 
  CR SP@ OUTX SP@ 2 - @
  OUTX R OUTX R 4 - @ 2 +
  NFA ID. ?TERMINAL
  IF
    KEY 27 = IF ABORT THEN
  THEN ;

: NINTERPRET
  BEGIN -FIND IF
	STATE @ < IF
	  CFA , TRACE @
	  IF ['] TRACE.SUB CFA , THEN
	ELSE
	  CFA EXECUTE
	THEN
	?STACK
  ELSE
	HERE NUMBER DPL @ 1+
	IF [COMPILE] DLITERAL
	ELSE DROP [COMPILE] LITERAL
	THEN
	?STACK
  THEN AGAIN ;
 

: NQUIT ( RUN WITH TRACING )
  0 BLK ! COMPILE
  BEGIN RP! CR QUERY NINTERPRET
  STATE @ 0= IF PROMPT THEN
  AGAIN ;

( INJECT NINTERPRET )
' NINTERPRET CFA 8844 ! ( LOAD )
( also in debug words ! ) 

( INJECT NQUIT )
' NQUIT CFA 7290 ! ( ERROR )
' NQUIT CFA 7913 ! ( ABORT )
