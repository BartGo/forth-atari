( APX forth spin-off, R variant )
( with WFR assembler  and RP's EDYTOR-FORTH )

( no graphics words included ; intended use )
(  - higher compatibility with assembly code )
(    published and used in other 6502 forths )
( - compatibility with mr. Pantola's editor  )
(   and routines                             )

( FIXME: )
( difference in small asm pieces: WFR requires END-CODE )
( this can be unified, add empty end-code to Mullarky's ) 
( rename XX to something else )
( e.g. & for edit/p and \ for edit/del )
( remove clashes of EDYTOR-FORTH or make words hidden )

FORTH DEFINITIONS DECIMAL 0 WARNING !

( : CORE ; ) 
( 21 LOAD  ) 
( 76 LOAD  ) ( WFR )

FORTH DEFINITIONS DECIMAL 0 WARNING !

( RP - added words for optional use with WFR assembler )
: C; CURRENT @ CONTEXT ! ?EXEC ?CSP SMUDGE ; IMMEDIATE
: MAC  -FIND 0= 0 ?ERROR DROP 32 C, , ; IMMEDIATE

FORTH DEFINITIONS DECIMAL 0 WARNING !

: EXTENSIONS ;

: (VER) ( version 1.1e8 )
  ASCII r 7903 C! 
  ASCII 8 7904 C! ;
(VER)

VOCABULARY EDITOR IMMEDIATE
FORTH DEFINITIONS 

: VER ( -- ; display version )
  CR
  CR ."    =============================="
  CR ."       Extended Fig-Forth Rev.2   "
  CR ."     by Patrick L. Mullarky, 1982 "
  CR ."    published by Atari through APX"
  CR ."    ------------------------------"
  CR ."       EDIT - by Mike Dougherty   "
  CR ."    as published in: 'Micro 6502' "
  CR ."       (no. 57 - February 1983)   "
  CR ."    ------------------------------"
  CR ."    Additional tools from magazine"
  CR ."    'Forth Dimensions' - collected"
  CR ."    & extended by BartGo, v2026/"
  7903 C@ EMIT 7904 C@ EMIT
  CR ."    =============================="
  CR ."    For the glory of Atari & Forth"
  CR ."    & PTODT (https://ptodt.org.pl)"  
  CR ."    =============================="
  CR CR ;

: .FRE ( -- )
  741 @ HERE - U. ." bytes free" ; 

( : BEEP 253 EMIT ; )

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
  EMPTY-BUFFERS
  80 SCR ! 
  CR .FRE
  CR ." Screen set to #" SCR ?
  CR ." Type 'HELP' for help"
  CR QUIT ;

HEX
: /? ( -- cc )
  [COMPILE] ' OUT @ C/L 2 / > 0= IF
    CR 0 OUT ! THEN
  CR CR ." * Word header of "
  DUP NFA ID. 
  DUP NFA @ 20 AND IF CR ."   SMUDGE " THEN
  DUP NFA @ 40 AND IF CR ."   IMMEDIATE " THEN 
  CR DUP
  ."   PFA=" U. CR DUP NFA
  ."   NFA=" U. DUP LFA
  ."   LFA=" U. DUP CFA
  ."   CFA=" U. CR DUP
  ."   CFA pointing to " CFA @ U.
  DUP CFA @ 1441 = IF
	.WORD ! ." (COLON)"
	CR ." * Decomp" CR
    BEGIN NXT1 NP CKIT CR AGAIN 
  ELSE DUP CFA @ 147D = IF
    ." (CONSTANT)" CR ."   Equals: "
    @ U. CR
  ELSE DUP CFA @ 1499 = IF
    ." (VARIABLE)" CR ."   Equals: "
    @ U. CR
  ELSE DUP CFA @ 14B2 = IF
    ." (USER)" CR ."   Equals: "
    C@ UP @ + @ . CR
  ELSE DUP CFA @ 18D8 = IF ." (DOES>)" CR
  ELSE DUP CFA @      = IF ." (ASSEMBLY)" CR
  THEN THEN THEN THEN THEN THEN CR ;

HEX
( Re-Defining a Colon Word )
( by E. H. Schmauch, FDv6n3p20 )
: (RE-CREATE) ( -- )
  -FIND 0= IF
    HERE COUNT TYPE ."  NOT FOUND" ABORT
  THEN
  DROP DUP CFA @ [ ' : CFA @ ] LITERAL = 0= IF
    HERE COUNT TYPE ."  NOT A COLON WORD!" ABORT
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

( * PICK and ROLL * )
(   for fig-FORTH   )
(    Steve Oakey    )
( /Forth for Micros )
( tested: APX Forth )
: PICK ( n -- n )
  2 * SP@ OVER 1 < SWAP ROT +
  SWAP OVER
  18 +ORIGIN @ ( S0 ) < 0= OR IF
    ." PICK: out of range"
	CR ABORT
  ELSE @ THEN ;
: ROLL ( n -- )
  2 * SP@ OVER 1 < SWAP ROT +
  SWAP OVER 
  18 +ORIGIN @ ( S0 ) < 0= OR IF
    ." ROLL: out of range"
	CR ABORT
  ELSE
    DUP @ >R SP@ 2+ SWAP DO
	  I 2 - @ I ! -2
	+LOOP
    DROP R>
  THEN ;

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

: ['] [COMPILE] ' ; IMMEDIATE

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

FORTH DEFINITIONS HEX
: EVLIST ( -- ; extended VLIST )
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
    PFA LFA @ DUP 0= ?TERMINAL OR CR
  UNTIL DROP ;

DECIMAL

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

( simplified .BUFS, displays +/- )
( with + for buffers synced with )
( the drive and '-' for pending )
0 VARIABLE BUFCHANGE
: .BUFSTAT ( -- ) 
  0 BUFCHANGE !
  FIRST LIMIT FIRST - B/BUF /
  1+ 1 DO
	DUP @ 32768 AND 0= 0= IF
	  1 BUFCHANGE +! THEN
	132 + 
  LOOP DROP
  BUFCHANGE @ IF ASCII - EMIT
    ELSE ASCII + EMIT THEN ;

( *** )
( KEYWORDS - WHERE USED
( FD VOL VII, NO 1
( COPYRIGHT [C] 1983
( by Nicholas L. Pappas, PhD
( + LOCATE macro by BartGo
( how to run, example: ' WORD LOCATE
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
: LOCATE ( pfa -- )
  CFA            ( n1 )
  ' LIT CFA      ( n1 n2 )
  LATEST PFA CFA ( n1 n2 n3 )
  ROT (FINDNO) ;

( DOS-like DIR, you can use now "D1: DIR" )
( and DIR will show lines started with (s )
: (INDEX) ( scr -- ; commented lines #0 ) 
  DUP SCR ! 0 SWAP (LINE) SWAP DUP C@ ASCII (
  = 0= IF 2DROP ;S THEN CR ." #"
  SCR ? SWAP -TRAILING TYPE ;      
: IND. ( 1st last -- ; INDEX on non-empty )
  1+ SWAP DO I (INDEX)
    ?TERMINAL IF LEAVE THEN LOOP ;
: DIR 0 89 IND. ; 
: D:  DR0 ; : D1: DR0 ; : D2: DR1 ;

( most basic string operations )
( only as a start of more complex module )
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
( 0 VARIABLE A$ 80 ALLOT )
( 0 VARIABLE B$ 80 ALLOT )
( A$ $" HELLO WORLD!" )
( A$ CTYPE )
( B$ $" HELLO UNIVERSE!" )
( B$ CTYPE )
( A$ CZ! )
( A$ ZTYPE )
( done )

( Local variables by Baranov, Nozdrunov; )
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

( TURNING THE STACK INTO LOCAL VARIABLES
( Marc Perkel 
( https://www.forth.org/fd/FD-V03N6.pdf
( tunings for Atari 8-but APX Forth by BartGo 

HEX 0 VARIABLE [ARG] 0 VARIABLE [TO]
: +ARG <BUILDS , DOES> @ [ARG] @ SWAP - [TO] @ -DUP
  IF 0< IF +! ELSE ! ENDIF ELSE @ ENDIF 0 [TO] ! ;
 0 +ARG S1  2 +ARG S2  4 +ARG S3  6 +ARG S4
 8 +ARG S5  A +ARG S6  C +ARG S7  E +ARG S8 10 +ARG S9
: TO  1 [TO] ! ; : +TO -1 [TO] ! ;
: ARGUMENTS R> [ARG] @ >R >R 2 * SP@ + DUP [ARG] !
  12 - SP@ SWAP - 2 / 0 DO 0 LOOP 0 [TO] ! ;
: RESULTS 2 * [ARG] @ SWAP - SP@ - 2 / 0 DO DROP LOOP
  R> R> [ARG] ! >R ;
DECIMAL

( : BOX ( n n n -- n n )
(  3 ARGUMENTS
(    S1 S2 S3 * * TO S4
(    S1 S2 S3 + + TO S5
(    S5 TO S1 
(    S4 TO S2
(  2 RESULTS ;
( 2 3 4 BOX .

( ----------------------------- )
( Local/scoped words by BartGo; )
( for Atari 8-bit APX fig-Forth )
( ----------------------------- )
( based on an idea published in )
( Forth Dimensions [FD] - V06N6 )
( by Carol Pruitt, 11-Jun-84 w/ )
( the below licence note:       )
( ----------------------------- )
( Copyright[c] 1985 by the      )
( University of Rochester. All  )
( rights reserved. Permission is)
( hereby granted for personal,  )
( non-commercial use provided   )
( this notice accompanies such  )
( use. 
( ----------------------------- )
( the original idea used a bit  )
( to mark local words; instead, )
( I follow an existing fig-Forth)
( convention of word names in   )
( paretheses meaning "internal" )
( ones. by FOLD'ing [ n -- ] we )
( request that lfa links are    )
( only preserved in non-internal)
( words, so the internal/local  )
( ones are not searchable - but )
( the references are preserved. )
( ----------------------------- )
( purpose: hide non-local words )
( ----------------------------- )
( usage: HERE ..declare.. FOLD  )
( or: ' FIRST-TO-CLEAN NFA FOLD )
( ----------------------------- )

FORTH DEFINITIONS DECIMAL

40 CONSTANT CHAR.LOC
0 VARIABLE LINK.FROM
: FOLD ( here -- )
  LATEST DUP LINK.FROM !
  BEGIN 2DUP < WHILE
    DUP	1+ C@ CHAR.LOC
    = IF
	  PFA LFA @ DUP
	  LINK.FROM @ !
    ELSE
	  PFA LFA DUP
	  LINK.FROM ! @
    THEN REPEAT 2DROP ;

( enable hooks )
: (FLAVOR) ( -- )
  ' (MESSAGE) CFA ' MESSAGE !
  ' ;S        CFA ' MESSAGE 2+ !
  ' (PROMPT)  CFA ' QUIT  26 + !
  ' (HOME)    CFA ' ABORT  6 + !
  ' (HELLO)   CFA ' ABORT 35 + ! ;
: FLAVOR (FLAVOR) 125 EMIT (VER)  
  ." FLAVOR is ON." CR .FRE CR
  ." 'SAVE' and 'COLD' to proceed." CR CR ;
  
( disable hooks )
: PURGE ( -- ) 
  ' WARNING    CFA ' MESSAGE    !  
  ' @          CFA ' MESSAGE 2+ ! 
  ' PROMPT     CFA ' QUIT 26 +  ! 
  ' CR         CFA ' ABORT 6 +  ! 
  ' QUIT       CFA ' ABORT 35 + ! 
  ' EXTENSIONS LFA @ PFA FENCE  !
  148 710 ! 125 EMIT
  32 7903 C! ( reverse (VER) 
  32 7904 C! ( so 1.1eN -> 1.1 )
  ." FLAVOR is OFF." CR .FRE CR
  ." Use 'FLAVOR' to reenable," CR
  ." 'FORGET EXTENSIONS' to obliterate." CR
  ." 'SAVE' and 'COLD' to save." CR CR ;
( later, PURGE is redefined with UNRAVEL )


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
: GOIN GOESINTO ; 
 
: ED-HELP ( -- ; display FIG EDITOR help )
  CR
  CR ." m SCR ! -> select screen m"
  CR ." .BUFS   -> show buffers"
  CR ." --------- EDYTOR-FORTH by RP
  CR ." E.      -> edit screen n"
  CR ." EE.     -> edit current screen"
  CR ."            Esc+space exits"
  ( CR ." EF-HELP -> cheatsheet
  CR ." --------- FIG LINE EDITOR"
  CR ." n &     -> add text in line n (P)"
  CR ." n XX    -> delete text in line n (E)"
  CR ." FL.     -> save (FLUSH)"
  CR ." EB.     -> undo (EMPTY-BUFFERS)"
  CR ." L.      -> LIST current screen"
  CR ." N. / P. -> LIST next/previous screen"
  CR ." --------- QMEG (if present)" 
  CR ." QMG     -> enters QMEG's menu" 
  CR ." MLM or MON enters QMEG's monitor" 
CR CR ;
  
: EF-HELP ( -- )  ;  
  
  ( TODO: add RP's editor, remove conflicts 
  ( e.g. L.
  ( consider removing IND
  ( how about tape management?
  
: HELP ( -- ; display help )
  CR
  CR ." VER for version, .FRE for memory info"
  CR ." EVLIST for an extended word list"
  CR ." ED-HELP to help on the source editors"
  CR ." \? XYZ for help on the word XYZ"
  CR ." STACK to _toggle_ stack display"
  CR ." .S to show the stack"
  CR ." .CC for CONTEXT and CURRENT info"
  CR ." D1: or D2: and DIR to browse floppies"
  CR ." .BUFS to show disc buffers"
  CR ." n m SEARCH XYZ search XYZ on screens"
  CR ." DECOMP XYZ to decompile word XYZ"
  CR ." GOIN XYZ for recursive decompiler"
  CR ." BREAK to debug, GO to proceed"
  CR ." || is BREAK alias, ?| is conditional"
  CR ." UNRAVEL-ON /-OFF - err/stack trace"
  CR ." RE: and ;RE allows redefining words"
  CR ."   : X ;  RE: X ;RE ( to redefine X )"
  CR ." ' XYZ LOCATE to locate uses of XYZ"
  ( THRU removed as not reliable yet )
  ( CR ." n m THRU to load screens w/out -->" )
  CR ." WHERE for the last loading error"
  CR ." PURGE removes interpreter plugins"
  CR CR ;



( EDYTOR-FORTH /STARTS @ )
( autor: Roland Pantola )
( [c] 1992 T.A. ) 


FORTH FORTH DEFINITIONS
0 VARIABLE #GGE
: GGE #GGE @ ; 129 #GGE !
: <=< OVER > >R < R> * ; ASSEMBLER
CODE INSTR 3 ,X LDA, XSAVE
 3 + STA, 2 ,X LDY,
0= IF, XSAVE 3 + DEC,
THEN, DEY, XSAVE 2+ STY,
0 ,X LDY, 4 ,X LDA,
BEGIN, XSAVE 2+ )Y CMP,
0= NOT IF, DEY, THEN,
0= UNTIL, 4 ,X STY,
 POPTWO JMP, END-CODE 
( A ADR DLU --- NR )
: SELECT <BUILDS SMUDGE ] DOES>
SWAP 2 * + @ EXECUTE ;
: % COMPILE CLIT BL WORD HERE
NUMBER DROP -1 OVER 256 <=< 0=
IF CR ." Error: % " DUP .
 ENDIF C, ; IMMEDIATE
0 VARIABLE #C 2 ALLOT
64 #C C!
0 #C 1+ C!
32 #C 2+ C!
96 #C 3 + C!

ASSEMBLER
CODE CMOVE> 2 ,X LDA, XSAVE 2+
STA, 4 ,X LDA, XSAVE 4 + STA,
1 ,X LDA, CLC, 5 ,X ADC,
XSAVE 5 + STA, 1 ,X LDA,
CLC, 3 ,X ADC, XSAVE 3 + STA,
BEGIN, 0 ,X LDY,
BEGIN, DEY, XSAVE 4 + )Y LDA,
XSAVE 2+ )Y STA, 0 # CPY, 0=
UNTIL, XSAVE 5 + DEC, XSAVE
3 + DEC, 0 ,X LDA, 0= IF,
1 ,X LDA, 0= NOT
IF, 1 ,X DEC, THEN, THEN,
0 # LDA, 0 ,X STA,
 1 ,X LDA, 0= UNTIL, 
INX, INX, XSAVE STX, POPTWO
JMP, END-CODE ASSEMBLER

CODE ASC-PEEK XSAVE STX,
2 ,X LDA, XSAVE 2+ STA,
3 ,X LDA, XSAVE 3 + STA,
0 ,X LDY,
BEGIN, DEY, XSAVE 2+ )Y LDA,
96 # AND, .A LSR, .A LSR,
.A LSR, .A LSR, .A LSR, TAX,
XSAVE 2+ )Y LDA,
255 96 - # AND, #C ,X ORA,
XSAVE 2+ )Y STA, 0 # CPY,
0= UNTIL, XSAVE LDX,
POPTWO JMP, END-CODE

: PEEK-ASC OVER OVER 2 0
DO ASC-PEEK LOOP ;
( ADDR DLU --- )
4 VARIABLE XPOS 4 VARIABLE YPOS
: XPOS@ XPOS @ ;
: YPOS@ YPOS @ ;
: POSE YPOS ! XPOS ! ;
48 CONSTANT ZERO
: X! % 85 ! ; : Y! % 84 C! ;
: X@ % 85 @ ; : Y@ % 84 C@ ;
: POS Y! X! ;
: 0.R ' ZERO CFA ' SPACE ! .R
' BL CFA ' SPACE ! ;
: BEEP 253 EMIT ;  

VOCABULARY EDITOR IMMEDIATE
EDITOR DEFINITIONS
: #DLE [ 112 C, 66 C, 48032 ,
2 C, 2 C, 2 C, 2 C, 2 C, 2 C,
 2 C, 2 C, 2 C, 2 C, 2 C, 2 C, 2
 C, 2 C, 2 C, 2 C, 2 C, 2 C, 2
 C, 2 C, 2 C, 2 C, 2 C, 2 C, 2
 C, 2 C, 2 C, 65 C, 47998 , ] ;
: #SCR? 0 % 10 POS ." SCR"
  0 % 12 POS SCR @ 3 0.R ;
: ADBUFF HERE 260 + ;
: LBUFF ADBUFF 2 - ;
: CZYBUFF ADBUFF % 4 -
@ 31886 = ;

: #BUFF? CZYBUFF IF LBUFF
@ ELSE 0 ADBUFF 2 - ! 31886
ADBUFF 4 - ! 0 ENDIF 0 % 16 POS
." BUF" 0 % 18 POS % 3 0.R ;
: #DISPE ' #DLE 47998 % 34
CMOVE 47998 560 ! 48032 % 88 !
; : #RAMKA % 125 EMIT % 88 @
% 28 0 DO DUP I % 40 * + % 3 +
% 124 SWAP OVER OVER % 33 + ! !
LOOP DROP #SCR? #BUFF? ;
0 VARIABLE #LINIA0
: #W# SCR @ B/SCR * DUP B/SCR +
SWAP ; : #WEJ #W# DO I
 BLOCK % 128 ASC-PEEK LOOP ; 
: #WYJ #W# DO I BLOCK % 128
PEEK-ASC LOOP ;
48036 CONSTANT ADE: : ADLINE
% 40 * ADE: + ;
: #KP SWAP OVER OVER 1 - C!
OVER OVER 32 + C! DROP DROP ;
: KK? ADLINE % 84 #KP ;
: PP? ADLINE % 124 #KP ;
: #LIN# DUP % 4 /MOD SCR @
B/SCR * + BLOCK SWAP % 32 * +
SWAP ADLINE #LINIA0 @ % 40 * -
; : LIN-E: #LIN# % 32 CMOVE ;
: EK-E: #LINIA0 @ DUP % 28 +
SWAP DO I LIN-E: LOOP ;
: LIN-BUF #LIN#  SWAP % 32
 CMOVE ; 

: EK-BUF #LINIA0 @ DUP % 28 +
SWAP DO I LIN-BUF LOOP ;
: E:V ADLINE DUP % 40 - % 26
ADLINE DO I DUP % 40 + % 32
CMOVE -40 +LOOP % 32 ERASE ;

: E:^ ADLINE % 40 +
% 28 ADLINE
SWAP DO I DUP % 40 - % 32
CMOVE % 40 +LOOP % 27 ADLINE
% 32 ERASE ;

: LINB #LINIA0 @ + ;
: E: ADE: % 4 - 
XPOS@ + YPOS@
% 40 * + ; : E:@ E: C@ ;
: E:! E: C! ;

: #KUR E:@ DUP % 127 >
IF % 128
- ELSE % 128 +
ENDIF E:! ;

: &PP
POSE #LINIA0 @ DUP 0=
IF 0 KK? ELSE 0 PP? ENDIF
% 4 = IF % 27 KK? ELSE % 27
PP? ENDIF ;

: #POS SWAP DUP % 4 < IF DROP
% 35 SWAP % 1 - SWAP ENDIF
DUP % 35 > IF DROP % 4 SWAP
1+ SWAP ENDIF SWAP
DUP 0 < IF #LINIA0 @ IF % 27
LINB LIN-BUF
 -1 #LINIA0 +! 0 E:V 0 LINB
LIN-E: DROP 0
ELSE DROP % 27 ENDIF ENDIF
DUP % 27 > IF #LINIA0 @ 4 =
IF DROP 0 ELSE
0 LINB LIN-BUF 1 #LINIA0 +! 0
E:^ % 27 LINB LIN-E:
DROP % 27 ENDIF ENDIF &PP ; 
: #PISZ DUP SP@ 1 ASC-PEEK #KUR
 E:! XPOS@ 1+ YPOS@ #POS #KUR ;
: #KXY@ #KUR XPOS@ YPOS@ ;
: #PK #POS #KUR ;
: ?< #KXY@ SWAP 1 - SWAP #PK ;
: ?> #KXY@ SWAP 1+ SWAP #PK ;
: ?^ #KXY@ 1 - #PK ;
: ?V #KXY@ 1+ #PK ;
: #RET #KXY@ 1+ SWAP DROP % 4
SWAP #PK 0 LBUFF ! #BUFF? ;
: #COF #KXY@ SWAP 1 - SWAP #POS
0 E:! #KUR ; : BFREE 430 LBUFF
@ % 32 * + 471 @ HERE - U< ;
: >BUFF YPOS@ ADLINE ADBUFF
LBUFF @ % 32 * + % 32 CMOVE
 1 LBUFF +! #BUFF? ; 

0 VARIABLE #CM 67 ALLOT
: #BU# % 28 #LIN# DROP DUP
% 32 + % 96 ;
: #EB# % 27 ADLINE % 28 LINB
#LIN# DROP ;
: BUFV #BU#  CMOVE> ;

: BUF^ #BU# OVER >R >R SWAP R>
CMOVE R> % 64 + % 32 ERASE ;
: XSP DO I C@ 0= 0= IF DROP I
LEAVE ENDIF LOOP ;

: OSTLIN #LINIA0 @ % 4 = IF 0
 % 27 ADLINE DUP % 32 + 
SWAP XSP ELSE 0 % 31 #LIN#
DROP DUP % 32 + SWAP XSP
ENDIF 0= ;

: #^^ BFREE IF #KUR >BUFF
YPOS@ E:^ #LINIA0 @
% 4 < IF #EB# SWAP % 32
CMOVE ENDIF BUF^ #KUR
ELSE BEEP BEEP ENDIF ;

: #VV OSTLIN IF
#KUR BUFV #LINIA0 @ % 4 <
IF #EB# % 32 CMOVE ENDIF
YPOS@ E:V #KUR ELSE BEEP
ENDIF ;

: #<BF OSTLIN IF LBUFF @ IF #VV
-1 LBUFF +! ADBUFF LBUFF @
32 * + YPOS@ ADLINE % 32
CMOVE #BUFF? #KUR ENDIF ELSE
BEEP ENDIF ;
: X#CM #CM XPOS@ + % 4 - ;
: XSPAC #CM % 63 + DUP X#CM
XSP #CM % 64 + DUP ROT
DO I C@ 0= I 1+ C@
0= * IF DROP I LEAVE
ENDIF LOOP X#CM - ;
: <#CM> YPOS@ #LINIA0 @ XPOS@
YPOS@ 1+ #POS #LINIA0 @ = 0=
- YPOS ! 
YPOS@ ADLINE #CM OVER OVER
YPOS@ % 27 < IF SWAP % 40
+ SWAP % 32 + ENDIF ;
: 32CM % 32 CMOVE ;
: >#CM  #KUR <#CM> #CM 66
ERASE 32CM 32CM ;
: <#CM <#CM> SWAP 32CM SWAP
32CM #KUR ;
: #>> >#CM XSPAC #CM % 63 +
C@ 0= OVER X#CM + #CM - % 63
< + IF X#CM DUP 1+ ROT
CMOVE> 0 X#CM C! ELSE BEEP
DROP ENDIF <#CM ;
: #<< >#CM X#CM 1+ DUP 1 -
XSPAC CMOVE <#CM ;

: #DUP DUP DUP % 127 >
IF % 128 - ENDIF ;
: ESC DROP KEY #DUP BL = IF
DROP 300 ELSE #PISZ ENDIF ;
: #KLA0 [ 27 C, 28 C, 29 C, 30
C, 31 C, 155 C, 126 C, 254 C,
255 C, 156 C, 157 C, 127 C,
] ;
: #NR-KLAW ' #KLA0 % 12 INSTR ;
SELECT #WYB0 #PISZ ESC ?^ ?V ?<
 ?> #RET #COF #<< #>> #^^ #VV
#<BF ;

FORTH DEFINITIONS
: (E) EDITOR  #WEJ
1 752 C! #DISPE #RAMKA
XPOS@ YPOS@ #POS
EK-E: #KUR
BEGIN
KEY DUP #NR-KLAW #WYB0
300 = UNTIL
#KUR EK-BUF #WYJ FORTH ;
: EXFO % 125 EMIT % 80 % 88 +!
." FORTH" CR 0 752 C! ;
: CLEAR % 16 0 DO I SCR @
(LINE) DROP C/L BLANKS UPDATE
LOOP ; ( TODO )

( EDYTOR-FORTH /ENDS     )
( ED-DYSK )
: MARK SCR @ % 8 * % 8 0 DO I
OVER + BLOCK DROP UPDATE
LOOP DROP ;
: EE. (E) EXFO ; ( renamed E. )
: E. SCR ! E. ; (renamed L.) 
: F. MARK FLUSH ; ( TODO: unclash with floating point ! )
: INDE EMPTY-BUFFERS
GGE SWAP GGE 1 - MIN
DO I 8 * BLOCK 32 -TRAILING
OVER @ DUP 8224 = 0= * IF CR
I . SPACE TYPE ELSE 2DROP ENDIF
?TERMINAL IF LEAVE ENDIF
LOOP EMPTY-BUFFERS ;
: IND 1 INDE ; 

( /END )


ASSEMBLER HEX
( RP@ code finally found in the Blazin' Forth sources )
CODE RP@ 
  XSAVE STX, TSX, TXA, PHA, 1 # LDA,
  XSAVE LDX, PUSH JMP,
  END-CODE

( ** CALL ** )
( David Held, Forth Dimension V/5 p. 22 )
( David Held, Forth Dimension V/3 p. 23 )
( Test: call selftest ->  HEX E471 CALL )
CODE (CALL)
    XSAVE STX,    0 JSR,
    XSAVE LDX, NEXT JMP,
 END-CODE
 
FORTH HEX
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
: MON MEMUP E480 CALL ;
: QMG MEMUP E471 CALL ;
DECIMAL


( Add a Break Point Tool / BREAK & GO )
( Frank Seuberling / Kim Harris - FDv5n1p19 )
( with small tunings by BG )
: .RS ( -- )
  CR ." RS: " RP@ R0 2 -
  DO I @ U. -2 +LOOP CR ;
0 VARIABLE RP*
( TODO: consider behavior when loading )
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

(FLAVOR) CR CR 
CR ." Please insert a formatted floppy"
CR ." to overwrite and press RETURN"
CR ." or ENTER. An updated, bootable"
CR ." Forth kernel will be saved there." CR
CR ." The computer will then reboot." CR CR
KEY DROP SAVE COLD 

;S ABORT ;S
