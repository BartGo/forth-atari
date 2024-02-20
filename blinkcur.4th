( "Blinking Characters" )
( ** Ron Miller's FORTH version of a routine published in COMPUTE, December, 1981 ** )
( - https://archive.org/details/waug-newsletter-april-1983/page/4/mode/1up?q=forth - )

HEX

CODE Blink ( -- )
  02F3 LDA,
  2  # AND,
  2  # EOR,
  02F3 STA,
  15 # LDA,
  021A STA,
RTS,
CODE BlinkStart ( -- )
  15 # LDA,
  021A STA,
NEXT JMP,

DECIMAL

: BlinkInit ( -- )
  ' Blink 228 ! ;
: BlinkCursor ( -- ) 
  BlinkInit
  BlinkStart ;

BlinkCursor
