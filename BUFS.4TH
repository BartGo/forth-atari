( ** Display addresses of all the buffers ** )
( **           by Timothy Huang           ** )
( * as published in Forth Dimensions V03N6 * )
( **  Originally "public domain" license  ** )
( ** Compatible with fig-Forth / 1k scrns ** )
( ** Tested on Atari800XL emul. APX Forth ** )

( .BUFS TDH 7/11/81 FD-V03N6 )
BASE @ DECIMAL
: .BUFS ( display addresses of all the buffers )
  CR ." #  Addr(hex) Upd  Block#  Screen   -sub"
  FIRST
  LIMIT FIRST - B/BUF / ( #BUFF )
  1+ 1 DO
    CR I 2 .R 2 SPACES
    DUP 2+ HEX 6 0 SWAP D.R DECIMAL 3 SPACES
    DUP @ 32768 AND
    0= 0= 32 + EMIT 2 SPACES
    DUP @ 32767 AND
	DUP 6 .R 4 SPACES
    B/SCR /MOD 5 .R 4 SPACES 2 .R
    132 + ?TERMINAL IF LEAVE THEN
  LOOP DROP CR ;
BASE !
