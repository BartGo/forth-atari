( FIXME: BROKEN for Atari APX )

79 CLEAR
 0 P ( Micro Text Formatter by Robert La Quey 1985 )
 1 P ( http://www.euroforth.org/ef85/papers/laqueyb.pdf )
 2 P : TASK ; DECIMAL 10 CONSTANT LEFT 70 CONSTANT RIGHT 
 3 P 0 VARIABLE >END  0 VARIABLE >CHAR  0 VARIABLE >LINE
 4 P : FF 12 EMIT ; : START LEFT >CHAR ! 0 >LINE ! FF ; 
 5 P : CR CR LEFT SPACES LEFT >CHAR ! 1 >LINE +! ; 
 6 P : BUMP DUP 1+ >CHAR +! ;  
 7 P : ?CR >CHAR @ RIGHT > IF CR BUMP THEN ; 
 8 P : .WORD BL WORD COUNT BUMP ?CR TYPE SPACE ;
 9 P : MEASURE IN @ ASCII ] WORD DROP IN @ >END ! IN ! ;
10 P : MORE? IN @ >END @ 1 - < ; : FINISH >END @ IN ! ;
11 P : [ MEASURE BEGIN MORE? WHILE .WORD REPEAT FINISH ;
12 P ;S
FLUSH

80 CLEAR
0 P ( Test of MTF )
1 P START CR CR CR 
2 P [ This is a test. Test. 
3 P Lots of test this is. ] CR CR CR [ And more of it. ]
4 P FINISH
FLUSH

