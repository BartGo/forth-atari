( ***LINIJKA, Marek Omirski ***)
( https://gitlab.com/amarok8bit/atari-listings)
( /-/blob/master/Moje_Atari/6/LINIJKA.LST )
( port to Atari 8-bit APX Forth)
( and its Mullarky Assembler   )
( by BartGo, 2025, MIT license )
( 1. BOOT APX FORTH IN ALTIRRA )
( 2. LOAD WR's ASM FROM SCR#40 ) 
( 3. PASTE BELOW OR COMPILE    )
(    FROM ATR FILE: "n m THRU" )
 : THRU ( n m -- ) CR 1+ SWAP DO
 BASE @ DECIMAL I ." !Loading scr# "
 U. CR BASE ! I LOAD ?TERMINAL IF
 LEAVE THEN LOOP CR ; 
( ---------------------------- )

FORTH DEFINITIONS HEX

021A     CONSTANT _CDTMV2
0228     CONSTANT _CDTMA2
02DC     CONSTANT _HELPFG
D40E     CONSTANT _NMIEN
08       CONSTANT _CNT  
40       CONSTANT _6B
02       CONSTANT _TT
00       CONSTANT _TN
BC26     CONSTANT _DL ( gr.0! )
 0       CONSTANT _L0
15       CONSTANT _LZ
_L0      VARIABLE *LN


ASSEMBLER DEFINITIONS HEX
  A8 SB TAY, 

FORTH DEFINITIONS HEX

CODE (NOP)
  NOP,
  RTS,

CODE LINER
    
  _HELPFG LDA, IFNE,
  
	_HELPFG LDA, _6B # AND,
	IFEQ, ( [ no shift / down )
	  *LN LDA, _LZ # CMP,
	  IFEQ, ( [ lower limit )
		_TT # LDA,
		_LZ # LDY, _DL ,Y STA,		
        _L0 # LDA, *LN STA,
      THEN, ( ] lower limit )
      _TT # LDA, 
	  *LN LDY, _DL ,Y STA, 
	  *LN INC,
      _TN # LDA,	  
	  *LN LDY, _DL ,Y STA, 
	THEN, ( ] no shift )
	
	_HELPFG LDA, _6B # AND,
	IFNE, ( [ with shift / up  )
      *LN LDA, _L0 # CMP,
	  IFEQ,
	    _TT # LDA, 
		_L0 # LDY, _DL ,Y STA,		
		_LZ # LDA, *LN STA,
      THEN, ( ] upper limit )
	  _TT # LDA, 
	  *LN LDY, _DL ,Y STA, 
	  *LN DEC, 
	  _TN # LDA,
	  *LN LDY, _DL ,Y STA, 
	THEN, ( ] with shift )

    0 # LDA, _HELPFG STA, 

  THEN, ( ] _HELPFG check )

  08 # LDA, _CDTMV2 STA,
  
  
  RTS,

CODE (VBISET)
  _CNT # LDA, _CDTMV2 STA,
  ( enable vbi )
  _6B # LDA, _NMIEN  STA, 
  NEXT JMP,

: VBI-CUSTOM ( -- )
  ' LINER _CDTMA2 ! (VBISET) ;

: VBI-NOP ( -- )
  ' (NOP) _CDTMA2 ! (VBISET) ;

' LINER U. CR VBI-CUSTOM
