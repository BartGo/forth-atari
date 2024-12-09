( WORK IN PROGRESS )
( ATARI 800XL, APX EXTENDED FIG FORTH )
( TODO: change arena to a char array? )
( Day 1: ca. 5h )
( Day 2: ca. 1h )

( *  Micro Core Wars  * )

FORTH DEFINITIONS DECIMAL

( ** INCLUDES ** )

( 39 LOAD ( assembler ) CR
( 50 LOAD ( graphics  ) CR

( ** CONSTANTS ** )

       1 CONSTANT #DEBUG
160 80 * CONSTANT #SIZE
       0 CONSTANT #_
      24 CONSTANT #MAXPROG
      88 CONSTANT #SAVMSC

( ** VARIABLES ** )

0 VARIABLE arena #SIZE 2 - ALLOT 
1 VARIABLE progCnt

( ** WORDS ** )

( "coroutine" ) 
: <CO> R> R> SWAP >R >R ; ( -- )

: ColCycle ( -- ) 
  BEGIN
    712 @ 255 = IF 0 712 ! THEN 
    712 @ 1+ 712 !
    1000 0 DO LOOP <CO>
  AGAIN ;

: TEST.ColCycle ( -- )
  ColCycle
  BEGIN ." Y" <CO> AGAIN ;

( dummy commands, see "Moje Atari 6": )
( https://archive.org/details/moje-atari-6/ )
(   page/n3/mode/2up )

: JMP DROP ; : MOV DROP DROP ;
: DAT DROP ; : ADD DROP DROP ; 

( Random number using POKEY )
: Rnd ( rng -- rnd )
  -11766 C@ -11766 C@ 256 * +
  SWAP MOD ABS ; 

( Start in an empty cell )
: SetCell ( c -- ) 
  BEGIN
    #SIZE Rnd arena + ( c n )
    DUP C@ #_ = IF      ( c n )
      #DEBUG IF
	    CR ." setcell: " 2DUP . .
		CR 
	  THEN
      C! ;S ELSE DROP DROP
    THEN 
  AGAIN ;  

: Worm ( pl -- )
  <BUILDS
    8 0 DO #_ C, LOOP 
    1 progCnt +! progCnt C@ ,
    SetCell ( -- )    
  DOES>
  0 1 MOV ;
  
: Dwrf ( pl -- name )
  <BUILDS
    8 0 DO #_ C, LOOP 
    1 progCnt +! progCnt C@ ,
    SetCell ( -- )    
  DOES>
  2    JMP
  0    DAT
  5 -1 ADD 
  0 -2 MOV
  2    JMP ;
  
: Init ( -- )
  arena #SIZE #_ FILL ;
  
: Show ( -- )
  CR #SIZE 0 DO
    arena I + C@ .
  LOOP CR ;
  
: (Run)
  arena #SAVMSC @ #SIZE CMOVE
  BEGIN
    KEY 27 = IF ;S THEN
  AGAIN
  ;
  
: Run ( -- )
  5 GR.
  (Run)
  XGR ;  
  
( Init
( 1 Worm WORM1
( 1 Worm WORM2
( 2 Worm WORM3
( 2 Dwrf DWRF1
( 3 Worm WORM4
( Run
