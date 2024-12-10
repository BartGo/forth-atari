( APX Extended Fig-Forth )
( & s*p*a*c*e fig4th 1.1 )
( 2025 Extensions -- WIP )

FORTH DEFINITIONS DECIMAL

: TASK ;
: TUNINGS ;

VOCABULARY EDITOR IMMEDIATE 
FORTH DEFINITIONS 

: FRE ( -- )
  741 @ HERE - U. ." bytes free" ;

: --> ( -- )
  SCR @ 1+ 2 * 712 C! [COMPILE] --> ; 

: LOAD ( -- ) 
  DUP 2 * 712 C! [COMPILE] LOAD
  DECIMAL ;

: (MESSAGE) ( n -- )
  DUP WARNING @ 0= IF
    ." MSG # " . CR DROP ;S ELSE DROP THEN
  DUP  4 = 0= IF 49 712 ! CR QUIT THEN ( TODO: ? )
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
  CR ." Current Screen is: #" SCR ?
  CR ." FLAVOR enabled, 'CLEAN' disables"
  CR ." Type 'HELP' for help"
  CR QUIT ;
  
( // is a modified word (.") 
( but instead of printing, keeps
( the string in the dictionary
: // R COUNT DUP 1+ R> + >R
  DROP DROP ;

( redefined as Space Forth won't have it )
: (ASCII) BL WORD HERE 1+ C@
  STATE @ IF COMPILE CLIT C,
  THEN ;  IMMEDIATE

( '( is a modified version of ."
( but using // instead of (.")
( and used to put the string
( into the dictionary 
: '( STATE @ 0= IF
    (ASCII) ) WORD ELSE
    COMPILE // (ASCII) ) WORD HERE
    C@ 1+ ALLOT
  THEN ; IMMEDIATE

HEX

: ['] [COMPILE] ' ;

: XLIST '( -- ; enhanced VLIST )
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


: RE-CREATE ( -- )
  -FIND 0= IF
    HERE COUNT TYPE ."  NOT FOUND" ABORT
  THEN
  DROP DUP CFA @ [ ' : CFA @ ] LITERAL = 0= IF
    HERE COUNT TYPE ."  NOT A COLON WORD" ABORT
  THEN HERE SWAP ! ;
: RE-EXIT ( -- ) R> R> 2DROP ;
: RE: ( -- )
  SP@ CSP ! CURRENT @ CONTEXT ! 
  RE-CREATE [ ' : CFA @ ] LITERAL , ] ;
: ;RE ( -- )
  ?CSP COMPILE RE-EXIT
  [COMPILE] [ ; IMMEDIATE
( : XX 1 . ; XX RE: XX 2 . ;RE XX


( fig edit minimal subset, in the FORTH vocabulary )
: TEXT/ HERE C/L 1+ BLANKS WORD HERE PAD C/L 1+ CMOVE ;
: LINE/ DUP FFF0 AND 17 ?ERROR SCR @ (LINE) DROP ;
: -MOVE/ LINE/ C/L CMOVE UPDATE ; 
: | 1 TEXT/ PAD 1+ SWAP -MOVE/ ; ( = P )
: XX LINE/ C/L BL FILL UPDATE ;  ( = E ) 
: L. SCR @ LIST ; : FL. FLUSH ; : EB. EMPTY-BUFFERS ;
: N. 1 SCR +! L. ; : P. -1 SCR +! L. ;
: WHERE DUP B/SCR / DUP SCR
    ! ." SCR # " DECIMAL .
    SWAP C/L /MOD C/L * ROT BLOCK +
    CR C/L -TRAILING TYPE CR
    HERE C@ - SPACES 1 2FE C!
    1C EMIT 0 2FE C! SP! QUIT ; 
: CLEAR ( n -- )
  SCR ! 10 0 DO I XX LOOP ; 
: CLEARS ( n m -- ) 
  DO I CLEAR FLUSH LOOP ; 
: COPY B/SCR * OFFSET @ + SWAP
  B/SCR * B/SCR OVER + SWAP DO
  DUP I BLOCK 2 - ! 1+ UPDATE
  LOOP DROP FLUSH ;
: #LOCATE R# @ C/L /MOD ;
: #LEAD #LOCATE LINE/ SWAP ;
: #LAG  #LEAD DUP >R + C/L R> - ;
: (1LINE) #LAG PAD COUNT MATCH R# +! ; 
: (M) R# +! CR SPACE #LEAD TYPE
  17 EMIT #LAG TYPE #LOCATE . DROP ;
: TOP 0 R# ! ; 

DECIMAL

( SEARCH SCREENS )
0 VARIABLE SRCHCNT
: (BUMP) 1 SRCHCNT +! SRCHCNT @ 56
    > IF 0 SRCHCNT ! CR THEN ;
: SEARCH '( from# to# -- string ; search within screens )
    CR 01 TEXT/ 0 SRCHCNT ! 1+ SWAP
    DO FORTH I SCR ! TOP BEGIN
      (1LINE) IF 0 (M) SCR ? (BUMP) THEN
    1023 R# @ < UNTIL LOOP ; 

: (HOME) ( -- )
  146 710 ! 125 EMIT ;

: (.S) '( -- ; display stack )
  40 EMIT SPACE
  SP@ 188 = 0= IF SP@ 2 - 186 DO
  I @ . -2 +LOOP THEN 41 EMIT SPACE ;

: (PROMPT) ( -- )
  0 IF (.S) THEN
  PFLAG @ 0 PFLAG ! ." ok"
  ' EDITOR CONTEXT @ 4 - = IF ." (editor)" THEN
  PFLAG ! ( prompt )
  BASE @ DUP 10 = IF DROP 0 THEN 712 C! ;  
: ok(editor) ; ( omit it like ok )  
  
: STACK '( -- ; toggle stack display )
  ' (PROMPT) @ ' 0 CFA = IF ' 1 ELSE ' 0 THEN
  CFA ' (PROMPT) ! ;

: .CC '( -- ; show CONTEXT and CURRENT)
  CR ." Context Current: "
  CONTEXT @ 4 - NFA ID.
  CURRENT @ 4 - NFA ID. CR ; 

: .BUFS '( -- ; show buffers )
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
  
: SCAN '( pfa -- ; where the word has been used? )
  CFA
  ' LIT CFA ' LATEST CFA 
  ROT (FINDNO) ;

( DOS-like DIR )
: (INDEX) ( scr -- ; commented lines #0 ) 
  DUP SCR ! 0 SWAP (LINE) SWAP DUP C@ ASCII (
  = 0= IF 2DROP ;S THEN CR ." #"
  SCR ? SWAP -TRAILING TYPE ;      
: INDICES ( 1st last -- ; INDEX on non-empty )
  1+ SWAP DO I (INDEX)
    ?TERMINAL IF LEAVE THEN LOOP ;
: DIR 0 89 INDICES ;
: D:  DR0 ;
: D1: DR0 ;
: D2: DR1 ;

( enable / disable "system bindings" )
: FLAVOR ( -- )
  ' (MESSAGE) CFA ' MESSAGE !
  ' ;S        CFA ' MESSAGE 2+ !
  ' (PROMPT)  CFA ' QUIT  26 + !
  ' (HOME)    CFA ' ABORT  6 + !
  ' (HELLO)   CFA ' ABORT 35 + !
  125 EMIT  
  ." FLAVOR is ON." CR FRE CR
  ." 'SAVE' and 'COLD' to proceed." CR CR ;
  
: CLEAN ( -- )
  ( ' WARNING CFA ' MESSAGE    ! )
  ( ' @       CFA ' MESSAGE 2+ ! )
  ' PROMPT  CFA ' QUIT 26 + ! 
  ' CR      CFA ' ABORT 6 + ! 
  ' QUIT    CFA ' ABORT 35 + ! 
  148 710 !
  ' TASK FENCE ! 125 EMIT
  ." FLAVOR is OFF." CR FRE CR
  ." 'FORGET TUNINGS' to purge if needed." CR
  ." 'SAVE' and 'COLD' to proceed." CR CR ;
  
EDITOR DEFINITIONS

 ( EDIT - BY M. DOUGHERTY )
 DECIMAL : CLS 125 EMIT ;
 752 CONSTANT CRSINH              59 CONSTANT HLP#               
 709 CONSTANT FNT#               710 CONSTANT BGR#
  18 CONSTANT TOP-BOT              2 CONSTANT REDGE
  22 CONSTANT LEDGE                0 VARIABLE SIDE 
  17 VARIABLE EXTRAOFF             0 VARIABLE STOP
   0 VARIABLE SAV-BUF 64 ALLOT  HLP# VARIABLE HLPM
   3 VARIABLE LINEOFF              3 VARIABLE CHAROFF 
   0 VARIABLE CLINE                0 VARIABLE CCHAR
: EREAD 16 0 DO I SCR @ (LINE) 
  DROP UPDATE DROP LOOP 0 CLINE ! 0 CCHAR ! 0 SIDE ! ; (FIXME )
: POINT-CURSOR 85 ! 84 C! ;     712 CONSTANT FRM#
: CURSOR@ CLINE @ LINEOFF @ +
  CCHAR @ SIDE @ IF 32 - ENDIF   CHAROFF @ + ;
: CURSOR CURSOR@ POINT-CURSOR ; 
: SCREEN-CURSOR CURSOR@ SWAP 40 * + 106 C@ 256 *
  960 - + DUP C@ 128 XOR SWAP C! ;
: HLINE 34 0 DO TOP-BOT EMIT LOOP ;
: LADDR CLINE @ SCR @ (LINE) DROP
  SIDE @ IF 32 + ENDIF ;
: EADDR CLINE @ SCR @ (LINE) DROP
  SIDE @ 0= IF 32 + ENDIF ;
: ELINE LEDGE EMIT LADDR 32 TYPE REDGE EMIT ;
: XLINE LEDGE EMIT EADDR 32 TYPE REDGE EMIT ;
: WRITE-LINE CLINE @ LINEOFF @ + CHAROFF @ 1 -
  POINT-CURSOR ELINE ;
: WRITE-EXTRA EXTRAOFF @ LINEOFF @ + CHAROFF @ 1 -
  POINT-CURSOR XLINE ; : FRE 741 @ HERE - ;
: 2TOP LINEOFF @ 1 - CHAROFF @ 1 - POINT-CURSOR HLINE ; 
: BOT LINEOFF @ 16 + CHAROFF @ 1 - POINT-CURSOR HLINE ; 
: ETITLE 0 CHAROFF @ POINT-CURSOR ." EDIT / Dr" 
  OFFSET @ 0= 0= . ." Scr" 
  SCR ? ." Side" SIDE
  ? ." Free" FRE U. ; 
: DISPLAY CLS 1 CRSINH C! ETITLE 2TOP CLINE @ 
  16 0 DO I CLINE ! WRITE-LINE LOOP CLINE !
  SIDE @ IF 32 ELSE 0 ENDIF CCHAR ! BOT
  WRITE-EXTRA CURSOR SCREEN-CURSOR ;
: ANYK CR ." (Return)" KEY DROP ; : ANYKD ANYK DISPLAY ;
: CASES ?COMP CSP @ !CSP 4 ; IMMEDIATE
: CASE 4 ?PAIRS COMPILE OVER COMPILE =
  COMPILE 0BRANCH HERE 0 , COMPILE DROP 5 ; IMMEDIATE
: IS 5 ?PAIRS COMPILE BRANCH HERE 0 ,
  SWAP 2 [COMPILE] ENDIF 4 ; IMMEDIATE
: END-CASES 4 ?PAIRS COMPILE DROP
  BEGIN SP@ CSP @ = 0= WHILE
  2 [COMPILE] ENDIF REPEAT
  CSP ! ; IMMEDIATE
: MOVE-RIGHT CCHAR @ 1 + SIDE @ IF
  DUP 64 = IF DROP 32 ENDIF ELSE
  DUP 32 = IF DROP 0  ENDIF ENDIF
  CCHAR ! ;
: RIGHT MOVE-RIGHT SCREEN-CURSOR ;
: RIGHT-CURSOR SCREEN-CURSOR RIGHT ;
: MOVE-LEFT CCHAR @ 1 - SIDE @ IF
  DUP 31 = IF DROP 63 ENDIF ELSE
  DUP -1 = IF DROP 31 ENDIF ENDIF
  CCHAR ! ; 
: LEFT MOVE-LEFT SCREEN-CURSOR ; 
: LEFT-CURSOR SCREEN-CURSOR LEFT ;
: MOVE-UP CLINE @ 1 - 15 AND
  CLINE ! WRITE-EXTRA ;
: EUP MOVE-UP SCREEN-CURSOR ;
: UP-CURSOR SCREEN-CURSOR EUP ;
: MOVE-DOWN CLINE @ 1 + 15 AND
  CLINE ! WRITE-EXTRA ;
: DOWN MOVE-DOWN SCREEN-CURSOR ;
: DOWN-CURSOR SCREEN-CURSOR DOWN ;
: RETURN SCREEN-CURSOR SIDE @ IF
  32 ELSE 0 ENDIF CCHAR ! DOWN ;
: EABORT EMPTY-BUFFERS 1 STOP ! [COMPILE] FORTH ;
: FLASH FRM# @ 255 XOR FRM# ! ; ( FIXME )
: BEEPF BEEP FLASH ; 
: SH CLS 0 CRSINH C! IN @ >R BLK @ >R 0 IN ! 
  0 BLK ! CR QUERY INTERPRET R> BLK ! R> IN ! ANYKD ; 
: UNDOSCR EMPTY-BUFFERS SCR +! EREAD DISPLAY ; ( n -- )
: ENEXT  1 UNDOSCR ; 
: ELAST -1 UNDOSCR ; 
: ADDR CLINE @ SCR @ (LINE) DROP CCHAR @ + ; ( UPDATE HERE? )
: ADDKEY DUP ADDR C! CURSOR EMIT RIGHT ;
: CHSIDE SIDE @ 1 XOR SIDE ! DISPLAY ;
: INSERT-CHAR ADDR SWAP CCHAR @ -
  SWAP OVER + SWAP -DUP IF 0 DO
  DUP 1 - C@ OVER C! 1 - LOOP ENDIF BL SWAP C! ;
: INSERT SIDE @ IF 63 ELSE 31 ENDIF 
  INSERT-CHAR WRITE-LINE CURSOR SCREEN-CURSOR ;
: HLP 
  125 EMIT
 ." ( EDIT - HELP ) --> Esc-H: help" CR
 ." Arrows, Ins, BckSp, Tab: normal" CR
 ." Esc-Q:  quit (empty-buffers)" CR
 ." Esc-S:  save (flush)" CR
 ." Esc-Z:  undo (empty-buffers) " CR
 ." Return: next line" CR
 ." Shf-Ins: ins ln*; Esc-1:5: plgns" CR
 ." Shf-Del: del ln*; Esc-T/F: color" CR
 ." Esc-V: ins last del ln*" CR
 ." Esc-B: forth command line" CR
 ." Esc-R: rotate/sides     ( / )" CR
 ." Esc-N: screen+1/empt-bf ( > )" CR
 ." Esc-L: screen-1/empt-bf ( < )" CR
 ." Ctl-Ins: ins space; " CR
 ." Ctl-BckSpc: del;  Esc-0: cold" CR
 ." Clear: clear screen (Shf> Ctl>)" CR
    ANYKD DISPLAY ; 
: DELETE-CHAR ADDR SWAP CCHAR @ -
  -DUP IF 0 DO DUP 1 + C@ OVER C!
  1 + LOOP ENDIF BL SWAP C! ;
: DELETE SIDE @ IF 63 ELSE 31 ENDIF
  DELETE-CHAR WRITE-LINE CURSOR SCREEN-CURSOR ;
: L-A SCR @ (LINE) DROP ;
: DELETE-L CLINE @ L-A SAV-BUF 64 CMOVE
  15 CLINE @ - IF 15 CLINE @ DO
  I 1+ L-A I L-A 64 CMOVE LOOP ENDIF
  15 L-A 64 BLANKS ;
: INSERT-L 15 CLINE @ - IF
  CLINE @ 15 DO I 1 - L-A I L-A 64 CMOVE
  -1 +LOOP ENDIF CLINE @ L-A 64 BLANKS ;
: INSERT-LINE INSERT-L DISPLAY ;
: DELETE-LINE DELETE-L DISPLAY ; 
: PUT-LINE INSERT-L SAV-BUF CLINE @
  L-A 64 CMOVE DISPLAY ;
: TAB 2 0 DO RIGHT-CURSOR LOOP ;
: DEL LEFT-CURSOR BL DUP ADDR C!
  CURSOR EMIT SCREEN-CURSOR ;
: CLEAR-SCR 
  16 0 DO I L-A 64 BLANKS LOOP DISPLAY ; 
: THEME DUP C@ 148 XOR SWAP C! ; 
: SAVESCR FLUSH EREAD DISPLAY  ; 
: BGRC 710 THEME ;    : FNTC 709 THEME ;
: PIN1 CLS VLIST        ANYKD ; ( vlist )
: PIN2 CLS SCR @ LIST   ANYKD ; ( list  )
: PIN3 CLS SCR @ TRIAD  ANYKD ; ( triad )
: PIN4 CLS DR0 18 SCR ! ANYKD ; ( set DR0, 18th screen )
: PIN5 CLS SCR @ LOAD   ANYKD ; ( load  )
: REVB FRM# @ 128 XOR FRM# ! ;  ( reverse frame when Esc )
: ESC REVB KEY CASES
    82 CASE CHSIDE    IS ( R )  47 CASE CHSIDE IS  ( / )
    78 CASE ENEXT     IS ( N )  62 CASE ENEXT  IS  ( > )
    76 CASE ELAST     IS ( L )  60 CASE ENEXT  IS  ( < )
    83 CASE SAVESCR   IS ( S )  49 CASE PIN1   IS  ( 1 )           
    81 CASE EABORT    IS ( Q )  50 CASE PIN2   IS  ( 2 )           
    86 CASE PUT-LINE  IS ( V )  51 CASE PIN3   IS  ( 3 )           
    90 CASE 0 UNDOSCR IS ( Z )  52 CASE PIN4   IS  ( 4 ) 
    66 CASE SH        IS ( B )  53 CASE PIN5   IS  ( 5 ) 
    48 CASE BOOT      IS ( 0 )  84 CASE BGRC   IS  ( T )
    72 CASE HLP       IS ( H )  70 CASE FNTC   IS  ( F )
  BEEPF END-CASES REVB ;
: DEEP SP@ 12 +ORIGIN @ SWAP - 2 / ; ( if no DEPTH dfnd )
: SETSCR DEEP 0= IF HLP# ENDIF SCR ! ;  
: EDIT '( m -- ; edit screen m with MDEDIT )
  SETSCR EREAD DISPLAY 0 STOP ! BEGIN
    KEY CASES
      27  CASE ESC          IS  155 CASE RETURN      IS
      28  CASE UP-CURSOR    IS  29  CASE DOWN-CURSOR IS
      31  CASE RIGHT-CURSOR IS  30  CASE LEFT-CURSOR IS
      255 CASE INSERT       IS  254 CASE DELETE      IS
      157 CASE INSERT-LINE  IS  156 CASE DELETE-LINE IS
      126 CASE DEL          IS  127 CASE TAB         IS
      125 CASE CLEAR-SCR IS 
      DUP ADDKEY 
    END-CASES
  STOP @ UNTIL   
  CLS 0 CRSINH ! ;   

FORTH DEFINITIONS
 
: ED-HELP '( -- ; display FIG EDITOR help )
  CR ." m SCR ! -> select screen m"
  CR ." --------- BASIC FIG EDITOR
  CR ." n |     -> add text in line n (P)"
  CR ." n XX    -> delete text in line n (E)"
  CR ." FL.     -> save (FLUSH)"
  CR ." EB.     -> undo (EMPTY-BUFFERS)"
  CR ." L.      -> LIST current screen"
  CR ." N. / P. -> LIST next/previous screen"
  CR ." --------- ADVANCED EDITOR (MDEDIT)"
  CR ." EDITOR  -> enable advanced editor"
  CR ." m EDIT  -> edit screen m"
  CR ."            Esc+H opens help"
  CR ."  FORTH  -> disable advanced editor"
CR CR ;
  
: VER '( -- ; display version )
  CR ." ******************************"
  CR ." *  Extended Fig-Forth Rev.2  *"
  CR ."  by Patrick L. Mullarky, 1982 "
  CR ." published by Atari through APX"
  CR ."  2025 tunings collected by BG "
  CR ." ******************************"
  CR CR ;

: HELP '( -- ; display help )
  CR ." VER for version"
  CR ." XLIST for enhanced VLIST"
  CR ." ED-HELP for screen editing help"
  CR ." STACK to toggle stack display"
  CR ." .CC for CONTEXT and CURRENT info"
  CR ." .BUFS to show disc buffers"
  ( CR ." DECOMP ABC to decompile )
  CR ." FRE to show free bytes"
  CR ." ' aaa SCAN to locate uses of aaa"
  CR ." n m SEARCH aaa to search screens"
  CR ." D1:/D2:/DIR to browse floppies"
  CR ." RE: and ;RE to redefine"
  CR CR ;

( FLAVOR SAVE COLD ) 
