( state machine in 4th

0 variable state

( needed collections and sets
( contains and similar ops

( needed matrix of valid transitions

  start in-progress completed closed
  1		2 			3		  4
  -----------------------------
1 0     1			0		  0
2 1		0			1		  0
3 1     1           1         1 
..

( binary matrix not enough, needed matrix
( of rules, so matrix of pointers to expressions
( which result in tf/ff 

: role <builds S, , > .. ; 
( name roleID -- )

: user <builds S, , does> .. ;

: isadmin ( user -- f )

: ruleIsTrue  3drop 1 ; ( user object status -- f )
: ruleIsFalse 3drop 0 ;
: ruleIsAdmin rot 2drop isadmin if 1 else 0 then ;

( rules can't be static, need to parse / eval

( data structures are forth weaknesses

;S

( TASK #1: implement EVAL
( this could be done on a screen, even simulated... possible syntax:
x y M MEVAL(" ( x y -- f ) 1 > IF 1 ELSE 0 THEN ") 


