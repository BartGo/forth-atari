// INCORRECT, DO  WE MOVE RETURN STACK OR DICTIONARY POINTER OR BOTH?

0 VARIABLE *RP ( return stack memory )
0 VARIABLE *DP ( dict memory )
: (( RP@ 2 - *RP ! ; ( why not )
: )) *RP RP@ ! ; ( why not )
( scopes can't be nested )

((
  0 VARIABLE &test
  6 VARIABLE &foo
  : LOCALPROC
    200 &test !
    &test ? ." < INSIDE" CR
  ;
))

&test ? ( ERROR ) ." < OUTSIDE" CR

