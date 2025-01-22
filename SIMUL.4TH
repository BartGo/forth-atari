( HAMURABI-LIKE GAME FOR APX FORTH )
( BY BARTGO )
( WIP )

( FIXME: HANGUPS - stack overflow )

FORTH DEFINITIONS DECIMAL

: .S ( -- )
  40 EMIT SPACE
  SP@ 188 = 0= IF SP@ 2 - 186 DO
  I @ . -2 +LOOP THEN 41 EMIT SPACE ;

1      CONSTANT #LASTYR
52 7 * CONSTANT #D/YR
2      CONSTANT #H  ( APETITE )
10     CONSTANT #G  ( PRICE )
30     CONSTANT #A  ( PRICE )
120    CONSTANT #F  ( PRICE )
10     CONSTANT #FC ( ENERGY USAGE )
40     CONSTANT #S  ( PRICE )
90     CONSTANT #C  ( PRICE )
10     CONSTANT #E  ( PRICE )
50     CONSTANT #FF ( YIELD )
10     CONSTANT #AA ( YIELD )
10     CONSTANT #CC ( YIELD )
100    CONSTANT #SS ( CAPCT )

20   VARIABLE P ( PEOPLE )
#SS  VARIABLE G ( GOODS )
0    VARIABLE E ( ENERGY )
0    VARIABLE C ( SOLAR CELLS / POWER PLANTS )
200  VARIABLE M ( MONEY )
0    VARIABLE A ( FARMS )
0    VARIABLE F ( FACTORIES )
1    VARIABLE S ( STORAGE )
0    VARIABLE T ( TIME )
0    VARIABLE H ( HUNGRY DAYS )

: PRODUCE ( -- )
  A @ #AA * G +!   ( FARMING!  )
  C @ #CC * E +!   ( ENERGY!   )
  E @ 0 > IF       ( ENERGY?   )
    F @ #FF * G +! ( INDUSTRY! )
  THEN
  S @ #SS * G @ < IF ( STORAGE CAP )
    S @ #SS * G ! THEN ;

: CONSUME ( -- )
	#FC F @ * E @ > 0= IF ( USE ENERGY )
	  E @ #FC F @ * - E ! ELSE 0 E !
	THEN
	G @ P @ #H * < 0= IF
	  G @ P @ #H * - G !  ( CONSUME )
	  0 H !               ( NO HUNGER )
	ELSE
	  0 G !
	  H @ 0 > IF
		P @ 0 > IF 
		  P @ H @ - P ! 
		THEN
	  ELSE 1 H ! THEN
	THEN
	( TODO: PEOPLE CAN USE ENERGY TOO )	;
	
: REPRODUCE ( -- )
	T @ #D/YR MOD 0= IF ( EVERY NEW YEAR )
	  P @ 8 * 7 / P !   ( INCREASE POPULATION BY 1/7 )
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
	  ." - IN HUNGER:" H ?
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
	CR ." -> f(A)rm:   /$" #A .
    CR ." -> (F)actory /$" #F .
	CR ." -> (S)torage /$" #S .
    CR ." -> (P)wrPlnt /$" #C .
    CR ." -> (T)radeGds/$" #G .
    CR ." -> trd(E)nrgy/$" #E .
    CR ." -> (D)ebug (N)ext" ; 
	
: GET-INPUT ( -- )
  0 BEGIN
	DUP ASCII N = 0=
  WHILE
	UI KEY
	DUP ASCII A = M @ #A < 0= AND IF
	    1 A +! M @ #A - M ! THEN
	DUP ASCII F = M @ #F < 0= AND IF
	    1 F +! M @ #F - M ! THEN 
	DUP ASCII T = G @ 0 > AND IF 
	    -1 G +! #G M +! THEN
	DUP ASCII E = E @ 0 > AND IF 
	    -1 E +! #E M +! THEN
	DUP ASCII S = M @ #S < 0= AND IF
	    1 S +! M @ #S - M ! THEN 
	DUP ASCII P = M @ #C < 0= AND IF
	    1 C +! M @ #C - M ! THEN 
	DUP ASCII D = IF 
	    CR .S CR BEGIN QUERY INTERPRET AGAIN THEN
  REPEAT DROP ;
  
: INIT ( -- )
  8 82 C!
  210 710 ! ;
  
: MAIN ( -- )
  INIT
  BEGIN
	#D/YR #LASTYR * T @ >
  WHILE
	SUNRISE	PRODUCE
	CONSUME	REPRODUCE
    GET-INPUT
  REPEAT ;
  
: RUN MAIN ;
