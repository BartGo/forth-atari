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
