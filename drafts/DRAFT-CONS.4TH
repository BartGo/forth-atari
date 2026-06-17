 
( ----------------------------- ) 
( Lifor / Lisp-like fun in 4th  )   
( ----------------------------- ) 
( This is an attempt to have    )
( lists management in Lisp-like )
( manner, in APX Forth on Atari )
( 8-bit; see "tests" section    )
( for usage examples; by BartGo.)

( FIXME: bugs - keep on testing!)

( * node pseudo-types  )
0 CONSTANT #NIL ( type:nil     \)
1 CONSTANT #ADR ( type:addr/var&)
2 CONSTANT #VAL ( type:value/nr#)
3 CONSTANT #STR ( type:atom/str$)
9 CONSTANT #4TH ( type:4th-wd  ^)

( * error for pseudo-typed ops )
: ERR.TYPES 5 ERROR ; 
( * store/! for pseudo-typed )  
: #! ( #tv val #tadr adr -- )
  ( store value under adress )
  ( TODO: test me )
  >R #ADR = ROT      ( val f #tv R: adr )
  #VAL = AND R> SWAP ( val adr f R: --  )
  IF ! ELSE     ( must be val->adr )
    2DROP ERR.TYPES  ( type error )
  THEN ; 
: @! ( #adr adr1 #adr adr2 -- val )
  ( FIXME: fix and test me )
  ( @ from address, store under address )
  SWAP #ADR = >R ROT #ADR = R> AND
  IF SWAP @ SWAP !
  ELSE 2DROP ERR.TYPES THEN ;
( * fetch/@ for pseudo-typed )
: #@ ( #tadr adr -- val )
  SWAP #ADR = IF @ ( addr only! )
  ELSE DROP ERR.TYPES THEN ;
: ]IS ( #ta a #tb -- f )
  SWAP DROP = ; ( ex: LST CDR #NIL ]IS )

( #VAL 0   #ADR 710 #! ( -- PASS )
( #VAL 148 #ADR 710 #! ( -- PASS )
( #ADR 710 #ADR 712 @! ( -- PASS )
  
( * node pseudo-type wrapping  )
: NIL]  ( -- #nil #nil ) #NIL #NIL ;
: ADR:] ( -- #adr )      #ADR ;
: VAL:] ( -- #val val )  #VAL ;
: STR:] ( -- #str adr )  #STR HERE ;

( * lisp-like functions )
: CONS
  ( #ta a #tb b -- #adr adr )
  ( dict: 4 cells alloted   )
  HERE >R 2SWAP
  SWAP , , SWAP , , #ADR R> ;
: CAR  ( #tx x -- #ty y ) 
  OVER #VAL = IF ;S THEN 
  OVER #STR = IF ;S THEN 
  OVER #4TH = IF ;S THEN 
  SWAP #NIL = 0= IF ( car[nil] )
    DUP 0 + @ #NIL = IF DROP NIL]
	ELSE 0 + DUP @ SWAP 2 + @ THEN
  ELSE #NIL SWAP THEN ;
: CDR ( #tx x -- #tx y )
  OVER #VAL = IF ;S THEN 
  OVER #STR = IF ;S THEN 
  OVER #4TH = IF ;S THEN 
  SWAP #NIL = 0= IF ( car[nil] )
    DUP 4 + @ #NIL = IF DROP NIL]
	ELSE 4 + DUP @ SWAP 2 + @ THEN
  ELSE #NIL SWAP THEN ; 
: CAAR ( #tx x -- #ty y ) CAR CAR ;
: CADR CDR CAR ;
: CDAR CAR CDR ;
: CDDR CDR CDR ;
: CAAAR CAR CAR CAR ;
: ?ATOM ( #tx x -- f ) DROP #STR = ;
: ?EQ ( #ta a #tb b -- f )
  >R ROT = IF ( are types equal? )
    R> = ( if yes, return "a=b" )
  ELSE
    R> 2DROP 0 ( if no, always "ff" )
  THEN ; ( TODO: not only for atoms? )
  ( TODO: comparing NILs?? )

( * data type for list variables )
: <LIST
  ( #adr adr -- ccc ; -- #adr adr )
  ( A list can only [!] be created)
  ( from CONS or with an address, )
  ( otherwise throw value error/5.)
  ( This means a NIL or value or  )
  ( other non-#ADR pseudo type can)
  ( not be used to create lists.  )
  <BUILDS
  OVER #ADR = 0= IF ( type mismatch ) 
    2DROP ERR.TYPES ;S 
  THEN , DROP DOES> @ #ADR SWAP ;  
  
( * node content printer )
: 'EX ( pfa -- ) CFA EXECUTE ;
: '.  ( pfa -- ) NFA ID. ;
: (?T.) ( #t1 '#t2 -- )
  DUP ROT ROT 'EX = IF '. ELSE DROP THEN ;
: ]. ( #tx x [lvl] -- ; describe a node )
  ( TODO: add lvl and indent CAR/CDR )
  ( ROT ROT ( lvl #tx x ) 
  DUP . SWAP 
  DUP ' #NIL (?T.) 
  DUP ' #ADR (?T.) ( [lvl] x #tx )
  DUP #ADR = IF 
    SWAP ( [lvl] #tx x )
	[ SMUDGE ]
	  ( ROT >R R ROT ROT )
	  2DUP CR ." CAR:" CAR ( R> ) ]. 
	  ( ROT >R R ROT ROT )
	  2DUP CR ." CDR:" CDR ( R> ) ]. 
	[ SMUDGE ]
	SWAP ( [lvl] x #tx )
  THEN
  DUP ' #VAL (?T.)
  DUP #VAL = IF ( [lvl] x #tx )
    OVER ." val=" . 
  THEN
  DUP ' #STR (?T.)
  DUP #STR = IF ( [lvl] x #tx )
    OVER ." str=" @ COUNT TYPE
  THEN
  DUP ' #4TH (?T.)
  DUP #4TH = IF ( [lvl] x #tx )
    OVER ." 4th=" @ NFA ID.
  THEN
  2DROP ( DROP ) ;

NIL] NIL] CONS
  VAL:] 1111 CONS
  VAL:] 2222 CONS
  VAL:] 3333 CONS
S.
].

;S

( * ----- )
( * tests )
( * ----- )

: =TEST ?EQ 1 ?PAIRS ;

( create a variable / list ptr )
NIL] NIL] CONS
  VAL:] 11 CONS
    VAL:] 22 CONS
	  VAL:] 33 CONS
<LIST MYLIST
  
( test some functions )
MYLIST CDR      #VAL 33 =TEST
MYLIST CDAR     #VAL 22 =TEST
MYLIST CAAR CDR #VAL 11 =TEST
  
( create an empty list )
( NIL] <LIST MUST-ALWAYS-FAIL )
NIL] NIL] CONS <LIST TREE ( OK )
TREE CDR NIL] =TEST     ( PASS )
TREE CAR NIL] =TEST     ( PASS )

( <<< above tests run OK! )
( FIXME: below  >>> )

( FIXME: join lists - FAIL )
TREE VAL:] 44 CONS MYLIST @! 
MYLIST CAR TREE =TEST      

( TODO: strings / atoms )
: (S")
  R COUNT DUP 1+ R> + >R
  DROP DROP ;
: S" ( -- adr adr len )
  STATE @ 0= IF
    ASCII " WORD HERE
  ELSE
    COMPILE (S")
	ASCII " WORD HERE
	C@ 1+ ALLOT
  THEN ; IMMEDIATE
  
( TODO: test strings / atoms )
: CONS$-TEST
  NIL]
  STR:] S" ELEMENT1"
    CONS 
    STR:] S" ELEMENT2" 
      CONS
  TREE @!
  TREE 0 ]. ;
	
CONS$-TEST	
	
;S
  
