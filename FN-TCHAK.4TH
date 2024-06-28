( FujiNet host list in APX 4th )
( - by Thom )
( http://www.atari.org.pl/forum/viewtopic.php?id=17467 ) 
( https://github.com/FujiNetWIFI/fujinet-firmware/wiki/Using-FujiNet-from-fig-FORTH )

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

: FRESET            ( -- )
      70 DDEVIC C!
      01 DUNIT  C!
      FF DCOMND C!
      00 DSTATS C!
    0000 DBUF   !
      0F DTIMLO C!
    0000 DBYT   !
    0000 DAUX   !
      (DO-SIOV) ;

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





( ["] is the compiler word that skips over words inside the " )
( while maintaining a length count for the ->STRING command.  )
: ["]
  R COUNT DUP 1+ R> + >R ;

( " provides the in-line string word, that works for both )
( interpreting and compiling.                             )
: "  ( start embedded string )
  22 STATE @ IF
    COMPILE ["] WORD HERE C@ 1+ ALLOT
  ELSE
    WORD HERE DUP C@ 1+ PAD SWAP CMOVE PAD COUNT
  THEN ; IMMEDIATE

( <-STRING allows you to take an in-line string    )
( made with " and copy it to a destination buffer. )

: <-STRING ( src len dest -- )
  2DUP + >R
  SWAP CMOVE R> 0 SWAP C! ;


( 128 character buffer for devicespec )
0 VARIABLE DSPEC 254 ALLOT
" N:TNFS://RASPBERRYPI/FOO.TXT " DSPEC <-STRING
DSPEC  DBUF !



02EA CONSTANT DVSTAT

: NSTATUS            ( n -- )
      70 DDEVIC C!
   ( n ) DUNIT  C!
      53 DCOMND C!
      40 DSTATS C!
  DVSTAT DBUF   !
      0F DTIMLO C!
    0004 DBYT   !
    0000 DAUX   !
      (DO-SIOV) ;

: NERR            ( -- n )
  DVSTAT 3 + C@ ;




( https://github.com/FujiNetWIFI/fujinet-firmware/wiki/SIO-Command-$FE-Get-SSID )



DECIMAL



;S

71 SCR !
 0 P ( FujiNet Host List by Thom )    (  Atari Online #5961 )
 1 P HEX VOCABULARY FUJINET           : %C CONSTANT ; IMMEDIATE
 2 P 0300 %C DDEVIC 0301 %C DUNIT   0302 %C DCOMND 0303 %C DSTATS
 3 P 0304 %C DBUF   0306 %C DTIMLO  0307 %C DRESVD 0308 %C DBYT
 4 P 030A %C DAUX1  030B %C DAUX2   030A %C DAUX   E459 %C SIOV
 5 P CODE (DO-SIOV) XSAVE STX,        SIOV JSR, XSAVE LDX, NEXT JMP, 
 6 P : HOST-ARRAY <BUILDS 256 ALLOT   DOES> SWAP 32 * + ; 
 7 P HOST-ARRAY FLHBUF 
 8 P : (FLH) ( -- ) 70 DDEVIC C!      01 DUNIT  C!  F4   DCOMND C!
 9 P  40 DSTATS C! 0 FLHBUF DBUF !   0F DTIMLO C!  0100 DBYT    !
10 P  0000 DAUX ! (DO-SIOV) ;        DECIMAL
11 P : HEMIT ( n -- ) DUP 0= IF       DROP ELSE EMIT THEN ; 
12 P 0 VARIABLE HOSTSLOT : .FLH"      ( n -- ) HOSTSLOT C! 32 0 DO
13 P    HOSTSLOT C@ FLHBUF I +       C@ HEMIT LOOP ;
14 P : FLH ( -- ) CR (FLH) 8 0 DO I   U. ." : " I .FLH" CR LOOP ; 
15 P ;S




---------------

( OTHER WAY TO DO STRINGS )

( BFOX9900 https://www.reddit.com/r/Forth/comments/1diqg25/the_word_word_use_examples/ )
0 VARIABLE MYSTRING 80 ALLOT 
: PLACE ( src n dst -- ) OVER OVER  C! 1+ SWAP CMOVE ;
: GETAWORD  BL WORD  HERE COUNT MYSTRING PLACE ; 

GETAWORD LOLOLO123123
MYSTRING COUNT TYPE



