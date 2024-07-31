( FIXME - broken after moving to mode 15 ) 

( MUGWUMP in APX Forth, Atari 8-bit )
( PCC Basic Game ported by BartGo 

( see "Title" section for program info )
( TODO: winning crashes; add ":" debugging )
(       and detect place of the crash )
( TODO: show the last entered coordinates )
( TODO: P/M graphics; laser + mugwump )

DECIMAL FORTH DEFINITIONS

( required screens: 40 LOAD 50 LOAD 60 LOAD )

: |APP| ;

10  CONSTANT GRIDSIZE
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

( RE-DEFINING A COLON WORD by EHS
( https://www.forth.org/fd/FD-V06N3.pdf
' : CFA @ CONSTANT DOCOL
: (RE:) ( -- )
  -FIND 0= IF HERE COUNT TYPE
  ."  NOT FOUND" QUIT THEN
  DROP DUP CFA @ DOCOL = 0= IF
  HERE COUNT TYPE ."  NOT A COLON WORD"
  QUIT THEN HERE SWAP ! ;
: (;RE) ( -- ) R> R> 2DROP ;
: RE: ( -- ) SP@ CSP ! CURRENT @
  CONTEXT ! (RE:) DOCOL , ] ;
: ;RE ( -- ) ?CSP COMPILE (;RE)
  [COMPILE] [ ; IMMEDIATE

( Start: LOCAL VARIABLES in Forth )
( *** by Marc Perkel FD-V03N6 *** )
HEX 0 VARIABLE [ARG] 0 VARIABLE [TO]
: +ARG <BUILDS , DOES> @ [ARG] @ SWAP - [TO] @ -DUP
  IF 0< IF +! ELSE ! ENDIF ELSE @ ENDIF 0 [TO] ! ;
 0 +ARG S1  2 +ARG S2  4 +ARG S3  6 +ARG S4
 8 +ARG S5  A +ARG S6  C +ARG S7  E +ARG S8 10 +ARG S9
: TO  1 [TO] ! ; : +TO -1 [TO] ! ;
: ARGUMENTS R> [ARG] @ >R >R 2 * SP@ + DUP [ARG] !
  12 - SP@ SWAP - 2 / 0 DO 0 LOOP 0 [TO] ! ;
: RESULTS 2 * [ARG] @ SWAP - SP@ - 2 / 0 DO DROP LOOP
  R> R> [ARG] ! >R ; DECIMAL
( End: LOCAL VARIABLES )

( Dot word with no trailing space )
: .; ( n -- ) S->D 0 D.R ;

: Esc? ( -- ) BEGIN KEY 27 = UNTIL ;

: YN? ( -- n )
  BEGIN
    KEY DUP
    DUP ASCII Y = SWAP ASCII y = OR IF EMIT 1 ;S THEN
    DUP ASCII N = SWAP ASCII n = OR IF EMIT 0 ;S THEN
  AGAIN ;

: Antic-OFF
  SDMCTL @ graph? ! 0 SDMCTL ! ;

: Antic-ON
  graph? @ SDMCTL ! ;

( Clear screen, set color and margin )
: Home ( b b -- ) COLOR2 C! LMARGN C! 125 EMIT ;
  
: Title
  Antic-OFF
  3 0 Home CR CR
  ." ***********************************" CR
  ."   M    U    G    W    U    M    P  " CR
  ." ***********************************" CR CR
  ."         A HIDE AND SEEK GAME       " CR
  ."      PEOPLE'S COMPUTER COMPANY     " CR
  ."            MENLO PARK CA           " CR CR
  ." Ported from Basic game published in" CR
  ." 1973-04 / People's Computer Company" CR CR
  ."    2024 port to Forth by: BartGo   " CR
  ."  Written in APX Extended Fig-Forth " CR
  ."           for Atari 8-bit          " CR CR
  ."             (Press ESC)"             CR
  Antic-ON
  Esc? ;  

( Print the rules )
: Rules ( -- )
  0 0 Home 0 graph? !
  ." Do you want graphics  (Y=YES)? "  
  YN? IF 1 graph? ! ENDIF
  CR ." Do you want the rules (Y=YES)? "  
  YN? 0= IF ;S ENDIF
  CR CR
  ." A MUGWUMP IS HIDING IN A " GRIDSIZE .
  ." BY " GRIDSIZE . ." GRID."                   CR
  ." TRY TO FIND HIM BY GUESSING HIS"            CR
  ." GRIDPOINT. HOMEBASE IS GRIDPOINT 0,0 "      CR
  ." AND A GUESS IS A PAIR OF WHOLE NUMBERS"     CR
  ." (0 to " GRIDSIZE 1 - .; ." )." CR
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
  CR ." Press ESC." Esc?  ;
  
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
  graph? @ 0 > 0= IF ;S THEN
  15 GR. 80 712 ! 80 COLOR2 !
  Antic-OFF
  GRIDSIZE 0 DO 
    BCOL  I 10 * 1 - 0 +  0 PLOT 
    BCOL  I 10 * 1 - 0 + 79 DRAW
    BCOL  0 0 + I 10 * 1 - PLOT 
    BCOL 79 0 + I 10 * 1 - DRAW
  LOOP Antic-ON ;

: Mark ( col x y -- )
  3 ARGUMENTS
    S1 S2 10 * 0 +
	   S3 10 * PLOT
    S1 S2 10 * 0 +
	   S3 10 * DRAW
	S1 S2 10 * 0 +
	   S3 10 * DRAW
	S1 S2 10 * 0 +
	   S3 10 * DRAW
  0 RESULTS ;

: GrUpdate ( x y -- )
  graph? @ 0= IF
    DROP DROP ;S
  THEN
  GCOL ROT ROT Mark ;

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
      ." You are " 
	  100 * Sqrt 10
	  /MOD .; ASCII . EMIT .
      ." unit(s) from the Mugwump. " 
      ( CR ." Shh... Check gridpoint " )
      ( hideX @ .; ASCII , EMIT )
      ( hideY @ .; CR CR )
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
  Esc? graph? @ IF XGR THEN 2 148 Home ;

( Game )
: RUN ( -- )
  Title
  ( BEGIN )
    Rules
    MainLoop ( n )
    HighScore
  ( AGAIN ) 
  XGR ;


( DEPLOY AUTOMATIC  LOAD )
( ' RUN CFA ' ABORT 6 + ! )
  
( DEPLOY ERROR HANDLING )
: CRASH ( -- )
  144 710 C!
  CR CR ." SYSTEM ERROR!" 
  CR CR ( UNRAVEL  )
  CR CR ." PRESS RESET TO REBOOT."
  BEGIN AGAIN ;
  
;S
