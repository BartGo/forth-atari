( A Better List ; n BLIST --   )

( APX FORTH for Atari 8-bit    )
( TO DO: make it compatible w/ )
(        APX- and val- Forths  )
( TO DO: adapt INDEX/OUTLINE   )

( This word works like LIST but)
( lists also screens w/ binary )
( data, presenting it in hex.  )
( Binary is recognised by the  )
( 1st character not being space)
( nor left bracket nor colon.  )

FORTH DEFINITIONS DECIMAL

( sub: is the screen binary )
: ?SCR-TXT ( b -- f )
  0 SWAP (LINE)      ( a len )
  DROP C@ DUP        ( c c )
  ASCII ( = SWAP DUP ( f1 c c )
  ASCII : = SWAP     ( f1 f2 c )
  BL      = OR OR ;  ( f )

( main: list a screen )
: BLIST ( b -- ; LIST+data/hex )
  DECIMAL           ( b / R: - )
  C/L >R 32 ' C/L ! ( R: C/L )
  CR DUP DUP        ( b b b )
  SCR ! ." SCR # "  ( b b )
  DUP .             ( b )
  ." [ " DUP 2 *    ( b 2b )
  DUP 1 + SWAP      ( b 2b+1 2b )
  . ." - " . ." ]"  ( b )
  ?SCR-TXT 0= IF
    ." ( data as hex )"
  ELSE
    ." ( text )"
  THEN CR            ( - )
  1024 C/L / 0 DO
    CR I 3 .R        ( - )
    SPACE            ( - )
    SCR @ ?SCR-TXT   ( f )
    IF               ( - )
      I SCR @ .LINE  ( - )
    ELSE
      I SCR @ (LINE) ( a len )
      OVER + SWAP    ( a2 a1 )
      DO 
        HEX I C@ U. DECIMAL
      LOOP 
    THEN             ( - )
  LOOP CR            ( R: C/L )
  R> ' C/L ! ;
  
: BLISTS ( upper lower -- )  
  DO
    I BLIST ( - )
  LOOP ;
  
( 200 0 BLISTS )


