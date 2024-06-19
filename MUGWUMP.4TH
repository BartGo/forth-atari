
( !! see "Title" below for program info !! )

( FIXME )

FORTH DEFINITIONS DECIMAL

( 39 LOAD 50 LOAD ) ( ASM & GRAPH )

: APP( ;

9  CONSTANT GRIDSIZE
10 CONSTANT GUESSMAX
0  VARIABLE guessX
0  VARIABLE guessY
0  VARIABLE hideX
0  VARIABLE hideY
0  VARIABLE graph

( Clear screen, set color and margin )
: Home ( b b -- )
  710 C! 82 C! 125 EMIT ;
  
: WaitEsc ( -- )
  BEGIN KEY 27 = UNTIL ;
  
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

( Dot word with no trailing space )
: .; ( n -- )
  S->D 0 D.R ;

( Print the rules )
: Rules ( -- )
  0 0 Home
  0 graph !
  ." Do you want graphics  (Y=YES)? "  
  KEY DUP EMIT CR ASCII Y = IF
    0 graph !
  ENDIF CR
  ." Do you want the rules (Y=YES)? "  
  KEY DUP EMIT CR CR ASCII Y = 0= IF ;S ENDIF
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
  ." THE MUGWUMP."                               CR ;
  
( Random number using POKEY )
: Rnd ( rng -- rnd )
  -11766 C@ -11766 C@ 256 * +
  SWAP MOD ABS ; 

( Enter a number )
: Get# ( -- n )
  BEGIN                   (   )
    KEY DUP ASCII 0 1 - > ( n f ) 
       OVER ASCII 9 1 + < ( n f f ) 
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

: GraphInit
  graph @ 0= IF ;S THEN
  ( init here ) ;

: GraphUpdate
  graph @ 0= IF ;S THEN
  ( update here ) ;

( Main loop )
: MainLoop ( -- n )
  GRIDSIZE Rnd hideX !
  GRIDSIZE Rnd hideY ! 
  CR ." Press ESC."
  WaitEsc
  0 0 Home
  GraphInit
  GUESSMAX 0 DO
    GraphUpdate
	CR ." Mugwump is hiding. You get "
    GUESSMAX I - . ." guesses. " CR
	Get# guessX !  ASCII , EMIT
    Get# guessY !  CR
    guessX @ hideX @ =
      guessY @ hideY @ = AND
    IF
	  I ( return loop# /win ) ;S
	ELSE
	  guessX @ hideX @ - ^2
        guessY @ hideY @ - ^2 +
      ." You are " Sqrt .
	  ." unit(s) from the Mugwump. " CR
	
		CR      ." Shh... Check gridpoint "
		hideX @ .; ASCII , EMIT
		hideY @ .; CR CR
	
    ENDIF
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
  CR CR ." Press ESC. " 
  ." Then, type RUN to play again." 
  CR WaitEsc
  148 710 C! 2 82 C! 125 EMIT
  CR CR ;

( Game )
: RUN ( -- )
  Title
  Rules
  MainLoop ( n )
  HighScore ;
	
: )APP ;
