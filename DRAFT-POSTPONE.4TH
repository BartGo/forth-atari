( from turbo forth )
( to be ported to fig / A8 )
( http://turboforth.net/resources/postpone.html )
( compare: https://github.com/ForthHub/discussion/discussions/105 )

: compLit ( n -- )
  compile lit , ;

: postpone ( "<spaces>name" -- )
  >in @ >r
  state @ 0= abort" POSTPONE: Illegal in interpretation state"
  bl word find ?dup if
    \ found
    1+ if
      \ immediate
      ,
    else
      \ non-immediate
      compile compile ,
    then
  else
    \ not found
    drop  r@ >in !
    bl word number if
      \ not a number
      r@ >in !
      cr ." POSTPONE: " bl word type ."  not found, " 
      ." in " latest @ 2+ dup @ 15 and swap 2+ swap type cr
      blk @ ?dup if ." in block #" . then abort
    else
      \ it's a number
      $A052 @ if swap compile lit , compile compLit then
      compile lit , compile compLit
    then
  then
  r> drop 
; immediate