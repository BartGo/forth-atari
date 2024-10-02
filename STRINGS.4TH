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
