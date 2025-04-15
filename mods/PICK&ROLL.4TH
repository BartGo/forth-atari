( * PICK and ROLL * )
(   for fig-FORTH   )
(    Steve Oakey    )
( /Forth for Micros )
( tested: APX Forth )

: PICK ( n -- n )
  2 * SP@ OVER 1 < SWAP ROT +
  SWAP OVER
  18 +ORIGIN @ ( S0 ) < 0= OR IF
    ." PICK: out of range"
	CR ABORT
  ELSE @ THEN ;

: ROLL ( n -- )
  2 * SP@ OVER 1 < SWAP ROT +
  SWAP OVER 
  18 +ORIGIN @ ( S0 ) < 0= OR IF
    ." ROLL: out of range"
	CR ABORT
  ELSE
    DUP @ >R SP@ 2+ SWAP DO
	  I 2 - @ I ! -2
	+LOOP
    DROP R>
  THEN ;
