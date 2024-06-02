( Case-insensitive fig-Forth )
( Ported from: pns-FORTH 1.4 )
( Tested on Atari 800XL emul.)
( and APX Extended fig-Forth )

: UPPER ( pns 1.4 )
  OVER + SWAP DO
      I C@ 96  > ( between a )
      I C@ 123 < ( ... and z )
    AND	IF I 32 TOGGLE THEN
  LOOP ;
: -FINDX
  BL WORD HERE
  COUNT UPPER HERE ( pns 1.4 )
  CONTEXT @ @ (FIND) DUP 0= IF
    DROP HERE LATEST (FIND)
  THEN ;  
: ZAP ( oldpfa newpfa -- ) 
  CFA OVER ! ( new pfa into old )
  [ ' ;S CFA   ] LITERAL OVER  2+ !
  [ ' ;  CFA @ ] LITERAL SWAP CFA ! ;
' -FIND ' -FINDX ZAP
FORGET ZAP
