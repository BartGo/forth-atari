: ['] ( -- cc ) [COMPILE] ' ;

( an example function )
: ADD3 ( n -- n+3 ) 3 + ; 

( apply a word from xt twice on n )
: TWICE' ( n xt -- xt[xt[n]] )
  DUP >R ( n xt | xt )
  CFA EXECUTE ( n' | xt ; assumed that xt leaves n' on stack! )
  R> CFA EXECUTE ( n'' ) ;

7 ' ADD3 TWICE' ( = g[] ) ( 7+3+3  )
  ' ADD3 TWICE'           ( 13+3+3 )
19 ?PAIRS  
