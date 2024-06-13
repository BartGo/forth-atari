( WORK IN PROGRESS )
( ATARI 800XL, APX EXTENDED FIG FORTH )

( *  Micro Core Wars  * )

FORTH DEFINITIONS DECIMAL

( ** INCLUDES ** )

( 39 LOAD ( assembler ) CR
( 50 LOAD ( graphics  ) CR

( ** TYPES ** )

: BYTE[] <BUILDS C, DOES> C@ ;

( ** CONSTANTS ** )

192 80 * CONSTANT #SIZE
       1 CONSTANT #_
	   3 CONSTANT #COLORS ( BUG? )
      24 CONSTANT #MAXPROG
      88 CONSTANT #SAVMSC

( ** VARIABLES ** )

#SIZE BYTE[]   arenaTEST
    0 VARIABLE arena #SIZE ALLOT 
   64 VARIABLE progCnt

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
    DUP @ #_ = IF      ( c n )
      ! ;S ELSE DROP DROP
    THEN 
  AGAIN ;  

: Worm ( -- name )
  <BUILDS
    8 0 DO #_ C, LOOP ( name )
    1 progCnt +!      ( nxt code )
    progCnt @
    DUP , SetCell     ( rnd loc )
  DOES>
  0 1 MOV ;
  
: Dwrf ( -- name )
  <BUILDS
    8 0 DO #_ C, LOOP ( name )
    1 progCnt +!      ( nxt code )
    progCnt @
    DUP , SetCell     ( rnd loc )
  DOES>
  2    JMP
  0    DAT
  5 -1 ADD 
  0 -2 MOV
  2    JMP ;
  
: Init ( -- )
  arena #SIZE #_ FILL ;
  
: Show ( -- )
  CR
  #SIZE 0 DO
    arena I + @ .
  LOOP
  CR ;
  
: (Run)
  arena #SAVMSC @ #SIZE 2 / CMOVE
  BEGIN
    KEY 27 = IF ;S THEN
  AGAIN
  ;
  
: Run ( -- )
  9 GR.
  (Run)
  XGR ;  
  
Init

( Worm PL1-WORM1
( Worm PL1-WORM2
( Dwrf PL2-DWRF
( Run
