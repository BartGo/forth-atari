( https://www.reddit.com/r/Forth/comments/myy8qr/coroutines_in_forth/ )

: YIELD R> R> SWAP >R >R ; ( -- )

: PRODUCER ( -- )
  BEGIN
    100 + DUP
	  ." In P: (+100,P->C) "
	  YIELD
  AGAIN ;

: CONSUMER ( -- )
  CR
  0
  PRODUCER
  BEGIN   
    CR ." In C: " DUP . CR   
  1000 < WHILE
    ." (C->P) "
	  YIELD
  REPEAT   
  DROP
  CR ." DONE! "
  R> DROP ;  

: RUN CONSUMER ; ( -- )
