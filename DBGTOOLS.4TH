;S
( to be used with APX Extended fig-forth for Atari 8-bit )
( the below are additional words for debugging )
( plus a great screen-based SEARCH )
( the script requires editor to be loaded, by e.g. 18 LOAD )
( and edits default screens - only adds, not overwrites )

( TODO: make this permanent:  ASCII 0 7894 C! )
(       to display modified Forth banner      )

( TODO: create words to move error screens from 14/15 to 87-89 )
(       see DECOMP MESSAGE to see that LIT 14 is hardcoded!    )
;S

DECIMAL EDITOR

17 CLEAR ( casette load )

19 SCR !
 0 P ( GOESINTO 1/2 )
 1 P ( Decompiler by R. D. Ackerman )
 2 P ( -- Forth Dimension Vol14 Nr2 )
 3 P 0 VARIABLE GIN 
 4 P : GIN+ CR GIN @ 2+ DUP GIN ! SPACES ;
 5 P : GCHK DUP @ 2+ ' COMPILE =
 6 P   IF  2+ DUP @ 2+ NFA ID. 2+
 7 P   ELSE DUP @ 2+ DUP ' LIT =
 8 P   OVER ' BRANCH  = OR OVER ' 0BRANCH = OR
 9 P   OVER ' (LOOP)  = OR SWAP ' (+LOOP) = OR
10 P   IF 2+ DUP @ SPACE . 2+ ELSE DUP @ 2+ ' CLIT =
11 P   IF 2+ DUP C@ SPACE . 1+ ELSE DUP @ 2+ 
12 P   ' (.") = IF 2+ DUP COUNT TYPE 
13 P   DUP C@ 1+ + ELSE 2+ THEN THEN THEN THEN 
14 P   -2 GIN +! ; 
15 P -->

20 SCR !
 0 P ( GOESINTO 2/2 ) 
 1 P : MYSELF LATEST PFA CFA , ; IMMEDIATE
 2 P : DIN CR GIN @ SPACES ;
 3 P : (GOESINTO) DUP CFA @ ' : CFA 
 4 P   @ = OVER ' ERROR = 0= AND
 5 P   IF BEGIN DUP @ DUP ' ;S CFA =
 6 P     OVER ' (;CODE) CFA = OR 0=
 7 P   WHILE 2+ DUP GIN+ NFA ID. KEY 
 8 P     DUP 81 = IF SP! QUIT ELSE 155 =
 9 P     IF MYSELF ELSE DROP THEN THEN
10 P     GCHK REPEAT 2+ DIN NFA ID.
11 P   THEN DROP ; ( 81=Q, 155=RETURN )
12 P : GOESINTO -FIND IF DROP 0 GIN !
13 P   (GOESINTO) ELSE ." NOT FOUND" CR THEN ;
14 P : GOIN GOESINTO ; 
15 P ;S ( "GOIN word", RET/SPC/Q ) 

21 SCR !
00 P ( DEBUG - H./B?/FREE/.CON/.CUR )
04 P : (.I) @ 4 - NFA ID. ;  ( FD V03NR1/KH )
05 P : .CON CONTEXT (.I) ; ( -- ) 
06 P : .CUR CURRENT (.I) ; ( -- ) 
13 P : LIST" 1 766 C! LIST 0 766 C! ; ( n -- )
14 P : TRIAD" 1 766 C! TRIAD 0 766 C! ; ( n -- )
15 P -->

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
00 P ( ** FULL LOAD - DEV TOOLS ** )
01 E
02 P : :DEV ;
04 P ( LOAD DEBUG & GOIN )
05 P    21 LOAD 19 LOAD
07 P ( LOAD EDITOR & SEARCH )
08 P    27 LOAD 35 LOAD
13 P ( LOAD EDIT )
14 P    60 LOAD
15 P : ;DEV ; ;S
  
FLUSH
