( *** Local Definitions *** )
( Carol Pruitt    11-Jun-84 )
( As published in: FD-V06N6 )

( SOMETIMES CRASHES! MORE TESTS NEEDED! )
( Ongoing testing  w/ Atari APX Forth   )

0  VARIABLE LINK.FROM
64 CONSTANT LBIT 

: LOCAL 
  CURRENT @ PFA @ NFA 
  DUP C@ LBIT OR SWAP C! ;
: LOCAL.START HERE ;
: LOCAL.END
  CURRENT @ PFA
  DUP LINK.FROM ! @ 
  BEGIN 2DUP <
  WHILE
    DUP NFA C@ LBIT AND
    IF
	  LFA @ DUP
	  LINK.FROM @ !
    ELSE
	  LFA DUP
	  LINK.FROM ! @
    THEN
  REPEAT 2DROP ;
  
;S
  
( Example of LOCAL usage )
LOCAL.START
  0 VARIABLE 0WORD              LOCAL
  ( CODE lWORD ..whtver.. NEXT, LOCAL )
  : 2WORD ( whatever ) ;        LOCAL
  : 3WORD CR 2WORD ;           ( GLOBAL )
  : 4WORD 10 0                 ( MIXING )
    DO CR LOOP ;                LOCAL
  : 5WORD 0WORD 
    IF 3WORD ELSE 4WORD THEN ; ( GLOBAL )
LOCAL.END

