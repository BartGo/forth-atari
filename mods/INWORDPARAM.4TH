( --------------------------- )
(  IN-WORD PARAMETER WORDS by )
( Sam Suan Chen, FD V6N6 p.9; )
( adapted from: FD V5N3 p.19, )
( IN-WORD PARAMETER PASSING   )
( by T. Huang, FD V5N3 p. 19; )
( test: Atari 8-bit APX Forth ) 
( --------------------------- )

FORTH DEFINITIONS DECIMAL
: INWORD$
  BASE @ >R 16 BASE !
  HERE + 0 0 ROT (NUMBER)
  DROP DROP [COMPILE] LITERAL
  R> BASE ! ;
: (?COMPILE
  STATE @ IF
    R> DUP @ , 2+ >R THEN ;

;S

( EXAMPLES - REQUIRE PICK&ROLL )
( 3 WIDTH ! : DUPX 3 INWORD$
(   (?COMPILE PICK ; IMMEDIATE
( 4 WIDTH ! : DROPX 4 INWORD$
(   (?COMPILE ROLL
(   (?COMPILE DROP ; IMMEDIATE
( 31 WIDTH !  
(   : (XYSWP 16 /MOD >R DUP +
(     SP@ + SP@ R> DUP + + OVER @
( 	OVER @ >R SWAP ! R> SWAP ! ;
( 4 WIDTH ! : SWAPXY 4 INWORD$
(   (?COMPILE (XYSWP ; IMMEDIATE  
( 31 WIDTH !  
( 
( HEX SP!
( 1 2 3 4 5 6 7 8 9 A B C D E F
( S. DUPE   S. SP!
( 1 2 3 4 5 6 7 8 9 A B C D E F
( S. DROPD  S. SP!
( 1 2 3 4 5 6 7 8 9 A B C D E F
( S. SWAP3E S. SP!  
( DECIMAL
  


