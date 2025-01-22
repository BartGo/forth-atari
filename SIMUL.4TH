( HAMURABI-LIKE GAME FOR APX FORTH )
( BY BARTGO )
( WIP )
( FIXME: HANGUPS )

FORTH DEFINITIONS DECIMAL

20   VARIABLE P ( PEOPLE )
100  VARIABLE G ( GOODS )
200  VARIABLE M ( MONEY )
0    VARIABLE A ( FARMS )
0    VARIABLE F ( FACTORIES )
0    VARIABLE S ( STORAGE )
0    VARIABLE T ( TIME )
0    VARIABLE H ( HUNGRY DAYS )

2      CONSTANT #LASTYR
52 7 * CONSTANT #D/YR
2      CONSTANT #C  ( APETITE )
10     CONSTANT #G  ( PRICE )
30     CONSTANT #A  ( PRICE )
120    CONSTANT #F  ( PRICE )
40     CONSTANT #S  ( PRICE )
50     CONSTANT #FF ( YIELD )
10     CONSTANT #AA ( YIELD )
100    CONSTANT #SS ( CAPCT )

: PRODUCE ( -- )
  A @ #AA * G @ + G !
  F @ #FF * G @ + G ! ;

: CONSUME ( -- )
	G @ P @ > IF
	  G @ P @ #C * - G ! ( CONSUME )
	  0 H !         ( NO HUNGER )
	ELSE
	  0 G !
	  H @ 0 > IF
		P @ 0 > IF 
		  P @ H @ - P ! 
		THEN
	  ELSE 1 H ! THEN
	THEN ;
	
: REPRODUCE ( -- )
	T @ #D/YR MOD 0= IF ( EVERY NEW YEAR )
	  P @ 8 * 7 / P !   ( INCREASE POPULATION BY 1/7 )
	THEN ;

: SUNRISE ( -- )
  1 T +! ;
 
: UI ( -- )
	125 EMIT CR
		F @ A @ > IF CR ." INDUSTRIAL KINGDOM OF X" 
	ELSE  CR ." FARMING KINGDOM OF X" THEN	
		CR ."   YEAR: " T @ #D/YR / 1+ .
	CR ."    DAY: " T @ .
	CR ."  MONEY: " M @ .
	CR ."  FARMS: " A @ . ." * " #AA .
	CR ." FACTORIES: " F @ . ." * " #FF . 
	CR ."  GOODS: " G @ . 
	CR ." PEOPLE: " P @ . H @ 0 > IF
  CR ." DAYS IN HUNGER:" H ? THEN
	CR ." STORAGE LEFT: " S @ #SS * G @ - .
	CR ." -> (A)gro (F)actory (T)rade (N)ext" ; 
	
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
  REPEAT DROP ;
  
: MAIN ( -- )
  BEGIN
    #D/YR #LASTYR * T @ >
  WHILE
	  SUNRISE	PRODUCE	CONSUME	REPRODUCE
    GET-INPUT
  REPEAT ;
