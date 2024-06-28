: /TOOLS ;

0 VARIABLE 'XW
: INCLUDE$ ." CR" ; ( default )
' INCLUDE$ 'XW !
: ?W ( -- pfa | 0 )
  'XW @ 2+ CONTEXT @ @ (FIND)
  IF DROP ELSE 0 THEN ; 
: NEEDED? 'XW ! ?W 0= ; 
: XW ( -- ) ( exec a vectored word )
  ?W DUP
  IF CFA EXECUTE ELSE DROP THEN ;

: A$ ." ASSEMBLER" ; : E$ ." EDITOR" ; : M$ ." )EDIT" ;

: LOAD-ED     ( -- ) ' E$ NEEDED? IF 27 LOAD THEN ;
: LOAD-ASM-PM ( -- ) ' A$ NEEDED? IF 39 LOAD THEN ;
: LOAD-ASM-WR ( -- ) ' A$ NEEDED? IF 75 LOAD THEN ;
: LOAD-ED-MD  ( -- ) ' M$ NEEDED? IF 60 LOAD THEN ;


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

  
  
: TOOLS/ ;



------ WITH ERROR BUT WOULD BE SIMPLE TO USE!


: ") ; : (" BL WORD  HERE COUNT PAD
  OVER OVER  C! 1+ SWAP CMOVE ; IMMEDIATE
: UNKNOWN? ( -- pfa | 0 )
  PAD 2+ CONTEXT @ @ (FIND) IF DROP ELSE 0 THEN 0= ; 

: |INCLUDE|
  (" ASSEMBLER ") UNKNOWN? IF 39 LOAD THEN
  (" GR.       ") UNKNOWN? IF 50 LOAD THEN
  (" FLOAT     ") UNKNOWN? IF 60 LOAD THEN
  ; |INCLUDE|
  

