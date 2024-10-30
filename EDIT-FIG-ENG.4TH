( WIP - SED, FIG line editor enhanced )
( by bartgo, 2024, apx forth for atari 8-bit )

FORTH DECIMAL EDITOR DEFINITIONS
32 ' C/L ! 
: TASK ;
: AT 84 C! 85 C! ;
: OK-OFF ' TASK   CFA ' QUIT 26 + ! ;
: OK-ON  ' PROMPT CFA ' QUIT 26 + ! ;
: X5 CR 5 SPACES ;
: (E) ( f scr -- )
  0 82 C! 125 EMIT
  DUP SCR ! 
  X5 .  ." SCR ! \E \U"
  X5        ." \S ( Save"
  X5        ." \E ( Empty"  
  X5 DUP IF ." \U ( Up"
     ELSE   ." \D ( Down" THEN
  X5        ." \Q ( Quit"  
  0= IF 15 0 ELSE 31 16 THEN DO
    CR FORTH I EDITOR 2 .R SPACE ." P"
    SPACE FORTH I EDITOR SCR @ .LINE
  LOOP 5 6 AT ;
: \S MARK FLUSH ;
: \E EMPTY-BUFFERS ;
: \U 0 SCR @ (E) ;
: \D 1 SCR @ (E) ;  
: \Q \E 2 82 C! OK-ON 125 EMIT ;
: SED OK-OFF SCR ! \U ; 
