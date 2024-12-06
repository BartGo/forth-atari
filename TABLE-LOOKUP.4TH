( * Table Lookup Example * )
( Henry Laxen, FDv3nr5p151 )
(  tested - APX Fig-Forth  )

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
