
( HAMURABI-LIKE GAME FOR APX FORTH )
( BY BARTGO )
( WIP )

( FIXME: CONSUMING TOO MUCH, GOODS <0 )


FORTH DEFINITIONS DECIMAL

: DEV( ;

	( SHOW STACK )
	: .S ( -- )
	  40 EMIT SPACE
	  SP@ 188 = 0= IF SP@ 2 - 186 DO
	  I @ . -2 +LOOP THEN 41 EMIT SPACE ;
	  
	( TURNING THE STACK INTO LOCAL VARIABLES )
	( Marc Perkel, FD V03N6 )
	HEX 0 VARIABLE [ARG] 0 VARIABLE [TO]
	: +ARG <BUILDS , DOES> @ [ARG] @ SWAP - [TO] @ -DUP
	  IF 0< IF +! ELSE ! ENDIF ELSE @ ENDIF 0 [TO] ! ;
	 0 +ARG S1  2 +ARG S2  4 +ARG S3  6 +ARG S4
	 8 +ARG S5  A +ARG S6  C +ARG S7  E +ARG S8 10 +ARG S9
	: TO  1 [TO] ! ; : +TO -1 [TO] ! ;
	: ARGUMENTS R> [ARG] @ >R >R 2 * SP@ + DUP [ARG] !
	  12 - SP@ SWAP - 2 / 0 DO 0 LOOP 0 [TO] ! ;
	: RESULTS 2 * [ARG] @ SWAP - SP@ - 2 / 0 DO DROP LOOP
	  R> R> [ARG] ! >R ;
	DECIMAL

	( RE-DEFINING A COLON WORD by EHS )
	( https://www.forth.org/fd/FD-V06N3.pdf )
	' : CFA @ CONSTANT DOCOL
	: RE-CREATE ( -- )
	  -FIND 0= IF
		HERE COUNT TYPE ."  NOT FOUND" ABORT
	  THEN
	  DROP DUP CFA @ DOCOL = 0= IF
		HERE COUNT TYPE ."  NOT A COLON WORD"
		ABORT
	  THEN HERE SWAP ! ;
	: RE-EXIT ( -- ) R> R> 2DROP ;
	: R: ( -- )
	  SP@ CSP ! CURRENT @ CONTEXT ! 
	  RE-CREATE DOCOL , ] ;
	: ;R ( -- )
	  ?CSP COMPILE RE-EXIT
	  [COMPILE] [ ; IMMEDIATE
  
: )DEV ;

1    CONSTANT #H  ( APETITE )
10   CONSTANT #G  ( PRICE )
30   CONSTANT #A  ( PRICE )
120  CONSTANT #F  ( PRICE )
10   CONSTANT #FC ( ENERGY USAGE )
40   CONSTANT #S  ( PRICE )
90   CONSTANT #C  ( PRICE )
10   CONSTANT #E  ( PRICE )
50   CONSTANT #FF ( YIELD )
10   CONSTANT #AA ( YIELD )
10   CONSTANT #CC ( YIELD )
100  CONSTANT #SS ( CAPCT )
1    CONSTANT #LASTYR ( LAST GAME YR )
52  7 * CONSTANT #D/YR   ( DAYS/YR )

: VAR 0 VARIABLE ; IMMEDIATE
VAR P ( PEOPLE )
VAR G ( GOODS )
VAR E ( ENERGY )
VAR C ( SOLAR CELLS / POWER PLANTS )
VAR M ( MONEY )
VAR A ( FARMS / AGRO )
VAR F ( FACTORIES )
VAR S ( STORAGE )
VAR T ( TIME )
VAR H ( HUNGRY DAYS )

: >= < 0= ;
: ASSERT< < 1 ?PAIRS ;
: #GROW    ( a -- a ) 8 * 7 /   ; ( POPULATION )
: SCAP@    (   -- a ) S @ #SS * ; ( TOTAL STORAGE )
: AYIELD@  (   -- a ) A @ #AA * ; ( TOTAL AGR YLD )
: CYIELD@  (   -- a ) C @ #CC * ; ( TOTAL CLL YLD )
: FYIELD@  (   -- a ) F @ #FF * ; ( TOTAL FCT YLD )
: FEUSAGE@ (   -- a ) F @ #FC * ; ( TOTAL FCT E USAGE )
: PGUSAGE@ (   -- a ) P @ #H  * ; ( TOTAL PPL G USAGE )
: PEUSAGE@ (   -- a ) P @       ; ( TOTAL PPL E USAGE )
: ELEFT@   (   -- a ) E @ FEUSAGE@ - PEUSAGE@ - ; ( E LEFT )
: GLEFT@   (   -- a ) G @ PGUSAGE@ -            ; ( G LEFT )
: PLEFT@   (   -- a ) P @ H @ -                 ; ( P LEFT )

: CONSUME ( -- )
  ELEFT@ 0 > IF ( FACTORIES AND PEOPLE ) 
    ELEFT@ E ! ELSE 0 E ! ( USE ENERGY )
  THEN
  GLEFT@ 0 > IF ( BUT ONLY PEOPLE )   
    GLEFT@ G !  ( CONSUME GOODS ) 
    0 H !       ( SO NO HUNGER HAPPENS )
  ELSE
    0 G !          ( IF NOTHING LEFT TO EAT )
    H @ 0 > IF     ( AND WE ALREADY HAVE HUNGER )
      PLEFT@ 0 > IF   ( THEN IF PEOPLE ARE LEFT )
  	    PLEFT@ P !    ( THE MORE HUNGRY THE MORE DIE )
      ELSE 0 P ! THEN ( UNTIL ALL ARE DEAD )
    THEN
    1 H +! ( JUST ANOTHER DAY OF HUNGER )
  THEN
  H @ T @ ASSERT< ;
	
: PRODUCE ( -- )
  AYIELD@ G +!   ( FARMING  )
  CYIELD@ E +!   ( ENERGY   )
  SCAP@ E @ < IF ( E CAP )
    SCAP@ E !
  THEN
  ELEFT@ 0 >= IF ( ENERGY?  )
    FYIELD@ G +! ( INDUSTRY )
  ELSE
    FYIELD@ ELEFT@ + G +!
  THEN
  SCAP@ G @ < IF ( G CAP )
    SCAP@ G !
  THEN ;
	
: BREED ( -- )
	T @ #D/YR MOD 0= IF ( EVERY NEW YEAR )
	  P @ #GROW P !     ( INCREASE POPULATION )
	THEN ;

: SUNRISE ( -- )
  1 T +! ;

: SEP ( -- )
  CR 24 0 DO 18 EMIT LOOP ;
   
: UI ( -- )
	125 EMIT
	F @ A @ > IF ." INDUSTRIAL KINGDOM OF X" 
	ELSE  ." FARMING KINGDOM OF X" THEN	
	SEP
	CR ."   YEAR: " T @ #D/YR / 1+ .
	CR ."    DAY: " T @ . H @ 0 > IF
	  ." - IN HUNGER: " H ?
	THEN
	CR ."  MONEY: " M @ .
	CR ." PEOPLE: " P @ . 
	CR ."  GOODS: " G @ . 
	CR ." ENERGY: " E @ . 
	SEP
	CR ."     FARMS: " A @ . ." * " #AA .
	CR ." FACTORIES: " F @ . ." * " #FF . 
	CR ." POWPLANTS: " C @ . ." * " #CC .
	CR ."   STORAGE: " S @ . ." * " #SS .
    SEP
	CR ." -> (A)groFrm:/$" #A .
	CR ." -> (S)torage /$" #S .
    CR ." -> (P)wrPlnt /$" #C .
    CR ." -> (F)actory /$" #F .
    CR ." -> (G)dsSell /$" #G .
    CR ." -> (E)nrgSell/$" #E .
    CR ." -> (D)ebug"
	CR ." -> (N)ext (Q)uit" ; 

: INIT ( -- ) ;
R: INIT ( -- )
  20  P !
  0   E !
  0   C !
  200 M !
  0   A !
  0   F !
  2   S !
  SCAP@ G ! 
  0   T !
  0   H !
  8 82 C!
  210 710 ! ;R

: FINALIZE ( -- )
  2 82 C! 148 710 ! ;

: GET-INPUT ( -- )
  0
  BEGIN
	ASCII N = 0= ( f )
  WHILE
	UI KEY ( a )
	DUP ASCII A = M @ #A >= AND IF
	    1 A +! M @ #A - M ! THEN
	DUP ASCII F = M @ #F >= AND IF
	    1 F +! M @ #F - M ! THEN 
	DUP ASCII G = G @   0 > AND IF 
	    -1 G +! #G M +!     THEN
	DUP ASCII E = E @   0 > AND IF 
	    -1 E +! #E M +!     THEN
	DUP ASCII S = M @ #S >= AND IF
	    1 S +! M @ #S - M ! THEN 
	DUP ASCII P = M @ #C >= AND IF
	    1 C +! M @ #C - M ! THEN 
	( a )
	DUP ASCII Q = IF 
	    DROP FINALIZE 125 EMIT QUIT
	THEN ( - )
	DUP ASCII D = IF 
	    DROP CR .S CR
		BEGIN QUERY INTERPRET
	AGAIN THEN ( - )
  REPEAT ;
 
: MAIN ( -- )
  INIT
  BEGIN
	#D/YR #LASTYR * T @ >
  WHILE
	SUNRISE	CONSUME	
	PRODUCE BREED
    GET-INPUT
  REPEAT ;
  
: RUN MAIN ;
