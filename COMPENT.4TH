( ----------------------------- )
(  compiled comments by BartGo  )
( * for Atari 8-bit APX Forth * )
( ----------------------------- )

: // R COUNT DUP 1+ R> + >R DROP DROP ;
: '( STATE @ 0= IF ASCII ) WORD ELSE
  COMPILE // ASCII ) WORD HERE C@ 1+ ALLOT
  THEN ; IMMEDIATE

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
      DUP ID. ." // "
      PFA 2+ COUNT TYPE CR
    ELSE
      ID. SPACE SPACE
    THEN
    PFA LFA @
    DUP 0= ?TERMINAL OR
  UNTIL DROP ; 

( test )
: -ROT '( backrot: a b c -- b c a ) ROT ROT ;
ELIST
;S

( side effect fixed below, otherwise )
( DECOMP would not work correctly!   )

27 LOAD ( run manually )
25 LIST
EDITOR
 8 P ( added // => compents BG '24 )
 9 P : CKIT DUP ZBRAN = OVER BRAN = OR
10 P  OVER PLOOP = OR OVER PPLOOP = OR  
11 P  IF BRNCH ELSE DUP .LIT = IF
12 P  1WORD ELSE DUP .CLIT = IF 1BYTE
13 P  ELSE DUP PDOTQ = OVER ' // CFA
14 P  = OR IF STG ELSE PWORD THEN
15 P  THEN THEN THEN ; -->
FLUSH
21 LOAD ( run manually )
DECOMP -ROT
;S
