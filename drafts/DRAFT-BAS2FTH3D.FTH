
--- BASIC VERSION

0 GRAPHICS 8:COLOR 1:DIM M(320)
1 FOR Y=1 TO 145 STEP 2
2   E=Y:C=Y-70:C=C*C
3   FOR X=1 TO 145
4     D=X-70
5     Z=80*EXP(-1.0E-03*(C+D*D))
6     X1=X+E:Y1=Z+E
7     IF Y1>=M(X1) THEN LET M(X1)=Y1:PLOT X1,160-Y1
8   NEXT X
9 NEXT Y

-- APX FORTH, FIXME

( _3D Plot_ )
( APX Forth )
( Atari 8-b )

39 LOAD 50 LOAD 60 LOAD ( ASM/GR/FP )
21 LOAD ( optional DBG )

: TASK ;
: CLS 125 EMIT ;
320 CONSTANT Z
: FBYTES 6 * ; 
: FARRAY <BUILDS FBYTES ALLOT
  DOES> SWAP FBYTES + ;
: #0 ( size pfa --  ) 
  SWAP FBYTES
  OVER + SWAP ( pfa+size pfa )
  DO 0 I C! LOOP ;
Z FARRAY F#MAP Z FBYTES ' F#MAP #0
FP 0 FVARIABLE FX1 
FP 0 FVARIABLE FY1 

: DEMO ( -- )
  8 GR.
  1 1 1 SETCOLOR
  145 1 DO             ( -- )
	I DUP 70 - DUP *   ( E C )
	145 1 DO
    DUP I 70 - DUP * + ( E C C+D^2 )
	  FLOAT            ( E C FL1 ) 
	    FP -1.0E-03 F* ( E C FL2 )
	    FEXP  FP 80 F* ( E C FL3 )  
	  FX1 F! OVER I +  ( E C E+X )
	  FLOAT            ( E C FL1 ) 
	    FX1 F@ F+
		FY1 F!         ( E C )
	  ( FOVER F#MAP F@ 
	  ( ...
	  ( FP 1.1 0 FM F!
	  ( 0 F#MAP F?
	  ( col x y PLOT )
    ( ...
	LOOP
	DROP DROP            ( -- )
  2 +LOOP                ( -- )
  BEGIN KEY UNTIL  ;
