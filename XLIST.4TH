: XLIST 
  BASE @ DECIMAL
  CR CR 128 OUT ! CONTEXT @ @ 
  ." NFA  SI WORD \LNK-TO (DEF-BY)" CR
  ." -----------------------------" CR
  BEGIN
    OUT @ C/L 2 / > 0= IF
      CR 0 OUT !
	THEN
	DUP HEX 4 .R SPACE DECIMAL
	DUP @ 32 AND IF ." S" ELSE ." -" THEN
	DUP @ 64 AND IF ." I" ELSE ." -" THEN
  	DUP SPACE ID. 
	DUP PFA LFA @ DUP 0= IF
	  ." --" DROP ELSE ." \" ID.
	THEN
	DUP	PFA CFA @ DUP 5185 = 0= IF
	  ." CFA=" HEX U. DECIMAL
	ELSE DROP ." (:) "
	THEN
	PFA LFA @ DUP 0= ?TERMINAL OR
	CR
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
