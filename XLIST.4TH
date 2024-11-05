( XLIST, an eXtended VLIST )
( tested on APX Forth / A8 )

FORTH DEFINITIONS HEX
: XLIST 
  CR CR 80 OUT ! CONTEXT @ @ 
  ." PFA  SI WORD CFA\PFA LNK-TO " CR
  ." ---------------------------" CR
  BEGIN
    OUT @ C/L 2 / > 0= IF CR 0 OUT ! THEN
    DUP PFA 4 .R SPACE 
    DUP @ 20 AND IF ." S" ELSE ." -" THEN
    DUP @ 40 AND IF ." I" ELSE ." -" THEN
    DUP SPACE ID. 
    DUP PFA CFA @ 
           DUP 1441 = IF ." (:)"
      ELSE DUP 147D = IF ." (CONSTANT)"
      ELSE DUP 1499 = IF ." (VARIABLE)"
      ELSE DUP 14B2 = IF ." (USER)"
      ELSE DUP 18D8 = IF ." (DOES>)"
    THEN THEN THEN THEN THEN
	U.
	DUP PFA LFA @ DUP 0= IF
      ." -- " DROP ELSE ID. THEN
    PFA LFA @ DUP 0= ?TERMINAL OR CR
  UNTIL DROP ;
DECIMAL
