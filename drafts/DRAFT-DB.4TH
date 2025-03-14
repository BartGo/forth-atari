( *WIP*, not yet working )

( mentioned by bfox9900 in https://www.reddit.com/r/Forth/comments/1e26nsn/fun_little_realization/ )
( "This feature of /MOD can be used to create records in block files as well. For example assuming 64 byte records:" )

FORTH DEFINITIONS DECIMAL 
64   CONSTANT #REC
1024 CONSTANT #PAG

: UM* ( n1 n2 — d)
  M* DABS ;
: UM/MOD ( d1 n1 — n2 n3)
  M/ ABS ;

: RECORD  ( rec# -- addr)
  #REC UM*
  #PAG UM/MOD ( offset blk#)
  BLOCK + ;

( TEST
0 RECORD 2198 ?PAIRS
1 RECORD 2262 ?PAIRS
2 RECORD 2326 ?PAIRS
)

( example: extract 2nd line from 40th screen )
40 1024 * 64 2 * + RECORD COUNT TYPE
( fail )
( otherwise, this works: 2 40 .LINE ( VOCABULARY ASSEMBLER IMMEDIATE



