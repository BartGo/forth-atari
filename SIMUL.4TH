( *WIP* )
( HAMURABI-LIKE GAME )
( FOR APX FORTH BY BARTGO )

FORTH DEFINITIONS DECIMAL

: DEV( ;

( SHOW STACK )
: .S ( -- )
  40 EMIT SPACE
  SP@ 188 = 0= IF SP@ 2 -
  186 DO
  I @ . -2 +LOOP THEN 41
  EMIT SPACE ;
  
( RE-DEFINING A COLON WORD )
( by EHS )
( https://www.forth.org/fd )
( /FD-V06N3.pdf )
' : CFA @ CONSTANT DOCOL
: RE-CREATE ( -- )
  -FIND 0= IF
	HERE COUNT
	TYPE ."  NOT FOUND"
	ABORT
  THEN
  DROP DUP CFA @ DOCOL = 0=
  IF
	HERE COUNT TYPE
	."  NOT A COLON WORD"
	ABORT
  THEN HERE SWAP ! ;
: RE-EXIT ( -- ) R> R>
  2DROP ;
: R: ( -- )
  SP@ CSP ! CURRENT @
  CONTEXT ! 
  RE-CREATE DOCOL , ] ;
: ;R ( -- )
  ?CSP COMPILE RE-EXIT
  [COMPILE] [ ; IMMEDIATE
  
: )DEV ;

1    CONSTANT #H  ( APETITE )
10   CONSTANT #G  ( PRICE )
30   CONSTANT #A  ( PRICE )
120  CONSTANT #F  ( PRICE )
10   CONSTANT #FC ( ENERGY USE )
40   CONSTANT #S  ( PRICE )
90   CONSTANT #C  ( PRICE )
10   CONSTANT #E  ( PRICE )
50   CONSTANT #FF ( YIELD )
10   CONSTANT #AA ( YIELD )
10   CONSTANT #CC ( YIELD )
100  CONSTANT #SS ( CAPCT )
1    CONSTANT #LASTYR ( LASTYR )
52  7 * CONSTANT #D/YR 

: VAR 0 VARIABLE ; IMMEDIATE
VAR P ( PEOPLE )
VAR G ( GOODS )
VAR E ( ENERGY )
VAR C ( SOLAR CELLS/PLANTS )
VAR M ( MONEY )
VAR A ( FARMS / AGRO )
VAR F ( FACTORIES )
VAR S ( STORAGE )
VAR T ( TIME )
VAR H ( HUNGRY DAYS )

: >= < 0= ( a b -- f ) ;
: ASSERT< ( a b -- ) < 1
  ?PAIRS ;

84   CONSTANT #Y
85   CONSTANT #X
: POS  ( x y -- ) #Y C! #X ! ; 
: XYRE ( x y -- )
       ( 10 10 XYRE Q )
  POS [COMPILE] ASCII 128 +
  EMIT ; 

: #GROW    ( a -- a )
  8 * 7 /   ; ( POPULATION )
: SCAP@    (   -- a )
   S @ #SS * ; ( TOTAL STORAGE )
: AYIELD@  (   -- a ) 
   A @ #AA * ; ( TOTAL AGR YLD )
: CYIELD@  (   -- a ) 
   C @ #CC * ; ( TOTAL CLL YLD )
: FYIELD@  (   -- a ) 
   F @ #FF * ; ( TOTAL FCT YLD )
: FEUSAGE@ (   -- a ) 
   F @ #FC * ; ( TOTAL FCT E U )
: PGUSAGE@ (   -- a ) 
   P @ #H  * ; ( TOTAL PPL G U )
: PEUSAGE@ (   -- a ) 
   P @       ; ( TOTAL PPL E U )
: ELEFT@   (   -- a ) 
   E @ FEUSAGE@ -
   PEUSAGE@ - ; ( E LEFT )
: GLEFT@   (   -- a ) 
   G @ PGUSAGE@ - ; ( G LEFT )
: PLEFT@   (   -- a ) 
   P @ H @ -      ; ( P LEFT )

: CONSUME ( -- )
  ELEFT@ 0 > IF
    ( FACTORIES AND PEOPLE ) 
    ELEFT@ E ! ELSE 0 E !
	( USE ENERGY )
  THEN
  GLEFT@ 0 > IF
    ( BUT ONLY PEOPLE )   
    GLEFT@ G !
	( CONSUME GOODS ) 
    0 H !
	( SO NO HUNGER HAPPENS )
  ELSE
    0 G !
	( IF NOTHING LEFT TO EAT )
    H @ 0 > IF
  	  ( AND HUNGER PERSISTS )
      PLEFT@ 0 > IF
  	    ( AND ANY PEOPLE LEFT )
  	    PLEFT@ P !
		( THE MORE HUNGRY )
		( THE MORE DIE )
      ELSE 0 P ! THEN
	  ( UNTIL ALL ARE DEAD )
    THEN
    1 H +!
	( ANOTHER DAY OF HUNGER )
  THEN
  H @ T @ ASSERT< ;
	
: PRODUCE ( -- )
  AYIELD@ G +!   ( FARMING  )
  CYIELD@ E +!   ( ENERGY   )
  SCAP@ E @ < IF ( E CAP )
    SCAP@ E !
  THEN
  ELEFT@ 0 >= IF ( ENERGY?  )
    FYIELD@ ELEFT@ MIN G +!
	( INDUSTRY )
  ELSE
    FYIELD@ ELEFT@ + G +!
  THEN
  SCAP@ G @ < IF ( G CAP )
    SCAP@ G !
  THEN ;
	
: BREED ( -- )
	T @ #D/YR MOD 0= IF
	  ( EVERY NEW YEAR )
	  P @ #GROW P !     
	  ( INCREASE POPULATION )
	THEN ;

: SUNRISE ( -- )
  1 T +! ;

: SEP ( -- )
  CR 24 0 DO 18 EMIT LOOP ;
   
: UI ( -- )
  125 EMIT
  F @ A @ > IF
    ." INDUSTRIAL KINGDOM OF X" 
  ELSE  ." FARMING KINGDOM OF X"
  THEN	
  SEP
  CR ."   YEAR: " T @
    #D/YR / 1+ .
  CR ."    DAY: " T @ . H @ 0 >
  IF
    ." - IN HUNGER: " H ?
  THEN
  CR ."  MONEY: " M @ .
  CR ." PEOPLE: " P @ . 
  CR ."  GOODS: " G @ . 
  CR ." ENERGY: " E @ . 
  SEP
  CR ."     FARMS: " A @ .
  ." ( " A @ #AA * . ."  )"
  CR ." FACTORIES: " F @ .
  ." ( " F @ #FF * . ."  )"
  CR ." POWPLANTS: " C @ .
  ." ( " C @ #CC * . ."  )"
  CR ."   STORAGE: " S @ .
  ." ( " S @ #SS * . ."  )"
     SEP
  CR ." -> (A)groFrm:/$" #A .
  CR ." -> (S)torage /$" #S .
     CR ." -> (P)wrPlnt /$" #C .
     CR ." -> (F)actory /$" #F .
     CR ." -> (G)dsSell /$" #G .
     CR ." -> (E)nrgSell/$" #E .
     CR ." -> (D)ebug"
  ( 12 14 XYRE A )
  ( 12 15 XYRE S )
  ( 12 16 XYRE P )
  ( 12 17 XYRE F )
  CR ." -> (N)ext (Q)uit" ; 

: INIT ( -- ) 
  20  P !
  0   E !
  0   C !
  200 M !
  0   A !
  0   F !
  2   S !
  SCAP@ G ! 
  0   T !
  0   H ! ;

: FINALIZE ( -- )
  2 82 C! 148 710 ! ;

: GET-INPUT ( -- )
  0
  BEGIN
	ASCII N = 0= ( f )
  WHILE
	UI KEY ( a )
	DUP ASCII A = M @ #A >=
	AND IF
	    1 A +! M @ #A - M ! THEN
	DUP ASCII F = M @ #F >=
	AND IF
	    1 F +! M @ #F - M ! THEN
	DUP ASCII G = G @   0 >
	AND IF 
	    -1 G +! #G M +!     THEN
	DUP ASCII E = E @   0 >
	AND IF 
	    -1 E +! #E M +!     THEN
	DUP ASCII S = M @ #S >=
	AND IF
	    1 S +! M @ #S - M ! THEN
	DUP ASCII P = M @ #C >=
	AND IF
	    1 C +! M @ #C - M ! THEN
	( a )
	DUP ASCII Q = IF 
	    DROP FINALIZE 125 EMIT
		QUIT
	THEN ( - )
	DUP ASCII D = IF 
	    DROP CR .S CR
		BEGIN QUERY INTERPRET
	AGAIN THEN ( - )
  REPEAT ;
 
: MAIN ( -- )
  8 82 C! 210 710 !
  BEGIN
	#D/YR #LASTYR * T @ >
  WHILE
	SUNRISE	CONSUME	
	PRODUCE BREED
    GET-INPUT
  REPEAT ;
  
: X INIT MAIN ;
