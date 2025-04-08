( MUGWUMP in APX Forth, Atari 8-bit )
( PCC Basic Game ported by BartGo   )

DECIMAL FORTH DEFINITIONS

( required screens: 40 LOAD 50 LOAD )

: |APP| ;
: |DEL| ' FIL FENCE ! ;
  ( FORGET |APP| )

( constants )
 1  CONSTANT DEBUG? ( 0 = DEBUG OFF )
10  CONSTANT GRIDSIZE 
10  CONSTANT FLD
10  CONSTANT GUESSMAX 
160 GRIDSIZE FLD * - 2 / 
    CONSTANT GOFF ( offset; 160: GR.7 )
    : G+ GOFF + ; : C+ G+ FLD 2 / + ;
2   CONSTANT BCOL ( board )
1   CONSTANT GCOL ( guess )
3   CONSTANT RCOL ( range )
2   CONSTANT CCOL ( crcle )
559 CONSTANT SDMCTL
710 CONSTANT COLOR2
82  CONSTANT LMARGN

( variables )
0 VARIABLE GUESSX
0 VARIABLE GUESSY
0 VARIABLE HIDEX
0 VARIABLE HIDEY
0 VARIABLE SDMCTLMEM

: -ROT ROT ROT ;
: S0 18 +ORIGIN @ ; ( -- n )
: .S SP@ S0 = 0= IF ( -- )
    SP@ 2 - S0 2 - DO I @ . -2 +LOOP
  ELSE ." Stack empty " THEN ; : S. .S ;

: (SINTAB) <BUILDS 0 ,              
 174 , 348  ,  522 ,  696 ,  870 ,
1044 , 1218 , 1390 , 1564 , 
1736 , 1908 , 2078 , 2248 , 2418 ,
2588 , 2756 , 2922 , 3090 , 
3254 , 3420 , 3582 , 3746 , 3906 ,
4066 , 4226 , 4382 , 4538 , 
4694 , 4848 , 5000 , 5150 , 5298 ,
5446 , 5590 , 5734 , 5876 , 
6018 , 6156 , 6292 , 6426 , 6560 ,
6690 , 6818 , 6946 , 7070 , 
7192 , 7312 , 7430 , 7546 , 7660 ,
7770 , 7880 , 7986 , 8090 , 
8190 , 8290 , 8386 , 8480 , 8570 ,
8660 , 8746 , 8828 , 8910 , 
8986 , 9062 , 9134 , 9204 , 9270 ,
9334 , 9396 , 9454 , 9510 ,
9562 , 9612 , 9658 , 9702 , 9742 ,
9780 , 9816 , 9848 , 9876 ,
9902 , 9924 , 9944 , 9960 , 9974 ,
9986 , 9992 , 9998 , 10000       ,
DOES> SWAP 2 * + @ ;

(SINTAB) SINTAB 

: S180 DUP 90 > IF 180 SWAP -
  THEN SINTAB ; : SIN
  360 MOD DUP 0< IF 360 + THEN
  DUP 180 > IF 180 - S180 MINUS
  ELSE S180 THEN ; : COS 90 + SIN ;

( RE-DEFINING A COLON WORD     )
( by EHS https://www.forth.org )
(             /fd/FD-V06N3.pdf )
' : CFA @ CONSTANT DOCOL
: (RE:) ( -- )
  -FIND 0= IF HERE COUNT TYPE
  ."  NOT FOUND" QUIT THEN
  DROP DUP CFA @ DOCOL = 0=
  IF HERE COUNT
     TYPE ."  NOT A COLON WORD"
     QUIT THEN HERE SWAP ! ;
: (;RE) ( -- ) R> R> 2DROP ;
: RE: ( -- ) SP@ CSP ! CURRENT @
  CONTEXT ! (RE:) DOCOL , ] ;
