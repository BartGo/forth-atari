( three-valued logic experiment in Forth )
( using Atari 8-bit APX fig-FORTH        )
( code by BartGo, with help of Gemini:   )
(               - observing that AND&OR  )
(                 can be done w/ MIN&MAX )
(               - truth table tests      )

 1 CONSTANT %T
-1 CONSTANT %F
 0 CONSTANT %U

: %NOT -1 * ;
: %OR MAX ; : %AND MIN ;
: %XOR * MINUS ;
: %EQ * ; ( %U==%U is %U )
: %IMP SWAP %NOT %OR ;

: %NOR %OR %NOT ;
: %NAND %AND %NOT ;
: %NEQ %EQ %NOT ;

( TESTS BELOW )

: =TEST
  = IF ." ." ELSE ." X" THEN ;
 
%F %NOT %T =TEST
%U %NOT %U =TEST
%T %NOT %F =TEST

%T %T %AND %T =TEST
%T %U %AND %U =TEST
%T %F %AND %F =TEST

%U %T %AND %U =TEST
%U %U %AND %U =TEST
%U %F %AND %F =TEST

%F %T %AND %F =TEST
%F %U %AND %F =TEST
%F %F %AND %F =TEST

%T %T %OR %T =TEST
%T %U %OR %T =TEST
%T %F %OR %T =TEST

%U %T %OR %T =TEST
%U %U %OR %U =TEST
%U %F %OR %U =TEST

%F %T %OR %T =TEST
%F %U %OR %U =TEST
%F %F %OR %F =TEST

%T %T %EQ %T =TEST
%T %U %EQ %U =TEST
%T %F %EQ %F =TEST

%U %T %EQ %U =TEST
%U %U %EQ %U =TEST 
%U %F %EQ %U =TEST

%F %T %EQ %F =TEST
%F %U %EQ %U =TEST
%F %F %EQ %T =TEST

%T %T %XOR %F =TEST
%T %U %XOR %U =TEST
%T %F %XOR %T =TEST

%U %T %XOR %U =TEST
%U %U %XOR %U =TEST
%U %F %XOR %U =TEST

%F %T %XOR %T =TEST
%F %U %XOR %U =TEST
%F %F %XOR %F =TEST

%T %T %IMP %T =TEST
%T %U %IMP %U =TEST
%T %F %IMP %F =TEST

%U %T %IMP %T =TEST
%U %U %IMP %U =TEST
%U %F %IMP %U =TEST

%F %T %IMP %T =TEST
%F %U %IMP %T =TEST
%F %F %IMP %T =TEST

FORGET =TEST
