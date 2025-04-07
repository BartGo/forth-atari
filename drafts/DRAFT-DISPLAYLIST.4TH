( ----- )
( REM https://www.atariarchives.org/c2bag/page069
( 4000 M=4:DL=PEEK(560)+256*PEEK(561):POKE DL+3,M+64
( 4005 FOR I=DL+6 TO DL+16+12*(M=4):POKE I,M:NEXT I:POKE I,65:POKE I+1,0:POKE I+2,DL/256
( ----- )


( 18 LOAD 50 LOAD )

: DL@ 560 @ ;
: DL! DL@ SWAP + C! ;
: A4X ( -- )
  DL@ 28 + DL@ 6 + DO
    4 I C! LOOP
  68  3 DL!
  65 28 DL!
  0  29 DL!
  DL@ 256 / 30 DL! ;
	
