( Display List Setup in )
( Atari 8-bit APX Forth )

VOCABULARY DISPLAY IMMEDIATE
DISPLAY DEFINITIONS DECIMAL

112   CONSTANT 8BL
65    CONSTANT JVB

: DL@ 560 @ ;
: DL? ( -- ; show DL )
  CR DL@ 32 0 DO
    DUP I + C? LOOP DROP CR ;
: DL!  ( instr ofs -- )
  DL@ SWAP + C! ;
: +LMS 64  + ;
: +DLI 128 + ;
  
: GR0! ( -- )
  8BL    0 DL!
  8BL    1 DL!
  8BL    2 DL!
  2 +LMS 3 DL!
  64     4 DL!
  188    5 DL!    ( BC40 )
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
  DL@ SWAP + DUP C@ 6 XOR SWAP C! ;
  
: A4/5! 
  DL@ SWAP + DUP C@ 1 XOR SWAP C! ;

FORTH DEFINITIONS DECIMAL

( string handling routines )

: (S") ( adr -- next-adr )
   R> COUNT  
   2DUP + >R 
   ROT SWAP  
   OVER >R   
   CMOVE R> ;

: S" ( -- adr )
   STATE @ IF
     COMPILE (S") ASCII "
     WORD HERE C@ 1+ ALLOT
   ELSE
     ASCII " WORD HERE
  THEN ; IMMEDIATE

( the program itself )

36          CONSTANT WIDE
15          CONSTANT HIGH
WIDE HIGH * CONSTANT SIZE

0 VARIABLE ROAD$ SIZE ALLOT

: ROAD-FILL ( c -- )
  ROAD$ OVER SIZE SWAP FILL ;

: ROAD? ( -- )
  CR HIGH 0 DO 
    ROAD$ I WIDE * + WIDE TYPE
	CR LOOP ;

: ROAD-INIT
  ROAD$
     0 + DUP S" -------------/--------\-------------"
  WIDE + DUP S" ------------/----------\------------"
  WIDE + DUP S" -----------/------------\-----------"
  WIDE + DUP S" ----------/--------------\----------"
  WIDE + DUP S" ---------/-------..-------\---------"
  WIDE + DUP S" --------/------------------\--------"
  WIDE + DUP S" -------/---------::---------\-------"
  WIDE + DUP S" ------/----------------------\------"
  WIDE + DUP S" -----/-----------[]-----------\-----"
  WIDE + DUP S" ----/----------- [] -----------\----"
  WIDE + DUP S" ----1----------- [] -----------\----"
  WIDE + DUP S" ----2----------- [] -----------\----"
  WIDE + DUP S" ----3----------- [] -----------\----"
  WIDE + DUP S" ----4----------- [] -----------\----"
  WIDE + DUP S" ----5----------- [] -----------\----"
  DROP ;

HEX
  02E5 CONSTANT MEMTOP
  B7FF CONSTANT NEWTOP
  B800 CONSTANT NEWDL
  BA00 CONSTANT NEWDM
  NEWTOP MEMTOP !
  ROAD$ MYDM SIZE CMOVE 
DECIMAL 
