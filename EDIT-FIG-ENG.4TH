( WIP - SED, FIG line editor enhanced )
( by bartgo, 2024, apx forth for atari 8-bit )

( NOTE:  27 LOAD or implement P, E from below & test )
( HEX
( : TEXT HERE C/L 1+ BLANKS WORD HERE PAD C/L 1+ CMOVE ;
( : LINE DUP FFF0 AND 17 ?ERROR SCR @ (LINE) DROP ;
( : -MOVE LINE C/L CMOVE UPDATE ; 
( : P 1 TEXT PAD 1+ SWAP -MOVE ;
( : E LINE C/L BL FILL UPDATE ; 
( DECIMAL
( FIXME: edit in lines 16-31 does not work )

FORTH DECIMAL 32 ' C/L ! 
EDITOR DEFINITIONS : TASK ;
: AT 84 C! 85 C! ;
: OK-OFF ' TASK   CFA ' QUIT 26 + ! ;
: OK-ON  ' PROMPT CFA ' QUIT 26 + ! ;
: X5 CR 5 SPACES ;
: (E) ( f scr -- )
  0 82 C! 125 EMIT
  DUP SCR ! 
  X5 .  ." SCR ! \E \U"
  X5 DUP IF ." \U ( Up"
     ELSE   ." \D ( Down" THEN
  X5 ." \S ( Save"
  X5 ." \E ( Empty"  
  X5 ." \Q ( Quit"  
  0= IF 16 0 ELSE 32 16 THEN DO 
    CR FORTH I EDITOR
	DUP 2 .R SCR @ (LINE) -TRAILING 
	DUP 0 >	IF ."  P " ELSE ."  E "
	THEN TYPE
  LOOP 5 6 AT ;
: \U 0 SCR @ (E) ;
: \D 1 SCR @ (E) ;  
: \S MARK FLUSH ;
: \E EMPTY-BUFFERS \U ;
: \Q \E 2 82 C! OK-ON 125 EMIT ;
: SED OK-OFF SCR ! \U ; 
: EDIT SED ;


  