: ;RE ( -- ) ?CSP COMPILE (;RE)
  [COMPILE] [ ; IMMEDIATE

( Start: LOCAL VARIABLES in Forth )
( *** by Marc Perkel FD-V03N6 *** )
HEX
0 VARIABLE [ARG]
0 VARIABLE [TO]
: +ARG <BUILDS , DOES> @ [ARG] @
  SWAP - [TO] @ -DUP IF
    0< IF +! ELSE ! ENDIF
  ELSE @ ENDIF 0 [TO] ! ;
 0 +ARG S1  2 +ARG S2  4 +ARG S3
 6 +ARG S4  8 +ARG S5  A +ARG S6 
 C +ARG S7  E +ARG S8 10 +ARG S9
: TO  1 [TO] ! ; : +TO -1 [TO] ! ;
: ARGUMENTS R> [ARG] @ >R >R 2 *
  SP@ + DUP [ARG] ! 12 - SP@
  SWAP - 2 / 0 DO 0 LOOP 0 [TO] ! ;
: RESULTS 2 * [ARG] @ SWAP -
  SP@ - 2 / 0 DO DROP LOOP
  R> R> [ARG] ! >R ;
DECIMAL
( End: LOCAL VARIABLES )

( Dot word with no trailing space )
: .; ( n -- ) S->D 0 D.R ;

: ESC? ( -- ) BEGIN KEY 27 = UNTIL ;

: YN? ( -- n ) ; RE: YN?
  KEY DUP    ( c c   )
  ASCII Y =  ( c f1  )
  SWAP       ( f1 c  )
  ASCII y =  ( f1 f2 ) 
  OR         ( f3    )
  IF
    1 ASCII Y EMIT ( 1 )
  ELSE
     0 ASCII N EMIT ( 0 )
  THEN ;RE

: ANTIC-OFF
  SDMCTL @ SDMCTLMEM ! 0 SDMCTL ! ;

: ANTIC-ON
  SDMCTLMEM @ SDMCTL ! ;

( Clear screen, set color and margin )
: HOME ( b b -- )
  COLOR2 C! LMARGN C! 125 EMIT ;
  
: TITLE
  ANTIC-OFF 3 0 HOME CR CR
  ." ***********************************"  CR
  ."   M    U    G    W    U    M    P  "  CR
  ." ***********************************"  CR CR
  ."         A HIDE AND SEEK GAME       "  CR
  ."      PEOPLE'S COMPUTER COMPANY     "  CR
  ."            MENLO PARK CA           "  CR CR
  ."    2024 port to Forth by: BartGo   "  CR
  ."  Written in APX Extended Fig-Forth "  CR
  ."           for Atari 8-bit          "  CR CR
  ." The original Basic game published in" CR
  ." 1973-04 / People's Computer Company"  CR CR
  ."             (Press ESC)"              CR
  ANTIC-ON ESC? ;  

( Print the rules )
: RULES ( -- )
  0 0 HOME 
  CR ." Do you want the rules (Y=YES)? "  
  YN? 0= IF ;S ENDIF
  CR CR
  ." A MUGWUMP IS HIDING IN A " GRIDSIZE .
  ." BY " GRIDSIZE . ." GRID."                   CR
  ." TRY TO FIND HIM BY GUESSING HIS"            CR
  ." GRIDPOINT. HOMEBASE IS GRIDPOINT 0,0 "      CR
  ." AND A GUESS IS A PAIR OF WHOLE NUMBERS"     CR
  ." (0 to " GRIDSIZE 1 - .; ." )." CR
  ." THE FIRST NUMBER IS THE DISTANCE"           CR
  ." TO THE RIGHT OF HOMEBASE AND THE SECOND"    CR
  ." NUMBER IS THE DISTANCE BELOW THE "          CR
  ." HOMEBASE. FOR EXAMPLE, IF YOU THINK THE"    CR
  ." MUGWUMP IS HIDING 8 UNITS TO THE RIGHT"     CR
  ." OF HOMEBASE AND 3 UNITS ABOVE HOMEBASE,"    CR
  ." THEN ENTER 8 3 AS YOUR GUESS."              CR
  ." YOU GET " GUESSMAX . ."  GUESSES."          CR 
  ." AFTER EACH GUESS, I WILL TELL YOU"          CR
  ." HOW FAR (IN A DIRECT LINE) YOU ARE FROM"    CR
  ." THE MUGWUMP."                               CR
  CR ." Press ESC." ESC?  ;
  
( Random number using POKEY )
: RND ( rng -- rnd )
  -11766 C@ -11766 C@ 256 * +
  SWAP MOD ABS ; 

( FIXME: should not leave non-# on stack! )
( Enter a number )
: GET# ( -- c ) ;
  RE: GET#
  0          ( sentinel set up )
  BEGIN             
    DROP ( ...sentinel or last )
	KEY                ( c     )
	DUP  ASCII 0 1 - > ( c f   ) 
    OVER ASCII 9 1 + < ( c f f ) 
  AND                  ( c f   )
  UNTIL                ( c     )
  DUP EMIT 48 - ;RE    ( c     )

( Square )
: ^2 DUP * ; ( n -- n*n )

( ** Square root, Newton Method  )
( https://sametwice.com/sqrt.fs ) 
: SQRT ( n -- n )
  1 BEGIN
    OVER OVER / OVER - 2 / DUP
  WHILE + REPEAT DROP SWAP DROP ;
( *** SQRT, FP VERSION          )
( *** APX REV.2 MANUAL P. 24    )
( FP, screen 60 would be needed )
( : FSQRT FLOG FP 2.0 F/ FEXP ; )
( USAGE EX.: FP 256 FSQRT FIX . )

: GRINIT ( -- )
  15 GR. 80 712 ! 80 COLOR2 ! ANTIC-OFF
  GRIDSIZE 1+ 0 DO 
    BCOL I FLD * G+              0 G+ PLOT 
    BCOL I FLD * G+ GRIDSIZE FLD * G+ DRAW
    BCOL 0 G+              I FLD * G+ PLOT 
    BCOL GRIDSIZE FLD * G+ I FLD * G+ DRAW
  LOOP ANTIC-ON ;

: MARK ( x y col -- )
  3 ARGUMENTS
    S3 S1 FLD * FLD + G+ S2 FLD *       G+ PLOT
    S3 S1 FLD *       G+ S2 FLD * FLD + G+ DRAW
    S3 S1 FLD *       G+ S2 FLD *       G+ PLOT
    S3 S1 FLD * FLD + G+ S2 FLD * FLD + G+ DRAW
  0 RESULTS ;

: ELLIPSE ( x y r1 r2 color step -- ) ;
  RE: ELLIPSE
  6 ARGUMENTS
    360 0 DO 
        I COS 1000 /
	      S3 * 10 /
	    S1 10 *
	  + C+ TO S7
        I SIN 1000 /
	      S4 * 10 /
	    S2 10 *
	  + C+ TO S8
      S5 S7 S8 PLOT 
    S6 +LOOP ( step: approx. circle )
  0 RESULTS ;RE

5 CONSTANT STEP
: CIRCLE ( x y col r scale -- ) ;
  RE: CIRCLE
  5 ARGUMENTS
    S1 S2 S4 S5 * S4 S5 * S3 STEP
	  ELLIPSE
  0 RESULTS ;RE

: RANGE ( sqr1 sqr2 x y color -- ) ;
  RE: RANGE  
  5 ARGUMENTS
    S2 1000 * S3 100 * + 100 / TO S6 ( r )
    S3 S4 S5 S6 1 CIRCLE
  0 RESULTS ;RE 

: GRUPDATE ( x y t -- x y c ) ; RE: GRUPDATE
  IF GCOL ELSE BCOL THEN
  MARK ;RE

( Main loop )
: MAINLOOP ( -- n ) ; RE: MAINLOOP
  GRIDSIZE RND HIDEX !
  GRIDSIZE RND HIDEY ! 
  0 0 HOME GRINIT
  1 ( loop sentinel )
  GUESSMAX 0 DO
    DROP ( sentinel | last loop )
    CR ." Mugwump is hiding. "
    GUESSMAX I - . ." guesses left: "
    GET# GUESSX !  ASCII , EMIT
    GET# GUESSY !  CR 
    GUESSX @ HIDEX @ =
      GUESSY @ HIDEY @ = AND
    IF
      GUESSX @ GUESSY @ 1 GRUPDATE 
      I LEAVE ( sentinel / leave) 
    ELSE
      GUESSX @ GUESSY @ 0 GRUPDATE 
      GUESSX @ HIDEX @ - ^2
      GUESSY @ HIDEY @ - ^2 +
      GUESSX @ .; ASCII , EMIT
      GUESSY @ . ." is " 
      100 * SQRT 10
      /MOD OVER OVER
        .; ASCII . EMIT .
        ." unit(s) from the Mugwump. " 
		  GUESSX @ GUESSY @ GCOL RANGE 
      0 ( sentinel / still playing ) 
    ENDIF
  LOOP ;RE

( Ending screen )
: HIGHSCORE ( n -- )
  -DUP IF 
    1+ CR ." You found him in " .
          ." guesses!!!" 
  ELSE
    CR ." Sorry, that's " GUESSMAX .
    ." tries." CR
    ." Mugwump is at gridpoint "
    HIDEX @ .; ASCII , EMIT
    HIDEY @ .; 
  THEN
  CR ." Press ESC." 
  ESC? XGR 2 148 HOME ;

  
( *** MAIN *** ) 

( Game )
: RUN ( -- ) ; RE: RUN
  TITLE
  BEGIN
    RULES
    MAINLOOP ( n )
    HIGHSCORE
  AGAIN
  XGR ;RE
  
( *** TOOLS *** ) 
  
: R0 TIB 2 - @    ; ( -- n )
ASSEMBLER CODE RP@ 
  XSAVE STX, TSX, TXA, PHA,
  1 # LDA, XSAVE LDX, PUSH JMP,
FORTH

( ***** AUGMENTED TRACE ***** )
( https://www.forth.org/fd/FD-V06N5.pdf )
( REQUIRES: assembler [39], RP@, R0     )
( FIXME: UNRAVEL sometimes fails, with  )
(        short words and other cases    )
: (UN CR SPACE DUP 4 .R SPACE ;
: UNRAVEL ( -- )
  BEGIN RP@ R0 = 0= WHILE
    R> DUP CFA @ DUP DUP @
    [ ' : @ @ ] LITERAL = SWAP @ C@
    [ ' FORTH @ C@ ] LITERAL = OR
    IF   (UN NFA ID. DROP
    ELSE (UN DROP U. THEN
  REPEAT
  DEBUG? IF
    QUIT ELSE BEGIN AGAIN THEN ;
    
: CRASH ( -- )
  125 EMIT 144 710 C!
  CR ." SYSTEM ERROR!"
  CR ." PRESS RESET TO REBOOT." CR
  DEBUG? IF 
    CR ." ENTERING DEBUG MODE." 
  THEN
  CR CR .S CR UNRAVEL ;

( modified prompt: fig-Forth 1.1* )
( ASCII * 7903 C! )

( DEPLOY ERROR HANDLING )
( ' CRASH CFA ' ) ( ABORT )
( ! -1 WARNING ! )

( DEPLOY AUTOMATIC  LOAD )
( ' RUN CFA ' ABORT 4 + ! )
( SAVE COLD )
  
;S
