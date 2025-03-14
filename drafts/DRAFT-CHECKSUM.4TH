( BUG: LEAVES AFTER 1ST LINE )

: VER( ;
( 0 VARIABLE CNT )

( Checksum for hand-entered source screens)
( FD IV No3 Klaxon Suralis and Leo Brodie )
: ACCUMULATE ( oldcrc\char -- newcrc )
  DUP EMIT 256 * XOR 8 0 DO DUP 0< IF
      16386 XOR DUP + 1+
    ELSE DUP + THEN LOOP ;
: DISPOSE ( crcvalue\adr\len --- newcrcvalue )
  OVER DUP C@ 40 = SWAP 1+ C@ BL = AND OVER 1 = AND 
  IF ( comment; skip it ) 2DROP 41 WORD HERE DROP
  ELSE 1+ OVER + SWAP DO I C@ ACCUMULATE LOOP
  THEN ; ( careful: LOOPs on addresses )
: MORE ( -- adr f )
  BL WORD HERE DUP C@ 2 < OVER 1+ C@
  33 < AND 0= ;
: VERIFY ( scr# -- crcvalue )
  ( 0 CNT ! )
  BLK @ >R  IN @ >R
  B/SCR * ( FIXED! ) BLK !
  0 IN !
  0
    BEGIN
      MORE
    WHILE
       ( 1 CNT +! ) BL OVER
      COUNT + C! COUNT DISPOSE
    REPEAT
  DROP
  R> IN !  R> BLK ! ;
: VE VERIFY ;
: VER SCR @ VERIFY U. ; 
: )VER ;

;S

0 P ( Test screen)
1 P      For program exchange, the medium of hard copy is cheap,
2 P convenient, and machine-indepedent. Its primary disadvantages
3 P are the time required for hand-typing the source code and the
4 P possibility of human error in the process. Even if the screens
5 P LOAD without error messages, some errors may pass undetected
6 P until run-time, when the system crashes mysteriously. 


0 P    ( Various Modes Setup 08/02/82 )
1 P : REATTACH ( source-buffer-adr)
2 P    DUP @ IF  .MODE AT DUP 2+ CHARACTER ROT @ ROOM MIN CMOVE
3 P    REWRITE @OLDPOS AT ELSE DROP THEN COMMAND! ;
4 P : HOME 0 R# ! 0 XCUR ! 0 YCUR ! ;
5 P : --- 7 EMIT ( bell) .CHAR ;
6 P : ESCAPE ( leave outer loop) T ?ESC ! ;
7 P -->


