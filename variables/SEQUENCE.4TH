( * sequences * )
( by bartgo [?] )
( OK: APX Forth )

( SEQUENCE )

: SEQ> 
  <BUILDS DOES>   
  DUP 1 SWAP +! @ ;

SEQ> AAA 100 , 
SEQ> BBB 200 ,
AAA 101 ?PAIRS
BBB 201 ?PAIRS
AAA 102 ?PAIRS
BBB 202 ?PAIRS

( A SILLY EXAMPLE - 'DOUBLER' )

: *ER>
  <BUILDS DOES>     
  DUP DUP @ 2 * SWAP ! @ ;

*ER> CC 2 ,
*ER> DD 3 ,

: TEST
  10 0 DO
    CC . DD . CR
  LOOP ;
TEST
