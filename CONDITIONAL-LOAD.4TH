0 VARIABLE 'XW
: INCLUDE$ ." CR" ; ( default )
' INCLUDE$ 'XW !
: ?W ( -- pfa | 0 )
  'XW @ 2+ CONTEXT @ @ (FIND)
  IF DROP ELSE 0 THEN ; 
: PRESENT? 'XW ! ?W ; 
: MISSING? PRESENT? 0= ;
: XW ( -- ) ( exec a vectored word )
  ?W DUP
  IF CFA EXECUTE ELSE DROP THEN ;

: A$ ." ASSEMBLER" ; : E$ ." EDITOR" ; : M$ ." )EDIT" ;

( TEST )
: X$ ." T" ; : XED ( -- ) ' E$ PRESENT? IF XW ' X$ 'XW ! XW THEN ;

: LOAD-ED     ( -- ) ' E$ MISSING? IF 27 LOAD THEN ;
: LOAD-ASM-PM ( -- ) ' A$ MISSING? IF 39 LOAD THEN ;
: LOAD-ASM-WR ( -- ) ' A$ MISSING? IF 75 LOAD THEN ;
: LOAD-ED-MD  ( -- ) ' M$ MISSING? IF 60 LOAD THEN ;

( scanlon_leo_j_forth_programming )
( convert from EXPECT to standard )
: LEN ( addr -- count )
  255 0 DO
    DUP I + C@ 0= IF
      I LEAVE THEN
  LOOP
  SWAP DROP ;
: ACCEPT ( addr n -- )
  OVER 1+ DUP ROT EXPECT 
  LEN SWAP C! ;
( PAD 20 ACCEPT PAD COUNT TYPE )





( FIXME )


: |ISDEF ( -- pfa | 0 )
  BL WORD  HERE COUNT PAD OVER OVER C!
  1+ SWAP CMOVE PAD 2+ CONTEXT @ @ (FIND)
  IF SWAP DROP ELSE 0 THEN
  ; IMMEDIATE

: |INCLUDE
  |ISDEF EDITOR    IF 27 LOAD THEN
  |ISDEF ASSEMBLER IF 39 LOAD THEN
  |ISDEF GR.       IF 50 LOAD THEN
  |ISDEF FLOAT     IF 60 LOAD THEN
  ; |INCLUDE|
  

