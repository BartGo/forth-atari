HEX
: XH HEX ; : XD DECIMAL ; 
: XLIST 
  BASE @ XD
  CR CR 128 OUT ! CONTEXT @ @ 
  ." NFA  SI WORD CFA-TO \LNK-TO " CR
  ." -----------------------------" CR
  BEGIN
    OUT @ C/L 2 / > 0= IF
      CR 0 OUT !
	THEN
	DUP 4 XH .R SPACE XD
	DUP @ 32 AND IF ." S" ELSE ." -" THEN
	DUP @ 64 AND IF ." I" ELSE ." -" THEN
  	DUP SPACE ID. 
	DUP PFA CFA @ 
        DUP XH 1441 XD = IF
           DROP ." [:] "
        ELSE DUP XH 147D XD = IF
           DROP ." [CONST] "
        ELSE DUP XH 147D XD = IF
           DROP ." [CONST] "
        ELSE DUP XH 14B2 XD = IF
           DROP ." [USER] "
        ELSE XH U. XD THEN THEN THEN THEN 
        DUP PFA LFA @ DUP 0= IF
	  ." \-- " DROP ELSE ." \" ID. THEN
        PFA LFA @ DUP 0= ?TERMINAL OR CR
  UNTIL DROP
  BASE ! ;

XLIST
 
 
 
 
( FIXME )
( : IS-TYPE CFA @ LFA NFA ID. ; )
( ' X IS-TYPE ( -> VARIABLE )
( ' Y IS-TYPE ( -> CONSTANT )
( ' Z IS-TYPE ( -> USER     )
( ' Q IS-TYPE ( -> MYTYPE   )
( ' V IS-TYPE ( -> [COLON]  )
( ' H IS-TYPE ( -> $0000    )
