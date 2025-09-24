( ********** EWK ********** )
( EDYTOR WYSWIETLANIA KODOW )
( [  CODE DISPLAY EDITOR  ] )
(       by R. PANTOLA       )
( best works together with: )
( EDYTOR KODOW KONTROLNYCH  )
( [  CONTROL CODE EDITOR  ] )
( Used to generate checksum )
( codes for Forth code, as  )
( published in the magazine )
( Tajemnice Atari [1992/93] )
( ************************* )

( REQUIRES: EW vocabulary with EDK )

DECIMAL

EW DEFINITIONS 

: ?KOD 
  0 *K ! 0 AF 32 + AF DO
    1 *K +!
	I C@ *K @ * + 1024 MOD
    I C@ 0= IF
	  I 32 BLANKS LEAVE
	ENDIF
  LOOP
  125 EMIT 2 2 POS
  32 BASE ! .R2 DECIMAL
  AF 32 TYPE CR 32 AB +! ;

: ?ZLE-W
  CR CR -32 AB +! 2 4 POS
  AF 32 TYPE 155 EMIT 28 EMIT ;

FORTH DEFINITIONS

: EDK ( -- )
  EW
    0 AB ! 125 EMIT
    BEGIN
      2 3 POS CR AF 37 EXPECT
      AF C@ IF
	    ?KOD ELSE ?ZLE-W
	  ENDIF
      AF C@ 5 = ( ctrl-E=Quit )
    UNTIL
  FORTH ;
