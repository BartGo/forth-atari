( Simple Local Variables )
( Tested on Atari 8-bit, )
( APX Forth [no loads]   )
( By BartGo, probably in-)
( spired by FD articles, )
( e.g. FD-V03N6.pdf p.185)
( Will NOT work in loops )
( or with R-stack change )
				
: 'L            ( n -- a ) 
  1 - 2 *       ( n )
  R> R> R       ( n R1 R2 r3 )
  ROT ROT       ( n r3 R1 R2 )
  >R >R + ;     ( a=r3+n ) 

( *** basic usage )

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

( *** sugared usage 2 ) ( FIXME )

: @1 R> 1 'L @ >R ; : !1 R> 1 'L ! >R ;
: @2 R> 2 'L @ >R ; : !2 R> 2 'L ! >R ;
: @3 R> 3 'L @ >R ; : !3 R> 3 'L ! >R ; 
: @4 R> 4 'L @ >R ; : !4 R> 4 'L ! >R ; 
: @5 R> 5 'L @ >R ; : !5 R> 5 'L ! >R ; 

: BOX2 ( x y z m -- a b )
  R> HERE >R >R   ( store HERE below RS top )
  0 DO , LOOP     ( create M locals )
  @1 @2 @3 * *    ( vol )
  @1 4 * @2 4 * + @3 4 * +  ( vol edge )  
  R> R> DP ! >R ; ( old DP ) 

21 4 8 3 BOX2 ( BUG / CRASH )
  132 ?PAIRS
  672 ?PAIRS

( *** sugared usage 3 ) ( FIXME )

: L(            ( m -- ) 
  R> R> HERE >R
  >R >R         ( store HERE below RS top )
  0 DO , LOOP ; ( define m locals  )

: )L            ( -- ) 
  R> R> R>
  DP ! >R >R ;  ( restore DP from RS ) 

: EXAMPLE       ( e d c b a M -- n ) 
  L(
    @1 @2 * !3 
    @3 @2 - !5
    @5
  )L ; 

55 44 33 22 11 5
  EXAMPLE    ( execute ) ( BUG / CRASH )
  220 ?PAIRS ( expected ) 
