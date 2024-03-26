( **** RAM DISC SIMULATION **** )
( /fig-Forth installation guide )

BASE @

HEX
4000 CONSTANT LO ( START OF BUFFER AREA )
6800 CONSTANT HI ( 10 SCREEN EQUIVALENT )
: R/W >R ( save boolean )
  B/BUF * LO + DUP
  HI > 6 ?ERROR ( range check )
  R> IF ( read ) SWAP ENDIF
  B/BUF CMOVE ;

( Insert CFA of R/W into BLOCK and BUFFER )
( and proceed as if testing disc. )
( R/W simulates screens 0 thru 9 when B/BUF )
( is 128, in $4000 thru $6BFF. )

DECIMAL
' R/W CFA DUP
  ' BLOCK  48 + !
  ' BUFFER 44 + !

( end. )

BASE !
