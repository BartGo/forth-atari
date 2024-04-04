FORTH DEFINITIONS

DECIMAL

: /APP ;

VOCABULARY GAME IMMEDIATE
           GAME DEFINITIONS

10 CONSTANT gridSize

 0 VARIABLE guessX
 0 VARIABLE guessY
 0 VARIABLE hideX
 0 VARIABLE hideY
 0 VARIABLE time

: FN ; : sentinel ; : () ;
: ** DUP * ;

  ( https://sametwice.com/sqrt.fs ) 
: (SQRT) OVER OVER / OVER - 2 / ; 
: SQRT 1 BEGIN (SQRT) DUP WHILE + REPEAT DROP SWAP DROP ;

: RND -11766 C@ -11766 C@ 256 *
  + SWAP MOD ABS ; ( rng -- rnd )
: P" COMPILE ." ; ( -- ) IMMEDIATE
: NUMBER KEY 48 - ; ( FIX ME )

: Rules ( -- )
  P" A MUGWUMP IS HIDING IN A" gridSize
  P" BY" gridSize
  P "GRID. TRY TO"
  P" FIND HIM BY GUESSING HIS GHIDPOINT. HOMEBASE IS"
  P" GHIDPOINT 0,0 AND A GUESS IS A PAIR OF WHOLE"
  P" numbers (0 to" gridSize 1 - ?
  P" separated by a comma, the first"
  P" NUMBER IS THE DISTANCE TO THE RIGHT OF HOMEBASE"
  P" AND THE SECOND NUMBER IS THE DISTANCE ABOVE THE"
  P" HOMEBASE. FOR EXAMPLE, IF YOU THINK THE MUGWUMP"
  P" IS HIDING fl UNITS 10 THE nIGHT OF HOMEBASE AND"
  P" AFTER EACH GUESS, I WILL TELL YOU HOW FAR (IN •DIRECT LINE)"
  P" YOU ARE FROM THE MUGWUMP."
  P" Do you want the rules?" CR
  KEY ASCII Y IF Rules THEN CR ;
: Init ( -- )
  gridSize RND hideX !
  gridSize RND hideY !
  1 time ! ;
: Guess ( -- )
  P" Hiding. Guess. " CR
  NUMBER guessX !
  NUMBER guessY ! ;
: Won
  P" FOUND IN" time ? ;
: Game ( -- )
  Rules
  Init

  0 sentinel ()
  BEGIN
    sentinel DROP ()
    Guess FN
      guessX @ hideX @ =
      guessY @ hideY @ = AND
    IF
      0 sentinel ()
    ELSE FN
        guessX @ hideX @ - ** 
        guessY @ hideY @ - ** +
      SQRT
      P" You are " ?
      P" units from... " CR
      1 time +!
      1 sentinel ()
    THEN DUP WHILE
  AGAIN
  sentinel DROP
        
  Won ;
    
: APP/ ;
