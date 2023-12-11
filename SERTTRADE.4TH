( https://www.atarimagazines.com/compute/issue30/044_1_The_FORTH_Page.php )

( COMPUTE, The FORTH Page, Disk Management)
( Michael Riley, Philadelphia )
( COMPUTE! ISSUE 30 / NOVEMBER 1982 / PAGE 232 )
( The words SERT and TRADE allow you to move and mass-move screens around )
( on a disk without fear of accidentally erasing something of value.      )
( No matter how you use these commands, no screens are ever overwritten.  )
( They simply end up somewhere else. )

( SERT / N1 N2 N3 — / )
(Deletes the group of screens numbered N1 through N2 and reinserts them   )
( between the screens numbered N3 and N3 + 1. )

( TRADE / N1 N2 N3 — / )
( Swaps a group of screens numbered N1 through N2 with a group of screens )
( starting at N3. The two groups are assumed to be the same size.


27 LOAD CR ( STANDARD LN EDITOR )
DECIMAL EDITOR

85 SCR ! 

 0 P ( SERT&TRADE 1/2: COMPUTE 30NOV )
 1 P : PAD-SWAP ( N1 --- / SWAP SCR W/ PAD )
 2 P	 DUP BLOCK PAD 1024 + 1024 CMOVE
 3 P 	 PAD SWAP BLOCK 1024 CMOVE UPDATE
 4 P 	 PAD 1024 + PAD 1024 CMOVE ;
 5 P 0 VARIABLE B-DST 0 VARIABLE LIM 0 VARIABLE CNT
 6 P 0 VARIABLE S-DST 0 VARIABLE STRT
 7 P :  (SERT) ( N1 N2 N3 --- )
 8 P	 DUP LIM ! SWAP - S-DST ! STRT !
 9 P	 LIM @ STRT @ - B-DST ! 0 CNT ! STRT @
10 P	 BEGIN DUP PAD-SWAP
11 P	   BEGIN S-DST @ + DUP LIM @ > 0 =
12 P	   IF B-DST @ - THEN
13 P	   DUP PAD-SWAP 1 CNT +! DUP STRT @ = 	
14 P	 UNTIL CNT @ B-DST @ <
15 P	WHILE 1 STRT +! 1+ REPEAT DROP ; -->

86 SCR !

 0 P ( SERT&TRADE 2/2: 1982 M. RILEY )
 1 P : ROOM? ( / IF ERROR, PRINT ‘NO ROOM IN DICT’ )
 2 P	 ( PAD 2048 + FIRST > 2 ?ERROR ) ; ( FIXME )
 3 P ( ‘ FIRST > ’ IS INSTALATION DEPENDENT )
 4 P : RANGE? ( N1 --- N1 / LEGAL SCREEN NUMBER? )
 5 P	 1 OVER > OVER 88 ( MAX SCR ) > OR 8 ?ERROR ;
 6 P : FX ( N1 N2 --- N2 N1 [OR] N1 N2 )
 7 P	 OVER OVER > IF SWAP THEN ;
 8 P : SERT ( 1ST LAST DEST --- / REINSERT SCRS AT DEST )
 9 P	 ROOM? 1+ RANGE? SWAP 1+ RANGE? ROT RANGE?
10 P	 FX > R FX R > FX (SERT) ;
11 P : TRADE ( IST LAST DEST --- / TRADE WITH SCRS AT DEST )
12 P	 ROOM? ROT > R R SWAP - B-DST ! ( LAST )
13 P	 1+ R > ( LAST + 1 1ST)
14 P	 DO I RANGE? I B-DST @ - RANGE? ( I I + DST)
15 P OVER	PAD-SWAP PAD-SWAP PAD-SWAP	LOOP DROP ;

FLUSH

( 85 LOAD VLIST )


