( FIXME: CRASH )

( * RDCP, a Recursive Decompiler * )
(  by Norman L. Hills / FDv5n6p16  )

( CASE BY C. EAKER FD V02N03 P 36 )
: /CASE
  ?COMP CSP @ !CSP
  4 ; IMMEDIATE
: /OF
  4 ?PAIRS
  COMPILE OVER
  COMPILE = 
  COMPILE 0BRANCH
  HERE 0 ,
  COMPILE DROP
  5 ; IMMEDIATE
: /ENDOF
  5 ?PAIRS
  COMPILE BRANCH HERE 0 ,
  SWAP 2 [COMPILE] ENDIF
  4 ; IMMEDIATE
: /ENDCASE 
  4 ?PAIRS 
  COMPILE DROP
  BEGIN
    SP@ CSP @ = 0=
  WHILE
    2 [COMPILE] ENDIF
  REPEAT 
  CSP ! ; IMMEDIATE  
    
  
( RDCP itself )

HEX
0 VARIABLE GIN
0 VARIABLE BASESAV
0 VARIABLE KEYSW
0 VARIABLE RDFEN
' C/L  2 - @ CONSTANT CONST.ADR
' BASE 2 - @ CONSTANT USERV.ADR
' GIN  2 - @ CONSTANT VAR.ADR
: U. 0 D. ;
: GOV OVER @ 2+ ;
: 2+D 2+ DUP ;
: .G@ 0 4 D.R GIN @ ;
: DIN CR DUP .G@ SPACES ;
: GIN+ CR OVER .G@ 2+D GIN ! SPACES ;
: MYSELF LATEST PFA CFA , ; IMMEDIATE

: GCHKTYP ( pfa -- f )
  /CASE ' LIT    /OF 1 /ENDOF
       ' BRANCH  /OF 1 /ENDOF
       ' 0BRANCH /OF 1 /ENDOF
       ' (LOOP)  /OF 1 /ENDOF
       ' (+LOOP) /OF 1 /ENDOF
       0 SWAP 
  /ENDCASE ;

: 1KEY KEYSW @
  IF ?TERMINAL IF ASCII Q
  ELSE DUP RDFEN @ U<
  IF BL ELSE 0D THEN THEN
  ELSE KEY THEN ;

: GCHK ( pfa -- pfa2 )
  /CASE GOV ' COMPILE =
    /OF 2+D @ 2+ NFA ID. /ENDOF
       GOV GCHKTYP
    /OF 2+D @ SPACE U. /ENDOF
       GOV ' (.") =
    /OF 2+D COUNT TYPE
      DUP C@ 1 - + /ENDOF
  /ENDCASE 2+ -2 GIN +! ;
 
: CK: DUP CFA @ ' : CFA @ = ;

: DISTYPE ( nfa -- )
  DUP C@ 40 AND ( immediate bit )
  IF ." [COMPILE] " ID.
  ELSE DUP ID. PFA CFA DUP @
    /CASE
      CONST.ADR /OF ." const "
        EXECUTE U. /ENDOF
      VAR.ADR   /OF ." var " 
        EXECUTE @ U. /ENDOF
      USERV.ADR /OF ." user "
        EXECUTE @ U. /ENDOF
      DROP
    /ENDCASE THEN ;

: (GOESINTO) ( pfa -- )
  CK: IF
    2 - DIN ."   :" 2+D
    NFA C@ 40 AND IF
  	  ."  IMMEDIATE"
	THEN
    BEGIN
 	  DUP @ DUP ' ;S CFA =
 	  OVER ' (;CODE) CFA = OR 0=
    WHILE
 	  2+ GIN+ DUP NFA DISTYPE
 	  1KEY /CASE
 	    ASCII Q /OF
 	  	SP! BASESAV @
 	  	BASE ! QUIT /ENDOF
 	    0D      /OF
 	  	MYSELF /ENDOF
 	    ASCII U /OF
 	  	DROP DROP R>
 	  	DROP -2 GIN +! /ENDOF
 	    DROP
 	  /ENDCASE
 	  GCHK
    REPEAT CR
    GIN @ 6 + SPACES 2+ NFA ID.
  THEN DROP ;   
  

: RDCP
  BASE @ BASESAV ! HEX
  -FIND
  IF DROP 0 GIN ! CK:
    IF (GOESINTO)
    ELSE NFA DISTYPE
    THEN
  ELSE ." Not in Dictionary"
  THEN 
  CR BASESAV @ BASE ! ;
 
HERE RDFEN ! DECIMAL
;S
