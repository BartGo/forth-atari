( Simple Local Variables )
( Tested on Atari 8-bit, )
( APX Forth [no loads]   )
( by BartGo, probably in-)
( spired by FD articles? )
( will NOT work in loops )
( or with R-stack change )
				
: !L ( n1..nm m ) 0 DO , LOOP ; ( init m locals )
  
: 'L ( n -- a ) ( offset to address )
  1 - 2 *       ( n )
  R> R> R       ( n R1 R2 r3 )
  ROT ROT       ( n r3 R1 R2 )
  >R >R + ;     ( a=r3+n ) 
                
: MYWORD ( e d c b a -- ) ( example )
  R> HERE >R >R    ( store HERE below RS top )
  5 !L             ( create five locals )
  1 'L @ 2 'L @ *  ( test )
  3 'L ! 
  3 'L @ 2 'L @ - 5 'L ! 5 'L ?
  R> R> DP ! >R ;  ( restore DP )
  
55 44 33 22 11 MYWORD ( e d c b a MYWORD )

