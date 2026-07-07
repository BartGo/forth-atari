( Algebraic Expression Evaluation in FORTH )
(   by Michael Stolovitz - - 30 Nov 1982   )
( implemented for unidentified Forth [79?] )
( Published in Forth Dimensions /V4N6 p.14 )

( adaptation to Atari 8-bit APX Forth in progress, )
( crashes but I feel it's close to a working state )
( -- BartGo, 2026                                  )

HEX

VOCABULARY ALGEBRAIC IMMEDIATE
ALGEBRAIC DEFINITIONS

0 CONSTANT OP 44 ALLOT

: ?INTERP ( pfa -- )
  CFA STATE @ IF , ELSE
  EXECUTE THEN ;
  
: OPP@ ( -- addr )
  OP DUP @ + ;

: >OP ( pfa lev -- )
  4 OP +! OPP@ D! ;

: OP> ( -- )
  OPP@ D@ -4 OP +!
  DROP ?INTERP ; 

: LEV? ( -- lev )
  OPP@ @ ;

: ]A
  BEGIN LEV? WHILE OP> REPEAT
  [COMPILE] FORTH ; IMMEDIATE

: ABORT"
  STATE @ IF COMPILE 0BRANCH
  HERE 0 , COMPILE (.")
  ASCII " WORD HERE C@ 1+ ALLOT
  COMPILE QUIT HERE OVER -
  SWAP ! ELSE IF ASCII " WORD
  HERE COUNT TYPE QUIT THEN
  THEN ; IMMEDIATE  

: INFIX ( lev -- ; rpnop infop )
  [COMPILE] ' <BUILDS SWAP , , IMMEDIATE
  DOES> D@ BEGIN DUP LEV? > 0=
  WHILE >R >R OP> R> R> REPEAT
  >OP ; 

7 INFIX * *  7 INFIX / /
6 INFIX + +  6 INFIX - -
5 INFIX > >  5 INFIX < <
5 INFIX = =
4 INFIX 0= 0=
3 INFIX AND AND
2 INFIX OR OR 

: (
  [COMPILE] CR 1 >OP ; IMMEDIATE
: )
  FORTH BEGIN 1 LEV? <
  WHILE OP> REPEAT
  1 LEV? = IF -4 OP +! ELSE
  1 ABORT" Missing ("
  THEN ; IMMEDIATE

DECIMAL
FORTH DEFINITIONS

: A[
  ALGEBRAIC 0 OP ! FORTH
  [COMPILE] ALGEBRAIC ; IMMEDIATE


( EXAMPLES )

( boom! crash! hang! )

A[ 1 + 5 - 8 * ( 8 - 7 ) ]A


  
