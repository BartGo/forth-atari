( Life - an expanded version from the book FORTH )
(        by Salman, Tisserand, Toulout 1983      )
(  **     tested on Atari 8-bit, APX Forth    ** )

FORTH DEFINITIONS DECIMAL 
( 39 LOAD 50 LOAD )

FORTH DEFINITIONS DECIMAL 
FORTH DEFINITIONS DECIMAL 

: ARRAY <BUILDS OVER , * ALLOT
        DOES> DUP @ ROT * + + 2+ ;

32 CONSTANT DIMX
23 CONSTANT DIMY
DIMX DIMY ARRAY UNIVERSE

: HOME
  0 710 C! 1 752 C! 125 EMIT ;
: BYE
  148 710 C! 0 752 C! 125 EMIT ;
: ALIVE 20 EMIT ;
: NONE SPACE ;
: J R> R> R> R R# ! >R >R >R R# @ ;
: INS ( indX indY -- )         
  UNIVERSE 1 SWAP C! ;
: N-INS ( xn yn .. n -- )
  0 DO INS LOOP ; 
: DEL ( indX indY -- )
  UNIVERSE 0 SWAP C! ;

: CLEAR ( -- )
  DIMY 0 DO
    DIMX 0 DO I J DEL LOOP
  LOOP ;
( : CLEAR.GR CLEAR 3 GR. ; )
  
: VERIFY
  DUP 3 = IF DROP 2+ ELSE
    2 = 0= IF 4 + THEN THEN ; 
: PREPARE ( -- )
  DIMY 0 DO DIMX 0 DO
    0 J 2+ DIMY MIN	J 1 - 0 MAX DO
	  J 2+ DIMX MIN J 1 - 0 MAX DO
        I J UNIVERSE C@ 1 AND +
    LOOP LOOP
    I J UNIVERSE C@ 1 AND
	SWAP OVER - VERIFY
    I J UNIVERSE C!
  LOOP LOOP ; 

: SHOW ( -- )
  HOME DIMY 0 DO DIMX 0 DO
    I J UNIVERSE C@
    IF ALIVE ELSE NONE THEN
  LOOP CR LOOP ;
( : SHOW.GR ( -- )
(   DIMY 0 DO DIMX 0 DO
(     I J UNIVERSE C@ I J PLOT
(   LOOP LOOP ; )
: DBG.SHOW ( -- )
  CR CR DIMY 0 DO DIMX 0 DO
    I J UNIVERSE C@ 48 + EMIT
  LOOP CR LOOP ;  

: GENERATE ( -- )
  DIMY 0 DO DIMX 0 DO
    I J UNIVERSE DUP C@ DUP
    3 > IF DROP 0 ELSE
      DUP 1 > IF DROP 1 THEN
	THEN SWAP C!
  LOOP LOOP ;    

: NO-ATTRACT 0 77 C! ;

: X ( -- )
  CLEAR ( .GR
  11 10  10 11  12 10
  12 11  12 12
  ( glider 1 ) 5 N-INS
  15 12 14 13
  16 12 17 14
  17 12
  ( glider 2 ) 5 N-INS
  BEGIN
    ?TERMINAL IF ;S THEN
    SHOW ( .GR
	PREPARE
	GENERATE 
	NO-ATTRACT
  AGAIN
  SHOW ( .GR
  BYE ;
