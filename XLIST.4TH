( XLIST FOR APX FORTH, WIP )
( SHOWS TYPE FROM CFA, IMMEDIATE AND SMUDGE AND COMPILE-ONLY [?], LAST FROM LFA )

: XLIST 
  BASE @ DECIMAL
  CR 128 OUT ! CONTEXT @ @ 
  BEGIN
    OUT @ C/L 2 / > 0= IF
      CR 0 OUT ! THEN
  	DUP ID. 
	( DUP	PFA ." PFA"       U. )
	DUP	PFA CFA @
	  DUP 5185 = 0= IF
	    ." CF@" U.
	  ELSE DROP ." (:) "
	  ( MANAGE ALSO: VAR, CONST, USER )
	  THEN
	( DUP	PFA ." NFA" NFA   U. )
	( DUP	PFA ." LFA" LFA   U. )
	( FLAGS: IM SM )
	." -- "
	( DUP	PFA ." LF@" LFA @ U. )
	CR
	PFA LFA @ DUP 0= ?TERMINAL OR
  UNTIL DROP
  BASE ! ;

XLIST
 
( FIXME )
( : IS-TYPE CFA @ LFA NFA ID. ; )
( ' X IS-TYPE ( -> VARIABLE )
( ' Y IS-TYPE ( -> CONSTANT )
( ' Z IS-TYPE ( -> USER     )
( ' Q IS-TYPE ( -> MYTYPE   )
( ' V IS-TYPE ( -> [COLON]  )
( ' H IS-TYPE ( -> $0000    )
