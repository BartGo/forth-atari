
( RACING GAME SANDBOX )

: PROGRAM ;

( *** STRINGS )

: (S") ( adr -- next-adr )
   R> COUNT 2DUP + >R ROT SWAP  
   OVER >R CMOVE R> ;

: S" ( -- adr )
  STATE @ IF COMPILE (S")
  ASCII " WORD HERE C@ 1+
  ALLOT ELSE ASCII " WORD HERE
  THEN ; IMMEDIATE
    
( *** DISPLAY LIST )

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
  
( *** CHECK IF PREREQ. MET )

: ) ;
: #PANIC( ( f -- )
  0= IF [COMPILE] ( ELSE
    CR CR
    ." COMPILATION PANIC AT "
    R U. CR CR
	BEGIN AGAIN THEN ; IMMEDIATE
: #KNOWN -FIND IF DROP DROP 1
  ELSE 0 THEN ;
  
( [ #KNOWN ASSEMBLER 0= ] #PANIC( ) 
( [ #KNOWN A4!       0= ] #PANIC( )
( [ #KNOWN S"        0= ] #PANIC( )

( *** MAIN MODULES *** ) 

36          CONSTANT WIDE
15          CONSTANT HIGH
WIDE HIGH * CONSTANT SIZE

0 VARIABLE ROAD$ SIZE ALLOT

: ROAD-FILL ( c -- )
  ROAD$ OVER SIZE SWAP FILL ;

: ROAD-INIT
  ROAD$
     0 + DUP S" -------------/--------\-------------"
  WIDE + DUP S" ----------.-/----..----\-.----------"
  WIDE + DUP S" -----------/------------\-----------"
  WIDE + DUP S" -------+--/------..------\--+-------"
  WIDE + DUP S" ---------/----------------\---------"
  WIDE + DUP S" --------/------------------\--------"
  WIDE + DUP S" ----|--/---------::---------\--|----"
  WIDE + DUP S" ------/----------------------\------"
  WIDE + DUP S" -----/------------------------\-----"
  WIDE + DUP S" --|-/----------- [] -----------\-|--"
  ( WIDE + DUP S" ----1----------- [] -----------\----"
  ( WIDE + DUP S" ----2----------- [] -----------\----"
  ( WIDE + DUP S" ----3----------- [] -----------\----"
  ( WIDE + DUP S" ----4----------- [] -----------\----"
  ( WIDE + DUP S" ----5----------- [] -----------\----"
  ( )
  DROP ;


HEX
  02E5 CONSTANT MEMTOP
  B7FF CONSTANT NEWTOP
  B800 CONSTANT NEWDL
  BA00 CONSTANT NEWDM
  NEWTOP MEMTOP !
  ROAD-INIT
  ROAD$ NEWDM SIZE CMOVE 
DECIMAL 

: (ROAD?) ( adr -- )
  CR HIGH 0 DO 
    DUP I WIDE * + WIDE TYPE
	CR LOOP DROP ;

: ROAD$? ( -- ) ROAD$ (ROAD?) ;
: NEWDM? ( -- ) NEWDM (ROAD?) ;

( *** MAIN )

: MAIN
  125 EMIT A4! ROAD$? ;
 
 
  
  
