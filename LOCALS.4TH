
: !L ( n1..nm m ) 0 DO , LOOP ; ( init locals )
  
: 'L ( n -- a ) ( offset to address )
  1 - 2 *       ( n )
  R> R> R       ( n R1 R2 r3 )
  ROT ROT       ( n r3 R1 R2 )
  >R >R + ;     ( a=r3+n ) 
  
: .L ( n )
  DUP 64 + EMIT ." =" 'L ? ;
 
: MYWORD ( c b a -- ) ( example )
  R> HERE DUP . >R >R ( store HERE below RS top )
  5 !L    HERE DUP .  ( reserve five locals )
  1 'L ? ( OK )
  2 'L ?
  3 'L ?
  4 'L ?
  5 'L ? 
  6 1 DO I 'L ? LOOP CR ( FAIL in loop )
  6 1 DO I .L   LOOP CR ( FAIL in loop )
  R> R> DP ! >R ;     ( restore DP )
  
55 44 33 22 11 MYWORD ( e d c b a MYWORD )

