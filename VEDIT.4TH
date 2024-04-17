( FIXME )

( VIDEO EDITOR, COPYRIGHT RCS 1978 )
( by Major Robert A. Selzer, FD2N3 )
( adapted to Atari 800XL: BARTGO   )
( tests on APX Extended Fig-Forth  )

( NOTE: would work only for screens )
( with no wrapped lines )    

: VEDIT( ; BASE @ HEX

00 VARIABLE CUR
: YXCUR 85 ! 84 C! ;
: .CUR CUR @ 40 /MOD 2 + SWAP 4 +
  SWAP YXCUR ;
: !CUR 0 MAX 3FF MIN CUR ! ;
: +CUR CUR @ + !CUR ;
: +.CUR +CUR .CUR ;
: +LIN CUR @ 40 / + 40 * !CUR ;
: HOM 00 CUR ! ;
: !BLK SCR @ 8 * CUR @ 80 /MOD
  ROT + BLOCK + C! UPDATE 1 +.CUR ;
: VEDIT ( n -- )
  7D EMIT ." VEDIT"
  LIST CR CR CR CR CR HOM .CUR
  BEGIN
    KEY
	  11 OVER SWAP = IF ( CTRL-Q )
	    0 12 YXCUR QUIT ELSE 
	  9B OVER SWAP = IF ( RETURN )
   	    BEEP ELSE       
	  DUP EMIT !BLK     ( OTHERS )   
	  THEN THEN 
	DROP 
  AGAIN ;
: )VEDIT ;

BASE !

;S
    	  
