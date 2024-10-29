( Atari 8-bit APX Forth )

( stack and base display with prompt )
( STACK turns it on and off )

: (.S) 
  40 EMIT SPACE
  SP@ 188 = 0= IF SP@ 2 - 186 DO
  I @ . -2 +LOOP THEN 41 EMIT SPACE ;
: (PROMPT) 0 IF
  (.S) 35 EMIT BASE @ DUP DECIMAL .
  BASE ! THEN PROMPT ;
: STACK
  ' (PROMPT) @ ' 0 CFA = IF ' 1 ELSE ' 0 THEN CFA ' (PROMPT) !
' (PROMPT) CFA ' QUIT  26 + ! 
