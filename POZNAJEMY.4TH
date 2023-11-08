( ROZDZIAL 1 )

: TEST 30000 0 DO LOOP BEEP ;
: ZMIENNA VARIABLE ;
: TU HERE ;
: KASUJ DROP ;
: LICZBA NUMBER ;

( ROZDZIAL 2 )
: KOT ;
FORGET KOT
: KOT CR ." Kot pije mleko" ;
: TEST2 11 0 DO I . LOOP ;
: TEST3 7 0 DO ." A " LOOP ;

( wszystko okej )

( ROZDZIAL 3 )

7 5 * 3 + 2 / 4 - 7 /
( wynik: 2 )

22 3 5 + / 7 10 + *
( wynik: 34 )

17 34 + 3 / +
( coś nie tak, underflow )
 
40000   .   ( wynik: -25536   )
40000  U.   ( wynik:  40000   )
1000000 .   ( wynik:  16960   )
1000000 . . ( coś nie tak, sprawdzić )
1000000. D. ( wynik: 1000000  )

: TEST 7 333 55 9999 20000 CR
  5 0 DO 6 .R CR LOOP ;

( przedtem zdefiniować S0 )

: .S 2 SPACES SP@ S0 @ = 0=
  IF
    SP@ 2 – S0 @ - DO I @ . -2 +LOOP
  THEN ;

: SZESCIAN DUP OVER * * . ;

: KWADRAT DUP * . ;

: KWADRATY CR DO I DUP U* 15 D.R CR LOOP ;

KWADRATY 45001 41980
(coś nie tak, chyba raczej:  45001 41980 KWADRATY )

( 3.5 )

: 2DUP OVER OVER ;
: 2DROP DROP DROP ;
: 2SWAP ROT >R ROT R> ;
: 2OVER >R >R 2DUP R> R> 2SWAP ;
: 2ROT >R >R 2SWAP R> R> 2SWAP ; ( nadmiarowa spacja )

: 2ROT ( n1 n2 n3 n4 n5 n6 --- n3 n4 n5 n6 n1 n2 )
    >R ( n1 n2 n3 n4 n5 )       ( – przenosi n6 na stos powrotów )
    >R ( n1 n2 n3 n4 )          ( – przenosi n5 na stos powrotów )
    2SWAP ( n3 n4 n1 n2 )       ( – zamienia pary liczb )
    R> ( n3 n4 n1 n2 n5 )       ( – przenosi z powrotem n5 )
    R> ( n3 n4 n1 n2 n5 n6 )    ( – przenosi z powrotem n6 )
    2SWAP ( n3 n4 n5 n6 n1 n2 ) ( – zamiana wykonana! )
    ;
( dziwne wyniki )
	
: /MOD 2DUP MOD ROT ROT / ;
( ! niewyraźna spacja przed średnikiem )

: / /MOD SWAP DROP ;
( ! niewyraźna spacja przed średnikiem )

( 3.6.2 )

D+ /d1 d2 --- d1+d2/
D- /d1 d2 --- d1-d2/
( ! - niekonsekwentne nawiasy, tutaj ukośne, gdzie indziej zwykłe )
D+ ( d1 d2 --- d1+d2 )
D- ( d1 d2 --- d1-d2 )

S->D n --- d
( ! brak nawiasów )
S->D ( n --- d )


0 VARIABLE AA
: TABLICZKA ( --- )
  125 EMIT CR CR 8 SPACES 
  ." TABLICZKA MNOZENIA" 
  CR CR 3 SPACES
  10 1 DO I 3 .R LOOP CR 
  30 0 DO ." _" LOOP CR 
  10 1 DO
    I DUP AA ! 
    . ." |" 
    10 1 DO
	  I AA 3 .R 
    LOOP CR 
  LOOP ; 

: J
  R> R> R> R R# ! >R >R >R R# @ ;

: TAB2 ( --- )
  125 EMIT CR CR 8 SPACES
  ." TABLICZKA MNOZENIA"
  CR CR 3 SPACES
  10 1 DO I 3 .R LOOP CR
  30 0 DO ." _" LOOP CR 
  10 1 DO
    I . ." |"
    10 1 DO
	  I J * 3 .R
    LOOP CR
  LOOP ;


( PF ERATOS 1/2 )
0 VARIABLE ERATOS 254 ALLOT
: WSTAW ( adr --- )
  256 1 DO 
    I OVER C! 1+
  LOOP
  DROP ;
: USUN ( n --- )
  256 OVER ( n 256 n )
  DO ( n )
	 I 1 ERATOS ( n I-1 adres )
	 + ( n adres --- I )
	 0 SWAP C! ( n ) ( 0 pod adr I )
	 DUP ( n n )
  +LOOP ( n )
  DROP ;

: PIERWSZE ( --- )
  ERATOS WSTAW CR
  ERATOS ( adr )
  256 2  ( adr 256 2 )
  DO     ( adr )
	 I 1 -  ( adr I-1 )
	 OVER   ( adr I-1 adr )
	 +      ( adr adr+I-1 )
	 C@     ( adr n )
	 -DUP IF DUP . 
	   USUN ( adr ) ( gdy n<>0 )
	 THEN
  LOOP DROP ;
  ( crash )
  
  
