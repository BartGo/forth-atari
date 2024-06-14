( conditional execution )
( atari 8-bit apx forth )
( thanks to thomasson_don_advanced_spectrum_forth )
( to do: allow vectored execution and using different strings )

: INCLUDE$ ." CRS" ; ( default )
: GO ( -- )
  ' INCLUDE$ 2+ CONTEXT @ @ (FIND)
  IF DROP CFA EXECUTE
  ELSE
    CR INCLUDE$ ." : not found!" CR
  THEN ; 

GO ( CR found and executed )
