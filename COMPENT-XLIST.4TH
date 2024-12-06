( XLIST w/ compiled comments )
( shows details on each word )
( and comments - if compiled )
( -- OK with Atari APX Forth )
( by BartGo             2024 ) 

( NOTE: plain DECOMP is not compatible, )
( consider patch from COMPENT code      )
( NOTE: redefining "'(" as "(" for      )
( the "production" version saves memory )

( // is a modified word (.") 
( but instead of printing, keeps
( the string in the dictionary
: // R COUNT DUP 1+ R> + >R
  DROP DROP ;

( '( is a modified version of ."
( but using // instead of (.")
( and used to put the string
( into the dictionary 
: '( STATE @ 0= IF
    ASCII ) WORD ELSE
    COMPILE // ASCII ) WORD HERE
    C@ 1+ ALLOT
  THEN ; IMMEDIATE

( ELIST is VLIST which prints the // comments
: ELIST '( enhanced VLIST: -- )
  CR CONTEXT @ @ BEGIN
    DUP DUP
    PFA @ ' // CFA = IF ( // 1st )
      DUP ID. ." // "
      PFA 2+ COUNT TYPE CR
    ELSE
      ID. SPACE SPACE
    THEN
    PFA LFA @
    DUP 0= ?TERMINAL OR
  UNTIL DROP ; 

FORTH DEFINITIONS HEX
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

 
: TEST '( Drop equivalent: a --) ;
: -ROT '( backrot: a b c -- b c a ) ROT ROT ;
