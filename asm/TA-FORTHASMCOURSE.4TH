( --------------------------- )
( FORTH COURSE, by R. Pantola )
( - FORTH ASSEMBLER chapters, )
( as published in a Polish    )
( magazine "TAJEMNICE ATARI", )
( 8/1992 - 10/1992            )
( --------------------------- )
( Requires Atari 8-bit, APX   )
( Extended fig-Forth rev. 2,  )
( Ragsdale assembler and small)
( enhancement words MAC and ;C)
( - checks and definitions are)
( below to redefine if needed )
( / Collected by BartGo '26 / )
( --------------------------- )

( \ macro / subroutine word   )
' MAC DROP 
( : MAC  -FIND 0= 0 ?ERROR    )
(   DROP 32 C, , ; IMMEDIATE  )

( / alias to the END-CODE word)
' C;  DROP 
( : C; CURRENT @ CONTEXT !    )
(   ?EXEC ?CSP SMUDGE ; IMMEDIATE )
( : END-CODE [COMPILE] C; ;   )

( --------------------------- )

(  FORTH part 7 - ASSEMBLER  )
( examples by Roland Pantola )
(  "TAJEMNICE ATARI", 08/92  )

( increment a Forth variable,)
( using assembly )
0 VARIABLE WA
CODE WA+
  WA LDY, INY,
  WA STY,
  NEXT JMP, C;
10 WA ! WA+ WA ? ( 11 )
WA @ 11 ?PAIRS
S. 

FORGET WA

( --------------------------- )

(  FORTH part 8 - ASSEMBLER  )
( examples by Roland Pantola )
(  "TAJEMNICE ATARI", 09/92  )

( modify a Forth variable,   )
( using assembly:            )
( * increment it, if <  100  )
( * decrement it, if >= 100  )
0 VARIABLE WA
CODE ZMW
  WA LDA,
  100 # CMP, >= IF,
    WA DEC,
  ELSE, WA INC, THEN,
  NEXT JMP, C;
10  WA ! ZMW WA ?
WA @ 11  ?PAIRS
150 WA ! ZMW WA ?
WA @ 149 ?PAIRS
S.

FORGET WA

( modify a Forth variable,   )
( using assembly:            )
( * increment it, if <= 100  )
( * decrement it, if >  100  )
0 VARIABLE WA
CODE ZM<
  WA LDA,
  100 # CMP, >= NOT IF,
    WA DEC,
  ELSE, WA INC, THEN,
  NEXT JMP, C;
10  WA ! ZM< WA ?
WA @ 9 ?PAIRS
150 WA ! ZM< WA ?
WA @ 151 ?PAIRS
S.

FORGET WA

( fill text rows with $ char )
CODE C$
  119 # LDY, 4 # LDA,
  BEGIN,
    88 )Y STA,
	DEY,
  0< UNTIL,
  NEXT JMP, C; 
C$

FORGET C$

( macro / subroutine example )
0 VARIABLE WA
CODE WA+
  CLC,
  WA ADC,
  CS IF, WA 1+ INC, THEN,
  WA STA,
  RTS, C;
CODE WA5+
  5 # LDA,
  MAC WA+
  NEXT JMP, C;
276 WA !
WA5+
WA ?
WA @ 281 ?PAIRS
S.

FORGET WA

( --------------------------- )

(  FORTH part 9 - ASSEMBLER  )
( examples by Roland Pantola )
(  "TAJEMNICE ATARI", 10/92  )

( stack to variable, no DROP )
SP!
0 VARIABLE WA
CODE >WA
  0 ,X LDA, WA    STA,
  1 ,X LDA, WA 1+ STA,
  NEXT JMP, C;
257 >WA WA ?
WA @ 257 ?PAIRS
S. 257 ?PAIRS

FORGET WA

( stack to variable, remove  )
( value from the stack, using)
( Forth's POP word to leave  )
SP!
0 VARIABLE W1
CODE >W1
  0 ,X LDA, W1    STA,
  1 ,X LDA, W1 1+ STA,
  POP JMP, C;
257 >W1 W1 ?
W1 @ 257 ?PAIRS
S.

FORGET W1

( stack to variable, remove  )
( value from the stack, by   )
( using INX on stack pointer )
SP!
0 VARIABLE W2
CODE >W2
  0 ,X LDA, W2    STA,
  1 ,X LDA, W2 1+ STA,
  INX, INX,
  NEXT JMP, C;
299 >W2 W2 ?
S.

FORGET W2
