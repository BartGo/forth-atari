BASE @ FORTH DEFINITIONS HEX
0 VARIABLE buf WIDTH ALLOT

: -' ( -- xt|0 )
  -FIND 0= IF 0 ;S THEN DROP ;
: -EXECUTE ( xt -- )
  DUP 0< IF DROP ;S THEN EXECUTE ;
: TEST CR ." Hello!" CR ;

( -' TEST CFA -EXECUTE ) 
( -' FAIL CFA -EXECUTE )

: ["] R COUNT DUP 1+ R> + >R ;
: $"  ( start embedded string )
  22 STATE @ IF
    COMPILE ["] WORD HERE C@ 1+ ALLOT
  ELSE
    WORD HERE DUP C@ 1+ PAD SWAP CMOVE PAD COUNT
  THEN ; IMMEDIATE
: =$ ( src len dest -- )
  2DUP + >R
  SWAP CMOVE R> 0 SWAP C! ;

$" MYWORD" buf =$
buf ' LIT NFA (FIND)
