( pseudolabels in APX Forth, Mullarky's Assembler )

( 40 LOAD )
ASSEMBLER DEFINITIONS HEX
: JOC, HERE 8 + + JMP,
  ; IMMEDIATE ( jmp over CODE header )

CODE 11A
  11 # LDA, 3 JOC, ( 5=len["22a"] )
CODE 22A
  22 # LDA, 8 JOC, ( 8=len["33a-test"] )
CODE 33A-TEST
  33 # LDA,
  ' 11A JMP,

' 11A . ( 311C )

11A
