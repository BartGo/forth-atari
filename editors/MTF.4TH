
EDITOR
79 CLEAR
 0 P (   Micro Text Formatter by Robert La Quey, 1985   )
 1 P ( http://www.euroforth.org/ef85/papers/laqueyb.pdf )
 2 P ( ------ tunings for Atari APX Forth by BGO ------ )
 3 P : TASK ; DECIMAL 0 CONSTANT LEFT 38 CONSTANT RIGHT 
 4 P 0 VARIABLE >END  0 VARIABLE >CHAR  0 VARIABLE >LINE
 5 P : FF 125 EMIT ; : START LEFT >CHAR ! 0 >LINE ! FF ; 
 6 P : CR CR LEFT SPACES LEFT >CHAR ! 1 >LINE +! ; 
 7 P : BUMP DUP 1+ >CHAR +! ; ( n -- n ) 
 8 P : ?CR >CHAR @ RIGHT > IF CR BUMP THEN ; 
 9 P : .WORD BL WORD HERE COUNT BUMP ?CR TYPE SPACE ; 
10 P : MEASURE IN @ ASCII ] WORD HERE DROP IN @ >END ! IN ! ;  
11 P : MORE? IN @ >END @ 1 - < ; : FINISH >END @ IN ! ;
12 P : [ MEASURE BEGIN MORE? WHILE .WORD REPEAT FINISH ;
13 P ;S
FLUSH

80 CLEAR
0 P ( Test of MTF )
1 P START CR CR CR 
2 P [ This is a test. Test. 
3 P Lots of test this is. ] CR CR CR [ And more of it. ]
4 P FINISH
FLUSH

( 79 LOAD )
( 80 LOAD )
