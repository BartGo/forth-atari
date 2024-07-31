( a_linked_list_implementation
( https://www.reddit.com/r/Forth/comments/1eeilqe/a_linked_list_implementation/
( by Aggravating_Date_315
( adapted for A8 APX Forth by BartGo

: ['] [COMPILE] ' ;
: [SELF] LATEST PFA CFA , ; IMMEDIATE

: [, ( p = >node ) HERE 0 , 0 , SWAP OVER ! ; 
: [; ( last> ) DUP 2+ @ IF 2+ @ [SELF] THEN ; 
: ]+ ( push ) SWAP [, SWAP OVER 2+ ! ;
: ], ( p, = swap append ) SWAP OVER [, OVER [; SWAP OVER 2+ ! DROP ; 
: EACH ( each ) -DUP IF 2DUP @ SWAP EXECUTE 2+ @ [SELF] ELSE DROP THEN ;
: .[ ( .ls ) ['] . SWAP EACH ;

132 [, 11 ], 123 ], 321 ], 10 ], CONSTANT )MYLIST
  
 
