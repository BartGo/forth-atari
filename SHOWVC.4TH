
BASE @
HEX

: (USHOW) 
  DUP    HEX  6 .R
  DUP    @    6 .R
  DUP DECIMAL 6 .R
         @    6 .R CR ;

: UVIEW CR CR
	." System Constants" CR
	( ." Name  HAddr  HVal DAddr DVal" CR )
	." FIRST" FIRST (USHOW)
	." LIMIT" LIMIT (USHOW)
	." B/SCR" B/SCR (USHOW)
	." B/BUF" B/BUF (USHOW)
	." C/L  "   C/L (USHOW)
	." User Variables" CR 
	( S0 )
	( R0 )
	TIB (USHOW)
	WARNING (USHOW)
	FENCE (USHOW)
	DP (USHOW)
	VOC-LINK (USHOW)
	BLK (USHOW)
	IN (USHOW)
	OUT (USHOW)
	SCR (USHOW)
	OFFSET (USHOW)
	CONTEXT (USHOW)
	CURRENT (USHOW)
	STATE (USHOW)
	BASE (USHOW)
	DPL (USHOW)
	FLD (USHOW)
	CSP (USHOW)
	R# (USHOW)
	HLD (USHOW) ;

BASE !
