( error !!! )


21 LOAD ( DEBUG )
125 EMIT
KEY DROP
: != = 0= ;
: INS ( n -- )
  ( depth - in_parameters )
  ( stored on the return stack )
  DEPTH - COMPILE >R ; IMMEDIATE
: OUTS ( n -- )
  ( depth - out_parameters )
  ( compared with the original )
  ( depth, QUIT if not equal   )
  DEPTH - COMPILE R> 
  != IF
    CR ." Parameter mismatch!" CR
  QUIT THEN ; IMMEDIATE


: Compare
  DEPTH .
  1 INS
  DEPTH .
  DROP
  DEPTH .
  ." Hello" CR 11 222 333
  DEPTH .
  3 OUTS
  DEPTH .
;

123 Compare

( **** )


( BG )

120 212 0 1 15
  THEME

0
  THEME

120 8
  THEME

: ?NOPAR
  OVER AND 0= [ IF ] ; IMMEDIATE 
: THE PAR 

: THEME ( [p1] [p2] [p3] [p4] n -- )
  8 ?NOPAR ( [p1-4] n if
    100 ROT DROP THEN ( [p1-3] n 100 )
  4 ?NOPAR 710 THEN 
  2 ?NOPAR  55 THEN 
  1 ?NOPAR   1 THEN
  ( move params through return st )
  SWAP DROP ( drop par# )
  710 ! 709 ! 712 ! 85 ! ;

  


