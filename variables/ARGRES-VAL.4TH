( TURNING THE STACK INTO LOCAL )
( VARIABLES by Marc Perkel,    )
( published in FD V03N6 ------ )
( merged w/ VAL-TO approach,   )
( tuned, tested for Atari 8-bit)
( APX Forth - by BartGo, 2026  )


FORTH DEFINITIONS HEX

0 VARIABLE [ARG] 0 VARIABLE [TO]
: +ARG <BUILDS , DOES> @ [ARG] @
  SWAP - [TO] @ -DUP IF 0< IF +!
  ELSE ! ENDIF ELSE @ ENDIF
  0 [TO] ! ;
0 +ARG S1  2 +ARG S2  4 +ARG S3
6 +ARG S4  8 +ARG S5  A +ARG S6
C +ARG S7  E +ARG S8 10 +ARG S9
: TO  1 [TO] ! ; : +TO -1 [TO] ! ;
: ARGUMENTS R> [ARG] @ >R >R 2 *
  SP@ + DUP [ARG] ! 12 - SP@
  SWAP - 2 / 0 DO 0 LOOP
  0 [TO] ! ;
: RESULTS 2 * [ARG] @ SWAP -
  SP@ - 2 / 0 DO DROP LOOP
  R> R> [ARG] ! >R ;

: VAL <BUILDS , DOES> [TO] @
  IF ! 0 [TO] ! ELSE @ THEN ;

DECIMAL

;S

( ARG-RES EXAMPLES )
: BOX ( n n n -- n n )
  3 ARGUMENTS
    S1 S2 S3 * * TO S4
    S1 S2 S3 + + TO S5
    S5 TO S1 
    S4 TO S2
  2 RESULTS ;

2 3 4 BOX
  24 ?PAIRS
  9  ?PAIRS
1 1 1 BOX
  1  ?PAIRS
  3  ?PAIRS


;S

( VAL examples )
: TASK ;  
42 VAL XYZ
24 VAL ABC
XYZ .
ABC .
11 TO ABC
22 TO XYZ
XYZ ABC + 33 ?PAIRS
FORGET TASK
