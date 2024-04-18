( FIXME )

0 VARIABLE *DP
: ((  HERE *DP ! ; 
: )) *DP @  DP @ ! ; 

((
  0 VARIABLE &test
  6 VARIABLE &foo
  : LOCALPROC
    200 &test !
    &test ? ." < INSIDE" CR
  ;
))

&test ? ( ERROR ) ." < OUTSIDE" CR

