: EXC ( pfa -- )
  CFA EXECUTE ; 
: ['] ( -- cc )
  [COMPILE] ' ;

: ADD3 ( n -- n+3 ) 3 + ;
: TWICE' ( n xt -- xt[xt[n]] )
  DUP >R EXC R> EXC ;

7 ' ADD3 TWICE' ( = g[] )
  ' ADD3 TWICE'
  
U. ( 19 )
