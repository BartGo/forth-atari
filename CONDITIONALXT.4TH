( * conditional execution * )
(  atari 8-bit / apx forth  )

0 VARIABLE 'GO
: INCLUDE$ ." CR" ; ( default )
' INCLUDE$ 'GO !
: GO ( -- )
  'GO @ 2+ CONTEXT @ @ (FIND)
  IF DROP CFA EXECUTE
  ELSE
    CR 'GO @ CFA
	EXECUTE ." : not found!" CR
  THEN ; 

GO ( CR found and executed )

: A$ ." ASSEMBLER" ;
' A$ 'GO ! GO ( switched to assembler )

: E$ ." EDITOR" ;
' E$ 'GO ! GO ( editor not found )

: Z$ ." BOOT" ;
' Z$ 'GO ! GO ( reboot found... oops )
