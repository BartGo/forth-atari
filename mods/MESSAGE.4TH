( static MESSAGE / ERROR to avoid screen usage )
( APX Forth for Atari 8-bit )

: (MESSAGE) ( n -- )
  DUP WARNING @ 0= IF
    ." MSG # " . CR DROP ;S ELSE DROP THEN
  DUP  1 = IF ." Stack empty" CR DROP ;S THEN
  DUP  2 = IF ." Dictionary full" CR DROP ;S THEN
  DUP  3 = IF ." Wrong address mode" CR DROP ;S THEN
  DUP  4 = IF ." Isn't unique" CR DROP ;S THEN
  DUP  5 = IF ." Value error" CR DROP ;S THEN
  DUP  6 = IF ." Disk address error" CR DROP ;S THEN
  DUP  7 = IF ." Stack full" CR DROP ;S THEN
  DUP  8 = IF ." Disk Error!" CR DROP ;S THEN
  DUP 17 = IF ." Use only in Definitions" CR DROP ;S THEN
  DUP 18 = IF ." Execution only" CR DROP ;S THEN
  DUP 19 = IF ." Conditionals not paired" CR DROP ;S THEN
  DUP 20 = IF ." Definition not finished" CR DROP ;S THEN
  DUP 21 = IF ." In protected dictionary" CR DROP ;S THEN
  DUP 22 = IF ." Use only when loading" CR DROP ;S THEN
  DUP 23 = IF ." Off current screen" CR DROP ;S THEN
  DUP 24 = IF ." Declare VOCABULARY" CR DROP ;S THEN
  DROP ;

' (MESSAGE) CFA ' MESSAGE    ! ( was ' WARNING CFA )
' ;S        CFA ' MESSAGE 2+ ! ( was ' @ CFA )

;S ( end )

Messages from the OOTB APX Forth: 14 LIST 15 LIST

SCR # 14 
  0 ( ERROR MESSAGES )
  1 Stack empty
  2 Dictionary full
  3 Wrong address mode
  4 Isn't unique
  5 Value error
  6 Disk address error
  7 Stack full
  8 Disk Error!

SCR # 15 
  0 ( ERROR MESSAGES )
  1 Use only in Definitions
  2 Execution only
  3 Conditionals not paired
  4 Definition not finished
  5 In protected dictionary
  6 Use only when loading
  7 Off current screen
  8 Declare VOCABULARY
