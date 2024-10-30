( WIP - SED, FIG line editor enhanced )
( by bartgo, 2024, apx forth for atari 8-bit )
( ERRORS PRESENT AFTER MOVING TO EDITOR VOC )
( - better create basic EDITOR words in FORTH voc! )

FORTH DECIMAL EDITOR DEFINITIONS
: TASK ; : (NOP) ;
: EDIT SCR ! ;
: OKOFF ' (NOP)  CFA ' QUIT 26 + ! ;
: OKON  ' PROMPT CFA ' QUIT 26 + ! ;
: 5S 5 SPACES ;
: (SED) ( f scr -- )
  DECIMAL DUP EDIT 0 82 C! 125 EMIT
  32 ' C/L ! 5S . ." EDIT \E \U"
  CR DUP IF 5S ." \U ( Up )"
    ELSE 5S ." \D ( Down)" THEN
  CR 5S ." \S ( Save )" CR 5S ." \E ( Empty )"  
  0= IF 15 0 ELSE 31 16 THEN DO
    CR FORTH I EDITOR 2 .R SPACE ." P"
	SPACE FORTH I EDITOR SCR @ .LINE LOOP CR ;
: \S MARK FLUSH ;
: \E EMPTY-BUFFERS ;
: \Q \E 2 82 C! OKON 125 EMIT ;
: \D 1 SCR @ (SED) ;  
: \U 0 SCR @ (SED) ;
: SED OKOFF SCR ! \U ; 
