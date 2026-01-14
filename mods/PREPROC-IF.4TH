( #IF pseudo-preprocessor directive, )
( - can only digest one line of text )
( ; by BartGo, but can't be original )

FORTH DEFINITIONS DECIMAL 

: #IF ( f -- )
  0= IF [COMPILE] ( THEN ; IMMEDIATE
: ) ;

( ------- )
( example )
( ------- )
( v should DEBUG be loaded )
0 CONSTANT _DBG
0 CONSTANT _ASM
( ^ select assembler's type: )
( 1 for Ragsdale, 0 for Mullarky )
: _LOAD
  [ _DBG 1 = ] #IF 21 DUP . LOAD )
  [ _ASM 1 = ] #IF 76 DUP . LOAD )
  [ _ASM 0 = ] #IF 40 DUP . LOAD 50 LOAD ) ;
_LOAD
