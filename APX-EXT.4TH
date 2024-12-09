( -------------------- )
( APX Forth Extensions )
( -------------------- )


FORTH DEFINITIONS DECIMAL

: TUNINGS ;

: -->  DUP 2 * 712 C! [COMPILE] --> ; 

: LOAD DUP 2 * 712 C! [COMPILE] LOAD DECIMAL ;

: FRE 741 @ HERE - U. ." bytes free" ;

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

: (HELLO) ( -- )
  EMPTY-BUFFERS
  80 SCR ! 
  CR FRE
  CR ." In-memory MESSAGE enabled"
  CR ." Current Screen is #" SCR ?
  CR ." Type 'HELP' for help"
  CR QUIT ;
  
( // is a modified word (.") 
( but instead of printing, keeps
( the string in the dictionary
: // R COUNT DUP 1+ R> + >R
  DROP DROP ;

( '( is a modified version of ."
( but using // instead of (.")
( and used to put the string
( into the dictionary 
: '( STATE @ 0= IF
    ASCII ) WORD ELSE
    COMPILE // ASCII ) WORD HERE
    C@ 1+ ALLOT
  THEN ; IMMEDIATE

HEX

: ['] '( Compile tick: --)
  [COMPILE] ' ;
: XLIST '( Extended VLIST w/ compents: --)
  CR 80 OUT ! CONTEXT @ @ 
  CR ." Context Current: "
  CONTEXT @ 4 - NFA ID.
  CURRENT @ 4 - NFA ID. CR CR
  ." PFA  SI WORD CFA\PFA LNK-TO " CR
  ." ---------------------------" CR
  BEGIN
    OUT @ C/L 2 / > 0= IF CR 0 OUT ! THEN
    DUP PFA 4 .R SPACE 
    DUP @ 20 AND IF ." S" ELSE ." -" THEN
    DUP @ 40 AND IF ." I" ELSE ." -" THEN
    DUP SPACE ID. 
	DUP PFA CFA @ 
           DUP 1441 = IF ." :\"
      ELSE DUP 147D = IF ." CONSTANT\"
      ELSE DUP 1499 = IF ." VARIABLE\"
      ELSE DUP 14B2 = IF ." USER\"
      ELSE DUP 18D8 = IF ." DOES>\"
    THEN THEN THEN THEN THEN
	U.
	DUP PFA LFA @ DUP 0= IF
      ." \-- " DROP ELSE ." \" ID. THEN
	DUP PFA DUP @ [ ' // CFA ] LITERAL = IF
      CR 2+ COUNT TYPE CR 
	ELSE DROP THEN
    PFA LFA @ DUP 0= ?TERMINAL OR CR
  UNTIL DROP ;

( fig edit minimal subset in FORTH vocabulary )
: TEXT/ HERE C/L 1+ BLANKS WORD HERE PAD C/L 1+ CMOVE ;
: LINE/ DUP FFF0 AND 17 ?ERROR SCR @ (LINE) DROP ;
: -MOVE/ LINE/ C/L CMOVE UPDATE ; 
: | 1 TEXT/ PAD 1+ SWAP -MOVE/ ;
: XX LINE/ C/L BL FILL UPDATE ; 
: L. SCR @ LIST ; : FL. FLUSH ; : EB. EMPTY-BUFFERS ;
: N. 1 SCR +! L. ; : P. -1 SCR +! L. ;

DECIMAL

: (HOME) '( -- ; clear the screen )
  146 710 ! 125 EMIT ;

: (.S) '( -- ; display stack )
  40 EMIT SPACE
  SP@ 188 = 0= IF SP@ 2 - 186 DO
  I @ . -2 +LOOP THEN 41 EMIT SPACE ;

: (PROMPT) ( -- )
  0 IF (.S) THEN
  PFLAG @ 0 PFLAG ! ." ok" PFLAG ! ( prompt )
  BASE @ DUP 10 = IF DROP 0 THEN 712 C! ;  
  
: STACK '( -- ; toggle stack display )
  ' (PROMPT) @ ' 0 CFA = IF ' 1 ELSE ' 0 THEN
  CFA ' (PROMPT) ! ;

: .CC '( -- ; show CONTEXT and CURRENT)
  CR ." Context Current: "
  CONTEXT @ 4 - NFA ID.
  CURRENT @ 4 - NFA ID. CR ; 

: .BUFS ( -- )
( display addresses of all the buffers )
  CR ." #  Addr(hex) Upd Block#  Screen  -sub"
  FIRST
  LIMIT FIRST - B/BUF / ( #BUFF )
  1+ 1 DO
    CR I 2 .R 2 SPACES
    DUP 2+ HEX 6 0 SWAP D.R DECIMAL 3 SPACES
    DUP @ 32768 AND
    0= 0= 32 + EMIT 2 SPACES
    DUP @ 32767 AND
	DUP 6 .R 4 SPACES
    B/SCR /MOD 5 .R 4 SPACES 2 .R
    132 + ?TERMINAL IF LEAVE THEN
  LOOP DROP CR ;

: (FINDID.) ( addr -- )
  BEGIN
    DUP
    [ ' LIT LFA ] LITERAL
    = SWAP 1 - DUP 1+ @
    [ ' : CFA @ ] LITERAL
    = DUP IF
      OVER 1+ 0 4 D.R SPACE
    THEN ROT OR
  UNTIL 3 + NFA ID.
  CR ;

: (FINDNO) ( addr nl n2 -- )
  CR CR ." LOOKING FOR "
  DUP 0 4 D.R
  SPACE DUP 2+ NFA ID.
  CR ROT ROT OVER + SWAP
  DO DUP I @ = IF
    I 0 4 D.R SPACE
    I (FINDID.)
  THEN LOOP DROP ; 
  
: SCAN ( pfa -- )
  CFA
  ' LIT CFA ' LATEST CFA 
  ROT (FINDNO) ;
  
: HELP '( -- ; display help )
  CR ." Type VER for version"
  CR ." Type XLIST for enhanced VLIST"
  CR ." Type EDITOR for its help"
  CR ." Type STACK to toggle stack display"
  CR ." Type .CC for CONTEXT, CURRENT"
  CR ." Type .BUFS to show buffers"
  ( CR ." Type DECOMP ABC to decompile )
  CR ." Type ' ABC SCAN to locate uses"
  CR ." Type FRE for free bytes"
  CR ." Frame color depends on BASE 
  CR ." Kill: CLEAN FORGET TUNINGS SAVE COLD"
  CR CR ;

: EDITOR ( -- )
  CR ." 'n |'  to add text in line n (P)"
  CR ." 'n XX' to delete text in line n (E)"
  CR ." 'FL.'   to save (FLUSH)"
  CR ." 'EB.'  to undo (EMPTY-BUFFERS)"
  CR ." 'L.'   to LIST current screen"
  CR ." 'N.'/'P.' LIST next/previous screen"
  CR CR ;
  
: VER '( -- display version )
  CR ." ******************************"
  CR ." *  Extended Fig-Forth Rev.2  *"
  CR ."  by Patrick L. Mullarky, 1982 "
  CR ." published by Atari through APX"
  CR ."  2025 tunings collected by BG "
  CR ." ******************************"
  CR CR ;

: FLAVOR 
  ' (MESSAGE)
    CFA ' MESSAGE    ! ( was ' WARNING CFA )
  ' ;S        
    CFA ' MESSAGE 2+ ! ( was ' @ CFA )
  ' (PROMPT) CFA 7860 ! ( in QUIT )
  ' (HOME)   CFA 7884 ! ( in ABORT )
  ' (HELLO)  CFA 7913 ! ( in ABORT )
  ASCII x      7903 C! 
  ASCII 0      7904 C!  ;

: CLEAN 
  ' WARNING CFA ' MESSAGE    ! 
  ' @       CFA ' MESSAGE 2+ ! 
  ' PROMPT  CFA 7860 ! 
  ' CR      CFA 7884 ! 
  ' QUIT    CFA 7913 ! 
  BL 7903 C! 
  BL 7904 C! 
  148 710 !
  ' ASCII FENCE !  
  125 EMIT ;

: TASK ;
  
( FLAVOR SAVE COLD )


  
