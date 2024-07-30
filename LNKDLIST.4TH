( a_linked_list_implementation
( https://www.reddit.com/r/Forth/comments/1eeilqe/a_linked_list_implementation/
( by Aggravating_Date_315
( adapted for A8 APX Forth by BartGo

: [* here 0 , 0 , ;
: [@ 2+ @ ;
: [! 2+ ! ;
: (+[) swap over [! ;
: P[ [* SWAP OVER ! ;
: [> DUP [@ if succ@ RECURSE then ;
: [PUSH SWAP P[ >succ ;
: +[ over P[ over [> ([+) drop ;
: EACH[ ( xt ls -- ) -dup if 
  2dup @ swap execute
  succ@ RECURSE else drop then ;
: ['] [COMPILE] ' ;
: .[] ['] . SWAP EACH[ ;
: ], SWAP +[ ;

\ 132 P[ 11 ], 123 ], 321 ], 10 ], constant example-list