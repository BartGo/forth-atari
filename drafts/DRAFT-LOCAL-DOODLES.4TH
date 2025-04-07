( data local to words )
( look ma, no variables )

( to do: manage also bytes and strings )
( ST$ ND$ RD$ TH$ STC NDC RDC THC )



FORTH DEFINITIONS DECIMAL

( an object containing data and method )
: Y ( -- )
  0 IF
    42 250 12 103 7
  THEN
  CR ." METHOD!" CR ;

( data getter / setter )
: #A       ( pfa n -- v )
  >R 6 +   ( hide n and point after "0 IF" )
  R> 4 * + ( offset by n )
  2 + ;    ( but skip LIT )

( unit tests )
' Y 0 #A @ 42  ?PAIRS 
' Y 1 #A @ 250 ?PAIRS
' Y 2 #A @ 12  ?PAIRS
' Y 3 #A @ 103 ?PAIRS
' Y 4 #A @ 7   ?PAIRS

HERE ' Y 0 #A !
' Y 0 #A @ HERE ?PAIRS 

LATEST ' Y 1 #A !
' Y 1 #A @ LATEST ?PAIRS 

Y


: (HOOK) ( latest f -- )
  0 IF 1000 THEN 
  0= IF 
	[ SMUDGE ] ' _HOOK 
 	[ SMUDGE ] 0 #A !
  ELSE 
    DROP [ SMUDGE ] ' _HOOK
	[ SMUDGE ] 0 #A @ DP !
  THEN ;
: _HOOK 0 (HOOK) ; ( latest )
: _UNHOOK 0 1 _HOOK ;  ( -- )

: MARK1 ;
: MARK2 ;

LATEST _HOOK

: X 1 2 . . ; X

_UNHOOK

--------------------

: DATA [COMPILE] 0 [COMPILE] IF ; IMMEDIATE
: END-DATA [COMPILE] THEN ; IMMEDIATE

: Y2 ( -- )
  DATA
    42 250 12 103 7
  END-DATA
  CR ." METHOD!" CR ;



