( APX Forth spin-off, 'R' variant )
( with WFR assembler  and RP's EDYTOR-FORTH )

( no graphics words included ; intended use )
(  - higher compatibility with assembly code )
(    published and used in other 6502 forths )
( - compatibility with mr. Pantola's editor  )
(   and routines                             )

( 21 LOAD ) ( DEBUG WORDS )
( 76 LOAD ) ( WFR ASSEMBLER ) ( <- \!/ )

FORTH DEFINITIONS DECIMAL 0 WARNING !

: CORE ;

FORTH DEFINITIONS DECIMAL 0 WARNING !


: EXTENSIONS ;

ASSEMBLER HEX
( RP@ code finally found in the Blazin' Forth sources )
CODE RP@ 
  XSAVE STX, TSX, TXA, PHA, 1 # LDA,
  XSAVE LDX, PUSH JMP,
END-CODE
FORTH DECIMAL
  
: (VER) ( version 1.1r8 )
  ASCII r 7903 C! ASCII 8 7904 C! ;
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
  CR ."    Tunings and tools collected by"
  CR ."           BartGo, v2026/"
  7903 C@ EMIT 7904 C@ EMIT
    CR ."    ------------------------------"
  CR ."    * Assembler by Bill Ragsdale *"
  CR ."    ------------------------------"
  CR ."    EDYTOR-FORTH by Roland Pantola"
  CR ."    =============================="
  CR ."    For the glory of Atari & Forth"
  CR ."    & PTODT (https://ptodt.org.pl)"  
  CR ."    =============================="
  CR CR ;

: .FRE ( -- ) 741 @ HERE - U. ." bytes free" ; 

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
  CR .FRE 80 SCR ! 
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
( FIG edit minimal subset, in the FORTH vocabulary )
( also, used by SEARCH )
: TEXT/ HERE C/L 1+ BLANKS WORD HERE PAD C/L 1+ CMOVE ;
: LINE/ DUP FFF0 AND 17 ?ERROR SCR @ (LINE) DROP ;
: -MOVE/ LINE/ C/L CMOVE UPDATE ; 
: P 1 TEXT/ PAD 1+ SWAP -MOVE/ ; ( = P )
: L. SCR @ LIST ; 
: N. 1 SCR +! L. ; : P. -1 SCR +! L. ;
: WHERE DUP B/SCR / DUP SCR
    ! ." SCR # " DECIMAL .
    SWAP C/L /MOD C/L * ROT BLOCK +
    CR C/L -TRAILING TYPE CR
    HERE C@ - SPACES 1 2FE C!
    1C EMIT 0 2FE C! SP! QUIT ; 
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

: (HOME) ( -- ) 144 710 ! 125 EMIT ;

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
( FIXME: not showing the ok-editor )
: ok-editor ; ( omit it like ok )  

FORTH DEFINITIONS HEX

( MERGE WITH EVLIST ) 
: .CC ( -- ; show CONTEXT and CURRENT)
  CR ." Context Current: "
  CONTEXT @ 4 - NFA ID.
  CURRENT @ 4 - NFA ID. CR ; 

: EVLIST ( -- ; extended VLIST )
  CR 80 OUT ! CONTEXT @ @ .CC CR
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
 

( 6502 Disassembler by John Mattes )              
HEX FORTH DEFINITIONS

0 VARIABLE POINTER
0 VARIABLE MULTIMODE -2 ALLOT
1D , 1E , 3C , 3D , 3E , 5C ,
5D , 5E , 7D , 7E , 9C , 9D ,
9E , BC , BD , BE , DC , DD ,
DE , FC , FD , FE ,
: SEEKD 1 + 0 DO OVER OVER I 2
* + C@ - DUP 0= IF DROP
DROP DROP I 1 LEAVE ELSE
0 < IF DROP DROP I 0 LEAVE
ENDIF ENDIF LOOP ;
: STRING BL BLK @ IF BLK @ BLOCK
ELSE TIB @ ENDIF IN @ + SWAP
ENCLOSE IN +! OVER - >R +
HERE R CMOVE R> ALLOT ;
0 VARIABLE MULTINAME -2 ALLOT
STRING ORAASLBITANDROLJMPEORLSR
STRING ADCRORSTYSTASTXLDYLDALDX
STRING CPYCMPDECCPXSBCINC
: CHKMODE DROP DUP 2 *
' MULTIMODE + @ POINTER @ C@ -
4 /MOD SWAP IF SWAP 1+ SWAP ENDIF ;
0 VARIABLE ONENAME -2 ALLOT
STRING BRKPHPASLBPLCLCJSRPLPROL
STRING BMISECRTIPHALSRBVCCLIRTS
STRING PLARORJMPBVSSEIDEYTXABCC
STRING STXTYATXSLDYLDXTAYTAXBCS
STRING LDXCLVTSXLDXINYDEXBNECLD
STRING INXNOPBEQSED???
0 VARIABLE ONEMODE -2 ALLOT
2C00 , 2C08 , 280A , 3010 ,
2C18 , 1020 , 2C28 , 282A ,
3030 , 2C38 , 2C40 , 2C48 ,
284A , 3050 , 2C58 , 2C60 ,
2C68 , 286A , 246C , 3070 ,
2C78 , 2C88 , 2C8A , 3090 ,
2096 , 2C98 , 2C9A , 14A0 ,
14A2 , 2CA8 , 2CAA , 30B0 ,
20B6 , 2CB8 , 2CBA , 04BE ,
2CC8 , 2CCA , 30D0 , 2CD8 ,
2CE8 , 2CEA , 30F0 , 2CF8 ,
00FF ,
0 VARIABLE MODE -2 ALLOT
STRING ,X,Y,X)Y..##0PX).Y().AIMRE 
0 VARIABLE LENGTH -2 ALLOT
2 C, 2 C, 1 C, 1 C, 2 C, 1 C,
1 C, 1 C, 1 C, 2 C, 0 C, 0 C,
1 C, 0 C,
: .NAME SPACE SWAP 3 * +
3 TYPE 2 SPACES ;
: .MODE 2 * ' MODE + 2 TYPE
2 SPACES ;
: .ADD POINTER @ C@ DUP 20
= OVER 40 = OR OVER 4C = OR
OVER 60 = OR SWAP 6C = OR
SWAP ' LENGTH + C@ 1 POINTER
+! POINTER @ OVER POINTER +!
OVER 0= IF DROP DROP ELSE
OVER 1 = IF C@ . DROP ELSE
@ 0 D. DROP ENDIF ENDIF ;
: DISASSEMBLE POINTER ! CR
BEGIN CR
POINTER @ DUP 0 D. 2 SPACES
C@ ' ONEMODE 2D SEEKD
IF DUP ' ONENAME .NAME 2 * 1+
' ONEMODE + C@ 4 /
ELSE DROP POINTER @ C@
' MULTIMODE 16 SEEKD
CHKMODE CHKMODE CHKMODE
SWAP ' MULTINAME .NAME ENDIF
DUP .MODE .ADD ?TERMINAL OR
UNTIL ; : DIS DISASSEMBLE ;

DECIMAL
 
: ED-HELP ( -- ; display FIG EDITOR help )
  CR
  CR ." 1) EDYTOR-FORTH by Roland Pantola
  CR ." EDIT    -> edit current screen"
  CR ." n E.    -> edit screen n"
  CR ." Shift+Insert/Delete -> cut/paste" 
  CR ." To exit, press Esc, release, Space" CR
  CR ." 2) FIG LINE EDITOR and screen mngmnt"
  CR ." n SCR ! -> select screen n"
  CR ." L.      -> LIST current screen"
  CR ." N. / P. -> LIST next/previous screen"
  CR ." n P ccc -> put text ccc in line n"
  CR ." .BUFS   -> show buffers"
  CR ." FL.     -> save (FLUSH)"
  CR ." EB.     -> undo (EMPTY-BUFFERS)"
  CR ." n m SEARCH XYZ -> search screens"
  CR ." n LOAD  -> compile from screen n"
  CR ." WHERE   -> show last compile error"
  CR CR ;
 
: HELP ( -- ; display help )
  CR
  CR ." HELP    -> *this* help"
  CR ." VER     -> version"
  CR ." .FRE    -> memory info"
  CR ." .CC     -> context"
  CR ." .S      -> show the stack"
  CR ." ED-HELP -> help on the source editors"
  CR ." \? cc   -> help on the word cc"
  CR ." EVLIST  -> show enhanced VLIST"
  CR ." DECOMP cc   -> decomp cc 
  CR ." GOIN cc     -> decomp cc [Ackerman]"
  CR ." ' cc DIS    -> deassemble cc [Mattes]"
  CR ." ' cc LOCATE -> locate uses of XYZ" 
  CR CR ;

( EDYTOR-FORTH /STARTS )
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
LOOP ; 

( EDYTOR-FORTH /ENDS     )
( ED-DYSK )
: MARK SCR @ % 8 * % 8 0 DO I
OVER + BLOCK DROP UPDATE
LOOP DROP ;
: EDIT (E) EXFO ; ( renamed E. )
: E. SCR ! EDIT ; ( renamed L.) 
: FL. MARK FLUSH ; 
: EB. EMPTY-BUFFERS ;
: INDE EMPTY-BUFFERS
GGE SWAP GGE 1 - MIN
DO I 8 * BLOCK 32 -TRAILING
OVER @ DUP 8224 = 0= * IF CR
I . SPACE TYPE ELSE 2DROP ENDIF
?TERMINAL IF LEAVE ENDIF
LOOP EMPTY-BUFFERS ;
: IND 1 INDE ; : DIR IND ;

( /END )

DECIMAL FORTH DEFINITIONS

: PURGE PURGE DIR ;

: TASK ( -- ; end of EXTENSIONS ) ;

(FLAVOR) CR CR 
CR ." Please insert a formatted floppy"
CR ." to overwrite and press RETURN"
CR ." or ENTER. An updated, bootable"
CR ." Forth kernel will be saved there." CR
CR ." The computer will then reboot." CR CR

KEY DROP SAVE COLD 


