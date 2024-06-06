( conditional tick, execute and others )
( this will not work as compiled code, )
( probably need to manipulate IN / TBD )

: -' ( -- xt|0 )
  -FIND 0= IF 0 ;S THEN DROP ;
: -EXECUTE ( xt -- )
  DUP 0< IF DROP ;S THEN EXECUTE ;
: TEST CR ." Hello!" CR ;

-' TEST CFA -EXECUTE
-' FAIL CFA -EXECUTE

: #INCLUDE.ASM ( n -- )
  -' ASSEMBLER ( BUG: can't compile, )
               ( need to change WORD )
  0= IF 39 LOAD THEN ;
