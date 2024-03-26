
BASE @
HEX

: .V 
  DUP NFA ID. SPACE
      CFA EXECUTE
  DUP    HEX  6 .R
  DUP    @    6 .R
  DUP DECIMAL 6 .R
         @    6 .R CR ;

: CVIEW CR CR
	." System Constants" CR
	( ." Name  HAddr  HVal DAddr DVal" CR )
	' FIRST .V
	' LIMIT .V
	' B/SCR .V
	' B/BUF .V
	'   C/L .V
;
: UVIEW CR CR
	." User Variables" CR 
	( S0 )
	( R0 )
	' TIB .V
	' WARNING .V
	' FENCE .V
	' DP .V
	' VOC-LINK .V
	' BLK .V
	' IN .V
	' OUT .V
	' SCR .V
	' OFFSET .V
	' CONTEXT .V
	' CURRENT .V
	' STATE .V
	' BASE .V
	' DPL .V
	' FLD .V
	' CSP .V
	' R# .V
	' HLD .V ;

BASE !
