( ****          BREAK&GO           **** )
( https://www.forth.org/fd/FD-V05N1.pdf )
(  Breakpoints, incl. conditional ones  )
( to fix: R.N usage, testing conditions )
(   In progress: testing on APX Forth   )
(         - for Atari 8-bit             )

FORTH DEFINITIONS DECIMAL
39 LOAD

FORTH DEFINITIONS DECIMAL

ASSEMBLER CODE RP@ 
  XSAVE STX,
  TSX, TXA, PHA,
  1 # LDA,
  XSAVE LDX,
  PUSH JMP,
FORTH

: S0 TIB 4 - @ ; ( -- n ) ( better: 18 +ORIGIN @ )
: R0 TIB 2 - @ ; ( -- n )
: .S SP@ S0 = 0= IF
    SP@ 2 - S0 2 - DO I @ . -2 +LOOP
  ELSE ." Stack empty " THEN ;

0 CONSTANT #DEBUG
0 VARIABLE RP*
: BREAK ( -- )
  CR ." (BREAK reached, type GO to proceed)"
  CR ." S= " .S ( CR ." R= " R.N ) CR 
  RP@ 4 - RP* ! 0 BLK ! BEGIN QUERY
  INTERPRET ." aok" CR AGAIN ;
: ?BREAK IF BREAK THEN ;
:  []  BREAK ;
: ?[] ?BREAK ;
( TODO:
( : BREAK" CR COMPILE (.") BREAK ; IMMEDIATE
( :  ["  CR [COMPILE] (.")  BREAK ; IMMEDIATE
( : ?["  CR [COMPILE] (.") ?BREAK ; IMMEDIATE )

: GO ( -- ) RP@ RP* @ = IF R> DROP R> DROP
  ELSE ." can't resume " QUIT THEN ; 
  
( usage example, conditional breakpoint )  
: X ( -- )
  1 2 + 3
  #DEBUG ?[]
  * ;

( nice, if DEPTH is available: DEPTH 0= ?() 

( END )  
