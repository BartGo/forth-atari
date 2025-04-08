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


  
