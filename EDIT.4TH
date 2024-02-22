;S

(  ** EDIT BY M. DOUGHERTY, MICRO 57/FEB/83 **  )
(  * AN EDITOR FOR ATARI 8-BIT APX FIG-FORTH *  )
( Cursor blink procedure: "Blinking Characters" )
(   Ron Miller's FORTH version of a routine     )
(   published in COMPUTE, December, 1981        )
(   https://archive.org/details/waug-newsletter-april-1983/page/4/mode/1up?q=forth )

( Warning: Screens 60-70 will be destroyed by the below script! )
( These screens are floating point words and the second editor. )

( To prepare the code: )
( - run clean APX fig-Forth in Altirra )
( - load fig-forth editor, debugger, assembler - by: 18 LOAD )
( - press CAPS to enable lowercase and paste the below )
( - FLUSH )
( - WHERE should show screen 0 if there were no errors )
( - check by 60 90 INDEX )
( To compile the code: )
( - boot the floppy prepared above )
( - 39 LOAD for the assembler, needed for cursor blinking )
( - or 18 LOAD for debugger, assembler, fig editor )
( - then 60 LOAD to compile EDIT, only warning about DEPTH is expected )
( - optionally, SAVE - if you know what it does )
( - to EDIT, type edit, optionally putting before the screen number on stack )
( - help is on screen 70 )

;S

( *** CODE STARTS HERE *** ) 

EDITOR

60 CLEAR
  0 P ( EDIT BY M. DOUGHERTY, MICRO 57/FEB/83 )
  1 P : TASK ; 752 CONSTANT CRSINH 70 CONSTANT #HLP 
  2 P 0  VARIABLE CLINE     0 VARIABLE CCHAR
  3 P 3  VARIABLE LINEOFF   3 VARIABLE CHAROFF
  4 P 18 CONSTANT TOP-BOT   2 CONSTANT REDGE
  5 P 22 CONSTANT LEDGE     0 VARIABLE SIDE 
  6 P 17 VARIABLE EXTRAOFF  0 VARIABLE STOP
  7 P 0  VARIABLE SAV-BUF  64 ALLOT 
  8 P : EREAD 16 0 DO I SCR @ (LINE) DROP
  9 P   UPDATE DROP LOOP 0 CLINE !
 10 P   0 CCHAR ! 0 SIDE ! ; 
 11 P : CLS 125 EMIT ; : ECLEAR CLS 1 CRSINH C! ; 
 12 P : POINT-CURSOR 85 ! 84 C! ;
 13 P : CURSOR@ CLINE @ LINEOFF @ +
 14 P  CCHAR @ SIDE @ IF 32 - ENDIF CHAROFF @ + ;
 15 P : CURSOR CURSOR@ POINT-CURSOR ; -->
61 CLEAR
  0 P ( EDIT ) 
  1 P : SCREEN-CURSOR CURSOR@ SWAP 40 * + 106 C@ 256 *
  2 P  960 - + DUP C@ 128 XOR SWAP C! ;
  3 P : HLINE 34 0 DO TOP-BOT EMIT LOOP ;
  4 P : LADDR CLINE @ SCR @ (LINE) DROP
  5 P  SIDE @ IF 32 + ENDIF ;
  6 P : EADDR CLINE @ SCR @ (LINE) DROP
  7 P  SIDE @ 0= IF 32 + ENDIF ;
  8 P : ELINE LEDGE EMIT LADDR 32 TYPE REDGE EMIT ;
  9 P : XLINE LEDGE EMIT EADDR 32 TYPE REDGE EMIT ;
 10 P : WRITE-LINE CLINE @ LINEOFF @ + CHAROFF @ 1 -
 11 P  POINT-CURSOR ELINE ;
 12 P : WRITE-EXTRA EXTRAOFF @ LINEOFF @ + CHAROFF @ 1 -
 13 P  POINT-CURSOR XLINE ;
 14 P : TOP LINEOFF @ 1 - CHAROFF @ 1 -
 15 P  POINT-CURSOR HLINE ;  -->
62 CLEAR 
  0 P ( EDIT - DISPLAY, CASE )
  1 P : BOT LINEOFF @ 16 + CHAROFF @ 1 -
  2 P  POINT-CURSOR HLINE ; 
  3 P : ETITLE 0 CHAROFF @ POINT-CURSOR
  4 P  ." Screen: " SCR ? ( 1 CHAROFF @ POINT-CURSOR )
  5 P  ." Side: " SIDE ? ." Free: " 741 @ HERE - U. ;
  6 P : DISPLAY ECLEAR ETITLE TOP CLINE @ 16 0 DO
  7 P  I CLINE ! WRITE-LINE LOOP CLINE !
  8 P  SIDE @ IF 32 ELSE 0 ENDIF CCHAR ! BOT
  9 P  WRITE-EXTRA CURSOR SCREEN-CURSOR ;
 10 P : CASES( ?COMP CSP @ !CSP 4 ; IMMEDIATE
 11 P : :: 4 ?PAIRS COMPILE OVER COMPILE =
 12 P  COMPILE 0BRANCH HERE 0 , COMPILE DROP 5 ; IMMEDIATE
 13 P : ;; 5 ?PAIRS COMPILE BRANCH HERE 0 ,
 14 P  SWAP 2 [COMPILE] ENDIF 4 ; IMMEDIATE
 15 P : ANYK CR ." (Return)" KEY DROP ; -->
63 CLEAR
  0 P ( EDIT - CASE, MOVEMENT )
  1 P : )CASES 4 ?PAIRS COMPILE DROP
  2 P   BEGIN SP@ CSP @ = 0= WHILE
  3 P   2 [COMPILE] ENDIF REPEAT
  4 P   CSP ! ; IMMEDIATE
  5 P : MOVE-RIGHT CCHAR @ 1 + SIDE @ IF
  6 P   DUP 64 = IF DROP 32 ENDIF ELSE
  7 P   DUP 32 = IF DROP 0  ENDIF ENDIF
  8 P   CCHAR ! ;
  9 P : RIGHT MOVE-RIGHT SCREEN-CURSOR ;
 10 P : RIGHT-CURSOR SCREEN-CURSOR RIGHT ;
 11 P : MOVE-LEFT CCHAR @ 1 - SIDE @ IF
 12 P  DUP 31 = IF DROP 63 ENDIF ELSE
 13 P  DUP -1 = IF DROP 31 ENDIF ENDIF
 14 P  CCHAR ! ; 
 15 P : LEFT MOVE-LEFT SCREEN-CURSOR ; -->
64 CLEAR 
  0 P ( EDIT - MOVEMENT, KEYJOY )
  1 P : LEFT-CURSOR SCREEN-CURSOR LEFT ;
  2 P : MOVE-UP CLINE @ 1 - 15 AND
  3 P   CLINE ! WRITE-EXTRA ;
  4 P : EUP MOVE-UP SCREEN-CURSOR ;
  5 P : UP-CURSOR SCREEN-CURSOR EUP ;
  6 P : MOVE-DOWN CLINE @ 1 + 15 AND
  7 P   CLINE ! WRITE-EXTRA ;
  8 P : DOWN MOVE-DOWN SCREEN-CURSOR ;
  9 P : DOWN-CURSOR SCREEN-CURSOR DOWN ;
 10 P : RETURN SCREEN-CURSOR SIDE @ IF
 11 P   32 ELSE 0 ENDIF CCHAR ! DOWN ;
 12 P : EABORT EMPTY-BUFFERS 1 STOP ! ;
 13 P : KEYJOY 632 C@ DUP 15 = IF KEY SWAP ENDIF DUP 
 14 P 11 = IF 30 ENDIF DUP 7 = IF 31 ENDIF DUP 14
 15 P = IF 28 ENDIF DUP 13 = IF 29 ENDIF DROP ; -->
65 CLEAR
  0 P ( EDIT - REFORTH, SCREEN NAVG, HELP )
  1 P : SH CLS 0 CRSINH C! IN @ >R BLK @ >R 0 IN ! 
  2 P   0 BLK ! CR QUERY INTERPRET R> BLK ! R> IN ! ANYK ; 
  3 P : ENEXT FLUSH SCR @ 1 + SCR ! EREAD DISPLAY ;
  4 P : ELAST FLUSH SCR @ 1 - SCR ! EREAD DISPLAY ;  
  5 P : ADDR CLINE @ SCR @ (LINE) DROP
  6 P   CCHAR @ + ; #HLP VARIABLE HLPM ( BEFORE HLP )
  7 P : ADDKEY DUP ADDR C! CURSOR EMIT RIGHT ;
  8 P : CHANGE-SIDE SIDE @ 1 XOR SIDE ! DISPLAY ;
  9 P : INSERT-CHAR ADDR SWAP CCHAR @ -
 10 P   SWAP OVER + SWAP -DUP IF 0 DO
 11 P   DUP 1 - C@ OVER C! 1 - LOOP
 12 P   ENDIF BL SWAP C! ; : INSERT SIDE @ IF
 13 P   63 ELSE 31 ENDIF INSERT-CHAR WRITE-LINE
 14 P   CURSOR SCREEN-CURSOR ; : HLP SCR @ 70 = IF
 15 P   HLPM @ SCR ! ELSE SCR @ HLPM ! #HLP SCR ! ENDIF ; -->
66 CLEAR
  0 P ( EDIT - DELETE, INSERT )
  1 P : DELETE-CHAR ADDR SWAP CCHAR @ -
  2 P   -DUP IF 0 DO DUP 1 + C@ OVER C!
  3 P   1 + LOOP ENDIF BL SWAP C! ;
  4 P : DELETE SIDE @ IF 63 ELSE 31 ENDIF
  5 P   DELETE-CHAR WRITE-LINE CURSOR SCREEN-CURSOR ;
  6 P : L-A SCR @ (LINE) DROP ;
  7 P : DELETE-L CLINE @ L-A SAV-BUF 64 CMOVE
  8 P   15 CLINE @ - IF 15 CLINE @ DO
  9 P   I 1+ L-A I L-A 64 CMOVE LOOP ENDIF
 10 P   15 L-A 64 BLANKS ;
 11 P : INSERT-L 15 CLINE @ - IF
 12 P   CLINE @ 15 DO I 1 - L-A I L-A 64 CMOVE
 13 P   -1 +LOOP ENDIF CLINE @ L-A 64 BLANKS ;
 14 P : INSERT-LINE INSERT-L DISPLAY ;
 15 P : DELETE-LINE DELETE-L DISPLAY ; -->
67 CLEAR 
  0 P ( EDIT - PUTLINE, TAB, BLINK )
  1 P : PUT-LINE INSERT-L SAV-BUF CLINE @
  2 P   L-A 64 CMOVE DISPLAY ;
  3 P : TAB 2 0 DO RIGHT-CURSOR LOOP ;
  4 P : DEL LEFT-CURSOR BL DUP ADDR C!
  5 P   CURSOR EMIT SCREEN-CURSOR ;
  6 P : CLEAR-SCR 16 0 DO I L-A 64 BLANKS
  7 P   LOOP DISPLAY ; 
  8 P ( ** CURSOR BLINK ** ) HEX
  9 P CODE (BLNK) 02F3 LDA,  2 # AND,
 10 P 2 #  EOR, 02F3 STA, 15 # LDA,
 11 P  021A STA, RTS,
 12 P CODE BGO 15 # LDA, 
 13 P 021A STA, NEXT JMP, 
 14 P : BINIT ' (BLNK) 228 ! ; DECIMAL
 15 P : BLNK BINIT BGO ; -->
68 CLEAR
  0 P ( EDIT - COMMANDS )
  1 P : REVB 712 @ 128 XOR 712 ! ; ( CLR4 )
  2 P : ESC REVB KEY CASES(        
  3 P     82 :: CHANGE-SIDE ;; ( R )
  4 P     78 :: ENEXT       ;; ( N )
  5 P     76 :: ELAST       ;; ( L )
  6 P     83 :: FLUSH       ;; ( S )
  7 P     81 :: EABORT      ;; ( Q )
  8 P     86 :: PUT-LINE    ;; ( V )
  9 P     90 :: EMPTY-BUFFERS DISPLAY ;; ( Z ) 
 10 P     66 :: SH DISPLAY  ;; ( B )             
 11 P     48 :: BOOT        ;; ( 0 ) 
 12 P     72 :: HLP DISPLAY ;; ( H )          
 13 P   BEEP )CASES REVB ;
 14 P : DEPTH SP@ 12 +ORIGIN @ SWAP - 2 / ;
 15 P : SETSCR DEPTH 0= IF #HLP ENDIF SCR ! ;  -->
69 CLEAR
  0 P ( EDIT - MAIN, END. ) : EDIT ( n -- ) 
  1 P SETSCR BLNK EREAD DISPLAY 0 STOP ! BEGIN 
  2 P   KEYJOY CASES( 27 :: ESC ;; 
  3 P   28 :: UP-CURSOR ;;
  4 P   29 :: DOWN-CURSOR ;;
  5 P   31 :: RIGHT-CURSOR ;;
  6 P   30 :: LEFT-CURSOR ;;
  7 P   155 :: RETURN ;;
  8 P   255 :: INSERT ;;
  9 P   254 :: DELETE ;;
 10 P   157 :: INSERT-LINE ;;
 11 P   156 :: DELETE-LINE ;;
 12 P   126 :: DEL ;; 127 :: TAB ;;
 13 P   125 :: CLEAR-SCR ;; 
 14 P DUP ADDKEY )CASES STOP @ UNTIL 
 15 P 125 EMIT 0 CRSINH ! ; ;S
70 CLEAR ( CONST #HLP = 70 )
  0 P ( EDIT - HELP ONLY, END. ) ;S
  2 P Arrows, Insert, BckSpc: standard
  3 P Return: next line, Tab: tab (2)
  4 P Clear: clear screen (Shf> Ctl>)
  5 P Esc-Z: undo scrn chn (empty-buf)
  6 P Shf-Insert: insert whole line*
  7 P Shf-Delete: delete whole line*
  8 P Ctl-Insert: insert space
  9 P Ctl-BckSpc: delete;  Esc-B: sh
 10 P Esc-R: rotate/sides; Esc-H: help
 11 P Esc-N: next screen, save (flush)
 12 P Esc-L: last screen, save (flush)
 13 P Esc-S: save (flush) ; Esc-0: cold!
 14 P Esc-Q: quit (empty-buf)
 15 P Esc-V: put last deleted line

71 CLEAR
72 CLEAR
73 CLEAR
74 CLEAR

FLUSH

( *** CODE ENDS HERE *** ) 

( TODO: change status line to include DR0/DR1, editor name, CAPS, INV )
( TODO: like this: EDIT|DR0/SCR20^|Chng|Caps|Inv|HELP )
( ." |DR" OFFSET @ 0= 0= . ." /SCR" SCR ? )
( WHERE )
( TODO: top, bottom, left, right; insert / overwrite? )
( TODO: search / grep (current, all screens / scope )
( TODO: c/x/v - czy da sie zrobić zaznaczanie i kopiowanie / usuwanie )
( TODO: use real HELP key? SELECT/OPTION - next/last? )
( TODO: buffer a la EDYTOR-FORTHA; full-screen/80col LIST? )
( TODO: kompilacja ekranu / nowy słownik TEMP, load, drop słownik ? )
( TODO: breakpoint () odpala re-forth podczas działania? )
( TODO: CAPS = 60, 188, 124, 252; INV = 39, 103, 167, 231 )
( TODO: is it possible to mark directly if file changed??  )
( TODO: jump to screen ; next / last: < > )
( TODO: esc shows help? )
( TODO: use joystick to navigate, with fire - change sides / screens )
( TODO: if Fujinet is present, display time? other features? Esc-F to toggle? )
( TODO: Fujinet: print to source control? script to detect screen number and update / replace? )
(       a la https://github.com/FujiNetWIFI/atariwifi/wiki/Using-the-N%3A-Device )
( READY
( XIO 44,#1,0,0,"N:TNFS://HOMESERVER/"
( 
( READY
( SAVE "N:PEWPEW.BAS"


