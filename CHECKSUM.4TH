: WORD WORD HERE ; : >IN IN ; : NOT 0= ;


( Checksum for hand-entered source screens)
( FD IV No3 Klaxon Suralis and Leo Brodie )
: ACCUMULATE ( oldcrc\char -- newcrc )
  256 * XOR 8 0 DO DUP 0< IF 16386 XOR DUP + 1+
  ELSE DUP + THEN LOOP ;
: DISPOSE ( crcvalue\adr\len --- newcrcvalue )
  OVER DUP C@ 40 = SWAP 1+ C@ BL = AND OVER 1 = AND 
  IF ( comment; skip it ) 2DROP 41 WORD HERE DROP
  ELSE 1+ OVER + SWAP DO I C@ ACCUMULATE LOOP
  THEN ; ( careful: LOOPs on addresses )
: MORE ( -- adr f )
  BL WORD HERE DUP C@ 2 < OVER 1+ C@ 33 < AND 0= ;
: VERIFY ( scr# -- crcvalue )
  BLK @ >R IN @ >R BLK ! 0 IN !
  0 BEGIN MORE WHILE BL OVER COUNT + C! COUNT DISPOSE
  REPEAT DROP R> IN ! R> BLK ! ;
: VER SCR @ VERIFY U. ;

( below checksum should be 5038 but is 14881 )

0 P ( Test screen)
1 P      For program exchange, the medium of hard copy is cheap,
2 P convenient, and machine-indepedent. Its primary disadvantages
3 P are the time required for hand-typing the source code and the
4 P possibility of human error in the process. Even if the screens
5 P LOAD without error messages, some errors may pass undetected
6 P until run-time, when the system crashes mysteriously. 
