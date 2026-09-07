
: PROGRAM ;

( RACING GAME DEMO )

{ $$../mods/DISPLAYLIST.FTH }
{ $$../variables/STRINGS.FTH }

36          CONSTANT WIDE
15          CONSTANT HIGH
WIDE HIGH * CONSTANT SIZE

0 VARIABLE ROAD$ SIZE ALLOT

: ROAD-FILL ( c -- )
  ROAD$ OVER SIZE SWAP FILL ;

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
  ROAD-INIT
  ROAD$ NEWDM SIZE CMOVE 
DECIMAL 

: (ROAD?) ( adr -- )
  CR HIGH 0 DO 
    DUP I WIDE * + WIDE TYPE
	CR LOOP DROP ;

: ROAD$? ( -- ) ROAD$ (ROAD?) ;
: NEWDM? ( -- ) NEWDM (ROAD?) ;
