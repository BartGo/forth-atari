( to be used with APX Extended fig-forth for Atari 8-bit )
( the below are additional words for debugging )
( plus a great screen-based SEARCH )
( the script requires editor to be loaded, by e.g. 18 LOAD )
( and edits default screens - only adds, not overwrites )

DECIMAL EDITOR

21 SCR !
00 P ( DEBUG - H./B?/FREE/.CON/.CUR )
04 P : (.I) @ 4 - NFA ID. ;  ( FD V03NR1/KH )
05 P : .CON CONTEXT (.I) ; ( -- ) 
06 P : .CUR CURRENT (.I) ; ( -- ) 

22 SCR !
00 P ( DEBUG - DUMP CDUMP )

23 SCR !
00 P ( DEBUG - STACK PRINTERS )

10 P : .S ( -- ) DEPTH -DUP IF
11 P     0 DO SP@ I 2 * + @ U. LOOP 
12 P   ELSE ." Empty " CR THEN ;

24 SCR !
00 P ( DEBUG - DEFINITION TRACER )
25 SCR !
00 P ( DEBUG - DEFINITION TRACER )
26 SCR !
00 P ( DEBUG - DEFINITION TRACER )

35 CLEAR
00 P ( SEARCH RANGE OF SCREENS  )
01 P DECIMAL 00 VARIABLE SRCHCNT
02 P : BUMP ( ln nr and paging )
03 P   1 SRCHCNT +! SRCHCNT @ 56 
04 P     > IF 0 SRCHCNT ! CR 
05 P   THEN ;
06 P : SEARCH ( FROM TO -- STRING )
07 P   CR 01 TEXT 0 SRCHCNT !
08 P   1+ SWAP DO FORTH I SCR !
09 P     EDITOR TOP BEGIN
10 P       1LINE IF 0 M SCR ? BUMP 
11 P       THEN 1023 R# @ < 
12 P     UNTIL 
13 P   LOOP ; CR ." SEARCH is loaded."  
14 P   CR ." Usage: 21 44 SEARCH KEYWORD" 
15 P CR CR ;S ( FD Vol03 Nr1 /WFR ) 

18 SCR !
07 P ( LOAD EDITOR & SEARCH )
08 P    27 LOAD 35 LOAD
  
FLUSH
