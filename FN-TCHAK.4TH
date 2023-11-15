( FujiNet host list in APX 4th )
( - by Thom )
( http://www.atari.org.pl/forum/viewtopic.php?id=17467 ) 

HEX VOCABULARY FUJINET
FUJINET DEFINITIONS

: % CONSTANT ; IMMEDIATE

( #FN SIO CONSTANTS 1 )
0300 % DDEVIC 0301 % DUNIT
0302 % DCOMND 0303 % DSTATS
0304 % DBUF   0306 % DTIMLO
0307 % DRESVD 0308 % DBYT
030A % DAUX1  030B % DAUX2
030A % DAUX   E459 % SIOV

( SIOV )
CODE (DO-SIOV)
  XSAVE STX, SIOV JSR,
  XSAVE LDX, NEXT JMP,

( FLH - Data Structures )
: HOST-ARRAY
  <BUILDS 256 ALLOT DOES>
  SWAP 32 * + ;

HOST-ARRAY FLHBUF

( FLH - Get Host List )
: (FLH) ( -- )
  70 DDEVIC C! 01 DUNIT  C!
  F4 DCOMND C! 40 DSTATS C!
  0  FLHBUF DBUF !
  0F DTIMLO C! 0100 DBYT !
  0000 DAUX ! (DO-SIOV) ;


( FLH - HEMIT word, no null )
: HEMIT ( n -- )
  DUP 8 0= IF DROP ELSE
  EMIT THEN ;
  
( FLH - Display Host slot n )
0 VARIABLE HOSTSLOT
: .FLH" ( n -- )
  HOSTSLOT C! 32 0 DO
    HOSTSLOT C@ FLHBUF I +
    C@ HEMIT LOOP ;

( FLH - Display all Host Slots )
: FLH ( -- )
  CR (FLH) 8 0 DO I U. ." : "
    I .FLH" CR LOOP ;

: MYHOSTLIST ( -- )
  ." This is my host list: "
  CR FLH ;
  
MYHOSTLIST
  
DECIMAL
