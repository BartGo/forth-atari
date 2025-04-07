( FIXME, CRASH )
( Baranov, Nozdrunov )
( Language Forth and its implementations )
( 3.2 / Infix notation )

0 CONSTANT OPRC HERE 2+ , 40 ALLOT

( analogies to >R R@ R> )
: >OPRC ( a -- )
  OPRC @ ! 2 OPRC +! ; 
: OPRC@ ( -- a )
  OPRC @ 2 - @ ;
: OPRC> ( -- a )
  OPRC@ -2 OPRC +! ;

: >OPRC> ( n:p -- )
  >R
  BEGIN
    OPRC@ R < 0=
  WHILE
    OPRC> DROP OPRC> 
	STATE @ IF ,
	ELSE EXECUTE THEN
  REPEAT R> DROP ;
: 2@ DUP @ SWAP 2+ @ ;
: 2-OP ( N:P -- )
  IN @ >R ' R> IN !
  CREATE
    IMMEDIATE , , DOES>
  2@ >R >R R >OPRC> R> R> 
  >OPRC >OPRC ;  
: 1-OP ( -- ) 9 2-OP ;

2 2-OP OR 
2 2-OP XOR
3 2-OP AND
4 2-OP = 

5 2-OP <
5 2-OP >
6 2-OP +
6 2-OP - 
7 2-OP *
7 2-OP / 
7 2-OP MOD
  1-OP NOT
  1-OP ABS
  1-OP NEGATE

: (( 0 >OPRC ; IMMEDIATE
: )) 1 >OPRC> OPRC> DROP ; IMMEDIATE


0 VARIABLE ?CH
: PARAM 
  <BUILDS 0 , DOES>
  [COMPILE] LITERAL
  ?CH @ IF STATE @ IF COMPILE @
  ELSE @ THEN THEN ; IMMEDIATE

: ::=
  [COMPILE] (( -1 ?CH !
  ; IMMEDIATE

: ;; [COMPILE] )) STATE @ IF
    COMPILE SWAP COMPILE !
  ELSE SWAP ! THEN
  0 ?CH ! ; IMMEDIATE

PARAM A  PARAM B
A ::= 10 ;;  B ::= 15 ;;
A ::= ( A + B ) * ( A - B ) + 2 ;;  
	
	
