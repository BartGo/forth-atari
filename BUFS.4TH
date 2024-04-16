( https://vfxforth.com/flag/fd/FD-V03N6.pdf )

( .BUFS TDH 7/11/81 )
DECIMAL
: #BUFF ;
: .BUFS ( display adr of all buffers )
  CR ." #  Addr(hex) Upd  Block#  Screen   -sub"
  FIRST #BUFF 1+ 1 DO
  CR I 2 .R 2 SPACES
  DUP 2+ HEX 6 0 SWAP D.R DECIMAL 3 SPACES
  DUP @ 32768 AND
    0= 0= 32 + EMIT 2 SPACES
  DUP @ 32767 AND DUP 6 .R 4 SPACES
    B/SCR /MOD 5 .R 4 SPACES 2 .R
  132 + ?TERMINAL IF LEAVE THEN
  LOOP DROP CR ;
