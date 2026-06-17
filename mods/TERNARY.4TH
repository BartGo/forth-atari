( TERNARY OPERATOR by BartGo )

: ['] [COMPILE] ' ; IMMEDIATE
: ?: ( xt1 xt2 f -- xt ; ternary )
  IF SWAP DROP ELSE DROP THEN ; IMMEDIATE
: ACT ( pfa -- ) CFA EXECUTE ;

;S

( --- TEST & EXAMPLE )
-1 VARIABLE ?CHECK
0 ?CHECK !
20 10
  ['] + ['] - ?CHECK @ ?: ACT  
. ( for check = 0, 20+10 )
1 ?CHECK !
20 10
  ['] + ['] - ?CHECK @ ?: ACT  
. ( for check = 1, 20-10 )


