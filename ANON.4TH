( ------------------- )
( Anonymous Variables )
( Leonard Morgenstern )
(       FDV06N1       )
( fine on Atari APX F )
( ------------------- )

0 VARIABLE ANON/
: MAKEANON
  HERE ANON/ ! ANON/
  CFA @ , 0 , ;
: ANON
  ANON/ @ STATE @ IF
    , ELSE EXECUTE
  ENDIF ; IMMEDIATE
: ANON+
  ANON/ @ EXECUTE +
  STATE @ IF
    [COMPILE] LITERAL
  ENDIF ; IMMEDIATE
: STORESTACK
  2 * OVER + SWAP
  DO I ! 2 +LOOP ;

( EXAMPLE )
MAKEANON 6 ALLOT ( 8 bytes )
: TESTWORD
  4 3 2 1 ANON 4 STORESTACK
  [ 2 ] ANON+ @ ;
