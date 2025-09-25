( LINIJKA, Marek Omirski, Bajtek 1991, as on:  )
( https://gitlab.com/amarok8bit/atari-listings )
( /-/blob/master/Moje_Atari/6/LINIJKA.LST      )
( *Ported to Atari APX Forth * )
( *and its Mullarky Assembler* )
( * BartGo, 2025, MIT license* )
( 1. BOOT APX FORTH IN ALTIRA  )
( 2. "40 LOAD", PASTE THE BELOW) 
( 3. USE HELP TO MOVE THE LINE )
( OR, use 0 10 THRU where THRU:)
( : THRU ( n m -- ) CR 1+ SWAP DO     )
( BASE @ DECIMAL I ." !Loading scr# " )
( U. CR BASE ! I LOAD ?TERMINAL IF    )
( LEAVE THEN LOOP CR ;         )
( OR, 1 LOAD 2 LOAD .. 5 LOAD  )
( ---------------------------- )

FORTH DEFINITIONS DECIMAL

560 @ 561 @ 256 *
         CONSTANT #DL
HEX
#DL 1D + CONSTANT #DZ 
021A     CONSTANT #CDTMV2
0228     CONSTANT #CDTMA2
02DC     CONSTANT #HELPFG
D40E     CONSTANT #NMIEN
2D       VARIABLE LN1 
2C       VARIABLE LN2 

ASSEMBLER DEFINITIONS HEX
A8 SB TAY, 

FORTH DEFINITIONS

CODE (NOP)
  NOP, RTS,

CODE LINER
  #HELPFG LDA, IFNE,
    LN1    INC, ( 1ST LINE )    
    20 #   LDA,
    LN1    LDY,
    #DL ,Y STA, 
    LN2    INC, ( 2ND LINE )
    02 #   LDA,
    LN2    LDY,
    #DL ,Y STA, 
    LN1 LDA, 3C # CMP,
    IFEQ,       ( LAST LINE? )
      26 # LDA, LN1 STA,
      25 # LDA, LN2 STA,
      02 # LDA, #DZ STA,
    THEN,
    0 # LDA, #HELPFG STA, 
  THEN,
  08 # LDA, #CDTMV2 STA, RTS,

CODE (VBISET)
  08 # LDA, #CDTMV2 STA,
  40 # LDA, #NMIEN  STA,
  NEXT JMP,

: VBI-CUSTOM ( -- )
  ' LINER #CDTMA2 ! (VBISET) ;

: VBI-NOP ( -- )
  ' (NOP) #CDTMA2 ! (VBISET) ;

VBI-CUSTOM
