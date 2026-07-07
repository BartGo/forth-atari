( variables as constants )
( as popularized in 1980s)
( by ???                 )

0 VARIABLE %TO
: TO 1 %TO ! ;
: VAL <BUILDS , DOES> %TO @
  IF ! 0 %TO ! ELSE @ THEN ;

( example )
  
42 VAL XYZ
24 VAL ABC
XYZ .
ABC .
11 TO ABC
22 TO XYZ
XYZ .
ABC .
