( Display List Setup in )
( Atari 8-bit APX Forth )

VOCABULARY DISPLAY IMMEDIATE
DISPLAY DEFINITIONS DECIMAL

560 @ CONSTANT DL@
112   CONSTANT 8BL
65    CONSTANT JVB

: +LMS 64  + ;
: +DLI 128 + ;
: DL!  ( instr ofs -- )
  DL@ SWAP + C! ;
: DL? ( -- ; show DL )
  CR DL@ 32 0 DO
    DUP I + C? LOOP DROP CR ;
  
: GR0! ( -- )
  8BL    0 DL!
  8BL    1 DL!
  8BL    2 DL!
  2 +LMS 3 DL!
  64     4 DL!
  188    5 DL! ( BC40 )
  2 29 6 DO
    DUP I DL! 
  LOOP DROP
  JVB    29 DL!
  32     30 DL!
  188    31 DL! ; ( BC20 )
  
: A4!  ( -- )
  GR0!
  4 +LMS 3 DL!
  4 29 6 DO
    DUP I DL! 
  LOOP DROP ;
  
: 0/A4! ( line# -- ; flip GR0/A4 )
  DL@ SWAP + DUP @ 6 XOR SWAP C! ;

FORTH DEFINITIONS DECIMAL

;S
