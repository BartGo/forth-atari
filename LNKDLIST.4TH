( a_linked_list_implementation
( https://www.reddit.com/r/Forth/comments/1eeilqe/a_linked_list_implementation/
( by Aggravating_Date_315
( adapted for A8 APX Forth by BartGo

: [* here 0 , 0 , ;
: [@ 2+ @ ; : [! 2+ ! ;

: [V ( n node -- node ) swap over ! ;
: [+ swap over [! ;
: P[ ( n -- node ) [* [V ;

: succ? dup [@ ;
: last>                      successor? if succ@ recurse then ;
: push   ( n ls -- ls )      swap P[ >succ ;
: +[ ( n ls -- ls )      over P[ over last> [+ drop ;

: EACH[ ( xt ls -- ) -dup if 
2dup @ swap execute
succ@ [smudge] EACH[ [smudge] else drop then ;

: ['] [COMPILE] ' ;
: .[] ['] . SWAP EACH[ ;
: ], SWAP +[ ;


\ 132 P[ 11 ], 123 ], 321 ], 10 ], constant example-list