( THRU - yet unstable )

: THRU ( n m -- )
  CR 1+ SWAP DO
    BASE @ DECIMAL 
	I ." Loading scr# "
	U. CR BASE !
	I LOAD ?TERMINAL
	IF LEAVE THEN
  LOOP CR ;
' ;S CFA ' --> !

21 26 THRU

( FIXME: words can't span )
( across multiple screens )


( ---- more tests --- )
  
: (-->)  
  ?LOADING 0 IN ! B/SCR BLK @
  OVER MOD - BLK +! ; IMMEDIATE

' ;S CFA ' --> !

: THRU ( n m )
  1+
  BLK @ >R IN @ >R 0 IN !
  CR SWAP DO
    BASE @ DECIMAL 
    I ." Loading #"	U. 
	I B/SCR *
	DUP U. IN @ U. BLK @ U.
	BLK !
	BASE !
	INTERPRET [COMPILE] (-->)
	." - completed." CR 0 IN !
	( ?TERMINAL IF LEAVE THEN )
  LOOP
  CR R> IN ! R> BLK ! ;

( -- Gemini proposal, to be tested )

FORTH DEFINITIONS DECIMAL

89 VARIABLE MAX-SCR

: (THRU-->) ( -- )
  ?LOADING
  BLK @ B/SCR / 1+ MAX-SCR @ > IF
    R> DROP  ( abort current LOAD cleanly )
  ELSE
    0 IN !
    B/SCR BLK @ OVER MOD - BLK +!
    BASE @ DECIMAL
    CR ." Loading scr# " BLK @ B/SCR / U.
    BASE !
  THEN ; IMMEDIATE

: THRU ( n m -- )
  MAX-SCR !
  BASE @ DECIMAL
  CR ." Loading scr# " DUP U.
  BASE !
  LOAD ;

( 81 83 THRU )


   
