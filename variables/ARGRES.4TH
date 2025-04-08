( TURNING THE STACK INTO LOCAL VARIABLES
( Marc Perkel 
( https://www.forth.org/fd/FD-V03N6.pdf
( tunings for Atari 8-but APX Forth by BartGo 

: ARGRES( ;

HEX 0 VARIABLE [ARG] 0 VARIABLE [TO]
: +ARG <BUILDS , DOES> @ [ARG] @ SWAP - [TO] @ -DUP
  IF 0< IF +! ELSE ! ENDIF ELSE @ ENDIF 0 [TO] ! ;
 0 +ARG S1  2 +ARG S2  4 +ARG S3  6 +ARG S4
 8 +ARG S5  A +ARG S6  C +ARG S7  E +ARG S8 10 +ARG S9
: TO  1 [TO] ! ; : +TO -1 [TO] ! ;
: ARGUMENTS R> [ARG] @ >R >R 2 * SP@ + DUP [ARG] !
  12 - SP@ SWAP - 2 / 0 DO 0 LOOP 0 [TO] ! ;
: RESULTS 2 * [ARG] @ SWAP - SP@ - 2 / 0 DO DROP LOOP
  R> R> [ARG] ! >R ;
DECIMAL

: )ARGRES ;

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
