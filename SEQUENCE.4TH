( * sequences * )
( by bartgo [?] )
( OK: APX Forth )

: FIELD 
  LATEST PFA 2+ ;
: SEQUENCE 
  <BUILDS , ( n -- )
  DOES>     ( -- n )
	DROP 1 FIELD +! 
	FIELD @ ;

( examples/tests )
  
1000 SEQUENCE MYID1
MYID1 1001 ?PAIRS
MYID1 1002 ?PAIRS
10   SEQUENCE MYID2
MYID2   11 ?PAIRS
MYID2   12 ?PAIRS
