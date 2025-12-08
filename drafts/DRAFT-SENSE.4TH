( WIP - idea only )
( Atari 8-bit, APX Forth )
( Idea: intellisense-like extension for fig-forth interpreter )
( How: modify interpreter loop, do not interpret TAB; upon it,) 
(      list a subset of VLIST, matching characters entered so )
(      far; show entered string again and allow to fill in.   )
( Challenges: EXPECT and KEY are optimized on Atari and are   )
(             different from FIG standard, not allowing vector)
(             etc; no string comparison.                      )
( Potential: display "compiled comments" / stack comments as a)
(            silly replacement of type checking )

FORTH DEFINITIONS HEX

( slower but forthy EXPECT )
: EXPECT2 ( a n -- )
  OVER + OVER DO
  KEY DUP 7E ( BS, 0E+ORIG )
	= IF
	  OVER I = DUP R> 2 - + >R -
	ELSE ( NOT BS )
	  DUP 7F = IF ( TAB )
	  2C6 DUP @ 4 XOR SWAP ! 
		( TODO: print matching )
		( TODO: needed string compare )
		( TODO: CR, show again entered )
		( S. )
		2C6 DUP @ 4 XOR SWAP ! 
	  ENDIF
	  DUP 9B = ( RET ) IF 
	    LEAVE DROP BL 0
	  ELSE DUP ENDIF
		I C! 0 I 1+ !
	ENDIF
	DUP 7F = IF ( TAB )
	  DROP ELSE EMIT
	ENDIF
  LOOP DROP ;
  
: QUERY2 TIB @ 50 EXPECT2 0 IN ! ;
  
' QUERY2 CFA ' QUIT C + !

ABORT

( Observation: )
( - QUERY is apparently only used in QUIT )
( - EXPECT is apparently only used in QUERY )
( Q: should we alter both words? replace QUIT? what is safest? )
 

-----------

