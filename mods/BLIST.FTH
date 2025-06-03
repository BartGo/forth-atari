( A Better List ; n BLIST --   )
( By BartGo 2025 / MIT license )
( APX-/valFORTH for Atari 8-bit)
( This word works like LIST but)
( lists also screens w/ binary )
( data, presenting it in hex.  )
( Text is recognised by all    )
( the characters from 1st line )
( of a screen being between BL )
( and z.                       )
( A line consisting of null    )

DECIMAL FORTH DEFINITIONS

( fn: is it a screen of text?  )
: ?SCRTXT ( b -- f )
  1 0 ROT (LINE)  ( tf a len )
  OVER + SWAP     ( tf a+len a )  
  DO
    I C@          ( tf|f c )
	DUP 31 > SWAP ( tf|f f c )
	123 < AND     ( tf|f f )
    AND           ( f )
  LOOP ;          ( f )

( main: list a single screen )
( ex: 80 BLIST )
: BLIST ( b -- ; LIST+data/hex )
  DECIMAL             ( b )
  CR DUP DUP          ( b b b )
  SCR ! ." SCR # " .  ( b )
  ?SCRTXT 0= IF
    ." ( hex/data )"
  ELSE
    ." ( txt )"
  THEN                ( - )
  B/BUF B/SCR * C/L / ( scrsiz )
  0 DO
    CR I 3 .R         ( - )
    SPACE             ( - )
    SCR @ ?SCRTXT    ( f )
    IF                ( - )
      I SCR @ .LINE   ( - )
    ELSE
      I SCR @ (LINE)  ( a len )
      OVER + SWAP     ( a2 a1 )
      DO 
        HEX I C@ U. DECIMAL
      LOOP 
    THEN              ( - )
  LOOP CR ;

( main: list range of screens )  
( ex: 0 100 BLISTS )
: BLISTS ( lower upper -- )  
  SWAP DO
	I BLIST ( - )
  LOOP ;
  
( valFORTH: )
(           ON P: )
(           0 999 BLISTS )
(           OFF P: )

( APXFORTH: )
(           PON )
(           0 999 BLISTS )
(           POFF )

( APXFORTH/PANTOLA: )
(           32 ' C/L ! PON )
(           0 999 BLISTS )
(           POFF 64 ' C/L ! )

