(          * DEFER-IS *         )
(  from Henry Laxen FDv5nr6p35  )
( Adapted by BartGo for Atari's )
(    APX  Extended Fig-Forth    )
( and fixed -- for compile mode )
( see also: FDv3nr6p174 [Laxen] )

: ['] [COMPILE] ' ; IMMEDIATE
: NOT-IMPL CR 20 ERROR ;
: DEFER
  <BUILDS [ ' NOT-IMPL CFA ]
  LITERAL , DOES> @ EXECUTE ; 
: IS ( pfa IS defrrd-word -- )
  2+ SWAP CFA SWAP ! ;
  
( Identify deferred meaning: )
( https://www.softsynth.com  )
( /pforth/pf_ref.php         )
( #Customising-FORGET        )
: WHATS  ( WHATS OP -- )
  [COMPILE] ' ( op's pfa )
  2+ @ ( op's target's cfa )
  2+   ( target's cfa->pfa )
  NFA ID. ; IMMEDIATE

DEFER X 
: OP1 ['] CR ['] X IS ;
: OP2 ['] VLIST ['] X IS ;

X WHATS X ( NOT-IMPL )
OP1 X     ( CR runs )
WHATS X   ( print "CR" )
OP2 X     ( VLIST runs )
WHATS X   ( print "VLIST" )
