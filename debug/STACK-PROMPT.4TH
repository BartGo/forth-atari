( Atari 8-bit APX Forth )

( stack and base display with prompt and color )
( DBG turns it on and off )

FORTH DEFINITIONS DECIMAL

: (.S) 
  40 EMIT SPACE
  SP@ 188 = 0= IF
    SP@ 2 - 186 DO
      I @ . -2
    +LOOP
  THEN
  41 EMIT SPACE ;

: (PROMPT)
  0 IF
    (.S) 35 EMIT
    BASE @ DUP DECIMAL .
    BASE !
  THEN 
  PFLAG @ 0 PFLAG ! ." ok"
  PFLAG ! BASE @
  DUP 10 = IF DROP 0   THEN
  DUP 16 = IF DROP 255 THEN
  712 C! ;

: DBG
  ' (PROMPT) @ ' 0 CFA = IF
    ' 1
  ELSE ' 0 0 712 C! THEN 
  CFA ' (PROMPT) ! ;

' (PROMPT) CFA ' QUIT 26 + ! 


