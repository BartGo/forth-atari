
: GLOBAL VARIABLE ; IMMEDIATE
0 GLOBAL *RP ( return stack memory )
\ scopes can't be nested, only seq.
: LOCAL <BUILDS , DOES> @ ; / mk snglt

(( \ RP stored in *RP
  0 LOCAL &test
  6 LOCAL &foo
  BEGIN
    200 &test !
    LEAVE
  AGAIN
)) \ locals released: drop till *RP
&test ? ( ERROR )


: (( RP@ 2- *RP ! ; \ why not
: )) *RP RP@ ! ; \ why not