( * APX Extended Fig-Forth /IDE combined for ATARI 8-BIT * )
( from multiple 1980s/90s sources, mainly Forth Dimensions ) 

( todo: consider RDCP instead of GOESINTO  )
( todo: document compilation of below      )

FORTH DEFINITIONS DECIMAL
ASCII e 7903 C! 
ASCII 3 7904 C! ( version 1.1e3 )
0 WARNING !

: CORE ;
( 40 LOAD ) ( <-- load assembler - manually! )
( 50 LOAD ) ( <-- load graphics  - manually! )

: EXTENSIONS ;
VOCABULARY EDITOR IMMEDIATE
FORTH DEFINITIONS 

: VER ( -- ; display version )
  CR
  CR ."    =============================="
  CR ."       Extended Fig-Forth Rev.2   "
  CR ."     by Patrick L. Mullarky, 1982 "
  CR ."    published by Atari through APX"
  CR ."    ------------------------------"
  CR ."        EDIT - by M. Dougherty    "
  CR ."    as published in: 'Micro 6502' "
  CR ."       (no. 57 - February 1983)   "
  CR ."    ------------------------------"
  CR ."    Additional tools from magazine"
  CR ."    Forth Dimensions, collected & "
  CR ."    extended by BartGo, Sept. 2025"
  CR ."    =============================="
  CR ."    For the glory of Atari & Forth"
  CR ."    & PTODT (https://ptodt.org.pl)"  
  CR ."    =============================="
  CR CR ;

: .FRE ( -- )
  741 @ HERE - U. ." bytes free" ;

: BEEP 253 EMIT ;

( static messages are needed as a bigger kernel overwrites )
( first screens, including those with messages )
( an alternative would be to move messages to the last screens )
: (MESSAGE) ( n -- )
  ( blink red on real err, orange on warning / msg 4 )
  710 @ SWAP DUP 4 = 0= IF
    49 710 ! ELSE 20 710 !
  THEN BEEP SWAP 710 ! ( n )
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
  DROP CR ;

' (MESSAGE) CFA ' MESSAGE    ! ( ex: WARNING )
' ;S        CFA ' MESSAGE 2+ ! ( ex: @ )

: (HELLO) ( -- )
  EMPTY-BUFFERS 80 SCR ! 
  CR .FRE
  CR ." Screen set to #" SCR ?
  CR ." Type 'HELP' for help"
  CR QUIT ;

