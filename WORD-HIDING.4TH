( *WIP* - CRASH
( simple namespaces [?] by hiding parts of vocabulary
( - a primitive alternative to dictionaries 
( Fig-Forth / APX Forth for Atari 8-bit

: ['] [COMPILE] ' ;
: A ." I am A! " ; 
: B ." I am B! " A ; 
: C ." I am C! " B A ; 

: ::LETTERS ( hide a series of earlier words )
  0 DROP      ( LFA memory )
  ' A LFA @ ( first word to hide is A =
  ( ['] LFA @   ( TODO: custom word to hide from )
  [ SMUDGE ] ' ::LETTERS [ SMUDGE ] ( get own PFA )
  LFA ! ;     ( link ::LETTERS behind A )

: UNCOVER:: ( restore the link using LFA memory in :ABC: ) ( -- ) ( CRASH FIXME )
  ['] DUP DUP DUP ( n n n n )
  IF ( only if LFA memory <> 0 ) ( n n n )
    LFA !    ( restore link ) ( n )
    0 SWAP ! ( put 0 back into the LFA memory )
  ELSE DROP DROP DROP THEN ( - ) ;

A B C ( OK )
VLIST
::LETTERS
A
A B C ( error )
UNCOVER:: ::LETTERS ( CRASH FIXME )
A B C ( OK )

;S

( helper / check )
' C LFA @   11014 ?PAIRS
' B NFA     11014 ?PAIRS
' B LFA @   11006 ?PAIRS
' A NFA     11006 ?PAIRS
' A LFA @   10970 ?PAIRS
' ASCII NFA 10970 ?PAIRS



