( *** )
( KEYWORDS - WHERE USED
( FD VOL VII, NO 1
( COPYRIGHT [C] 1983
( by Nicholas L. Pappas, PhD
( + SCAN macro by BartGo
( how to run, example: ' WORD SCAN
( *** )

  ' : CFA @
CONSTANT DOCOL

  ' LIT LFA
CONSTANT XLIT

: FINDID. ( addr -- )
  BEGIN
    DUP XLIT = SWAP 1 -
    DUP 1+ @ DOCOL = DUP
    IF OVER 1+ 0 4 D.R SPACE
    THEN ROT OR
  UNTIL 3 + NFA ID.
  CR ;

: FINDNO ( addr nl n2 -- )
  CR CR ." LOOKING FOR "
  DUP 0 4 D.R
  SPACE DUP 2+ NFA ID.
  CR ROT ROT OVER + SWAP
  DO DUP I @ =
    IF I 0 4 D.R SPACE
    I FINDID.
  THEN
  LOOP
  DROP ; 
  
: SCAN ( pfa -- )
  CFA
  ' LIT CFA ' LATEST CFA 
  ROT FINDNO ;
 
;S
