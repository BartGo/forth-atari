(    ### UNBUG / DEV UTILS ###    )
(     A library of debug words.   )
( Collected from Forth Dimensions ) 
( Atari800XL / APX Ext. Fig-Forth )
(  REQUIRES: assembler [39 LOAD]  )
(    optionally: debug [21 LOAD]  )
( see also:                       )
(  https://www.atarimagazines.com )
(  /software/83-09/FORTHASM.4TH   )
( https://archive.org/details/    )
( 1983-09-anticmagazine/page/79/mode/1up?q=forth )
( 1986-02-anticmagazine/page/98/mode/2up?q=forth )
( 1982-06-anticmagazine/page/45/mode/1up?q=forth )
( 1983-04-anticmagazine/page/94/mode/1up?q=forth )
( 1982-12-anticmagazine/page/49/mode/2up?q=definers )
( needed: CALL or PROC /?/ to directly execute machine code procedure )
( consider for this MAC from RP's words )
( load asm[39] and optionally debug - useful DUMP, DECOMP )

ASCII / 7903 C! 
ASCII d 7904 C! ( "debug" ) ( load before! )
ASCII a 7905 C! ( asm wfr ) ( load before! )
ASCII e 7906 C! ( fig edt ) ( included     )
ASCII u 7907 C! ( utils )   ( included     )

( ************************** )
( Case-insensitive fig-Forth )
( ************************** )
( Ported from: pns-FORTH 1.4 )
( Tested on Atari 800XL emul.)
( and APX Extended fig-Forth )

: UPPER ( pns 1.4 )
  OVER + SWAP DO
      I C@ 96  > ( between a )
      I C@ 123 < ( ... and z )
    AND	IF I 32 TOGGLE THEN
  LOOP ;
: -FINDX
  BL WORD HERE
  COUNT UPPER HERE ( from pns 1.4 )
  CONTEXT @ @ (FIND) DUP 0= IF
    DROP HERE LATEST (FIND)
  THEN ;  
: ZAP ( oldpfa newpfa -- ) 
  CFA OVER ! ( new pfa into old )
  [ ' ;S CFA   ] LITERAL OVER  2+ !
  [ ' ;  CFA @ ] LITERAL SWAP CFA ! ;
' -FIND ' -FINDX ZAP
FORGET ZAP

ASCII o 7894 C! ( insnstv ) ( included     )

( fig-FoRTH  1.1/dae )

( ASCII E 7908 C! ) ( big edits / external )

FORTH DEFINITIONS

: FIGED( ; HEX

( TODO: put into editor definitions? )

( ***   EDITOR'S SUBSET    *** )
( REQUIRES: NOTHING            )
( PUT to edit: "n P xxx "      ) 

0 VARIABLE SRCHCNT
: TEXT HERE C/L 1+ BL FILL WORD HERE PAD C/L 1+ CMOVE ;
: LINE DUP FFF0 AND 17 ?ERROR SCR @ (LINE) DROP ; 
: -MOVE LINE C/L CMOVE UPDATE ;
: H.E LINE PAD 1+ C/L DUP PAD C! CMOVE ;
: E. ( n -- ) LINE C/L BL FILL UPDATE ; 
: S.E DUP 1 - 0E DO I LINE I 1+ -MOVE -1 +LOOP E. ;
: D.E DUP H.E 0F DUP ROT DO I 1+ LINE I -MOVE LOOP E. ; 
: R. PAD 1+ SWAP -MOVE ;
: I. DUP S.E R. ;
: P ( n -- ccc ) 1 TEXT R ; : P. P ;
: #LOCATE R# @ C/L /MOD ;
: #LEAD #LOCATE LINE SWAP ;
: #LAG  #LEAD DUP >R + C/L R> - ;
: 1LINE #LAG PAD COUNT MATCH R# +! ; 
: M. R# +! CR SPACE #LEAD TYPE
  17 EMIT #LAG TYPE #LOCATE . DROP ;
: T. DUP C/L * R# ! DUP H.E 0 M. ;
: TOP ( -- ) 0 R# ! ; 
: L. ( -- ) SCR @ LIST 0 M. ; : LI. L. ;
: TR. ( -- ) SCR @ TRIAD ; 
: N.   ( -- ) 1 SCR +! L. ; : B. ( -- ) -1 SCR +! L. ;
: MARK ( -- ) 10 0 DO I LINE UPDATE DROP LOOP ;
: FL.  ( -- ) MARK FLUSH ;
: EB.  ( -- ) EMPTY-BUFFERS ;
: WHERE ( -- ) DUP B/SCR / DUP SCR
  ! ." SCR # " DECIMAL .
  SWAP C/L /MOD C/L * ROT BLOCK +
  CR C/L -TRAILING TYPE CR
  HERE C@ - SPACES 1 2FE C!
  1C EMIT 0 2FE C! SP! QUIT ; 
: CLEAR ( n -- ) SCR ! 10 0 DO I E. LOOP ;
: CLEARS ( n m -- ) DO I CLEAR FLUSH LOOP ; 
: COPY ( n n -- )
  B/SCR * OFFSET @ + SWAP
  B/SCR * B/SCR OVER + SWAP DO
    DUP I BLOCK 2 - ! 1+ UPDATE
  LOOP DROP FLUSH ;

DECIMAL

( FIXME )
( *** Some New Editor Extensions *** ) 
( * by Kim Harris - FD II/6 p. 156 * )
( usage example:  )
( 100 LIST EDITOR )
( 2 NEW           )
( 2 UNDER         )
: ENTER? ( start-line# current-line# -- f ) OVER = ;
: ENTER ( -- ) QUERY 1 TEXT ;
: NULL? ( -- f ) TIB @ C@ 0= ;
: .BS ( -- ) 254 EMIT ;
: S@L SCR @ .LINE ;
: NEW ( start-line# -- )
  16 0 DO
    CR I 3 .R SPACE I ENTER?
	IF
	  ENTER NULL? IF
        .BS I S@L
	  ELSE I R. 1+ THEN
	ELSE I S@L
	THEN
  LOOP DROP ;
: UNDER ( start-line# -- )
  1+ 16 0 DO
    CR I 3 .R SPACE I ENTER?
	IF
	  ENTER NULL? IF
	    .BS I S@L
	  ELSE I I. 1+ THEN
	ELSE
      I S@L
    THEN
  LOOP DROP ;	
	

( ** LINE EDITOR HISTORY ** )
( FD V15N6 p. 13 )
( https://archive.org/details/ ) 
( Forth_Dimension_Volume_15_Number_6/page/n9/mode/1up?q=editor )

( ***      SEARCH     *** ) 
( REQUIRES: editor subset )
( SEARCH to: "n p SEARCH word ")
: BUMP 1 SRCHCNT +! SRCHCNT @ 56
  > IF 0 SRCHCNT ! CR THEN ;
: SEARCH ( FROM TO -- STRING )
  CR 01 TEXT 0 SRCHCNT ! 1+ SWAP
  DO
    FORTH I SCR ! TOP
    BEGIN
      1LINE IF 0 M. SCR ? BUMP THEN
    1023 R# @ < UNTIL 
  LOOP ; 

: )FIGED ;

: UTILS( ; DECIMAL

( ***   OUTLINE   *** ) 
( REQUIRES: NOTHING   )
( Source Screen Documentation Tool WF25 2Apr82 KRH
( Kim Harris / Laxen & Harris, Inc. 
( https://archive.org/details/Forth_Dimension_Volume_04_Number_2/page/n22/mode/1up
( Modified by BartGo, to use (LINE)
( instead of BLOCK, renamed OUTLINE-OUTLINES, 1OUTLINE-OUTLINE )
: OUTLINE ( #scr -- ) 
  DUP CR CR ." Screen # " . DUP SCR !
  15 0 DO
    DUP I SWAP  ( scr#, ln#, scr# )
    (LINE) SWAP ( scr#, 64, lineaddr )
    DUP C@ BL = 0=      
    I 0= OR IF  ( 1st line or non-space? )         
      SWAP -TRAILING CR TYPE ( print line )
    ELSE DROP DROP THEN ( skip line )
  LOOP DROP CR ;                
: OUTLINES ( #1st-screen #last-screen -- )
  1+ SWAP DO I 1OUTLINE LOOP ;
: .DOC  OUTLINE  ;
: .DOCS OUTLINES ;

( ******* BUFS ******* )
( REQUIRES: NOTHING )
( TDH 7/11/81 FD-V03N6 )
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

( ******* .CC ****** )
( Vw current/context )
( FD III/1 p10 / KH  )  
( REQUIRES: NOTHING  )
: .CC ( -- )
  CR ." Context Current: "
  CONTEXT @ 4 - NFA ID.
  CURRENT @ 4 - NFA ID. CR ; 

( *******   GOESINTO    ****** )
( Decompiler by R. D. Ackerman )
( -- Forth Dimension Vol14 Nr2 )
( "GOIN word", RET/SPC/Q ) 
( TODO: enhance, add addresses )
0 VARIABLE GIN 
: GIN+ CR GIN @ 2+ DUP GIN ! SPACES ;
: GCHK DUP @ 2+ ' COMPILE =
  IF  2+ DUP @ 2+ NFA ID. 2+
  ELSE DUP @ 2+ DUP ' LIT =
  OVER ' BRANCH  = OR OVER ' 0BRANCH = OR
  OVER ' (LOOP)  = OR SWAP ' (+LOOP) = OR
  IF 2+ DUP @ SPACE . 2+ ELSE DUP @ 2+ ' CLIT =
  IF 2+ DUP C@ SPACE . 1+ ELSE DUP @ 2+ 
  ' (.") = IF 2+ DUP COUNT TYPE 
  DUP C@ 1+ + ELSE 2+ THEN THEN THEN THEN 
  -2 GIN +! ; 
: MYSELF LATEST PFA CFA , ; IMMEDIATE
: DIN CR GIN @ SPACES ;
: (GOESINTO) DUP CFA @ ' : CFA 
  @ = OVER ' ERROR = 0= AND
  IF BEGIN DUP @ DUP ' ;S CFA =
    OVER ' (;CODE) CFA = OR 0=
  WHILE 2+ DUP GIN+ NFA ID. KEY 
    DUP 81 = IF SP! QUIT ELSE 155 =
    IF MYSELF ELSE DROP THEN THEN
    GCHK REPEAT 2+ DIN NFA ID.
  THEN DROP ; ( 81=Q, 155=RETURN )
: GOESINTO -FIND IF DROP 0 GIN !
  (GOESINTO) ELSE ." NOT FOUND" CR THEN ;
: GOIN ( -- ) GOESINTO ; 

( *** zap word - IRREVERSIBLY *** )
( *** replace word in nucleus *** )
( *** usage:  ' OLD ' NEW ZAP *** )
( REQUIRES: NOTHING               )
: ZAP ( oldpfa newpfa -- ) 
  CFA OVER ! ( new pfa into old )
  [ ' ;S CFA   ] LITERAL OVER  2+ !
  [ ' ;  CFA @ ] LITERAL SWAP CFA ! ;

( ***** S0, R0, .S ***** )
( REQUIRES: NOTHING      )
: S0 TIB 4 - @ ; ( -- n ) ( better: 18 +ORIGIN @ )
: R0 TIB 2 - @ ; ( -- n )
: .S SP@ S0 = 0= IF
    SP@ 2 - S0 2 - DO I @ . -2 +LOOP
  ELSE ." Stack empty " THEN ;

( ******* RP@ ****** )
( from Blazin' Forth )
( REQUIRES: assembler [39 LOAD] )
ASSEMBLER
  CODE RP@ 
    XSAVE STX,
    TSX, TXA, PHA,
    1 # LDA,
    XSAVE LDX,
    PUSH JMP,
  END-CODE
FORTH


( TESTME )
( ** CALL ** )
( David Held, Forth Dimension V/5 p. 22 )
( David Held, Forth Dimension V/3 p. 23 )
( REQUIRES: assembler [39 LOAD] )
( Test: call selftest ->  HEX E471 CALL )
FORTH DEFINITIONS ASSEMBLER
CODE (CALL)
    XSAVE STX,    0 JSR,
    XSAVE LDX, NEXT JMP,
END-CODE
FORTH
' (CALL) 3 + CONSTANT CALL-ADDR
: CALL CALL-ADDR ! (CALL) ;


( ***** .EVAR **** )
( REQUIRES: S0, R0, RP@, asm [39] )
: (VC ( pfa -- )
    DUP CFA EXECUTE 4 4 + .R 
    NFA SPACE ID. CR ;
: (VV ( pfa -- )
    DUP CFA EXECUTE DUP 4 .R C@
    4 .R NFA SPACE ID. CR ;
: .SYS ( -- )
  CR 5 SPACES
  ." Val System-Constant" CR
  ' BL    (VC  '   C/L (VC 
  ' FIRST (VC  ' LIMIT (VC
  ' B/BUF (VC  ' B/SCR (VC 
  ( ' RP@ (VC  ' SP@ (VC      )
  ;
: .USR ( -- )
  CR ." Addr Val User-Variable" CR
  ' S0       (VV  ' R0      (VV
  ' TIB      (VV  ' WIDTH   (VV
  ' WARNING  (VV
  ' FENCE    (VV  ' DP      (VV
  ' VOC-LINK (VV  ' BLK     (VV
  ' IN       (VV  ' OUT     (VV
  ' SCR      (VV  ' OFFSET  (VV
  ' CONTEXT  (VV  ' CURRENT (VV
  ' STATE    (VV  ' BASE    (VV
  ' DPL      (VV  ' FLD     (VV
  ' CSP      (VV  ' R#      (VV
  ' HLD      (VV  ( and? ... )
  ' USE      (VV  ' PREV    (VV
  ' UP       (VV  ' PAD     (VV ;
: .EVAR ( -- ) .SYS .USR ;

( *********** R.N ************* )
( Shows the return stack        )
( REQUIRES: assembler [39], RP@ )
: R.N ( -- ) RP@ R0 = 0= IF
    RP@ 2 - R0 2 - DO I @ U. -2 +LOOP
  THEN ; ( FIXME )

( **** BREAK&GO **** )
( https://www.forth.org/fd/FD-V05N1.pdf )
( REQUIRES: assembler [39], RP@, R0, S0, .S, R.N )
0 VARIABLE RP*
: BREAK ( -- )
  CR ." (BREAK reached, type GO to proceed)"
  CR ." S= " .S CR ." R= " R.N CR 
  RP@ 4 - RP* ! 0 BLK ! BEGIN QUERY
  INTERPRET ." aok" CR AGAIN ; : || BREAK ;
: GO ( -- ) RP@ RP* @ = IF R> DROP R> DROP
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
  REPEAT QUIT ; ( original QUIT replaced with BREAK )

( *** stack trace ON / OFF *** )
( REQUIRES: assembler [39], RP@, R0, UNRAVEL )
: TRACE-ON ( -- ) ' UNRAVEL CFA 7290 ! ;
( ^ replace 'QUIT' IN 'ERROR' with UNRAVEL + QUIT )
: TRACE-OFF ( -- ) ' QUIT    CFA 7290 ! ; ( default )

( FIXME: don't use ZAP! prevents FORGET to baseline!) 
( ** BASE COLOR FRAME THROUGH PROMPT ** )
( BG 2024; REQUIRES: ZAP )
1 VARIABLE BASECOL
: BASECOL-ON  1 BASECOL ! ; ( -- )
: BASECOL-OFF 0 BASECOL ! ; ( -- )
: PROMPTX ( -- )
  PFLAG @ 0 PFLAG ! ." ok" PFLAG !
  BASECOL @ 1 = IF 
    BASE @ DUP 10 = IF DROP 0 THEN
    712 C!
  ELSE 0 712 ! THEN ;
' PROMPT ' PROMPTX ZAP 
  ( fix: NEED TO ROLL BACK? )
  ( fixme: ' PROMPTX ' SPACE ZAP )
HEX DECIMAL ( BLINK TO TEST )

( INTERPRET COMPILE-ONLY WORDS )
( REQUIRES: NOTHING            )
( FD II/6 p. 168 / Henry Laxen )
( example: in the command line:)
( :: 0 IF 1 ELSE 2 THEN ;      )
( S. => SHOWS 2 BUT NO NEW WORD)
(       IS DEFINED, ONLY TEMP. )
(       / DISCARDED DEFINITION )
: :: ( -- ) 
  HERE >R
  [ ' QUIT CFA @ ] LITERAL ,
  !CSP ]
  BEGIN
    INTERPRET
  STATE @ WHILE
    CR QUERY
  REPEAT
  SMUDGE
  R EXECUTE
  R> DP ! ;

: )UTILS ;

( SAVE ) 

( *** step tracing TBD *** )

;S

( DECOMP MESSAGE DONE )
( MESSAGE SCREEN IS 14 AT 8777 DEC )
DECIMAL 14 8777 C! ( 14+ as default message screens   )
        87 8777 C! ( 87+ as new message screens       )
( - better solution: replace 8775 to 8789 with static )
(   messages and no drive access                      )
( - make warning remembered after boot                )

( : UN UNRAVEL ; 
  : R3 UN ;
  : R2 R3 ;
  : R1 R2 ;
  : TEST-UNRAVEL R1 ; )

( crash )
( : ['] [COMPILE] ' ; )
( : DEFER CREATE ['] ABORT , DOES> @ EXECUTE ; )

DOC TOOL
https://archive.org/details/Forth_Dimension_Volume_04_Number_2/page/n22/mode/1up
TASKER
https://archive.org/details/Forth_Dimension_Volume_05_Number_2/page/n19/mode/1up
RDCP
https://archive.org/details/Forth_Dimension_Volume_05_Number_6/page/n14/mode/1up
DEFER
https://archive.org/details/Forth_Dimension_Volume_05_Number_6/page/n34/mode/1up
DEBUGGING TECHNIQUES: pt 1 / UNRAVEL
https://archive.org/details/Forth_Dimension_Volume_06_Number_2/page/n37/mode/2up?q=unravel
DEBUGGING TECHNIQUES: pt 2 / TRACE
https://archive.org/details/Forth_Dimension_Volume_06_Number_3/page/n31/mode/2up?q=unravel
FORMATTER
https://archive.org/details/Forth_Dimension_Volume_08_Number_2/page/n25/mode/2up?q=FORMATTER
HIGH-LEVEL SINGLE STEPPER
https://archive.org/details/Forth_Dimension_Volume_10_Number_6/page/n14/mode/1up?q=unravel
STEP TRACKING
https://archive.org/details/Forth_Dimension_Volume_10_Number_2/page/n20/mode/1up
