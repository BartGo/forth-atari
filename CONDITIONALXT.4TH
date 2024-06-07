( NOT WORKING YET )

( detecting whether a word exists, probably will require modification of WORD )
( uses adepted string routines from tchak's fujinet words )
( written for atari 8-bit apx extended fig-forth )


FORTH DEFINITIONS HEX

0 VARIABLE len 
0 VARIABLE buf WIDTH ALLOT

: -' ( -- xt|0 ) -FIND 0= IF 0 ;S THEN DROP ;
: -EXECUTE ( xt -- ) DUP 0< IF DROP ;S THEN EXECUTE ;
: TEST CR ." Hello!" CR ;
( -' TEST CFA -EXECUTE )  ( -' FAIL CFA -EXECUTE )
: ["] R COUNT DUP 1+ R> + >R ;  ( [."] without TYPE )
( start embedded string ) 
: $" (  same as ."  without TYPE )
  22 STATE @ IF COMPILE ["] WORD HERE C@ 1+ ALLOT
  ELSE WORD HERE DUP C@ 1+ PAD SWAP CMOVE PAD COUNT
  THEN ; IMMEDIATE
: $= ( src len dest -- )
  2DUP + >R SWAP CMOVE R> 0 SWAP C! ;
: "$ ( n -- )
  DUP len ! ;

( FIXME )
$" $LOL" "$ buf $= ( set string )
len @ buf C! ( set len )
buf 1 + len C@ 1 - TYPE ( print string )
buf COUNT TYPE

( buf ' LIT NFA (FIND) )

