( --- namespaces, approach 1 ---- )

( see:    dictionary/LOCALDEF.4TH )
(         for non-vocabulary ideas)

( ---- namespaces, approach 2 --- )

( a vocabulary needs to be called )
( before a word from it, and the  )
( control is immediately returned )
( to the FORTH vocabulary...      )

FORTH DEFINITIONS

: ): CFA EXECUTE ;

VOCABULARY HOUSE IMMEDIATE
HOUSE DEFINITIONS
  : WINDOW 1 . ;
  : DOOR   2 . ;
FORTH DEFINITIONS
: HOUSE:(
  [COMPILE] HOUSE [COMPILE] '
  [COMPILE] FORTH ; IMMEDIATE

: MAIN1
  HOUSE:( WINDOW ): 
  HOUSE:( DOOR   ): ;
  
VOCABULARY BOAT IMMEDIATE
BOAT DEFINITIONS
  : SAIL 3 . ;
FORTH DEFINITIONS
: BOAT:(
  [COMPILE] BOAT [COMPILE] '
  [COMPILE] FORTH ; IMMEDIATE

: MAIN2
  BOAT:( SAIL ): ;


( ---- namespaces, approach 3 ---- )

( just shortcuts to custom vocabularies )
( and implicit return to the FORTH one  )

FORTH DEFINITIONS DECIMAL EMPTY-BUFFERS 
: ;F [COMPILE] FORTH
     [COMPILE] DEFINITIONS ; IMMEDIATE

( -LOAD defined in FORTH aborts )
: -LOAD ABORT ; 

VOCABULARY SYS IMMEDIATE
           SYS DEFINITIONS ;F

: S: [COMPILE] SYS
     [COMPILE] DEFINITIONS ; IMMEDIATE

( -LOAD defined in SYS / S: proceeds )
S: : -LOAD DROP ; ;F

( back in FORTH )
: $" BL WORD ;
$" ASSEMBLER" 39 S: -LOAD ;F 
$" EDITOR"    27 S: -LOAD ;F

( S: / ;F switched to SYS and back )
