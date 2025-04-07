(          * DEFER-IS *         )
(  from Henry Laxen FDv5nr6p35  )
( Adapted by BartGo for Atari's )
(    APX  Extended Fig-Forth    )
( see also: FDv3nr6p174 [Laxen] )

: DEFER ( DEFER X -- )
  <BUILDS [ ' ;S CFA ]
  LITERAL , 
  DOES> @ EXECUTE ; 
: IS ( pfa IS defrrd-word -- )
  CFA [COMPILE] '
  2 + ! ; IMMEDIATE
: ['] [COMPILE] ' ; IMMEDIATE

DEFER OP

( https://www.softsynth.com  )
( /pforth/pf_ref.php         )
( #Customising-FORGET        )
: WHATS  ( WHATS OP -- )
  [COMPILE] ' ( op's pfa )
  2+ @ ( op's target's cfa )
  2+   ( target's cfa->pfa )
  NFA ID. ; IMMEDIATE

WHATS OP ( ;S )
' + IS OP 2 1 OP . 
WHATS OP ( +  )
' - IS OP  2 1 OP .
WHATS OP ( -  )

( this version is not working )
( in compile mode!! )

( --------------------------------

( CRASHES
( 2nd way FD v7n5p28 )
( adapted by bartgo


( faulty )
: DEFER ( DEFER VAR -- )
  <BUILDS [ ' ;S CFA ] LITERAL ,
  DOES> @ EXECUTE ; 
: (IS) ( pfa -- )
  CFA R @ 2+ !
  R> 2+ >R ;
: IS  ( pfa -- )
  STATE @ IF
	COMPILE (IS)
  ELSE
    CFA [COMPILE] ' 2+ !
  THEN ; IMMEDIATE

( corrections )
: DEFER ( DEFER VAR -- )
  <BUILDS [ ' ;S CFA ] LITERAL ,
  DOES> @ EXECUTE ; 
: ['] [COMPILE] ' ; 
: IS CFA ' 2+ ! ; IMMEDIATE
    
DEFER X
X
' CR IS X
X
: XXX ['] CR [COMPILE] IS! X ; 
XXX X
: YYY ['] VLIST IS! X ;
YYY X

( ---------- another attempt )

( v8n5p26 )
: (DEFER) 
  R> COUNT 2DUP + >R DROP FIND
  IF EXECUTE ELSE
    COUNT TYPE TRUE ABORT" is undefined." 
  THEN ;
: DEFER 
  COMPILE (DEFER) BL WORD
  C@ 1+ ALLOT ; IMMEDIATE

