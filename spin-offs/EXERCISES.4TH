( for APX Forth / Atari 8-bit )
( demo source code below - can be pasted with Altirra )
( destroys screens 80-83 )

FORTH DECIMAL

80 CLEAR 80 SCR !
0  & ( factorial, iterative )
1  & : FAC         ( n -- n! )
2  &   1 SWAP 1+ 1 ( 1 n+1 1 )
3  &   DO I * LOOP ;  
4  & CR 3 FAC . CR 8 FAC U. 
5 XX
6  & ( factorial, recursive )
7  & : FACR ( n -- n! ) DUP 0= IF 1 +
8  &   ELSE DUP 1 - [ SMUDGE ]
9  &     FACR [ SMUDGE ] * THEN ;
10 & CR 4 FAC . CR 8 FAC U. CR
11 XX
12 & : =T ( n n -- ; assert-eq )
13 &   = 0= IF ."  .FAIL" CR
14 &   ELSE ."  .PASS" CR THEN ; 
15 & 81 LOAD ( proceed to tests )

FLUSH

81 CLEAR 81 SCR !

0  & ( factorial, tests ) 
1  & : RUN OVER CFA EXECUTE ;
2  & : U> SWAP U< ;
3  & : TEST.FAC ( pfa -- ) CR 
4  &  ." Test: " DUP NFA ID. 
5  &  ." T1:f(0)" 0 RUN 1  =T 
6  &  ." T2:f(1)" 1 RUN 1  =T     
7  &  ." T3:f(4)" 4 RUN 24 =T       
8  &  ." T4:f(2)<f(4)" 
9  &    2 RUN SWAP 3 RUN ROT U>
10 &    1 =T
11 &  ." T5: f(8)<f(9)"      
12 &    8 RUN SWAP 9 RUN ROT U>
13 &    1 =T ;
14 & ' FAC TEST.FAC  ' FACR TEST.FAC
15 &   FORGET FAC      SP! QUIT 
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
14 & 8 GR. CR ." 100 10 20 SQUARE"
15 & CR ." XGR " QUIT
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
14 & 8 GR. CR ." 100 10 20 SQUARE"
15 & CR ." XGR " QUIT
FLUSH

84 CLEAR 84 SCR !
 0 & ( "Blinking Characters" )
 1 & ( req: Mullarky's ASM [scr 39] )
 2 & ( *** RM COMPUTE 12/81 )
 3 & HEX : TASK ; CODE Blink ( -- )
 4 &   02F3 LDA,  2 # AND, 2 #  EOR,
 5 &   02F3 STA, 15 # LDA, 021A STA,
 6 & RTS,
 7 & CODE BlinkStart ( -- )
 8 &   15 # LDA, 021A STA,
 9 & NEXT JMP,
10 & : BlinkInit ( -- )
11 &   ' Blink 228 ! ;
12 & : BlinkCursor ( -- )
13 &   BlinkInit  BlinkStart ;
14 & DECIMAL ;S
FLUSH

( ESCAPE DEMO by J. Mattes - original author unknown )
( published in Atari Computer Enthusiasts Nsw nr 6&8 )
85 CLEAR 85 SCR !
 0 & ( ESCAPE DEMO by J. Mattes ) DECIMAL
 1 & 0 VARIABLE X1  0 VARIABLE Y1 0 VARIABLE X2  0 VARIABLE Y2
 2 & 1 VARIABLE C : BOX C @ X1 @ Y1 @ PLOT
 3 &  C @ X2 @ Y1 @ DRAW  C @ X2 @ Y2 @ DRAW
 4 &  C @ X1 @ Y2 @ DRAW  C @ X1 @ Y1 @ DRAW ;
 5 & : SETCR 0 2 4 6 8 6 4 2 9 1 DO 224 + 704 I + C! LOOP ;
 6 & : ROTATE DUP @ ROT ROT OVER SWAP DO I 1+ @ I C! LOOP C! ;
 7 & : RUN BEGIN 712 705 ROTATE 600 1 DO LOOP 2 0= UNTIL ;
 8 & : ESCAPE  ( -- ) 10 GR. SETCR 39 0 DO I X1 ! I I + Y1 !
 9 &  79 X1 @ - X2 ! 190 Y1 @ - Y2 ! BOX 1 Y1 +!
10 &  1 MINUS Y2 +! BOX 1 C  +! C @ 8 > IF 1 C !
11 & ENDIF LOOP RUN ;
12 & CR CR ." type ESCAPE to start the demo" CR CR 
FLUSH

86 CLEAR 86 SCR !
 0 & ( GCD - fix me! )
 1 & : GCD         ( n m -- gcd ) 
 2 &   -DUP        ( n m m | n 0 )
 3 &   0 > IF      ( n m )
 4 &     ????????? ( m n m )
 5 &     MOD       ( m MOD{n/m} )
 6 &    [ SMUDGE ]
 7 &      GCD
 8 &    [ SMUDGE ] 
 9 &   THEN ;      ( ELSE: n )
10 & 784 48 GCD . ( 16 ) 56 49 GCD . ( 7 )
FLUSH



