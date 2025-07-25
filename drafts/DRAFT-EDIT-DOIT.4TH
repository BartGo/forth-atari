( FIX ME - totally broken for now )
( Calfee's Turbo 4th EDITOR "DOIT" port to APX Forth )

HEX VOCABULARY EDITOR IMMEDIATE

( OS & HDW CONSTANTS )

D200 CONSTANT F1AUD
D201 CONSTANT C1AUD
D202 CONSTANT F2AUD
D203 CONSTANT C2AUD
D204 CONSTANT F3AUD
D205 CONSTANT C3AUD
D206 CONSTANT F4AUD
D207 CONSTANT C4AUD
D20F CONSTANT SKCTL
D208 CONSTANT AUDCTL
 230 CONSTANT DLST
 22F CONSTANT DMCT
  14 CONSTANT RTCLK
 2F0 CONSTANT CRSINH
  F4 CONSTANT CHBAS
 2C4 CONSTANT COL0
 2C5 CONSTANT COL1
 2C6 CONSTANT COL2
 2C7 CONSTANT COL3   
 2C8 CONSTANT COL4
D01F CONSTANT CONSOL 
 2FC CONSTANT CH
 2BF CONSTANT BOTSC   
  52 CONSTANT LMARGN
 2FB CONSTANT ATACHR

( CIO CALL ROUTINES )

340 VARIABLE IOC
  0 VARIABLE IOB

: IOCB 7 MIN 0 MAX 10 * DUP IOB
  ! 340 + IOC ! ;
: .IOC <BUILDS , DOES> @ IOC @ +  ;

1 .IOC ICDNO
2 .IOC ICCOM
3 .IOC ICSTA
4 .IOC ICBAL
6 .IOC ICPTL
8 .IOC ICBLL
A .IOC I1CAX
B .IOC I2CAX

( CODE CIO
(   TXA, PHA, IOB LDX, E456 JSR,
(   PLA, TAX, NXT, END-CODE
  
CODE Get
 XSAVE STX, IOB LDX, E456 JSR,
 XSAVE LDX, PUSH0A JMP, END-CODE

: GET 7 ICCOM C! Get ;

( END OF PREREQUISITES )

: EDIT SCR ! [COMPILE] EDITOR ;

EDITOR DEFINITIONS

0 VARIABLE TOPFLAG

: ULL DUP TOPFLAG ! ( 0 GR. ) 125 EMIT
  2203  LMARGN ! 3 0 POS. ( 32 CHAR )
  1 2FE C! ( PRINT ALL CHARS )
  SCR @ BLOCK + 200 TYPE ( PRINT )
  0 2FE C! ( CURSOR CNTRLS )
  CR ." DOIT" CR 0AAAA 2B2 ! ;
: UL 0 ULL ; 
: LL 200 ULL ;
: DOIT 10 0 DO -1 2B2 !
  3 I POS. ( POINT CURSOR )
  SCR @ BLOCK I 20 * + TOPFLAG @ +
  ICBAL ! 20 ICBLL ! GET DROP
  LOOP UPDATE ( 0 GR. ) 125 EMIT TOPFLAG @ 0=
  IF UL ELSE LL ENDIF ;
: FLUSH 2602 LMARGN ! [COMPILE] FORTH FLUSH ;

FORTH  DEFINITIONS   HEX

: TEXT ( ACCEPT FOLLOWING TEXT TO PAD *)
  HERE  C/L  1+   BLANKS  WORD  HERE
  PAD  C/L  1+  CMOVE  ;
: #OFLINES B/BUF B/SCR * C/L / ;
: LINE             ( RELATIVE TO SCR, LEAVE ADDRESS OF LINE *)
  DUP  #OFLINES            MINUS AND IF ." NOT ON SCREEN" ABORT
  ENDIF  ( KEEP ON THIS SCREEN )        SCR  @  (LINE)  DROP  ;

(  LINE EDITING COMMANDS )

EDITOR DEFINITIONS
: -MOVE   ( MOVE IN BLOCK BUFFER ADDR FROM-2,  LINE TO-1 *)
  LINE  C/L  CMOVE  UPDATE  ;
: HL                      ( HOLD NUMBERED LINE AT PAD *)
  LINE  PAD  1+  C/L  DUP  PAD  C!  CMOVE  ;
: BL                     ( ERASE LINE-1 WITH BLANKS *)
  LINE  C/L  BLANKS  UPDATE ;
: SL                    ( SPREAD MAKING LINE # BLANK *)
  DUP  1  -  ( LIMIT )      #OFLINES 2 -  ( FIRST TO MOVE )
  DO  I  LINE  I  1+  -MOVE   -1  +LOOP  BL ;
: DL            ( DELETE LINE-1, BUT HOLD IN PAD *)
  DUP  HL  #OFLINES   1   -       DUP  ROT
  DO  I  1+  LINE  I  -MOVE  LOOP  BL ;
: CL  ( COPY LINE-2 OF SCREEN-1  TO PAD )
  SCR @ >R SCR ! HL R> SCR ! ;

(  LINE EDITING COMMANDS                           WFR-790105 )

: RL                             ( REPLACE ON LINE-1, FROM PAD )
  PAD  1+  SWAP  -MOVE  ;
: $                        ( PUT FOLLOWING TEXT ON LINE-1 )
  1  TEXT  RL  QUIT  ;
: %                ( INSERT TEXT FOLLOWING AFTER LINE-1 *)
  1   TEXT  1+  DUP  SL  RL  ;
: IL       (  INSERT  PAD  AFTER LINE-1 ) 1+  DUP  SL  RL  ;
: TL   ( TYPE LINE BY #-1,  SAVE ALSO IN PAD *)
  DUP . ." $ "                    HL PAD  1+  C/L  TYPE  CR ;

(  SCREEN EDITING COMMANDS )

FORTH DEFINITIONS

: COPY  (  SRCBLK DESTBLK --- ^ COPY SCREEN *)
  >R >R ?STACK    R> R> SWAP BLOCK SWAP BUFFER
  400 CMOVE UPDATE FLUSH  ;
: LIST 2602 LMARGN ! LIST ;
: SHOW 1+ SWAP DO I LIST LOOP ;
: L SCR @ LIST ( RE-LIST SCR ) ;
: N SCR @ 1+ LIST ;  ( LIST NEXT SCR)
: WHERE ( OFFSET BLK --- ) DUP  SCR ! ." SCR # " . CR C/L /MOD
  EDITOR TL FORTH 2 + SPACES      5E EMIT [COMPILE] EDITOR QUIT ;
: SCOPY ( FIRST LAST NEWFIRST --- ^ COPY FROM FIRST TO NEWFIRS)
  ROT ROT 1+ SWAP DO >R ?STACK R>
  I OVER COPY 1+ LOOP DROP  ;

BASE @ DECIMAL
' EDITOR 3 + 32 +ORIGIN ! ( VOC-LINK )
BASE ! ;S

