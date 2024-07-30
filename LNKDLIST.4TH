( a_linked_list_implementation
( https://www.reddit.com/r/Forth/comments/1eeilqe/a_linked_list_implementation/
( by Aggravating_Date_315
( adapted for A8 APX Forth by BartGo

: [, HERE 0 , 0 , SWAP OVER ! ;
: [+ DUP 2+ ! IF [+ RECURSE THEN ;
: [: SWAP [, [+ ;
: ], SWAP OVER [, OVER [+ SWAP
  OVER 2+ ! DROP ;

: [EACH -DUP IF 2DUP @ SWAP EXECUTE
  [: RECURSE ELSE DROP THEN ;

: '[ [COMPILE] ' ;
: .[ '[ . SWAP [EACH ;

\ 132 [, 11 ], 123 ], 321 ], 10 ], CONSTANT MYLIST[