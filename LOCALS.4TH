( Simple Local Variables )
( Tested on Atari 8-bit, )
( APX Forth [no loads]   )
( By BartGo, probably in-)
( spired by FD articles? )
( Will NOT work in loops )
( or with R-stack change )
				
: 'L            ( n -- a ) 
  1 - 2 *       ( n )
  R> R> R       ( n R1 R2 r3 )
  ROT ROT       ( n r3 R1 R2 )
  >R >R + ;     ( a=r3+n ) 
                
: EXAMPLE         ( e d c b a M -- n ) 
  R> HERE >R >R   ( store HERE below RS top )
  0 DO , LOOP     ( create M locals )
  1 'L @ 2 'L @ * ( tests follow... )
  3 'L ! 
  3 'L @ 2 'L @ - 5 'L ! 5 'L @
  R> R> DP ! >R ; ( restore DP )

55 44 33 22 11 5
  EXAMPLE    ( execute )
  220 ?PAIRS ( expected example ) 

