( Simple Local Variables )
( Tested on Atari 8-bit, )
( APX Forth; by BartGo,  )
( similar to FD-V03N6/185)
( Will NOT work in loops )
( or with R-stack change )
				
: 'L            ( n -- a ) 
  1 - 2 *       ( n )
  R> R> R       ( n R1 R2 r3 )
  ROT ROT       ( n r3 R1 R2 )
  >R >R + ;     ( a=r3+n ) 

( test similar to the one from FD-V03N6 )
: BOX ( x y z m -- a b )
  R> HERE >R >R   ( store HERE below RS top )
  0 DO , LOOP     ( create M locals )
  1 'L @ 2 'L @ 3 'L @ * * ( vol )
  1 'L @ 4 *
  2 'L @ 4 * + 
  3 'L @ 4 * +    ( vol edge )  
  R> R> DP ! >R ; ( old DP ) ( vol edge )

21 4 8 3 BOX
  132 ?PAIRS
  672 ?PAIRS

