( DRAFT / NOT WORKING )

FORTH DEFINITIONS DECIMAL

( redcode examples from "Moje Atari 6": )
( https://archive.org/details/moje-atari-6/page/n3/mode/2up )
          
40 25 * CONSTANT #ArenaSize
      8 CONSTANT #PlayNameLen
     32 CONSTANT #EmptyChar

0 VARIABLE arena #ArenaSize 2 - ALLOT 

( dummy commands )
: JMP DROP ; : MOV DROP DROP ;
: DAT DROP ; : ADD DROP DROP ; 

( Random number using POKEY )
: Rnd ( rng -- rnd )
  -11766 C@ -11766 C@ 256 * +
  SWAP MOD ABS ; 

( Start a program in an empty arena cell )
: SetCell ( -- n )
  BEGIN
    #ArenaSize Rnd DUP ( rnd rnd )
    arena + @ 0= IF
      DUP arena ! ;S   ( n )
    ELSE DROP DROP THEN
  AGAIN ;  

( Reserve empty characters for the name )
: EmptyChar DO #EmptyChar C, LOOP ; ( n n -- )
  
: Worm ( -- name )
  <BUILDS
    #PlayNameLen 0 EmptyChar ( name )
    SetCell ,                ( rnd loc )
  DOES>
  0 1 MOV ;

: Dwrf ( -- name )
  <BUILDS
    #PlayNameLen 0 EmptyChar ( name )
    SetCell ,                ( rnd loc )
  DOES>
  2    JMP
  0    DAT
  5 -1 ADD 
  0 -2 MOV
  2    JMP ;
  
: Register
  Worm worm1Player1
  Worm worm2Player1
  Worm worm1Player2 ;

: SetArena
  125 EMIT
  Register ;

