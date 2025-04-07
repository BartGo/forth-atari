(          * DEFER-IS *         )
(  from Henry Laxen FDvVnr6p35  )
( Adapted by BartGo for Atari's )
(    APX  Extended Fig-Forth    )

: DEFER ( DEFER X -- )
  <BUILDS [ ' ;S CFA ] LITERAL , 
  DOES> @ EXECUTE ; 
: IS ( pfa IS deferred-word -- )
  CFA [COMPILE] ' 2 + ! ; IMMEDIATE

;S
DEFER OP
' + IS OP  2 1 OP .
' - IS OP  2 1 OP .

( https://www.softsynth.com/pforth/pf_ref.php#Customising-FORGET )
: WHAT'S ( ... )
  ' CFA @ NFA ID. ; ( UNTESTED )
WHAT'S OP ( - )

( __ TEST ME _________________ )

( 2nd way FD v7n5 )
: <BUILDS 2 ALLOT DOES> @ EXECUTE ;
: (IS) R @ CFA ! R> 2 + >R ;
: IS STATE @ IF
    COMPILE (IS) ELSE ' CFA !
  THEN ; IMMEDIATE

( ___ some ideas to be tested ____ )

: -EXE ( -EXE myword -- )
  -FIND IF DROP CFA EXECUTE
  THEN ; IMMEDIATE  

: \EXE ( -EXE myword -- )
  -FIND IF
    [COMPILE] -EXE EXECUTE
  ELSE DEFER THEN ; IMMEDIATE  

-EXE CR
DEFER S.

: EXAMPLE ( -- )
  10 0 DO
    I CR -EXE S.
  LOOP -EXE S. ;
  


