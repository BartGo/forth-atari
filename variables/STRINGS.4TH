( Simple string handling )
( tested on APX Forth for Atari 8-bit )

( as suggested by BFOX9900 )
( https://www.reddit.com/r/Forth/comments/1diqg25/the_word_word_use_examples/ )
0 VARIABLE MYSTRING 80 ALLOT 
: PLACE ( src n dst -- ) OVER OVER  C! 1+ SWAP CMOVE ;
: GETAWORD  BL WORD  HERE COUNT MYSTRING PLACE ; 
: MYSTRING:" GETAWORD ; IMMEDIATE
( test )
MYSTRING:" ASSEMBLY
MYSTRING COUNT TYPE

( beautified & tuned )
0 VARIABLE $ 80 ALLOT 
: $" ASCII " WORD HERE COUNT $ OVER
  OVER C! 1+ SWAP CMOVE ; IMMEDIATE
( test )
$" HELLO WORLD!" $ COUNT TYPE



( --------------------- EXPERIMENTS

0 VARIABLE S$ C/L ALLOT 

: C" ( usage: C" ABC" S$ COUNT TYPE )
  ASCII " WORD HERE COUNT S$ OVER
  OVER C! 1+ SWAP CMOVE ;
  IMMEDIATE

: PRC ( n -- ) COUNT TYPE ;

: SMOVE ( a1 a2 -- )
  OVER COUNT 1+ ( a1 a2 a1 # )
  SWAP DROP CMOVE ;

: SZ! ( a1 -- ) ( cnt->0 convert )
  DUP COUNT ( a1 a1' ct )
  ROT SWAP  ( a1' a1 ct )
  2DUP + >R ( a1' al ct R: al+ct )
  CMOVE     ( R: al+ct )
  0 R> C! ; ( -- )  
  
: Z# ( a -- a ct ) ( 0->cnt fn )
  0 ENCLOSE       ( a n1 n2 n3 )
  ROT DROP DROP ; ( a ct )
 
: PR0 ( n -- ) Z# TYPE ;


C" XYZ" S$ PRC S$ PAD SMOVE
C" 123" S$ PRC
PAD S$ SMOVE S$ PRC
C" ABCDEF"
( S$ PRC S$ C/L CDUMP
( S$ S0! S$ C/L CDUMP
S$ PAD SMOVE
S$ SZ! S$ PR0

: REDIRECT
  S$ C/L EXPECT S$ PR0
  ' S$ CFA DUP ' WORD 18 + !
               ' QUERY     ! QUIT ;

( ' PAD CFA ' WORD 18 + ! ( WAS: ' TIB CFA )
( ' PAD CFA ' QUERY     ! ( WAS: ' TIB CFA )

: Z" ( to do ) ;
C" HELLO, FORTH!"
CR CR S$ COUNT TYPE CR

( identical to Z#+PR0 but rather slower )
: ZYPE ( addr -- )
  BEGIN 
	DUP C@ DUP  ( ad adC@ adC@ )
	0= IF       
	  DROP DROP ( - ) ;S
	THEN        ( ad adC@ )
	EMIT 1+ ( ad+1 )
  AGAIN DROP ; 

S$ SZ!  ( convert counted to zero-ended )
S$ PR0  ( print zero-ended ) CR
S$ ZYPE ( same )
