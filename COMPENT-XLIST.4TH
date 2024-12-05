( XLIST compatible w COMPENT )
( shows details on each word )
( and comments - if compiled )
( -- OK with Atari APX Forth )
( by BartGo             2024 ) 

( NOTE: plain DECOMP is not compatible, )
( consider patch from COMPENT code      )
( NOTE: redefining "'(" as "(" for      )
( the "production" version saves memory )

FORTH DEFINITIONS HEX
: TEST '( Drop equivalent: a --) ;
: ['] '( Compile tick: --)
  [COMPILE] ' ;
: XLIST '( Extended VLIST w/ compents: --)
  CR 80 OUT ! CONTEXT @ @ 
  CR ." Context Current: "
  CONTEXT @ 4 - NFA ID.
  CURRENT @ 4 - NFA ID. CR CR
  ." PFA  SI WORD CFA\PFA LNK-TO " CR
  ." ---------------------------" CR
  BEGIN
    OUT @ C/L 2 / > 0= IF CR 0 OUT ! THEN
    DUP PFA 4 .R SPACE 
    DUP @ 20 AND IF ." S" ELSE ." -" THEN
    DUP @ 40 AND IF ." I" ELSE ." -" THEN
    DUP SPACE ID. 
	DUP PFA CFA @ 
           DUP 1441 = IF ." :\"
      ELSE DUP 147D = IF ." CONSTANT\"
      ELSE DUP 1499 = IF ." VARIABLE\"
      ELSE DUP 14B2 = IF ." USER\"
      ELSE DUP 18D8 = IF ." DOES>\"
    THEN THEN THEN THEN THEN
	U.
	DUP PFA LFA @ DUP 0= IF
      ." \-- " DROP ELSE ." \" ID. THEN
	DUP PFA DUP @ [ ' // CFA ] LITERAL = IF
      CR 2+ COUNT TYPE CR 
	ELSE DROP THEN
    PFA LFA @ DUP 0= ?TERMINAL OR CR
  UNTIL DROP ;
DECIMAL

 
