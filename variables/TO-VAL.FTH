( variables as constants )
( as popularized in 1980s)
( by ???                 )
( & naming aligned with  )
( ARGUMENTS/RESULTS code )

0 VARIABLE [TO] : TO 1 [TO] ! ;
: VAL <BUILDS , DOES> [TO] @
  IF ! 0 [TO] ! ELSE @ THEN ;

;S

( example )
: TASK ;  
42 VAL XYZ
24 VAL ABC
XYZ .
ABC .
11 TO ABC
22 TO XYZ
XYZ ABC + 33 ?PAIRS
FORGET TASK
