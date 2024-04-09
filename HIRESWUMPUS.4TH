( https://www.atarimagazines.com/hi-res/v1n2/strollingforth.php ) 
( Screen Listings For WUMPUS In Forth )
( FIXME )

: --> ; ( no screens )

( CONSTANTS AND VARIABLES   )

88 @ CONSTANT TOPLEFT
TOPLEFT 960 + CONSTANT BOTRIGHT

     15 VARIABLE DURATION
     25 VARIABLE STICK-DELAY

      0 VARIABLE STICK-COUNT
      0 VARIABLE HIGH-SCORE
    0 VARIABLE POINTS
    0 VARIABLE DX
    0 VARIABLE DY
    0 VARIABLE WUMPUS
 :  2DUP OVER OVER ;
 :  NOT 0= ;              -->


    ( BYTE-LOOKUP BOARD-FIGS  )

:    BYTE-LOOKUP
    <BUILDS DOES> + C@ ;

BYTE-LOOKUP BOARD-FIGS
 00 C,  70 C,   71 C,   84 C,
 00 C,  00 C,   00 C,   00 C,
 70 C,  70 C,   70 C,   70 C,
 71 C,  71 C,   71 C,   71 C,





              -->




( PICK-BF MAKE-BOARD )

 : PICK-BF
   53770 C@ 15 AND BOARD-FIGS ;

 : MAKE-BOARD
   BOTRIGHT TOPLEFT
   DO PICK-BF I C!
   LOOP ;






              -->




    ( STICK                )

    : STICK  ( N -- L/R U/D )
    632 + C@ >R R 8 AND 0=
    IF 1    ( RIGHT )
    ELSE R  4 AND 0=
        IF -1     ( LEFT )
        ELSE 0
        ENDIF
    ENDIF R 1 AND 0=
    IF -1         ( UP )
    ELSE R  2 AND 0=
        IF 1    ( DOWN )
        ELSE 0
        ENDIF
    ENDIF R> DROP ;      -->




    ( MOVE-WUMPUS DOT-CHECK  )

    : MOVE-WUMPUS ( -- )
    DY @ 40 * DX @ +
    WUMPUS @ + DUP
    BOTRIGHT U< NOT
    IF 960 -
    ENDIF DUP TOPLEFT U<
    IF 960 +
    ENDIF WUMPUS @ 128 TOGGLE
    DUP 128 TOGGLE WUMPUS ! ;

    :   DOT-CHECK  ( -- )
    WUMPUS @ C@ 212 = ( 84 + 128 )
    IF 128 WUMPUS @ C! 1 POINTS 1 SWAP +!
    ENDIF ;              -->






    ( MOVE-OK?   )

 :   MOVE-OK? ( --F )
 DX @ DY @ AND
 IF DX @ DY @ =
   WUMPUS @ C@ 199 = OVER AND
   WUMPUS @ C@ 198 = ROT NOT AND
   OR
 ELSE WUMPUS @ C@ 128 =
 ENDIF ;





                   -->





    ( GET-STICK      )

 :  GET-STICK ( -- )
    0 STICK 2DUP DY !   DX !
    2DUP OR ROT ROT AND NOT AND
    WUMPUS @ C@ 128 = AND
    IF STICK-COUNT @ 0= NOT
     IF -1 STICK-COUNT +!
      0 DX ! 0 DY !
     ELSE STICK-DELAY @
      STICK-COUNT !
     ENDIF
    ENDIF ;


      ->




( PICK-ONE INITIALIZE   )

   : PICK-ONE ( N -- N )
     53770 C@ 256 *
     53770 C@ +
     U* SWAP DROP ;

   : INITIALIZE ( -- )
     0 STICK-COUNT !
     0 POINTS !
     960 PICK-ONE
     TOPLEFT + DUP
     WUMPUS ! 128 TOGGLE ! ;

                          -->





 ( SHOW-SCORES FINISHED?  )

: SHOW-SCORES ( -- )
     HIGH-SCORE @ POINTS @
     MAX HIGH-SCORE !
     125 EMIT CR CR CR CR
     3 SPACES
     ." YOUR SCORE: "
     POINTS @ 4 . R
     CR CR 3 SPACES
     ." HIGH SCORE: "
     HIGH-SCORE @ 4    . R CR CR ;

  : FINISHED?  ( -- F )
     3 SPACES ." TRY AGAIN? (Y/N) "
     KEY 223 AND 89 = NOT ; -->




( DOT-MAZE     )

: DOT-MAZE ( -- )
  0 HIGH-SCORE !
  BEGIN MAKE-BOARD INITIALIZE
  DURATION @ 0
     DO 1000 0
       DO DOT-CHECK
         GET-STICK MOVE-OK?
         IF MOVE-WUMPUS ENDIF
         764 C@ 255 = NOT
         IF LEAVE ENDIF
       LOOP
     LOOP SHOW-SCORES
     FINISHED?
  UNTIL 125 EMIT ;
