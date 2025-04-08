( ------------------------------------ )
( MON jumps from APX Fig-Forth to QMLM )
( & from QMEG - Q/Esc returns to Forth )
( ------------------------------------ )
( Uses CALL by David Held - FD V/3&V/5 )
( ------------------------------------ )
( Requires Mullarky's Asm - or similar )
( ------------------------------------ )

' ASSEMBLER DROP ( 39 LOAD )

FORTH DEFINITIONS ASSEMBLER HEX
CODE (CALL)
    XSAVE STX,    0 JSR,
    XSAVE LDX, NEXT JMP,
FORTH
: CALL
  [ ' (CALL) 3 + ]
  LITERAL ! (CALL) ;

: MEMUP
  LATEST 0C +ORIGIN ! ( NTOP )
  HERE   1C +ORIGIN ! ( FENCE )
  HERE   1E +ORIGIN ! ; ( DP )

: MLM MEMUP E480 CALL ;
: QMG MEMUP E471 CALL ;
: MON MLM ; 
  
DECIMAL
