( primitive "classes" )
( APX Forth, Atari 8 bit )
( BartGo 2024 )

( TODO: CAN WE MANAGE OTHER TYPES - FLOATS, STRINGS? )
( TODO: CAN WE MAKE THESE "CLASSES" NON-STATIC? )
( TODO: INHERITING SHOULD BE POSSIBLE, CHECK )
( TODO: INSTEAD OF ' XYZ SCAL VOC FOR THE LAST CLASS )

: CLASS <BUILDS HERE , DOES> ; : OF 2 * 4 + + ; 
: CID 2+ @ ; : U? @ U. ;

CLASS SHOP
  9999 , ( 0 : # apples )
  9999 , ( 1 : price )
  9999 , ( 2 : # oranges )
  9999 , ( 3 : price )
  9999 , ( 4 : value )
  : SHOP/INIT ( -- )
    10  ' SHOP 0 OF ! 
    200 ' SHOP 1 OF !	  
    5   ' SHOP 2 OF ! 
    500 ' SHOP 3 OF !	  
    0   ' SHOP 4 OF ! ;
  : SHOP/CALC ( -- )
    ' SHOP 0 OF @
    ' SHOP 1 OF @ *
    ' SHOP 2 OF @
    ' SHOP 3 OF @ * +
    ' SHOP 4 OF ! ;
  : SHOP/SHOW ( -- )
    CR
    ' SHOP 0 OF U? ." apples for "
    ' SHOP 1 OF U? ." cents each " CR
    ' SHOP 2 OF U? ." oranges for "
    ' SHOP 3 OF U? ." cents each " CR
    ' SHOP 4 OF U? ." total" CR ;
  : SHOP/CID ' SHOP CID ;

SHOP/SHOW
SHOP/INIT
SHOP/SHOW
SHOP/CALC
SHOP/SHOW


( ---- more experiments ----- )



: ATTRIBUTE ( -- )
  32 CURRENT @ @ C! ; IMMEDIATE
: METHOD ( -- )
  [COMPILE] ATTRIBUTE ; IMMEDIATE
: CLASS ( -- )
  VOCABULARY IMMEDIATE
  DEFINITIONS ; IMMEDIATE
: FORTH: ( -- )
  FORTH DEFINITIONS ; IMMEDIATE

FORTH:
  CLASS GAME: 
  : /NAME 30 ALLOT        ; ATTRIBUTE
  : /CODE 10 ALLOT        ; ATTRIBUTE
  : .JUMP CR              ; METHOD
  : .SEE  CR CR           ; METHOD
  : .MAKE 10 0 DO CR LOOP ; METHOD
FORTH:

GAME:
  CLASS FOOTBALL:
  : .SCARE CR ;
FORTH:

FOOTBALL: .SCARE
GAME: .SCARE

  
