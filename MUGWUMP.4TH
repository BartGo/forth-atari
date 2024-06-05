: /APP ;

VOCABULARY GAME IMMEDIATE
GAME DEFINITIONS
DECIMAL

10 CONSTANT gridSize
 0 VARIABLE guessX
 0 VARIABLE guessY
 0 VARIABLE hideX
 0 VARIABLE hideY
 0 VARIABLE time

( Square )
: ** DUP * ;
( Square root, Newton Method, https://sametwice.com/sqrt.fs ) 
: SQRT 1 BEGIN
    OVER OVER / OVER - 2 / 
  DUP WHILE + REPEAT
  DROP SWAP DROP ;
( Random from POKEY )
: RND -11766 C@ -11766 C@ 256 *
  + SWAP MOD ABS ; ( rng -- rnd )
( Enter a number )
: NUMBER KEY 48 - ; ( FIX ME )

: Rules ( -- )
  ." A MUGWUMP IS HIDING IN A" gridSize
  ." BY" gridSize
  . "GRID. TRY TO"
  ." FIND HIM BY GUESSING HIS GHIDPOINT. HOMEBASE IS"
  ." GHIDPOINT 0,0 AND A GUESS IS A PAIR OF WHOLE"
  ." numbers (0 to" gridSize 1 - ?
  ." separated by a comma, the first"
  ." NUMBER IS THE DISTANCE TO THE RIGHT OF HOMEBASE"
  ." AND THE SECOND NUMBER IS THE DISTANCE ABOVE THE"
  ." HOMEBASE. FOR EXAMPLE, IF YOU THINK THE MUGWUMP"
  ." IS HIDING fl UNITS 10 THE nIGHT OF HOMEBASE AND"
  ." AFTER EACH GUESS, I WILL TELL YOU HOW FAR (IN •DIRECT LINE)"
  ." YOU ARE FROM THE MUGWUMP."
  ." Do you want the rules?" CR
  KEY ASCII Y IF Rules ENDIF CR ;
: Init ( -- )
  gridSize RND hideX !
  gridSize RND hideY !
  1 time ! ;
: Guess ( -- )
  ." Hiding. Guess. " CR
  NUMBER guessX !
  NUMBER guessY ! ;
: Won ( -- )
  ." FOUND IN" time ? ;
: Game ( -- )
  Rules Init sentinel: 0
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
      SQRT
      ." You are " ?
      ." units from... " CR
      1 time +! ( sentinel: ) 1
    ENDIF
    DUP
  WHILE AGAIN
  ( sentinel: ) DROP
  Won ;
    
: APP/ ;
