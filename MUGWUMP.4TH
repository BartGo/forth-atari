
( *********************************** )
(   M    U    G    W    U    M    P   )
( *********************************** )
(         A HIDE AND SEEK GAME        )
(      PEOPLE'S COMPUTER COMPANY      )
(            MENLO PARK CA            )
( *********************************** )
( Ported from Basic game published in )
( 1973-04 / People's Computer Company )
(  https://archive.org/details/       )
(    1973-04-peoples-computer-company )
( *********************************** )
(     Adaptation: BartGo, 2024-06     )
(  Written in APX Extended Fig-Forth  )
(           for Atari 8-bit           )
( *********************************** )

FORTH DEFINITIONS DECIMAL

: /APP ;

9 CONSTANT gridSize ( TODO: make sure it's 10x10 )
0 VARIABLE guessX
0 VARIABLE guessY
0 VARIABLE hideX
0 VARIABLE hideY
0 VARIABLE time

( Clear screen )
: Home ( -- )
  0 82 C!
  125 EMIT ;
  
( Not equals )
: <> = 0= ;

( Dot word, no trailing space )
: .; ( n -- )
  S->D 0 D.R ;
  
( Print the rules )
: Rules ( -- )
  Home CR CR ." Do you want the rules? " 
  KEY DUP EMIT CR CR ASCII Y <> IF ;S ENDIF
  ." A MUGWUMP IS HIDING IN A " gridSize .
  ." BY " gridSize . ." GRID."                   CR
  ." TRY TO FIND HIM BY GUESSING HIS"            CR
  ." GRIDPOINT. HOMEBASE IS GRIDPOINT 0 0 "      CR
  ." AND A GUESS IS A PAIR OF WHOLE NUMBERS"     CR
  ." (0 to " gridSize .; ." ) SEPARATED BY A COMMA." CR
  ." THE FIRST NUMBER IS THE DISTANCE"           CR
  ." TO THE RIGHT OF HOMEBASE AND THE SECOND"    CR
  ." NUMBER IS THE DISTANCE ABOVE THE "          CR
  ." HOMEBASE. FOR EXAMPLE, IF YOU THINK THE"    CR
  ." MUGWUMP IS HIDING 8 UNITS TO THE RIGHT"     CR
  ." OF HOMEBASE AND 3 UNITS ABOVE HOMEBASE,"    CR
  ." THEN ENTER 8 3 AS YOUR GUESS."              CR
  ( TO DO: LIMIT )
  ." AFTER EACH GUESS, I WILL TELL YOU"          CR
  ." HOW FAR (IN A DIRECT LINE) YOU ARE FROM"    CR
  ." THE MUGWUMP."                               CR ;
  
( Random number using POKEY )
: Rnd ( rng -- rnd )
  -11766 C@ -11766 C@ 256 * +
  SWAP MOD ABS ; 
  
( Init variables )  
: Init ( -- )
  gridSize Rnd hideX !
  gridSize Rnd hideY !
  1 time ! ;

( Enter a number )
: GetNumber ( -- n )
  KEY DUP EMIT 48 - SPACE ;

( Square )
: ^2 DUP * ;

( Square root, Newton Method    )
( https://sametwice.com/sqrt.fs ) 
: Sqrt ( n -- n )
  1 BEGIN
    OVER OVER / OVER - 2 / DUP
  WHILE + REPEAT DROP SWAP DROP ;

( Main loop )
: MainLoop ( -- )
  BEGIN
    ." Hiding. Guess. " CR
	GetNumber guessX !
    GetNumber guessY !  CR
    guessX @ hideX @ =
      guessY @ hideY @ = AND
    IF ;S ELSE
      guessX @ hideX @ - ^2
        guessY @ hideY @ - ^2 +
      Sqrt
      ." You are " .
	  ." units from... " CR
      1 time +! 
    ENDIF
  AGAIN ;

( Winning screen )
: HighScore ( -- )
  ." FOUND IN " time ?
  2 82 C! CR CR ;

( Game )
: RUN ( -- )
  Rules
  Init
  MainLoop
  HighScore ;
	
: APP/ ;
