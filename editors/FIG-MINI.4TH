( mini fig editor, from fig )
( a subset suggested by Ted Shapin, FD-V03N2 )
( tested with APX Forth on Atari 8-bit )

HEX
: TEXT HERE C/L 1+ BLANKS WORD HERE PAD C/L 1+ CMOVE ;
: LINE DUP FFF0 AND 17 ?ERROR SCR @ (LINE) DROP ;
: -MOVE LINE C/L CMOVE UPDATE ; 
: P 1 TEXT PAD 1+ SWAP -MOVE ;
DECIMAL

;S

( not originally suggested but very useful )
: E LINE C/L BL FILL UPDATE ;
( also, consider adding: MARK, CLEAR, COPY, WHERE )
