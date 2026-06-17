( fun with DL )

FORTH DEFINITIONS DECIMAL

\ 39 LOAD ( LOAD ASSEMBLER )
\ 50 LOAD ( LOAD GRAPHICS  )

: \ IN @ 64 MOD 64 SWAP - IN +! ; IMMEDIATE

: .DL ( -- ; show DL )
  560 @ 32 0 DO DUP I + C? LOOP DROP ;
: FLIPM ( line# -- ; flip line# between GR0 and A4 )
  560 @ SWAP + DUP @ 6 XOR SWAP ! ;
( example: 6 FLIPM 26 FLIPM )


: DL@ ( -- n )
  [ 14 GR. 560 @ XGR ] LITERAL ;
: DL! ( n -- )
  DL@ SWAP + C! ;
: A4X ( -- )
  DL@ 28 + DL@ 6 + DO
    4 I C! LOOP
  68  3 DL!
  65 28 DL!
  0  29 DL!
  DL@ 256 / 30 DL! ;
