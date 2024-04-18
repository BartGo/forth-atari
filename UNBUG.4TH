(          ### UNBUG ###          )
(     A library of debug words.   )
( Collected from Forth Dimensions ) 
( Atari800XL / APX Ext. Fig-Forth )
(  REQUIRES: assembler [39 LOAD]  )
( see also:                       )
(  https://www.atarimagazines.com )
(  /software/83-09/FORTHASM.4TH   )

FORTH DEFINITIONS DECIMAL

: UNBUG( ;

( ******* BUFS ******* )
( REQUIRES: NOTHING )
( TDH 7/11/81 FD-V03N6 )
: .BUFS ( display addresses of all the buffers )
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
: .CC CR ." Context Current: "
  CONTEXT @ 4 - NFA ID.
  CURRENT @ 4 - NFA ID. CR ; 

( *** zap word - IRREVERSIBLY *** )
( *** replace word in nucleus *** )
( *** usage:  ' OLD ' NEW ZAP *** )
( REQUIRES: NOTHING               )
: ZAP ( oldpfa newpfa -- ) 
  CFA OVER ! ( new pfa into old )
  [ ' ;S CFA ]   LITERAL OVER 2+ !
  [ ' ;  CFA @ ] LITERAL SWAP CFA ! ;

( ***** S0, R0, S. ***** )
( REQUIRES: NOTHING      )
: S0 TIB 4 - @ ; ( -- n )
: R0 TIB 2 - @ ; ( -- n )
: S. SP@ S0 = 0= IF
    SP@ 2 - S0 2 - DO I @ . -2 +LOOP
  ELSE ." Stack empty " THEN ;

( ******* RP@ ****** )
( from Blazin' Forth )
( REQUIRES: assembler [39 LOAD] )
CODE RP@ 
  XSAVE STX,
  TSX, TXA, PHA,
  1 # LDA,
  XSAVE LDX,
PUSH JMP,

( ***** .EVAR **** )
( REQUIRES: S0, R0, RP@, asm [39] )
: (VC) ( pfa -- )
    DUP CFA EXECUTE
	4 4 + .R 
    NFA SPACE ID. CR ;
: (VV) ( pfa -- )
    DUP CFA EXECUTE   DUP
	4 .R              C@ 4 .R 
    NFA SPACE ID. CR ;
: .SYS ( -- )
  CR 5 SPACES
  ." Val System-Constant" CR
  ' BL    (VC)  '   C/L (VC) 
  ' FIRST (VC)  ' LIMIT (VC)
  ' B/BUF (VC)  ' B/SCR (VC) 
  ( ' RP@ (VC)
  ( ' SP@ (VC)
  ;
: .USR ( -- )
  CR ." Addr Val User-Variable" CR
  ' S0       (VV)  ' R0      (VV)
  ' TIB      (VV)  ' WIDTH   (VV)
  ' WARNING  (VV)
  ' FENCE    (VV)  ' DP      (VV)
  ' VOC-LINK (VV)  ' BLK     (VV)
  ' IN       (VV)  ' OUT     (VV)
  ' SCR      (VV)  ' OFFSET  (VV)
  ' CONTEXT  (VV)  ' CURRENT (VV)
  ' STATE    (VV)  ' BASE    (VV)
  ' DPL      (VV)  ' FLD     (VV)
  ' CSP      (VV)  ' R#      (VV)
  ' HLD      (VV)
  ( and? ... )
  ' USE      (VV)
  ' PREV     (VV)
  ' UP       (VV) 
  ' PAD      (VV) ;
: .EVAR ( -- )
  .SYS .USR ;

( *********** R.N ************* )
( Shows the return stack        )
( REQUIRES: assembler [39], RP@ )
: R.N RP@ R0 = 0= IF ( TODO: TEST )
    RP@ 2 - R0 2 - DO I @ U. -2 +LOOP
  THEN ;

( **** BREAK&GO **** )
( https://www.forth.org/fd/FD-V05N1.pdf )
( REQUIRES: assembler [39], RP@, R0, S0, S., R.N )
0 VARIABLE RP*
: BREAK 
  CR ." (BREAK reached, type GO to proceed)"
  CR ." S= " S.
  CR ." R= " R.N CR 
  RP@ 4 - RP* ! 0 BLK ! BEGIN
    QUERY INTERPRET ." aok" CR
  AGAIN ;
: || BREAK ;
: GO RP@ RP* @ = IF
    R> DROP R> DROP
  ELSE
    ." can't resume " QUIT
  THEN ;

( ***** AUGMENTED TRACE ***** )
( https://www.forth.org/fd/FD-V06N5.pdf )
( REQUIRES: assembler [39], RP@, R0     )
( FIXME: UNRAVEL sometimes fails, with  )
(        short words and other cases    )
: HIGH? ( cfa -- f )
  DUP  @    [ ' : @ @ ] LITERAL =
  SWAP @ C@ [ ' FORTH @ C@ ] LITERAL = OR ;
: (UNLINE) CR SPACE DUP 4 .R SPACE ;
: UNRAVEL ( -- )
  BEGIN RP@ R0 = 0=
  WHILE
      R> DUP CFA @ DUP ( n2 n n ) 
      HIGH?            ( n2 n f  )
    IF
      (UNLINE) NFA ID. DROP
    ELSE
      (UNLINE) DROP U.
    THEN
  REPEAT QUIT ; ( original QUIT replaced with BREAK )

( *** stack trace ON / OFF *** )
( REQUIRES: assembler [39], RP@, R0, UNRAVEL )
: TRACE-ON  ' UNRAVEL CFA 7290 ! ; ( replace 'QUIT' IN 'ERROR' with UNRAVEL + QUIT )
: TRACE-OFF ' QUIT    CFA 7290 ! ; ( restore default )

: )UNBUG ;

( fig-F*RTH hacked with a heart )
( 0 7894 C!  SAVE ) 

( *** step tracing TBD *** )

;S

(
 : UN UNRAVEL ; 
 : R3 UN ;
 : R2 R3 ;
 : R1 R2 ;
 : TEST-UNRAVEL R1 ;
)


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
