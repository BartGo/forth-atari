( ----------------------------- )
(   DEFINING WORDS II: Sets,    )
(   A Techniques Tutorial by    )
(   Henry Laxen, FD V4N2 p.20   )
( ----------------------------- )
( !! FIXME - tests in progress, )
( MEMBERS don't work correctly! )
( ----------------------------- )
( checks: Atari 8-bit APX Forth )
( ----------------------------- )

( Uniquely identifies the name as an item number )
0 VARIABLE ITEM#   0 ITEM#  !

( Uniquely identifies the class as a class number )
0 VARIABLE CLASS#  0 CLASS# !

( Always zero, for finishing a linked search )
0 VARIABLE NULL#   0 NULL#  !

( Add a link to a linked list chain. Addr is the head. )
: LINK ( addr -- )
  HERE OVER @ , SWAP ! ;
  
( A defining word that creates defining words. )
( A unique clas number is assigned to a class. )
( The class name can be used to create items   )
( belonging to the class. An item number is    )
( assigned to each member. Members are linked. ) 
: CLASS
  <BUILDS 0 , CLASS# @ , 1 CLASS# +!
  DOES>
    <BUILDS LINK ITEM# @ , 1 ITEM# +!
	DOES> 2+ @ ;

( Takes an item number and a pointer to    )
( a class, and returns True if the item is )
( a member of the class. Else False.       )
: MEMBER? ( n pfa -- f )
  0 ROT ROT BEGIN @ DUP WHILE 2DUP 2+ @
  = IF 2DROP DROP 1 1 NULL# THEN REPEAT 2DROP ;

( Takes a pointer to a class and lists its members. )
: MEMBERS ( pfa -- )
  BEGIN @ DUP WHILE DUP NFA ID. REPEAT DROP ;
( FIXME )


CLASS COLOR
  COLOR RED
  COLOR WHITE
  COLOR BLUE
  COLOR YELLOW
  
CLASS TEXTURE
  TEXTURE SMOOTH
  
SMOOTH ' COLOR MEMBER? .
YELLOW ' COLOR MEMBER? .
SMOOTH ' TEXTURE MEMBER? .
RED SMOOTH = .

' COLOR MEMBERS ( FIXME )
