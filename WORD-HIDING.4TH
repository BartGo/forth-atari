( *WIP* - CRASH
( simple namespaces [?] by hiding parts of vocabulary
( - a primitive alternative to dictionaries 
( Fig-Forth / APX Forth for Atari 8-bit

: ['] [COMPILE] ' ;
: AA ." I am A! " ; 
: BB ." I am B! " AA ; 
: CC ." I am C! " BB AA ; 

: ::NS ( hide a series of earlier words )
  0 IF 0 THEN  ( LFA "memory slot", init to 0 )
  ' AA LFA @   ( first word to hide is AA = ( n1 )
  ( ['] LFA @  ( TODO: custom word to hide from )
  [ SMUDGE ] ' ::NS
  [ SMUDGE ]   ( own PFA ( n2 )
  2DUP         ( n1 n2 n1 n2 )
  2+ 2+ 2+ !   ( LFA to "slot" behind 0 IF )
  LFA ! ;      ( ::NS behind AA )


 ( CRASH FIXME )
: ENDS:: ( restore the link using LFA memory in ::NS ) ( -- )
  ['] DUP DUP DUP ( n n n n )
  IF ( only if LFA memory <> 0 ) ( n n n )
    LFA !    ( restore link ) ( n )
    0 SWAP ! ( put 0 back into the LFA memory )
  ELSE DROP DROP DROP THEN ( - ) ;

AA BB CC ( OK )
VLIST
::NS
  AA ( error )
  CC ( error )
ENDS:: ::NS ( CRASH FIXME )
AA BB CC ( OK )

;S

( helper / check )
' C LFA @   11014 ?PAIRS
' B NFA     11014 ?PAIRS
' B LFA @   11006 ?PAIRS
' A NFA     11006 ?PAIRS
' A LFA @   10970 ?PAIRS
' ASCII NFA 10970 ?PAIRS



