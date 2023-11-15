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

