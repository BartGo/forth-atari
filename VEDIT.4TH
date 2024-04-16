( CORRUPTED / FIX ME )
  
( VIDEO EDITOR, COPYRIGHT RCS 1978 )
( by Major Robert A. Selzer, FD2N3 )
( adapted to Atari 800XL: BG160424 )
( tested on APX Extended Fig-Forth )

: TASK ;
BASE @ HEX
00 VARIABLE CUR
: YXCUR 85 ! 84 C! ;
: .CUR CUR @ 40 /MOD 2 + SWAP 4 + SWAP YXCUR ;
: !CUR 0 MAX 3FF MIN CUR ! ;
: +CUR CUR @ + !CUR ; : +.CUR +CUR .CUR ;
: +LIN CUR @ 40 / ( LINE# ) + 40 * !CUR ;
: HOM 00 CUR ! ;
: !BLK SCR @ 8 * CUR @ 80 /MOD ROT + BLOCK + C!
  UPDATE 1 +.CUR ;
: VEDIT ( n -- )
  7D EMIT ." VEDIT"
  LIST CR CR CR CR CR HOM .CUR
  BEGIN KEY ||
    DUP 11 IF 0 12 YXCUR QUIT ELSE ( CTRL-Q )
	  DUP 9B IF                 ELSE ( RETURN )
	         IF DUP EMIT !BLK   THEN ( OTHERS )
	THEN THEN DROP 
  AGAIN ; 
BASE !
;S
    	  
