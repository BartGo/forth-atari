( #IF pseudo-preprocessor directive, )
( - can only digest one line of text )
( also, example of 'include': #KNOWN )

FORTH DEFINITIONS DECIMAL 0 WARNING !

: ) ;
: #IF ( f -- )
  0= IF [COMPILE] ( THEN ; IMMEDIATE
: #KNOWN -FIND IF DROP DROP 1 ELSE 0 THEN ;

( --------- )
( example 1 )
( --------- )
: _LOAD-SIMPLE
  [ #KNOWN ASSEMBLER 0= ] #IF 76 DUP . LOAD ) ;
_LOAD-SIMPLE

( --------- )
( example 2 )
( --------- )
( v should DEBUG be loaded )
0 CONSTANT _DBG
0 CONSTANT _ASM
( ^ select assembler's type: )
( 1 for Ragsdale, 0 for Mullarky )
: _LOAD-COMPLEX
  [ _DBG 1 = ] #IF 21 DUP . LOAD )
  [ _ASM 1 = ] #IF 76 DUP . LOAD )
  [ _ASM 0 = ] #IF 40 DUP . LOAD 50 LOAD ) ;
( _LOAD )
