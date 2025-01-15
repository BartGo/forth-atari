( simplified for fig forth, based on: )
( https://rosettacode.org/wiki/Apply_a_callback_to_an_array#Forth )

FORTH DEFINITIONS DECIMAL : TASK ;

2 CONSTANT CELLS
: ON ( addr n -- n+addr addr )
  CELLS * OVER + SWAP ;
: SHOW ( addr n -- )
  ON DO I ? 2 +LOOP ;
: MAP  ( fn addr n -- )  
  ON DO
    I @ OVER    ( fn n fn )
	CFA EXECUTE ( fn m )
	I !
  2 +LOOP       ( fn )
  DROP ;
  
CREATE DATA' 1 , 2 , 3 , 4 , 5 , SMUDGE

: ^2+1 DUP * 1+ ;
' DATA' 5 SHOW
' ^2+1 ' DATA' 5 MAP 
' DATA' 5 SHOW
