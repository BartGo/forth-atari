;S
( to be used with APX Extended fig-forth for Atari 8-bit )
( the below are additional words for debugging )
( plus a great screen-based SEARCH )
( the script requires editor to be loaded, by e.g. 18 LOAD )
( and edits default screens - only adds, not overwrites )

( TODO: make this permanent:  ASCII 0 7894 C! )
(       to display modified Forth banner, do the same on SCR 45 )

( TODO: create words to move error screens from 14/15 to 87-89 )
(       see DECOMP MESSAGE to see that LIT 14 is hardcoded!    )
;S

( 18 LOAD ) DECIMAL EDITOR

16 CLEAR 16 SCR !
00 P ( ------ DISC INDEX ------ ) ;S
01 P 14-15: error messages
02 P 17-17: SEARCH* (req. EDITOR*) 
03 P 18-18: FULL LOAD dev tools (*)
04 P 19-20: GOESINTO* decompiler
05 P 21-26: DEBUG* words 
06 P 27-34: EDITOR* (fig)
07 P 35-38: empty
( ^^ SERT/TRADE HERE! )
08 P 39-49: ASSEMBLER (Mullarky) 
09 P 50-59: EDIT (Pantola) req. 75
10 P 60-70: EDIT (Dougherty)
11 P 71-74: FUJINET (-WIP-)
12 P 75-78: ASSEMBLER (Ragsdale)
13 P 79-83: OBJECT READER, IO, 850
14 P 84-88: DIS (Mattes)
15 P ( ------------------------- ) ;S

17 CLEAR 17 SCR !
00 P ( Search screens - req. EDITOR )
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
12 P     UNTIL LOOP ; 
13 P CR ." SEARCH is loaded." CR
14 P ." Usage: 21 44 SEARCH KEYWORD" 
15 P ;S ( FD Vol03 Nr1 /WFR ) 

18 SCR !
00 P ( -- FULL LOAD - DEV TOOLS -- )
01 P : :DEV ; 125 EMIT 
02 P   CR ." DEBUG..."     21 LOAD 
03 P   CR ." GOESINTO..."  19 LOAD 
04 P   CR ." EDITOR..." 
05 P   ( EDITOR ) CR SPACE 27 LOAD 
06 P   ( SEARCH )          17 LOAD 
07 P : ;DEV ; CR CR 
08 P ." 16 LIST for directory" CR
09 P ." 18 LIST for this list" CR
10 P ." 39 LOAD for PLM's ASM" CR
11 P ." 75 LOAD for WFR's ASM" CR
12 P ." 60 LOAD for MD's EDIT" CR
13 P ." 50 LOAD for RP's EDIT" CR 
14 P ." 71 LOAD for TC's FUJINET" CR 
15 P CR ;S

19 SCR !
 0 P ( 1/2 GoesInto - Decomp by RDA )
 1 P ( -- Forth Dimension Vol14 Nr2 )
 2 P   0 VARIABLE GIN 
 3 P : MYSELF LATEST PFA CFA , ; IMMEDIATE
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
15 P : DIN CR GIN @ SPACES ; -->

20 SCR !
 0 P ( 2/2 Use: "GOIN x" RET/SPC/Q ) 
 1 P : (GOESINTO) DUP CFA @ ' : CFA 
 2 P   @ = OVER ' ERROR = 0= AND
 3 P   IF BEGIN DUP @ DUP ' ;S CFA =
 4 P     OVER ' (;CODE) CFA = OR 0=
 5 P   WHILE 2+ DUP GIN+ NFA ID. KEY 
 6 P     DUP 81 = IF SP! QUIT ELSE 155 =
 7 P     IF MYSELF ELSE DROP THEN THEN
 8 P     GCHK REPEAT 2+ DIN NFA ID.
 9 P   THEN DROP ; ( 81=Q, 155=RETURN )
10 P : GOESINTO -FIND IF DROP 0 GIN !
11 P   (GOESINTO) ELSE ." NOT FOUND" CR THEN ;
12 E
13 P : GOIN GOESINTO ; 
14 E
15 P ;S 

21 SCR !
00 P ( Debug - H./B?/FREE/.CON/.CUR )
04 P : (.I) @ 4 - NFA ID. ;  ( FD V03NR1/KH )
05 P : .CON CONTEXT (.I) ; ( -- ) 
06 P : .CUR CURRENT (.I) ; ( -- ) 
13 P : LIST" 1 766 C! LIST 0 766 C! ; ( n -- )
14 P : TRIAD" 1 766 C! TRIAD 0 766 C! ; ( n -- )
15 P -->

22 SCR !
00 P ( Debug - DUMP CDUMP )

23 SCR !
00 P ( Debug - stack printers )
10 P : .S ( -- ) DEPTH -DUP IF
11 P     0 DO SP@ I 2 * + @ U. LOOP 
12 P   ELSE ." Empty " CR THEN ;

24 SCR !
00 P ( Debug - definition tracer )

25 SCR !
00 P ( Debug - definition tracer )

26 SCR !
00 P ( Debug - definition tracer )

35 CLEAR
36 CLEAR
37 CLEAR
38 CLEAR

50 SCR !
00 P ( EDYTOR-FORTH by RP, [c] TA'92 ) 
01 P : <=< OVER > >R < R> * ; ASSEMBLER

71 SCR !
 0 P ( FujiNet Host List by Thom )    (  Atari Online #5961 )
 1 P HEX VOCABULARY FUJINET           : %C CONSTANT ; IMMEDIATE
 2 P 0300 %C DDEVIC 0301 %C DUNIT   0302 %C DCOMND 0303 %C DSTATS
 3 P 0304 %C DBUF   0306 %C DTIMLO  0307 %C DRESVD 0308 %C DBYT
 4 P 030A %C DAUX1  030B %C DAUX2   030A %C DAUX   E459 %C SIOV
 5 P CODE (DO-SIOV) XSAVE STX,        SIOV JSR, XSAVE LDX, NEXT JMP, 
 6 P : HOST-ARRAY <BUILDS 256 ALLOT   DOES> SWAP 32 * + ; 
 7 P HOST-ARRAY FLHBUF 
 8 P : (FLH) ( -- ) 70 DDEVIC C!      01 DUNIT  C!  F4   DCOMND C!
 9 P  40 DSTATS C! 0 FLHBUF DBUF !   0F DTIMLO C!  0100 DBYT    !
10 P  0000 DAUX ! (DO-SIOV) ;        DECIMAL
11 P : HEMIT ( n -- ) DUP 0= IF       DROP ELSE EMIT THEN ; 
12 P 0 VARIABLE HOSTSLOT : .FLH"      ( n -- ) HOSTSLOT C! 32 0 DO
13 P    HOSTSLOT C@ FLHBUF I +       C@ HEMIT LOOP ;
14 P : FLH ( -- ) CR (FLH) 8 0 DO I   U. ." : " I .FLH" CR LOOP ; 
15 P ;S

72 CLEAR 
73 CLEAR
74 CLEAR

78 SCR ! ( for compatibility, END-CODE = C; )
08 P : C; CURRENT @ CONTEXT ! ?EXEC ?CSP SMUDGE ; IMMEDIATE 

58 79 COPY ( DOS object reader )
59 80 COPY

84 CLEAR
85 CLEAR
86 CLEAR 
87 CLEAR 
88 CLEAR 

FLUSH
