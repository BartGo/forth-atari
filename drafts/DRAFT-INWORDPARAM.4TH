(  In-word Parameter Passing    )
(  FD V5N3p19 by T. Huang       )
(  &  In-Word Parameter Words   )
(  FD V6N6p9  by S.Chen,L. Tan  ) 

( port to Atari 8-bit APX Forth )
( in progress; we should type   )
( $0a and have 01 hex, both for )
( compile and interpretation    )
( however, BUG: 
( HEX 
( $00 $FF $99 $AA 
( S. ( 0 0 0 FF FF 0 99 99 0 AA AA 0 


FORTH DEFINITIONS DECIMAL

: UM* ( n1 n2 — d) M* DABS ;

: ?COMPILE STATE @ IF R>
  DUP @ . 2 + >R THEN ; 

: INWORD$ BASE @ >R
  16 BASE ! HERE + 0 0 ROT
  (NUMBER) ( originally, CONVERT )
  DROP DROP [COMPILE] LITERAL
  R> BASE ! ; 

1 WIDTH  !
  : $xx 1 INWORD$ ?COMPILE BASE @
    HERE 1+ NUMBER ROT BASE !
	[COMPILE] LITERAL ; IMMEDIATE
31 WIDTH !
