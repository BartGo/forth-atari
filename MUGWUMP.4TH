
( ******* )
( MUGWUMP )
( ******* )
( adapted )
(  from:  )
(   ??    )
( ******* )

FORTH DEFINITIONS DECIMAL

: /APP ;

9 CONSTANT gridSize
0 VARIABLE guessX
0 VARIABLE guessY
0 VARIABLE hideX
0 VARIABLE hideY
0 VARIABLE time

( Clear screen )
: Home ( -- )
  0 82 C!
  125 EMIT ;
  
: != = 0= ;
  
( Print the rules )
: Rules ( -- )
  Home CR CR ." Do you want the rules? " 
  KEY DUP EMIT CR CR ASCII Y != IF ;S ENDIF
  ." A MUGWUMP IS HIDING IN A " gridSize .
  ." BY " gridSize . ." GRID." CR
  ." TRY TO FIND HIM BY GUESSING HIS GRIDPOINT." CR
  ." HOMEBASE IS GRIDPOINT 0,0 AND A GUESS" CR
  ." IS A PAIR OF WHOLE NUMBERS (0 to" gridSize . ." )" CR
  ." SEPARATED BY A COMMA. THE FIRST" CR
  ." NUMBER IS THE DISTANCE TO THE RIGHT OF HOMEBASE " CR
  ." AND THE SECOND NUMBER IS THE DISTANCE ABOVE THE " CR
  ." HOMEBASE. FOR EXAMPLE, IF YOU THINK THE MUGWUMP " CR 
  ." IS HIDING XX UNITS TO THE RIGHT OF HOMEBASE AND " CR
  ." AFTER EACH GUESS, I WILL TELL YOU HOW FAR (IN DIRECT" CR
  ." LINE) YOU ARE FROM THE MUGWUMP." ;
  
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
  KEY DUP EMIT 48 - CR ;

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
    GetNumber guessY ! 
    guessX @ hideX @ =
    guessY @ hideY @ = AND
    IF ;S ELSE
      guessX @ hideX @ - ^2
      guessY @ hideY @ - ^2 +
      Sqrt
      ." You are " ? 
      ." units from... " CR
      1 time +! 
    ENDIF
  AGAIN ;

( Winning screen )
: HighScore ( -- )
  ." FOUND IN" time ?
  2 82 C! CR CR ;

( Game )
: RUN ( -- )
  Rules
  Init
  MainLoop
  HighScore ;
	
: APP/ ;
