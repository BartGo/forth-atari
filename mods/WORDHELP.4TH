( ------------------------------------ )
( word help for apx extended fig-forth )
( on atari 8-bit; code by BartGo, 2026;)
( requires and includes parts of DECOMP)
( as including in the "base" APX Forth )
( ------------------------------------ )
( requires DEBUG/DECOMP, so do 21 LOAD )
( ------------------------------------ )
( use - \? cc - for help about word cc )
(   \? SCR   )
(   \? BL    )
(   \? DUP   )
(   \? SPACE )
(   \? .WORD )
(   \? WIDTH )
( ------------------------------------ )

FORTH DEFINITIONS HEX
: /? ( -- cc )
  [COMPILE] ' OUT @ C/L 2 / > 0= IF
    CR 0 OUT ! THEN
  CR CR ." * Word header of "
  DUP NFA ID. 
  DUP NFA @ 20 AND IF CR ."   SMUDGE " THEN
  DUP NFA @ 40 AND IF CR ."   IMMEDIATE " THEN 
  CR DUP
  ."   PFA=" U. CR DUP NFA
  ."   NFA=" U. DUP LFA
  ."   LFA=" U. DUP CFA
  ."   CFA=" U. CR DUP
  ."   CFA pointing to " CFA @ U.
  DUP CFA @ 1441 = IF
	.WORD ! ." (COLON)"
	CR ." * Decomp" CR
    BEGIN NXT1 NP CKIT CR AGAIN 
  ELSE DUP CFA @ 147D = IF
    ." (CONSTANT)" CR ."   Equals: "
    @ U. CR
  ELSE DUP CFA @ 1499 = IF
    ." (VARIABLE)" CR ."   Equals: "
    @ U. CR
  ELSE DUP CFA @ 14B2 = IF
    ." (USER)" CR ."   Equals: "
    C@ UP @ + @ . CR
  ELSE DUP CFA @ 18D8 = IF ." (DOES>)" CR
  ELSE DUP CFA @      = IF ." (ASSEMBLY)" CR
  THEN THEN THEN THEN THEN THEN CR ;

DECIMAL
