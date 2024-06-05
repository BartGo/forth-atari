
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

( Random number, using POKEY )
: Rnd ( rng -- rnd )
  -11766 C@
  -11766 C@ 256 * +
  SWAP MOD ABS ; 
  
( Square )
: ** DUP * ;

( Square root, Newton Method    )
( https://sametwice.com/sqrt.fs ) 
: Sqrt ( n -- n )
  1 BEGIN
    OVER OVER / OVER - 2 / DUP
  WHILE + REPEAT
  DROP SWAP DROP ;

( Clear screen )
: Home ( -- )
  0 82 C! 125 EMIT ;
  
: Return ( -- )
  2 82 C! CR CR ; 

( Enter a number )
: Number ( -- n )
  KEY DUP EMIT 48 - CR ;

( Print the rules )
: Rules ( -- )
  CR CR ." Do you want the rules?" 
  CR CR KEY ASCII Y = 0= IF ;S ENDIF
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
  
( Init variables )  
: Init ( -- )
  gridSize Rnd hideX !
  gridSize Rnd hideY !
  1 time ! ;

( Guess coordinates ) 
: Guess ( -- )
  ." Hiding. Guess. " CR
  Number guessX !
  Number guessY ! ;

( Winning screen )
: Won ( -- )
  ." FOUND IN" time ? ;

( Main loop )
: Game ( -- )
  Home
  Rules
  Init ( sentinel: ) 0
  BEGIN
    ( sentinel: ) DROP
    Guess
    guessX @ hideX @ =
      guessY @ hideY @ = AND
    IF
      ( sentinel: ) 0
    ELSE
      guessX @ hideX @ - ** 
        guessY @ hideY @ - ** +
      Sqrt
      ." You are " ? 
      ." units from... " CR
	  ." DEBUG: " hideX ? hideY ?
	  ." //" CR
      1 time +! ( sentinel: ) 1
    ENDIF
    DUP
  WHILE REPEAT
  ( sentinel: ) DROP
  Won
  Return ;
    
: APP/ ;
