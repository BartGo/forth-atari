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
