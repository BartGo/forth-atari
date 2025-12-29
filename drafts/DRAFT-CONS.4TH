 ( * trying to understand cons )   
 ( * on Atari 8-bit, APX Forth )

0 CONSTANT #NIL ( type of nil   )
1 CONSTANT #ADR ( type of addr  )
2 CONSTANT #VAL ( type of value )
3 CONSTANT #STR ( type of str   )
: !^   ( t val var-adr -- ) ! DROP ; 
: NIL: ( -- #nil #nil ) #NIL #NIL ;
: VAL: ( val -- #val val ) #VAL ;
: ADR: ( adr -- #adr adr ) #ADR ;
: CONS ( ta a tb b -- #adr ad )
  HERE >R 2SWAP
  SWAP , , SWAP , , #ADR R> ;
: CAR  ( #adr|#nil adr -- #adr|#nil val )
  SWAP #NIL = 0= IF ( car[nil]=nil )
    DUP 0 + @ #NIL = IF DROP NIL:
	ELSE 0 + DUP @ SWAP 2 + @ THEN
  ELSE #NIL SWAP THEN ;	
: CDR ( #adr|#nil adr -- #adr|#nil val )
  SWAP #NIL = 0= IF ( car[nil]=nil )
    DUP 4 + @ #NIL = IF DROP NIL:
	ELSE 4 + DUP @ SWAP 2 + @ THEN
  ELSE #NIL SWAP THEN ;

( * tests )

0 VARIABLE CON^ ( cons handle )
: CONS-TEST ( -- )
  NIL:      ( #nil #nil         )
  VAL: 11   ( #nil #nil #adr 11 )
    CONS    ( #adr  adr         )
    VAL: 22 ( #adr  adr #adr 22 )
      CONS  ( #adr  adr         )
  CON^ !^
  CON^ . ;

CONS-TEST  

;S


( TODO )
( * counted strings ) 
( ... )
: CONS$-TEST
  ADR: CON^
    ADR: C" ELEMENT1" 
      CONS 
      ADR: C" ELEMENT2" 
        CONS
    CON^ !^
    CON^ . ;
	
CONS$-TEST	
	
;S
  
