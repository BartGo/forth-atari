( compiled comments )
: // R COUNT DUP 1+ R> + >R DROP DROP ;
: '( STATE @ 0= IF ASCII ) WORD ELSE
  COMPILE // ASCII ) WORD HERE C@ 1+ ALLOT
  THEN ; IMMEDIATE
: TASK '( marker! ) ;

: VLIST '( standard VLIST: -- )
  128 OUT ! CONTEXT @ @
  BEGIN
    OUT @ C/L > IF CR 0 OUT ! THEN
    DUP ID. SPACE SPACE PFA LFA @
    DUP 0= ?TERMINAL OR
  UNTIL DROP ; FORGET VLIST

( VLIST with stack comments )
: ELIST '( enhanced VLIST: -- )
  CR CONTEXT @ @ BEGIN
    DUP DUP
    PFA @ ' // CFA = IF ( // 1st )
      ID. ASCII # EMIT CR
    ELSE
      ID. SPACE SPACE
    THEN
    PFA LFA @
    DUP 0= ?TERMINAL OR
  UNTIL DROP ; 
;S


( EXAMPLE 1 )
: -ROT '( backrot: a b c -- b c a ) ROT ROT ;
ELIST
;S

( EXAMPLE 2 )
( decomp showing compiled comments )
: TASK ;
27 LOAD 25 SCR ! EDITOR
 8 P ( added // => compents BG '24 )
 9 P : CKIT DUP ZBRAN = OVER BRAN = OR
10 P  OVER PLOOP = OR OVER PPLOOP = OR  
11 P  IF BRNCH ELSE DUP .LIT = IF
12 P  1WORD ELSE DUP .CLIT = IF 1BYTE
13 P  ELSE DUP PDOTQ = OVER ' // CFA
14 P  = OR IF STG ELSE PWORD THEN
15 P  THEN THEN THEN ; -->
FORGET TASK
: TASK ;
21 LOAD DECOMP -ROT
FORGET TASK
;S
