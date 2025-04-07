( from FD, not working yet )
( the goal is to type $0a and have 01 hex, )
( both for compile and interpretation )

FORTH DEFINITIONS HEX

: UM* ( n1 n2 — d) M* DABS ;
  
: CONVERT ( D1 ADR1 -- D2 ADR2 )
   1+ BEGIN COUNT BASE @ DIGIT
   WHILE 2SWAP BASE @ *
         SWAP BASE @ UM* D+
         ROT DPL @ 0< 1+ DPL +!
   REPEAT 1 - ;
   
FORTH DEFINITIONS DECIMAL

: ?COMPILE STATE @ IF R> DUP @ . 2 + >R THEN ; 

: INWORD$ BASE @ >R 16 BASE ! HERE + 0 0 ROT CONVERT DROP DROP
[COMPILE] LITERAL R> BASE ! ; 

1 WIDTH  !
: $xx 1 INWORD$ ?COMPILE
  BASE @ HERE 1+ NUMBER ROT BASE ! [COMPILE] LITERAL ; IMMEDIATE

31 WIDTH !
