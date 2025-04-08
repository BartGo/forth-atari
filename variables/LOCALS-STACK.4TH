( Local variables )
( Baranov, Nozdrunov )
( Language Forth and its implementations )

100 ALLOT HERE CONSTANT LP0
0 VARIABLE LP@ 
: INIT LP0 LP@ ! ; INIT
: LOCALS: ( n -- )
  1+ 2 * LP@ @ OVER - DUP LP@ ! ! ;
: ;LOCALS ( -- ) LP@ @ @ LP@ +! ;
: @@ <BUILDS , DOES> @ LP@ @ + @ ;
: !! <BUILDS , DOES> @ LP@ @ + ! ;
2 @@ @1 4 @@ @2 6 @@ @3 8 @@ @4 10 @@ @5
2 !! !1 4 !! !2 6 !! !3 8 !! !4 10 !! !5

( : 5INV ( ABCDE -> EDCBA )
(   5 LOCALS: !1 !2 !3 !4 !5 )
(   @1 @2 @3 @4 @5 ;LOCALS ; )
( 1 2 3 4 5 6 7 5INV )
  
