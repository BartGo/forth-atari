0 VARIABLE 'XW

: INCLUDE$ ." CR" ; ( default )
' INCLUDE$ 'XW !

: ?W ( -- pfa | 0 )
  'XW @ 2+ CONTEXT @ @ (FIND)
  IF DROP ELSE 0 THEN ; 
  
: XW ( -- ) ( exec a vectored word )
  ?W DUP
  IF CFA EXECUTE ELSE DROP THEN ;

XW ( default CR found and executed )

: A$ ." ASSEMBLER" ;
' A$ 'XW !
XW ( switch to assembler )

: E$ ." EDITOR" ;
' E$ 'XW !
XW ( quiet - word not found )
