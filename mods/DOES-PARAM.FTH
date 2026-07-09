( * Parameter Passing to Does> *)
( by David McKibbin /FD V3N1p14 )
( tuned/tested for Atari 8-bit, )
( APX Forth by BartGo, VII 2026 )

FORTH DEFINITIONS DECIMAL

: $ ( n -- ; push nth parameter)
  1 - DUP + R# @ + @ ;

: EXAMPLE ( -- cc arg pfa )
  <BUILDS DOES>
  R# ! 1 $ 2 $ CFA EXECUTE ;

EXAMPLE ZZZ 90 , ' EMIT ,
EXAMPLE SPC 10 , ' SPACES ,
ZZZ
SPC

( another example... )
: $ 1 - DUP + R# @ + @ ;
: OPER ( -- cc $1 $2 $op-pfa ; $1 op $2 )
  <BUILDS DOES>
  R# ! 1 $ 2 $ 3 $ CFA EXECUTE ;
( ... and tests )
OPER ADD 123 , 321 , ' + ,
     ADD 444   ?PAIRS
OPER MUL 123 , 321 , ' * ,
     MUL 39483 ?PAIRS
  


