( EVALUATE STRINGS )
( IDEA/DRAFT, EARLY VERSION, NOT WORKING!! )

FORTH DEFINITIONS HEX

( SWORD is WORD for strings )
: SWORD ( adr ch -- )
  IN @ + SWAP ENCLOSE
  HERE 22 BLANKS IN +! 
  OVER - >R R HERE C! + 
  HERE 1+ R> CMOVE ;

( -EVAL is -FIND with SWORD )
(       instead of WORD    )
: -EVAL ( adr -- )
  BL SWORD HERE CONTEXT @ @
  (FIND) DUP 0= IF
    DROP HERE LATEST (FIND)
  THEN ;	

( ENINTERPRET is INTERPRET but )
( referring to SWORD and -EVAL )
( and running once, no looping )  
: (EINTERPRET) ( strz -- )
  -EVAL IF
	STATE @ < IF
	  12 ERROR ( exec only )
	ELSE
	  CFA EXECUTE
	THEN
  ELSE
	HERE NUMBER DPL @ 1+
	IF
	  [COMPILE] DLITERAL
	ELSE
	  DROP [COMPILE] LITERAL
	THEN
	?STACK
  THEN ;  

FORTH DEFINITIONS DECIMAL

0 VARIABLE S$ 80 ALLOT 
: S$" ASCII " WORD HERE COUNT S$ OVER
  OVER C! 1+ SWAP CMOVE ; IMMEDIATE
( test )
S$" 1 2 DUP * + . ;S " ( space! )
S$ COUNT TYPE

: SZ! ( a1 -- ) ( cnt->0 convert )
  DUP COUNT ( a1 a1' ct )
  ROT SWAP  ( a1' a1 ct )
  2DUP + >R ( a1' al ct R: al+ct )
  CMOVE     ( R: al+ct )
  0 R> C! ; ( -- )  
  
S$ SZ!
S$ (EINTERPRET)
  
