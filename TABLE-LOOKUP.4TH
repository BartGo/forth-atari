( * Table Lookup Example * )
( Henry Laxen, FDv3nr5p151 )
(  tested - APX Fig-Forth  )

12 SIZE CONSTANT

: TABLE 
  <BUILDS ( -- )
  DOES>   ( index -- value )
    SWAP 1 - 2 * + @ ;

TABLE DAYS/MONTH
  31 , 28 , 31 , 30 , 31 , 30 ,
  31 , 31 , 30 , 31 , 30 , 31 ,
  
 1 DAYS/MONTH . ( 31 ok )
 2 DAYS/MONTH . ( 28 ok )
11 DAYS/MONTH . ( 30 ok )

: TEST ( -- )
  SIZE 0 DO CR
    ." Month #" I 1+ .
	." has " I 1+ DAYS/MONTH .
	." days." 
  LOOP CR ;
  
;S

( MONTH #1 HAS 31 DAYS.
( MONTH #2 HAS 28 DAYS.
( MONTH #3 HAS 31 DAYS.
( MONTH #4 HAS 30 DAYS.
( MONTH #5 HAS 31 DAYS.
( MONTH #6 HAS 30 DAYS.
( MONTH #7 HAS 31 DAYS.
( MONTH #8 HAS 31 DAYS.
( MONTH #9 HAS 30 DAYS.
( MONTH #10 HAS 31 DAYS.
( MONTH #11 HAS 30 DAYS.
( MONTH #12 HAS 31 DAYS.

( end. )  
