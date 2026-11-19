(   ------------------------------------------   )
(    Checksum for hand-entered source screens    )
(   ---- by Klaxon Suralis and Leo Brodie ----   )
(   Forth Dimensions Vol 4 No 3, public domain   )
(   ------------------------------------------   )
( Adapted to APX Forth by porting from Forth-79, )
( done by BartGo; fix for different screen sizes )
( by Gemini; )
(   ------------------------------------------   )
( Faster but incompatible ACCUMULATE: Vol 5 No 1 )
( : PRBS XOR DUP O< IF 5260 XOR DUP + LSHIFT 1 + )
(   ELSE DUP + THEN ; -- untested; LSHIFT needed )
(   ------------------------------------------   )

FORTH DEFINITIONS DECIMAL

: VERIFY ( scr# -- crcvalue )
  BLK @ >R  IN @ >R  B/SCR * BLK ! 0 B/SCR 0 DO
    0 IN ! 
    BEGIN
      BL WORD HERE DUP C@ 2 < OVER 1+ C@
      33 < AND 0= 
    WHILE
      BL OVER COUNT + C! COUNT
      ( DISPOSE ) ( crcvalue\adr\len --- newcrcvalue )
      OVER DUP C@ 40 = SWAP 1+ C@ BL = AND OVER 1 = AND 
        IF ( comment; skip it )
          2DROP 41 WORD HERE DROP
        ELSE ( not a comment )
          1+ OVER + SWAP DO
            I C@
            ( ACCUMULATE ) ( oldcrc\char -- newcrc )
            256 * XOR 8 0 DO
              DUP 0< IF 16386 XOR DUP + 1+ ELSE DUP + THEN
            LOOP
            ( ENDS ACCUMULATE )
          LOOP
        THEN 
      ( ENDS DISPOSE )
    REPEAT
    DROP
    1 BLK +!
  LOOP  R> IN !  R> BLK ! ;

;S

80 SCR ! 80 CLEAR
0 P ( Test screen)
1 P      For program exchange, the medium of hard copy is cheap,
2 P convenient, and machine-independent. Its primary disadvantages
3 P are the time required for hand-typing the source code and the
4 P possibility of human error in the process. Even if the screens
5 P LOAD without error messages, some errors may pass undetected
6 P until run-time, when the system crashes mysteriously. 
FLUSH

80 VERIFY U. ( expected CRC: 5038 dec )