HEX
( Re-Defining a Colon Word )
( by E. H. Schmauch, FDv6n3p20 )
: (RE-CREATE) ( -- )
  -FIND 0= IF
    HERE COUNT TYPE ."  NOT FOUND" ABORT
  THEN
  DROP DUP CFA @ [ ' : CFA @ ] LITERAL = 0= IF
    HERE COUNT TYPE ."  NOT A COLON WORD" ABORT
  THEN HERE SWAP ! ;
: (RE-EXIT) ( -- ) R> R> 2DROP ;
: RE: ( -- )
  SP@ CSP ! CURRENT @ CONTEXT ! 
  (RE-CREATE) [ ' : CFA @ ] LITERAL , ] ;
: ;RE ( -- )
  ?CSP COMPILE (RE-EXIT)
  [COMPILE] [ ; IMMEDIATE
( : XX 1 . ; XX RE: XX 2 . ;RE XX )

HEX
( FIG edit minimal subset, in the FORTH vocabulary )
: TEXT/ HERE C/L 1+ BLANKS WORD HERE PAD C/L 1+ CMOVE ;
: LINE/ DUP FFF0 AND 17 ?ERROR SCR @ (LINE) DROP ;
: -MOVE/ LINE/ C/L CMOVE UPDATE ; 
: & 1 TEXT/ PAD 1+ SWAP -MOVE/ ; ( = P )
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

( Search )
( John S. James, FDv2N6p165 with errata )
0 VARIABLE SRCHCNT
: (BUMP) 1 SRCHCNT +! SRCHCNT @ 56
    > IF 0 SRCHCNT ! CR THEN ;
: SEARCH ( from# to# -- string ; search within screens )
    CR 01 TEXT/ 0 SRCHCNT ! 1+ SWAP
    DO FORTH I SCR ! TOP BEGIN
      (1LINE) IF 0 (M) SCR ? (BUMP) THEN
    1023 R# @ < UNTIL LOOP ; 

: (HOME) ( -- )
  146 710 ! 125 EMIT ;

: S0 18 +ORIGIN @ ; ( -- n )
: R0 20 +ORIGIN @ ; ( -- n )

: .S ( -- ; display stack )
  40 EMIT SPACE
  SP@ 188 = 0= IF SP@ 2 - 186 DO
  I @ . -2 +LOOP THEN 41 EMIT SPACE ;

: S. .S ; ( -- ; an alias for .S )

: (REFRM) ( -- )
  BASE @ DUP 10 = IF DROP 0 THEN 712 C! ;

: (PROMPT) ( -- )
  0 IF .S THEN
  PFLAG @ 0 PFLAG ! ." ok"
  ' EDITOR CONTEXT @ 4 - = IF ." -editor" THEN
  PFLAG ! ( prompt )
  (REFRM) ;  
: ok-editor ; ( omit it like ok )  
  
: STACK ( -- ; toggle stack display )
  ' (PROMPT) @ ' 0 CFA = IF ' 1 ELSE ' 0 THEN
  CFA ' (PROMPT) ! ;

( blink border while loading )
: --> ( -- )
  SCR @ 1+ 2 * 712 C! [COMPILE] --> (REFRM) ; 

( blink border while loading )
: LOAD ( n -- ) 
  DUP 2 * 712 C! [COMPILE] LOAD DECIMAL (REFRM) ;

( load screens nl thru n2 inclusive )
: THRU ( nl n2 -- ) 
  1+ SWAP DO I LOAD LOOP ;
  
: .CC ( -- ; show CONTEXT and CURRENT)
  CR ." Context Current: "
  CONTEXT @ 4 - NFA ID.
  CURRENT @ 4 - NFA ID. CR ; 

( Diagnostics on Disk Buffers )
( Timothy Huang, FDv3nr6p183 )
: .BUFS ( -- ; show buffers )
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

0 VARIABLE BUFCHANGE
: .BUFSTAT ( -- ) ( simplified .BUFS )
  0 BUFCHANGE !
  FIRST LIMIT FIRST - B/BUF /
  1+ 1 DO
	DUP @ 32768 AND 0= 0= IF
	  1 BUFCHANGE +! THEN
	132 + 
  LOOP DROP
  BUFCHANGE @ IF ."  unsaved "
    ELSE ."  (saved) " THEN CR ;

( *** )
( KEYWORDS - WHERE USED
( FD VOL VII, NO 1
( COPYRIGHT [C] 1983
( by Nicholas L. Pappas, PhD
( + SCAN macro by BartGo
( how to run, example: ' WORD SCAN
( *** )
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
  CFA            ( n1 )
  ' LIT CFA      ( n1 n2 )
  LATEST PFA CFA ( n1 n2 n3 )
  ROT (FINDNO) ;

( DOS-like DIR )
: (INDEX) ( scr -- ; commented lines #0 ) 
  DUP SCR ! 0 SWAP (LINE) SWAP DUP C@ ASCII (
  ( ) 
  = 0= IF 2DROP ;S THEN CR ." #"
  SCR ? SWAP -TRAILING TYPE ;      
: INDICES ( 1st last -- ; INDEX on non-empty )
  1+ SWAP DO I (INDEX)
    ?TERMINAL IF LEAVE THEN LOOP ;
: DIR 0 89 INDICES ; 
: D:  DR0 ; : D1: DR0 ; : D2: DR1 ;

( most basic string operations )
: $" ( $ -- ; define counted string )
  ASCII " WORD HERE COUNT ROT OVER
  OVER C! 1+ SWAP CMOVE ; IMMEDIATE
: CTYPE ( a -- ; type counted )
  COUNT TYPE ; 
: ZTYPE ( n -- ; type zeroed )
  0 ENCLOSE     ( a n1 n2 n3 )
  ROT DROP DROP ( a ct )
  TYPE ;
: CZ! ( a1 -- ) ( convert counted to zeroed )
  DUP COUNT ( a1 a1' ct )
  ROT SWAP  ( a1' a1 ct )
  2DUP + >R ( a1' al ct R: al+ct )
  CMOVE     ( R: al+ct )
  0 R> C! ; ( -- )  
 
( tests )
( 0 VARIABLE A$ 80 ALLOT 
( 0 VARIABLE B$ 80 ALLOT 
( A$ $" HELLO WORLD!"
( A$ CTYPE
( B$ $" HELLO UNIVERSE!"
( B$ CTYPE
( A$ CZ!
( A$ ZTYPE
( done )

( Local variables )
( Baranov, Nozdrunov )
( Language Forth and its implementations )
100 ALLOT HERE CONSTANT LP0
0 VARIABLE LP@ 
: INIT LP0 LP@ ! ; INIT
: LOCALS: ( n -- )
  1+ 2 * LP@ @ OVER - DUP LP@ ! ! ;
: ;LOCALS ( -- ) LP@ @ @ LP@ +! ;
: @@ <BUILDS , DOES> @ LP@ @ + @ ;
: !! <BUILDS , DOES> @ LP@ @ + ! ;
2 @@ @1 4 @@ @2 6 @@ @3 8 @@ @4 10 @@ @5
2 !! !1 4 !! !2 6 !! !3 8 !! !4 10 !! !5
( : 5INV ( ABCDE -> EDCBA )
(   5 LOCALS: !1 !2 !3 !4 !5 )
(   @1 @2 @3 @4 @5 ;LOCALS ; )
( 1 2 3 4 5 6 7 5INV )

( enable / disable "bindings" )
: FLAVOR ( -- )
  ' (MESSAGE) CFA ' MESSAGE !
  ' ;S        CFA ' MESSAGE 2+ !
  ' (PROMPT)  CFA ' QUIT  26 + !
  ' (HOME)    CFA ' ABORT  6 + !
  ' (HELLO)   CFA ' ABORT 35 + !
  125 EMIT  
  ." FLAVOR is ON." CR .FRE CR
  ." 'SAVE' and 'COLD' to proceed." CR CR ;
  
: PURGE ( -- ) 
  ' WARNING    CFA ' MESSAGE    !  
  ' @          CFA ' MESSAGE 2+ ! 
  ' PROMPT     CFA ' QUIT 26 +  ! 
  ' CR         CFA ' ABORT 6 +  ! 
  ' QUIT       CFA ' ABORT 35 + ! 
  ' EXTENSIONS LFA @ PFA FENCE  !
  148 710 ! 125 EMIT
  32 7903 C! 
  32 7904 C! ( 1.1eN -> 1.1 )
  ." FLAVOR is OFF." CR .FRE CR
  ." 'FORGET EXTENSIONS' obliterates," CR
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
  DROP UPDATE DROP LOOP 0 CLINE ! 0 CCHAR ! 0 SIDE ! ; ( FIXME )
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
  POINT-CURSOR XLINE ; : (FRE) 741 @ HERE - ;
: 2TOP LINEOFF @ 1 - CHAROFF @ 1 - POINT-CURSOR HLINE ; 
: BOT LINEOFF @ 16 + CHAROFF @ 1 - POINT-CURSOR HLINE ; 
: ETITLE 0 CHAROFF @ POINT-CURSOR ." EDIT / Dr" 
  OFFSET @ 0= 0= . ." Scr" 
  SCR ? ." Side" SIDE
  ? ." Free" (FRE) U. CR 17 SPACES .BUFSTAT ; 
: DISPLAY CLS 1 CRSINH C! ETITLE 2TOP CLINE @ 
  16 0 DO I CLINE ! WRITE-LINE LOOP CLINE !
  SIDE @ IF 32 ELSE 0 ENDIF CCHAR ! BOT
  WRITE-EXTRA CURSOR SCREEN-CURSOR ;
: ANYK CR ." (Press Return or Enter)" KEY DROP ;
: ANYKD ANYK DISPLAY ;
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
: EABORT CLS EMPTY-BUFFERS 1 STOP !
 [COMPILE] FORTH ;
: JOYKEY 764 C@ 255 = IF 632 C@
  300 + ELSE KEY THEN ;
: SH CLS 0 CRSINH C! IN @ >R BLK @ >R 0 IN ! 
  0 BLK ! CR QUERY INTERPRET R> BLK ! R> IN ! ANYKD ; 
: UNDOSCR EMPTY-BUFFERS SCR +! EREAD DISPLAY ; ( n -- )
: ENEXT  1 UNDOSCR ; 
: ELAST -1 UNDOSCR ; 
: EUNDO  0 UNDOSCR ;
: ADDR CLINE @ SCR @ (LINE) DROP CCHAR @ + ; ( UPDATE HERE? )
: ADDKEY DUP ADDR C! CURSOR EMIT RIGHT ;
: CHSIDE SIDE @ 1 XOR SIDE ! DISPLAY ;
: INSERT-CHAR ADDR SWAP CCHAR @ -
  SWAP OVER + SWAP -DUP IF 0 DO
  DUP 1 - C@ OVER C! 1 - LOOP ENDIF BL SWAP C! ;
: INSERT SIDE @ IF 63 ELSE 31 ENDIF 
  INSERT-CHAR WRITE-LINE CURSOR SCREEN-CURSOR ;
: HLP 125 EMIT CR
  ." *EDIT* by M. Dougherty  (Esc-H: help)" CR
  ." =====================================" CR
  ." Arrows, Ins, BckSp, Tab: normal use"   CR
  ." Return: next line (no line breaks)"    CR
  ." Esc-X: *copy and delete line"          CR
  ." Esc-C: *copy and keep line"            CR  
  ." Esc-V: *insert copied line"            CR
  ." Esc-R: *copy and run line in forth"    CR
  ." Esc-B: insert empty line"              CR
  ." Esc-U: execute forth command"          CR
  ." Esc-#: forth macros and commands:"     CR
  ."        1/VLIST 2/LIST-this 3/.BUFS"    CR
  ."        4/SCR80 5/LOAD-this 0/CLRSCR"   CR
  ." Esc-]: screen+1 (empty-buf)"           CR
  ." Esc-[: screen-1 (empty-buf)"           CR
  ." Esc-W: switch with shadow screen"      CR
  ." Esc-F/G: foregr.&backgr. colors"       CR
  ." Esc-E: version"                        CR 
  ." Esc-S: save (flush)"                   CR
  ." Esc-Z: undo (empty-buf) "              CR
  ." Esc-Q: quit (empty-buf)"               CR
  ." =====================================" CR
  CR ANYKD ; 
: DELETE-CHAR ADDR SWAP CCHAR @ -
  -DUP IF 0 DO DUP 1 + C@ OVER C!
  1 + LOOP ENDIF BL SWAP C! ;
: DELETE SIDE @ IF 63 ELSE 31 ENDIF
  DELETE-CHAR WRITE-LINE CURSOR SCREEN-CURSOR ;
: L-A SCR @ (LINE) DROP ;
: COPY-L CLINE @ L-A SAV-BUF 64 CMOVE ;
: DELETE-L COPY-L
  15 CLINE @ - IF 15 CLINE @ DO
  I 1+ L-A I L-A 64 CMOVE LOOP ENDIF
  15 L-A 64 BLANKS ;
: INSERT-L 15 CLINE @ - IF
  CLINE @ 15 DO I 1 - L-A I L-A 64 CMOVE
  -1 +LOOP ENDIF CLINE @ L-A 64 BLANKS ;
: INS-LINE INSERT-L DISPLAY ;
: DEL-LINE DELETE-L DISPLAY ; 
: PUT-LINE INSERT-L SAV-BUF CLINE @
  L-A 64 CMOVE DISPLAY ;
: PRT-LINE CLINE @ L-A 64 TYPE ;
: RUN-LINE COPY-L CR PRT-LINE CR QUERY INTERPRET ;
: TAB 2 0 DO RIGHT-CURSOR LOOP ;
: DEL LEFT-CURSOR BL DUP ADDR C!
  CURSOR EMIT SCREEN-CURSOR ;
: CLRSCR 
  16 0 DO I L-A 64 BLANKS LOOP DISPLAY ; 
: THEME DUP C@ 148 XOR SWAP C! ; 
: SAVESCR FLUSH EREAD DISPLAY  ; 
: BGRC 710 THEME ;    : FNTC 709 THEME ;
: PIN1 CLS VLIST        ANYKD ; ( vlist )
: PIN2 CLS SCR @ LIST   ANYKD ; ( list  )
: PIN3 CLS .BUFS        ANYKD ; ( buffers )
: PIN4 CLS DR0 80 SCR ! ANYKD ; ( set DR0, 80th screen )
: PIN5 CLS SCR @ LOAD   ANYKD ; ( load  )
: REVB FRM# @ 128 XOR FRM# ! ;  ( reverse frame when Esc )
: (VER) 125 EMIT VER ANYK ;
: ESC REVB KEY CASES ( bug: more cases crush CASE/IS )
    66 CASE INS-LINE  IS ( B )
    67 CASE COPY-L    IS ( C )
    69 CASE (VER)     IS ( E )
    70 CASE FNTC      IS ( F )
    71 CASE BGRC      IS ( G )
    72 CASE HLP       IS ( H )
    81 CASE EABORT    IS ( Q )
    82 CASE RUN-LINE  IS ( R )
    83 CASE SAVESCR   IS ( S )
    85 CASE SH        IS ( U )
    86 CASE PUT-LINE  IS ( V )
    87 CASE CHSIDE    IS ( W )
    88 CASE DEL-LINE  IS ( X )
    90 CASE EUNDO     IS ( Z )
    91 CASE ELAST     IS ( ] )
    93 CASE ENEXT     IS ( [ )
    49 CASE PIN1      IS ( 1 )
    50 CASE PIN2      IS ( 2 )
    51 CASE PIN3      IS ( 3 )
    52 CASE PIN4      IS ( 4 )
    53 CASE PIN5      IS ( 5 )
    48 CASE CLRSCR    IS ( 0 )
  END-CASES REVB ;
: DEEP SP@ 12 +ORIGIN @ SWAP - 2 / ; ( if no DEPTH dfnd )
: SETSCR DEEP 0= IF HLP# DUP ENDIF SCR ! ; ( -- | 80 )
: (EDIT) ( m -- ; edit screen m with MDEDIT )
  SETSCR EREAD DISPLAY 0 STOP ! BEGIN
    JOYKEY CASES
      27  CASE ESC          IS  155 CASE RETURN      IS
      28  CASE UP-CURSOR    IS  29  CASE DOWN-CURSOR IS
      31  CASE RIGHT-CURSOR IS  30  CASE LEFT-CURSOR IS
      255 CASE INSERT       IS  254 CASE DELETE      IS
      126 CASE DEL          IS  127 CASE TAB         IS
      ( joy directions +300 not to collide w/ keys )
      314 CASE UP-CURSOR    IS  313 CASE DOWN-CURSOR IS
      307 CASE RIGHT-CURSOR IS  311 CASE LEFT-CURSOR IS
      ( todo: add diagonals )
      DUP DUP 300 < IF ADDKEY ELSE DROP THEN
    END-CASES
  STOP @ UNTIL   
  CLS 0 CRSINH ! ;  
FORTH DEFINITIONS
: EDIT EDITOR (EDIT) FORTH ; ( n -- | -- : scr 80 )
: E. EDITOR SCR @ (EDIT) FORTH ; ( -- : current ) 

( *******   GOESINTO    ****** )
( Decompiler by R. D. Ackerman )
( -- Forth Dimension Vol14 Nr2 )
( "GOIN word", RET/SPC/Q ) 
0 VARIABLE GIN 
: GIN+ GIN @ 2+ DUP GIN ! SPACES ; 
: GCHK DUP @ 2+ ' COMPILE =
  IF  2+ DUP @ 2+ NFA ID. 2+
  ELSE DUP @ 2+ DUP ' LIT =
  OVER ' BRANCH  = OR OVER ' 0BRANCH = OR
  OVER ' (LOOP)  = OR SWAP ' (+LOOP) = OR
  IF 2+ DUP @ SPACE . 2+ ELSE DUP @ 2+ ' CLIT =
  IF 2+ DUP C@ SPACE . 1+ ELSE DUP @ 2+ 
  ' (.") = IF 2+ DUP COUNT TYPE 
  DUP C@ 1+ + ELSE 2+ THEN
  THEN THEN THEN 
  -2 GIN +! ; 
: MYSELF LATEST PFA CFA , ; IMMEDIATE
: DIN GIN @ SPACES ;
: (GOESINTO) ( pfa -- )
  DUP CFA @ ' : CFA @ =
  OVER ' ERROR =
  0= AND IF
	BEGIN
 	  DUP @ DUP ' ;S CFA =
      OVER ' (;CODE) CFA =
	OR 0= WHILE
	  2+ CR OVER U. DUP GIN+
	  NFA ID. KEY 
      DUP 81 = IF SP! QUIT ELSE 155 =
      IF MYSELF ELSE DROP THEN THEN
      GCHK
    REPEAT
	2+ CR OVER U. DIN NFA ID.
  THEN DROP ; ( 81=Q, 155=RETURN )
: GOESINTO -FIND IF
    DROP 0 GIN ! CR
    CR ." * GOESINTO decomp by R. D. Ackerman *" 
    CR ." * Q=bye / Space=next / Enter=gointo *"
    CR (GOESINTO)
  ELSE ." NOT FOUND" CR THEN ;
: DECOMP GOESINTO ;
 
: ED-HELP ( -- ; display FIG EDITOR help )
  CR
  CR ." m SCR ! -> select screen m"
  CR ." .BUFS   -> show buffers"
  CR ." --------- SOURCE EDITOR"
  CR ." m EDIT  -> edit screen m"
  CR ." E.      -> edit current screen"
  CR ."            Esc+H opens help"
  CR ." --------- FIG LINE EDITOR"
  CR ." n &     -> add text in line n (P)"
  CR ." n XX    -> delete text in line n (E)"
  CR ." FL.     -> save (FLUSH)"
  CR ." EB.     -> undo (EMPTY-BUFFERS)"
  CR ." L.      -> LIST current screen"
  CR ." N. / P. -> LIST next/previous screen"
(  CR ." --------- QMEG" )
(  CR ." QMG     -> enters QMEG's drive menu" )
(  CR ." MLM or MON enters QMEG's monitor" )
CR CR ;
  
: HELP ( -- ; display help )
  CR
  CR ." VER for version"
  CR ." ED-HELP for screen editing help"
  CR ." .S to show the stack in one line"
  CR ." .CC for CONTEXT and CURRENT info"
  CR ." .FRE to show free bytes"
  CR ." .BUFS to show disc buffers"
  CR ." STACK to toggle stack display"
  CR ." DECOMP XYZ to decompile word XYZ"
  CR ." BREAK to debug, GO to proceed"
  CR ." || is BREAK, ?| is conditional"
  CR ." UNRAVEL-ON /-OFF - err stk trace"
  CR ." RE: and ;RE to redefine words"
  CR ." ' aaa SCAN to locate uses of aaa"
  CR ." D1:/D2:/DIR to browse floppies"
  CR ." n m SEARCH aaa for screen search"
  CR ." n m THRU to load multiple screens"
  CR ." WHERE for the last loading error"
  CR ." : X ;  RE: X ;RE  to redefine words"
  CR ." PURGE removes extension bindings"
  CR CR ;

ASSEMBLER HEX

( RP@ code finally found in the Blazin' Forth sources )
CODE RP@ 
  XSAVE STX, TSX, TXA, PHA, 1 # LDA,
  XSAVE LDX, PUSH JMP,

( ** CALL ** )
( David Held, Forth Dimension V/5 p. 22 )
( David Held, Forth Dimension V/3 p. 23 )
( Test: call selftest ->  HEX E471 CALL )
CODE (CALL)
    XSAVE STX,    0 JSR,
    XSAVE LDX, NEXT JMP,


FORTH
HEX
: CALL
  [ ' (CALL) 3 + ]
  LITERAL ! (CALL) ;

( ** QMEG & MLM ** )
: MEMUP
  FORTH DEFINITIONS
  LATEST 0C +ORIGIN ! ( NTOP )
  HERE   1C +ORIGIN ! ( FENCE )
  HERE   1E +ORIGIN ! ( DP )
  ; ( TODO: how is it different from )
    ( the partial content of (SAVE)
    ( which also touches VOC-LINK etc )
  
: MLM MEMUP E480 CALL ;
: QMG MEMUP E471 CALL ;
: MON MLM ; 
DECIMAL



( Add a Break Point Tool / BREAK & GO )
( Frank Seuberling / Kim Harris - FDv5n1p19 )
( with small tunings by BG )
: .RS ( -- )
  CR ." RS: " RP@ R0 2 -
  DO I @ U. -2 +LOOP CR ;
0 VARIABLE RP*
: BREAK ( -- ; BREAK&GO debugging method )
  CR ." Breapoint!"
  CR RP@ 4 - RP* ! 0 BLK !  BEGIN
    QUERY INTERPRET ." aok [GO]" CR
  AGAIN ;
: || ( -- ; alias for BREAK ) BREAK ;
: ?| ( f -- ; BREAK if f ) IF BREAK THEN ;
: GO ( -- ; proceed after BREAK )
  RP@ RP* @ = IF R> DROP R> DROP
  ELSE ." can't resume " QUIT THEN ;

( ***** AUGMENTED TRACE ***** )
( https://www.forth.org/fd/FD-V06N5.pdf )
( REQUIRES: assembler [39], RP@, R0     )
( FIXME: UNRAVEL sometimes fails, with  )
(        short words and other cases    )
: HIGH? ( cfa -- f )
  DUP  @    [ ' : @ @ ] LITERAL =
  SWAP @ C@ [ ' FORTH @ C@ ] LITERAL = OR ;
: (UNLINE CR SPACE DUP 4 .R SPACE ;
: UNRAVEL ( -- )
  BEGIN RP@ R0 = 0= WHILE
    R> DUP CFA @ DUP ( n2 n n ) 
    HIGH?            ( n2 n f  )
    IF   (UNLINE NFA ID. DROP
    ELSE (UNLINE DROP U. THEN
  REPEAT QUIT ; ( original QUIT replaced with BREAK? )

( *** stack trace ON / OFF *** )
: UNRAVEL-ON ( -- ) ' UNRAVEL CFA 7290 ! ;
( ^ replace 'QUIT' IN 'ERROR' with UNRAVEL + QUIT )
: UNRAVEL-OFF ( -- ) ' QUIT    CFA 7290 ! ; ( default )

: PURGE PURGE UNRAVEL-OFF ;

: TASK ( -- ; end of EXTENSIONS ) ;

( demo source code )

80 CLEAR 80 SCR !
0 & ( factorial )
1 & : FAC         ( n -- n! )
2 &   1 SWAP 1+ 1 ( 1 n+1 1 )
3 &   DO I * LOOP ;  
4 & CR 3 FAC .
5 & CR 8 FAC U.
6 & CR
FLUSH

81 CLEAR 81 SCR !
0  & ( factorial tests )
1  & : TEST.FAC ( -- )
2  &  .” T1: f(0) = ”     
3  &   0 FAC DUP U. 1 ?PAIRS CR
4  &  .” T2: f(1) ”       
5  &   1 FAC  1 ?PAIRS CR
6  &  .” T3: f(4) ”       
7  &   4 FAC 24 ?PAIRS CR
8  &  .” T4: f(2)<f(4) ”
9  &   2 FAC 3 FAC U< 1 ?PAIRS CR
10 &  .” T5: f(8)<f(9) ”  
11 &   8 FAC 9 FAC U< 1 ?PAIRS CR
12 &  .” Tests Done. “ CR ; 
FLUSH

82 CLEAR 82 SCR !
0  & ( a broken SQUARE )
1  & 1 CONSTANT #COLOR
2  & 0 VARIABLE X
3  & 0 VARIABLE Y
4  & 0 VARIABLE SIDE
5  & : SQUARE  ( side y x -- )
6  &   SIDE ! Y ! X !
7  &   #COLOR X @ Y @ PLOT
8  &   #COLOR X @ SIDE + Y @ DRAW
9  &   #COLOR X @ SIDE + Y @ SIDE
10 &     + DRAW
11 &   #COLOR X @ Y @ DRAW  
12 &   #COLOR X @ Y @ SIDE @
13 &     + DRAW 1 ;
14 & 8 GR. ( XGR exists ) CR CR 
15 & ." 100 10 20 SQUARE " CR
FLUSH

83 CLEAR 83 SCR !
0  & ( a fixed SQUARE )
1  & 1 CONSTANT #COLOR
2  & 0 VARIABLE X
3  & 0 VARIABLE Y
4  & 0 VARIABLE SIDE
5  & : SQUARE  ( side y x -- )
6  &   X ! Y ! SIDE !
7  &   #COLOR X @ Y @ PLOT
8  &   #COLOR X @ SIDE @ + Y @ DRAW
9  &   #COLOR X @ SIDE @ + Y @ SIDE @
10 &     + DRAW
11 &   #COLOR X @ Y @ SIDE @ + DRAW  
12 &   #COLOR X @ Y @ DRAW ;
13 & ( no more bugs! )
14 & 8 GR. ( XGR exists ) CR CR 
15 & ." 100 10 20 SQUARE " CR
FLUSH

( todo: diff between screens )

84 CLEAR FLUSH
85 CLEAR FLUSH
86 CLEAR FLUSH
87 CLEAR FLUSH
88 CLEAR FLUSH

FLAVOR SAVE COLD  
