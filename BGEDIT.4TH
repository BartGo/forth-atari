( BGEDIT: "scr EDIT" ) 
( by bartgo, 2024, apx forth for atari 8-bit )
( includes many pieces of fig editor, by FIG )

( FIXME: SAVES ASCII 0 FOR EMPTY LINES )

FORTH DEFINITIONS DECIMAL
32 ' C/L !  ( shorter lines )
32 10233 C! ( LIST to know that )
: TASK ;

HEX

( tuned fig editor )

VOCABULARY EDITOR IMMEDIATE 
EDITOR DEFINITIONS 

: TEXT HERE C/L 1+ BLANKS
  WORD HERE PAD C/L 1+ CMOVE ;
: LINE DUP FFE0 AND 11 ?ERROR
  SCR @ (LINE) DROP ;
: -MOVE LINE C/L CMOVE UPDATE ; 
: H LINE PAD 1+ C/L DUP PAD C! CMOVE ;
: MARK 20 0 DO I LINE UPDATE DROP LOOP ;
: E LINE C/L BL FILL UPDATE ;
: P 1 TEXT PAD 1+ SWAP -MOVE ;
: | P ; ( FIXME: SAVES ASCII 0 )
: CLEAR ( n -- )
  SCR ! 20 0 DO I E LOOP ; 
: CLEARS ( n m -- ) 
  DO I CLEAR FLUSH LOOP ; 
: COPY B/SCR * OFFSET @ + SWAP
  B/SCR * B/SCR OVER + SWAP DO
    DUP I BLOCK 2 - ! 1+ UPDATE
  LOOP DROP FLUSH ;
: #LOCATE R# @ C/L /MOD ;
: #LEAD #LOCATE LINE SWAP ;
: #LAG  #LEAD DUP >R + C/L R> - ;
: 1LINE #LAG PAD COUNT MATCH R# +! ; 
: M R# +! CR SPACE #LEAD TYPE
  1B EMIT 1E EMIT #LAG TYPE #LOCATE . DROP ;
: T DUP C/L * R# ! DUP H 0 M ;
: TOP ( -- ) 0 R# ! ; 
: WHERE DUP B/SCR / DUP SCR
  ! ." SCR # " DECIMAL .
  SWAP C/L /MOD C/L * ROT BLOCK +
  CR C/L -TRAILING TYPE CR
  HERE C@ - SPACES 1 2FE C!
  1C EMIT 0 2FE C! SP! QUIT ; 
( end fig edit )

DECIMAL

0 VARIABLE SRCHCNT
: BUMP 1 SRCHCNT +! SRCHCNT @ 56
  > IF 0 SRCHCNT ! CR THEN ;
: SEARCH ( FROM TO -- STRING )
  125 EMIT CR 01 TEXT 0 SRCHCNT ! 1+ SWAP
  DO FORTH I EDITOR SCR ! TOP BEGIN
    1LINE IF 0 M SCR ? BUMP THEN
  1023 R# @ < UNTIL LOOP
  CR ." n EDIT to proceed with editing..." CR ; 

: (OK-OFF) ( -- )
  ' TASK CFA ' QUIT 26 + ! ;
: (OK-ON)  ( -- )
  ' PROMPT CFA ' QUIT 26 + ! ;
: (>)     ( -- )
  5 0 DO 31 EMIT LOOP  ; 
: (BAR)    ( -- )
  CR CR 3 SPACES ." ( " 7 0 DO
    ." ----" LOOP ." ----" ;
: (E)      ( f scr -- )
  125 EMIT 
  DUP SCR !
     (>) ."  ( *EDIT*  \N=Next \P=Prev )"
  CR (>) ."  ( \S=Save \U=Undo \Q=Quit )" 
  CR (>) ."  ( n m SEARCH XYZ searches )" 
  CR (>) 2 SPACES
      .  ." SCR ! EMPTY-BUFFERS UL" 
  CR (>) DUP IF
          ."  UL ( see Upper Lines / LL )"
  ELSE
          ."  LL ( see Lower Lines / UL )"
  THEN (BAR)
  0= IF 16 0 ELSE 32 16 THEN DO 
    CR FORTH I EDITOR DUP 2 .R SCR @
	(LINE) -TRAILING ."  | " TYPE
  LOOP 6 84 C! (>) ;
: UL  0 SCR @  (E) ;
: LL  1 SCR @  (E) ;  
: \N  1 SCR +! (E) ;
: \P -1 SCR +! (E) ;
: \S MARK FLUSH ;
: \Q EMPTY-BUFFERS (OK-ON) 2 82 C! 125 EMIT ;

: EDIT ( scr -- )
  (OK-OFF) 0 82 C!
  SCR ! UL ; 

;S

17 EDIT
