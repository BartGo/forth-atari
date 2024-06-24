( MUGWUMP in APX Forth, Atari 8-bit )
( FIXME ) 

( see "Title" section for program info )
( TODO: winning crashes; add ":" debugging and detect place of the crash )
( TODO: use a gr. mode of 8 colors + txt [?] to make a heatmap! )
( TODO: show the last entered coordinates )
( TODO: P/M graphics; laser + mugwump )
( TODO: without FP we get very little info! )
( TODO: DLI )

DECIMAL FORTH DEFINITIONS CR

( LOAD ASM & GRAPH ) 
39 LOAD 50 LOAD CR
: SKIPPED-BECAUSE-OF-APX-ERROR ( --- ) ;

: |APPLICATION| ;

9   CONSTANT GRIDSIZE
10  CONSTANT GUESSMAX
2   CONSTANT BCOL ( board color )
1   CONSTANT GCOL ( guess color )
559 CONSTANT SDMCTL
710 CONSTANT COLOR2
82  CONSTANT LMARGN
0   VARIABLE guessX
0   VARIABLE guessY
0   VARIABLE hideX
0   VARIABLE hideY
0   VARIABLE graph?

( Dot word with no trailing space )
: .; ( n -- ) S->D 0 D.R ;

: WaitEsc ( -- ) BEGIN KEY 27 = UNTIL ;

: WaitYN? ( -- n )
  BEGIN
    KEY DUP
    DUP ASCII Y = SWAP ASCII y = OR IF EMIT 1 ;S THEN
    DUP ASCII N = SWAP ASCII n = OR IF EMIT 0 ;S THEN
  AGAIN ;

( Clear screen, set color and margin )
: Home ( b b -- ) COLOR2 C! LMARGN C! 125 EMIT ;
  
: Title
  3 0 Home CR CR
  ." ***********************************" CR
  ."   M    U    G    W    U    M    P  " CR
  ." ***********************************" CR CR
  ."         A HIDE AND SEEK GAME       " CR
  ."      PEOPLE'S COMPUTER COMPANY     " CR
  ."            MENLO PARK CA           " CR CR
  ." Ported from Basic game published in" CR
  ." 1973-04 / People's Computer Company" CR CR
  ."     Adaptation: BartGo, 2024-06    " CR
  ."  Written in APX Extended Fig-Forth " CR
  ."           for Atari 8-bit          " CR CR
  ."             (Press ESC)" CR WaitEsc ;  

( Print the rules )
: Rules ( -- )
  0 0 Home 0 graph? !
  ." Do you want graphics  (Y=YES)? "  
  WaitYN? IF 1 graph? ! ENDIF
  CR ." Do you want the rules (Y=YES)? "  
  WaitYN? 0= IF ;S ENDIF
  CR CR
  ." A MUGWUMP IS HIDING IN A " GRIDSIZE .
  ." BY " GRIDSIZE . ." GRID."                   CR
  ." TRY TO FIND HIM BY GUESSING HIS"            CR
  ." GRIDPOINT. HOMEBASE IS GRIDPOINT 0,0 "      CR
  ." AND A GUESS IS A PAIR OF WHOLE NUMBERS"     CR
  ." (0 to " GRIDSIZE .; ." )." CR
  ." THE FIRST NUMBER IS THE DISTANCE"           CR
  ." TO THE RIGHT OF HOMEBASE AND THE SECOND"    CR
  ." NUMBER IS THE DISTANCE ABOVE THE "          CR
  ." HOMEBASE. FOR EXAMPLE, IF YOU THINK THE"    CR
  ." MUGWUMP IS HIDING 8 UNITS TO THE RIGHT"     CR
  ." OF HOMEBASE AND 3 UNITS ABOVE HOMEBASE"     CR
  ." AND 3 UNITS ABOVE HOMEBASE,"                CR
  ." THEN ENTER 8 3 AS YOUR GUESS."              CR
  ." YOU GET " GUESSMAX . ."  GUESSES."          CR 
  ." AFTER EACH GUESS, I WILL TELL YOU"          CR
  ." HOW FAR (IN A DIRECT LINE) YOU ARE FROM"    CR
  ." THE MUGWUMP."                               CR
  CR ." Press ESC." WaitEsc  ;
  
( Random number using POKEY )
: Rnd ( rng -- rnd )
  -11766 C@ -11766 C@ 256 * +
  SWAP MOD ABS ; 

( FIXME: should not leave non-# on stack! )
( Enter a number )
: Get# ( -- n )
  BEGIN                   (   )
    KEY DUP ASCII 0 1 - > ( n f ) 
    OVER    ASCII 9 1 + < ( n f f ) 
  AND UNTIL               ( n )
  DUP EMIT 48 - ;         ( n )

( Square )
: ^2 DUP * ; ( n -- n*n )

( Square root, Newton Method    )
( https://sametwice.com/sqrt.fs ) 
: Sqrt ( n -- n )
  1 BEGIN
    OVER OVER / OVER - 2 / DUP
  WHILE + REPEAT DROP SWAP DROP ;

: GrInit
  graph? @ 0= IF ;S THEN
  7 GR. 80 712 ! 80 COLOR2 !
  SDMCTL @ 0 SDMCTL !
  8 1 DO 
    BCOL  I 10 * 1 - 40 +  0 PLOT 
    BCOL  I 10 * 1 - 40 + 79 DRAW
    BCOL  0 40 + I 10 * 1 - PLOT 
    BCOL 79 40 + I 10 * 1 - DRAW
  LOOP SDMCTL ! ;

: GrUpdate ( n n -- )
  graph? @ 0= IF DROP DROP ;S THEN
  GCOL ROT ROT PLOT 
  ( update here ) ;

( Main loop )
: MainLoop ( -- n )
  GRIDSIZE Rnd hideX !
  GRIDSIZE Rnd hideY ! 
  0 0 Home GrInit
  GUESSMAX 0 DO
    CR ." Mugwump is hiding. You get "
    GUESSMAX I - . ." guesses. " CR
    Get# guessX !  ASCII , EMIT
    Get# guessY !  CR CR
    guessX @ hideX @ =
      guessY @ hideY @ = AND
    IF I ( return loop# /win ) ;S
    ELSE
      guessX @ hideX @ - ^2
      guessY @ hideY @ - ^2 +
      ." You are " Sqrt .
      ." unit(s) from the Mugwump. " ( CR 
      ( CR ." Shh... Check gridpoint "
      ( hideX @ .; ASCII , EMIT
      ( hideY @ .; CR CR 
    ENDIF
  guessX @ guessY @ GrUpdate
  LOOP 0 ( return 0 /lost ) ;

( Ending screen )
: HighScore ( n -- )
  ( FIXME : win coord detection )
  -DUP IF 
    CR ." You found him in " 
    GUESSMAX SWAP - ." guesses!!!" 
  ELSE
    CR ." Sorry, that's " GUESSMAX .
    ." tries." CR
    ." Mugwump is at gridpoint "
    hideX @ .; ASCII , EMIT
    hideY @ .; 
  THEN
  CR ." Press ESC." 
  WaitEsc graph? @ IF XGR THEN 2 148 Home ;

( Game )
: RUN ( -- )
  Title
  BEGIN
    Rules
    MainLoop ( n )
    HighScore
  AGAIN ;
