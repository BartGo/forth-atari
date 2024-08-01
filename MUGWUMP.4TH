
( MUGWUMP in APX Forth, Atari 8-bit )
( PCC Basic Game ported by BartGo 

( TODO: P/M graphics; laser + mugwump )

DECIMAL FORTH DEFINITIONS

( required screens: 40 LOAD 50 LOAD )
( screen 60 [FP] to consider )

: |APP| ;

 1  CONSTANT DEBUG? ( 0 = DEBUG OFF )
10  CONSTANT GRIDSIZE
10  CONSTANT FLD
10  CONSTANT GUESSMAX
160 GRIDSIZE FLD * - 2 / 
    CONSTANT GOFF ( offset; 160: GR.7 )
    : G+ GOFF + ;
2   CONSTANT BCOL ( board color )
1   CONSTANT GCOL ( guess color )
3   CONSTANT RCOL ( range color )
1   CONSTANT CCOL ( circle color )
559 CONSTANT SDMCTL
710 CONSTANT COLOR2
82  CONSTANT LMARGN

0   VARIABLE guessX
0   VARIABLE guessY
0   VARIABLE hideX
0   VARIABLE hideY
0   VARIABLE graph?

: -ROT ROT ROT ;
: S0 18 +ORIGIN @ ; ( -- n )
: .S SP@ S0 = 0= IF ( --   )
    SP@ 2 - S0 2 - DO I @ . -2 +LOOP
  ELSE ." Stack empty " THEN ;
: S. .S ;

( TODO: podać źródło )
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
9986 , 9992 , 9998 ,
10000 , DOES> SWAP 2 * + @ ;

(SINTAB) SINTAB 

: S180 DUP 90 > IF 180 SWAP -
  THEN SINTAB ; : SIN
  360 MOD DUP 0< IF 360 + THEN
  DUP 180 > IF 180 - S180 MINUS
  ELSE S180 THEN ; : COS 90 + SIN ;

( RE-DEFINING A COLON WORD by EHS
( https://www.forth.org/fd/FD-V06N3.pdf
' : CFA @ CONSTANT DOCOL
: (RE:) ( -- )
  -FIND 0= IF HERE COUNT TYPE
  ."  NOT FOUND" QUIT THEN
  DROP DUP CFA @ DOCOL = 0= IF
  HERE COUNT TYPE ."  NOT A COLON WORD"
  QUIT THEN HERE SWAP ! ;
: (;RE) ( -- ) R> R> 2DROP ;
: RE: ( -- ) SP@ CSP ! CURRENT @
  CONTEXT ! (RE:) DOCOL , ] ;
: ;RE ( -- ) ?CSP COMPILE (;RE)
  [COMPILE] [ ; IMMEDIATE

( Start: LOCAL VARIABLES in Forth )
( *** by Marc Perkel FD-V03N6 *** )
HEX 0 VARIABLE [ARG] 0 VARIABLE [TO]
: +ARG <BUILDS , DOES> @ [ARG] @ SWAP - [TO] @ -DUP
  IF 0< IF +! ELSE ! ENDIF ELSE @ ENDIF 0 [TO] ! ;
 0 +ARG S1  2 +ARG S2  4 +ARG S3  6 +ARG S4
 8 +ARG S5  A +ARG S6  C +ARG S7  E +ARG S8 10 +ARG S9
: TO  1 [TO] ! ; : +TO -1 [TO] ! ;
: ARGUMENTS R> [ARG] @ >R >R 2 * SP@ + DUP [ARG] !
  12 - SP@ SWAP - 2 / 0 DO 0 LOOP 0 [TO] ! ;
: RESULTS 2 * [ARG] @ SWAP - SP@ - 2 / 0 DO DROP LOOP
  R> R> [ARG] ! >R ; DECIMAL
( End: LOCAL VARIABLES )

( Dot word with no trailing space )
: .; ( n -- ) S->D 0 D.R ;

: Esc? ( -- ) BEGIN KEY 27 = UNTIL ;

: YN? ( -- n )
  BEGIN
    KEY DUP
    DUP ASCII Y = SWAP ASCII y = OR IF EMIT 1 ;S THEN
    DUP ASCII N = SWAP ASCII n = OR IF EMIT 0 ;S THEN
  AGAIN ;

: Antic-OFF
  SDMCTL @ graph? ! 0 SDMCTL ! ;

: Antic-ON
  graph? @ SDMCTL ! ;

( Clear screen, set color and margin )
: Home ( b b -- ) COLOR2 C! LMARGN C! 125 EMIT ;
  
: Title
  Antic-OFF
  3 0 Home CR CR
  ." ***********************************" CR
  ."   M    U    G    W    U    M    P  " CR
  ." ***********************************" CR CR
  ."         A HIDE AND SEEK GAME       " CR
  ."      PEOPLE'S COMPUTER COMPANY     " CR
  ."            MENLO PARK CA           " CR CR
  ."    2024 port to Forth by: BartGo   " CR
  ."  Written in APX Extended Fig-Forth " CR
  ."           for Atari 8-bit          " CR CR
  ." The original Basic game published in" CR
  ." 1973-04 / People's Computer Company" CR CR
  ."             (Press ESC)"             CR
  Antic-ON
  Esc? ;  

( Print the rules )
: Rules ( -- )
  0 0 Home 0 graph? !
  ." Do you want graphics  (Y=YES)? "  
  YN? IF 1 graph? ! ENDIF
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
  CR ." Press ESC." Esc?  ;
  
( Random number using POKEY )
: Rnd ( rng -- rnd )
  -11766 C@ -11766 C@ 256 * +
  SWAP MOD ABS ; 

( FIXME: should not leave non-# on stack! )
( Enter a number )
: Get# ( -- n )
  BEGIN             (   )
    KEY DUP ASCII 0 1 - > ( n f ) 
    OVER    ASCII 9 1 + < ( n f f ) 
  AND UNTIL               ( n )
  DUP EMIT 48 - ;         ( n )

( Square )
: ^2 DUP * ; ( n -- n*n )

( Square root, Newton Method    )
( https://sametwice.com/sqrt.fs ) 
: Sqrt ( n -- n )
  1 BEGIN
    OVER OVER / OVER - 2 / DUP
  WHILE + REPEAT DROP SWAP DROP ;

: GrInit ( -- )
  graph? @ 0 > 0= IF ;S THEN
  15 GR. 80 712 ! 80 COLOR2 ! Antic-OFF
  GRIDSIZE 1+ 0 DO 
    BCOL I FLD * G+              0 G+ PLOT 
    BCOL I FLD * G+ GRIDSIZE FLD * G+ DRAW
    BCOL 0 G+              I FLD * G+ PLOT 
    BCOL GRIDSIZE FLD * G+ I FLD * G+ DRAW
  LOOP Antic-ON ;

: Mark ( col x y -- )
  3 ARGUMENTS
    S1 S2 FLD * FLD + G+ S3 FLD *       G+ PLOT
	S1 S2 FLD *       G+ S3 FLD * FLD + G+ DRAW
	S1 S2 FLD *       G+ S3 FLD *       G+ PLOT
	S1 S2 FLD * FLD + G+ S3 FLD * FLD + G+ DRAW
  0 RESULTS ;

:   Circle ( x y r c -- ) ;
RE: Circle
  4 ARGUMENTS
  360 0 DO 
	I COS 1000 / S3 * 10 / S1 + TO S5
	I SIN 1000 / S3 * 10 / S2 + TO S6
	S4 S5 S6 PLOT 
  18 +LOOP ( step: approx. circle )
  0 RESULTS ;RE
  
: GrUpdate ( x y t -- )
  IF BCOL ELSE GCOL THEN
  -ROT Mark ;

( TODO: TEST and FIX )
:   Range ( sqr1 sqr2 X Y col -- ) ;
RE: Range
  5 ARGUMENTS
  S5 S3 10 * S4 10 * PLOT
  S3 S4 S2 100 * S3 100 * + 100 / S5
    Circle
  0 RESULTS ;RE 

( Main loop )
: MainLoop ( -- n ) ; RE: MainLoop
  GRIDSIZE Rnd hideX !
  GRIDSIZE Rnd hideY ! 
  0 0 Home GrInit
  1 ( loop sentinel )
  GUESSMAX 0 DO
    DROP ( sentinel | last loop )
	CR ." Mugwump is hiding. "
    GUESSMAX I - . ." guesses left: "
    Get# guessX !  ASCII , EMIT
    Get# guessY !  CR 
    guessX @ hideX @ =
      guessY @ hideY @ = AND
    IF
	  graph? @ IF guessX @ guessY @ 1 GrUpdate THEN
      I LEAVE ( sentinel / leave) 
    ELSE
      graph? @ IF guessX @ guessY @ 0 GrUpdate THEN
      guessX @ hideX @ - ^2
      guessY @ hideY @ - ^2 +
      guessX @ .; ASCII , EMIT
	  guessY @ . ." is " 
	  100 * Sqrt 10
	  /MOD OVER OVER
	    .; ASCII . EMIT .
        ." unit(s) from the Mugwump. " 
	  ( guessX @ guessY @ GCOL Range )
	  0 ( sentinel / still playing ) 
    ENDIF
  LOOP ;RE

( Ending screen )
: HighScore ( n -- )
  -DUP IF 
    1+ CR ." You found him in " .
	      ." guesses!!!" 
  ELSE
    CR ." Sorry, that's " GUESSMAX .
    ." tries." CR
    ." Mugwump is at gridpoint "
    hideX @ .; ASCII , EMIT
    hideY @ .; 
  THEN
  CR ." Press ESC." 
  Esc? graph? @ IF XGR THEN 2 148 Home ;

  
( *** MAIN *** ) 

( Game )
: RUN ( -- ) ; RE: RUN
  Title
  BEGIN
    Rules
    MainLoop ( n )
    HighScore
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
  
( DEPLOY ERROR HANDLING )
( ' CRASH CFA ' ) ( ABORT )
( ! -1 WARNING ! )
( modified prompt: fig-Forth 1.1* )
( ASCII * 7903 C! )
( DEPLOY AUTOMATIC  LOAD )
( ' RUN CFA ' ABORT 6 + ! )
( SAVE COLD )
  
;S
