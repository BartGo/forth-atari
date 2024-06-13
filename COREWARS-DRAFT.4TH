( WORK IN PROGRESS )
( ATARI 800XL, APX EXTENDED FIG FORTH )

( *  Micro Core Wars  * )

FORTH DEFINITIONS DECIMAL

39 LOAD ( assembler ) CR
50 LOAD ( graphics )  CR

( "coroutine" ) 
: <CO> ( -- )
  R> R> SWAP >R >R ;

: ColCycle ( -- ) 
  BEGIN
    712 @ 255 = IF 0 712 ! THEN 
    712 @ 1+ 712 !
    1000 0 DO LOOP <CO>
  AGAIN ;

: TEST.COLCYCLE ( -- )
  ColCycle
  BEGIN ." Y" <CO> AGAIN ;

2 CONSTANT #A
: TEST.GrArena ( -- )
  5 GR. ( 80 x 40 x 4, text window )
  ColCycle
  #A  0  0 PLOT
  #A  0 39 DRAW <CO>
  #A 79 39 DRAW <CO>
  #A 79  0 DRAW <CO>
  #A  0  0 DRAW ;
          
40 20 * CONSTANT #SIZE
     46 CONSTANT #_
     24 CONSTANT #MAXPROG
   88 @ CONSTANT #SAVMSC@

 0 VARIABLE arena #SIZE 2 - ALLOT 
64 VARIABLE progCnt

( dummy commands )
( redcode examples from "Moje Atari 6": )
( https://archive.org/details/moje-atari-6/page/n3/mode/2up )
: JMP DROP ; : MOV DROP DROP ;
: DAT DROP ; : ADD DROP DROP ; 

( Random number using POKEY )
: Rnd ( rng -- rnd )
  -11766 C@ -11766 C@ 256 * +
  SWAP MOD ABS ; 

( Start a program in an empty arena cell )
: SetCell ( c -- ) 
  BEGIN
    #SIZE Rnd arena + ( c n )
    DUP C@ #_ = IF    ( c n )
      C! ;S ELSE DROP DROP
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
  
: INIT ( -- )
  arena #SIZE #_ FILL ;

: HOME ( -- )
  0 82 C! 125 EMIT ;

: RUN ( -- )
  HOME #SIZE 0 DO
    I arena + @ EMIT
  LOOP CR ;

: FASTRUN ( -- ) 
  ;S ( FIXME )
  HOME arena #SAVMSC@ #SIZE CMOVE
  CR ;

INIT
Worm PL1-WORM1
Worm PL1-WORM2
Worm PL1-WORM3
Dwrf PL2-DWRF
RUN
;S
