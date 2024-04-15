(              UNBUG             )
(   Debugging words for Atari's  )
(     APX Extended Fig-Forth     )

FORTH DEFINITIONS DECIMAL

: UNBUG( ;

( ***** S0, R0 ***** )
( fig-FORTH_Installation_Manual_May79%20good.pdf )
( REQUIRES: NOTHING )
: S0 TIB 4 - @ ; 
: R0 TIB 2 - @ ; 

( ***** -EXECUTE ***** )
( REQUIRES: NOTHING )
( : -EXECUTE -FIND IF DROP CFA EXECUTE THEN ; IMMEDIATE )

( ******* RP@ ****** )
( from Blazin' Forth )
( REQUIRES: assembler [39 LOAD] )
( TO DO: machine code version )
CODE RP@ ( -- ADDR RETURN STACK 1- )
  XSAVE STX,
  TSX, TXA, PHA,
  1 # LDA,
  XSAVE LDX,
PUSH JMP,

( **** BREAK&GO **** )
( https://www.forth.org/fd/FD-V05N1.pdf )
( REQUIRES: RP@: S., S.: S0 ) ( TBD: R.N )
0 VARIABLE RP*
: S. SP@ S0 = 0= IF
  SP@ 2 - S0 2 - DO I @ . -2 +LOOP
THEN ;
: R.N RP@ R0 = 0= IF ( TEST ME )
  RP@ 2 - R0 2 - DO I @ U. -2 +LOOP
THEN ;
: BREAK 
  CR ." (BREAK hit, GO to proceed)"
  CR ." S= " S.
  CR ." R= " R.N CR 
  RP@ 4 - RP* ! 0 BLK ! BEGIN
    QUERY INTERPRET ." aok" CR
  AGAIN ; : || BREAK ;
: GO RP@ RP* @ = IF R> DROP R> DROP
  ELSE ." can't resume " QUIT THEN ;

( ***** AUGMENTED TRACE ***** )
( https://www.forth.org/fd/FD-V06N5.pdf )
( REQUIRES: RP@, R0 ) 
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
  REPEAT BREAK ; ( original QUIT replaced with BREAK )

( R CFA @ NFA ID. => INTERPRET )

( *** stack trace *** )

: TRACE-ON  ' UNRAVEL CFA 7290 ! ; ( replace 'QUIT' IN 'ERROR' with UNRAVEL + QUIT )
: TRACE-OFF ' QUIT    CFA 7290 ! ; ( restore default )

TRACE-ON

( *** zap word *** )
: ZAP ( oldpfa newpfa -- ) ( replace word in nucleus )
  CFA OVER !                          ( new pfa into old )
  [ ' ;S CFA ]   LITERAL OVER 2+ !    ( force ;S )
  [ ' ;  CFA @ ] LITERAL SWAP CFA ! ; ( force DOCOL)
  ( ' OLD ' NEW ZAP )
: PROMPTX
  PFLAG @ 0 PFLAG ! 
  ." ok" PFLAG !
  BASE @ DUP 10 = IF DROP 0 THEN
  712 C! ;

: )UNBUG ;

' PROMPT ' PROMPTX ZAP
SAVE

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

DEBUGGING TECHNIQUES: pt 1 / UNRAVEL
https://archive.org/details/Forth_Dimension_Volume_06_Number_2/page/n37/mode/2up?q=unravel
DEBUGGING TECHNIQUES: pt 2 / TRACE
https://archive.org/details/Forth_Dimension_Volume_06_Number_3/page/n31/mode/2up?q=unravel
HIGH-LEVEL SINGLE STEPPER
https://archive.org/details/Forth_Dimension_Volume_10_Number_6/page/n14/mode/1up?q=unravel
RDCP
https://archive.org/details/Forth_Dimension_Volume_05_Number_6/page/n14/mode/1up
DEFER
https://archive.org/details/Forth_Dimension_Volume_05_Number_6/page/n34/mode/1up
TASKER
https://archive.org/details/Forth_Dimension_Volume_05_Number_2/page/n19/mode/1up
FORMATTER
- tbc -
DOC TOOL
https://archive.org/details/Forth_Dimension_Volume_04_Number_2/page/n22/mode/1up

