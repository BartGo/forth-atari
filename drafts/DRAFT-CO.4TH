( SIMPLE COROUTINE / YIELD
( limited with return stack usage,
( e.g. do..loop impossible, use begin..again instead )

( https://home.hccnet.nl/a.w.m.van.der.horst/forthlecture6.html
( https://comp.lang.forth.narkive.com/LrkFm3UV/yield-in-forth
( http://forum.6502.org/viewtopic.php?f=9&t=5379&start=183

: CO R> R> SWAP >R >R ;

: PRIMARY
  BEGIN 
    ." 1" CO
  AGAIN ;
    
: SECONDARY
  BEGIN
    ." 2" CO
  AGAIN ;
  
: RUN
  125 EMIT
  PRIMARY SECONDARY ;

( ---------------- )
( more experiments )
( ---------------- )
: CO R> R> SWAP >R >R ;

: 1ST BEGIN ." 1" CO AGAIN ;
: 2ND BEGIN ." 2" CO AGAIN ;
1ST 2ND

---------

: CO ( -- ) R> R> SWAP >R >R ;
: 1ST ( -- )
  0 IF 9999 THEN 10 0 DO
	CR ." 1ST.I=" I . R> R>
	[ SMUDGE ]
	R ' 1ST 8 + ! ' 1ST 8 + ?
	[ SMUDGE ] ." (1) " CO >R >R
  LOOP ;
: 2ND ( -- )
  0 IF 9999 THEN 10 0 DO
	CR ." 2ND.I=" I . R> R> 
	[ SMUDGE ]
	R ' 2ND 8 + ! ' 2ND 8 + ?
	[ SMUDGE ] ." (2) " CO >R >R
  LOOP ;
: RUN ( -- ) 1ST 2ND ;



  
