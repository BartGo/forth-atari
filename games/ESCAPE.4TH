( ESCAPE DEMO by John Mattes )
(  - original author unknown )

( Code from https://archive.org/details/ )
( atari_computer_enthusiasts_nsw_06 )
( /page/n15/mode/2up?q=escape )
( With errata and Team Forth / 1.4S hints: )
( - https://archive.org/details/ )
( atari_computer_enthusiasts_nsw_08 )
( /page/n10/mode/1up?q=forth )
( See also BASIC version:
( - https://archive.org/details )
( /atari_computer_enthusiasts_nsw_03 )
( /page/n15/mode/1up?q=ESCAPE )
( Tested on: Atari 800XL, APX Extended )
( fig-Forth / Altirra )

DECIMAL

( requires: 39 LOAD ) ( ASM )
( requires: 50 LOAD ) ( GR. )

( JEM-10DEC82 )

0 VARIABLE X1  0 VARIABLE Y1
0 VARIABLE X2  0 VARIABLE Y2
1 VARIABLE C
: BOX C @ X1 @ Y1 @ PLOT
      C @ X2 @ Y1 @ DRAW
      C @ X2 @ Y2 @ DRAW
      C @ X1 @ Y2 @ DRAW
      C @ X1 @ Y1 @ DRAW ;
: SETCR
  0 2 4 6 8 6 4 2 9 1 DO
    224 + 704 I + C! LOOP ;
: ROTATE
  DUP @ ROT ROT OVER SWAP DO
    I 1+ @ I C!
  LOOP C! ;
: RUN BEGIN
    712 705 ROTATE 600 1 DO LOOP
  2 0= UNTIL ;
: ESCAPE  ( -- )
  10 GR. SETCR
  39 0 DO 
    I          X1  ! ( X1 = I      )
    I I +      Y1  ! ( Y1 = 2*I    )
     79 X1 @ - X2  ! ( X2 = 79-X1  )
    190 Y1 @ - Y2  ! ( Y2 = 190-Y1 )
    BOX      1 Y1 +! ( Y1++        )
    1 MINUS    Y2 +! ( Y2--        )
    BOX      1 C  +! ( C++         )
    C @ 8 > IF       ( if c > 8 .. )
      1 C !          (  then c=:1  )
    ENDIF
  LOOP RUN ;
 
( ESCAPE )
