( ROZDZIAL 1 )

: TEST 30000 0 DO LOOP BEEP ; 
: ZMIENNA VARIABLE ;
: TU HERE ;
: KASUJ DROP ;
: LICZBA NUMBER ;

( ROZDZIAL 2 )
: KOT ; ( *oryginalnie brak średnika na końcu )
KOT
FORGET KOT
: KOT CR ." Kot pije mleko" ;
7 SPACES
: TEST2 11 0 DO I . LOOP ; ( *oryginalnie brak spacji przed ; )
: TEST3 7 0 DO ." A " LOOP ;
B/SCR .
B/BUF .
. ." " : ; SPACES VLIST B/BUF B/SCR C/L CR FORGET SPACE

( ROZDZIAL 3 )

2 3 +
2 3 + 7 *
5 7 - 10 8 + *

7 5 * 3 + 2 / 4 - 7 /
( wynik: 2 , czy tak w odpowiedziach? )

22 3 5 + / 7 10 + *
( wynik: 34 , czy tak w odpowiedziach?  )

17 34 + 3 / +
( błąd, za mało liczb na stosie, czy tak w odpowiedziach? )
 
40000   .   ( wynik: -25536   )
40000  U.   ( wynik:  40000   )
1000000 .   ( wynik:  16960   )
1000000 . . ( coś nie tak, sprawdzić )
1000000. D. ( wynik: 1000000  )

: TEST 7 333 55 9999 20000 CR
  5 0 DO 6 .R CR LOOP ;

( przedtem zdefiniować S0, NP. WG INSTRUKCJI )
: S0 188 ;
( - )

: .S 2 SPACES SP@ S0 @ = 0=
  IF
    SP@ 2 – S0 @ - DO I @ . -2 +LOOP
  THEN ;
( ZEPSUTE!)

: SZESCIAN DUP OVER * * . ;
: KWADRAT DUP * . ;
: KWADRATY CR DO I DUP U* 15 D.R CR LOOP ;
45001 44980 KWADRATY 

( OK )

(coś było nie tak, chyba raczej:  41980 45001 KWADRATY )
( albo górna plus 1: 41980 45002 KWADRATY )
( czwórka zamiast jedynki )

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
      I AA @ *
      3 .R 
    LOOP CR 
  LOOP ; 

( OK )

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
      I J *
      3 .R
    LOOP CR
  LOOP ;

( OK )

0 VARIABLE ERATOS 254 ALLOT
: WSTAW ( adr --- )
  256 1 DO 
    I OVER C! 1+
  LOOP DROP ;
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
     -DUP IF
	   DUP . 
       USUN ( adr ) ( gdy n<>0 )
     THEN
  LOOP DROP ;
 
( ERROR - ??? )

  
: S0 18 +ORIGIN ; ( ? MOŻE TAK ? Z DECOMP S. )
  
: .S 2 SPACES SP@ S0 @ = 0=
  IF
    SP@ 2 – S0 @ -
    DO I @ . -2 +LOOP
  THEN ;
  
( coś tu nie tak )  
  
  
: FIBO ( n --- ) ( max n: 23 ) ( * a nie trzydziesta trzecia! )
  0 1 ROT 0 CR
  DO
    DUP 10 .R CR SWAP OVER +
  LOOP ; 
  
34 FIBO
( OK )
  
: DFIBO ( n --- ) ( max n: 46 )
  0.       ( d=0 )       ( od początku używamy liczb podwójnych )
  ROT      ( 0. n )      ( przenosi górną granicę nad 0. )
  1. ROT   ( 0. 1. n )   ( taki sam manewr )
  0 CR     ( 0. 1. n 0 ) ( granice pętli ustalone )
  DO       ( 0. 1. )     ( granice pętli przeniesione na stos powrotów )
    2DUP   ( 0. 1. 1. )
    14 D.R ( 0. 1. )     ( pierwsza liczba wydrukowana )
    CR
    2SWAP  ( 1. 0. )
    2OVER  ( 1. 0. 1. )
    D+     ( 1. 1. )     ( pierwsze z kolejnych dodawań )
  LOOP ;                 ( powrót do początku pętli )
  

47 DFIBO
( OK )

: IKSY BEGIN ." X" 1 - DUP 0= UNTIL ;
4 IKSY

( OK )

: NWP BEGIN SWAP OVER MOD -DUP 0= UNTIL ;

128 1024 NWP .
( wynik: 128 -- a nie 126, plus brak był kropki w listingu )
324 556 NWP .
( wynik: 4 )
1933 821 NWP .
( wynik: 1 )



: QUERY TIB @ 80 EXPECT 0 IN ! ; ( *ZGADZA SIĘ Z DECOMP )
: NAZWISKO? CR ." PODAJ SWOJE NAZWISKO: " CR QUERY ; ( *DODANE CR, ŁADNIEJ )
NAZWISKO?
: NAZWISKO? CR ." PODAJ SWOJE NAZWISKO: " CR QUERY 155 WORD HERE ; 
: DRUKUJ NAZWISKO? CR COUNT TYPE ;
DRUKUJ

( OK )  

: INPUT CR QUERY BL WORD HERE NUMBER DROP ;  ( *Z CR ŁADNIEJ )
INPUT .


: DATY ( n n n --- )
 <BUILDS , , , DOES>
 DUP 2+ DUP 2+ ? ? ?
 CR ;

12 9 1683 DATY WIEDEN
4 4 1794 DATY RACLAWICE
18 6 1815 DATY WATERLOO
1 9 1870 DATY SEDAN
12 10 1943 DATY LENINO

WATERLOO

( OK )

: TENKOD ( --- n )
  CURRENT @ @ PFA CFA
  ; IMMEDIATE
: SILNIA ( n --- )
  1 SWAP 1+ 1 DO I * LOOP ;
: SILNIA2 ( n --- )
  DUP 2 = IF ELSE
    DUP 1 -
	TENKOD LITERAL
	EXECUTE *
  THEN ;
: SILNIA3 ( n --- )
  [ SMUDGE ]
  DUP 2 = IF ELSE
    DUP 1 - SILNIA3 *
  THEN
  [ SMUDGE ] ;
8 SILNIA  U.
8 SILNIA2 U. ( * NIE ZADZIAŁA W TEAMS FORTH )
8 SILNIA3 U.


: ARRAY <BUILDS 2 * ALLOT DOES> SWAP 2 * + ;
10 ARRAY LICZBY
7 LICZBY
22 7 LICZBY !
7 LICZBY @ .

: 2DARRAY
  <BUILDS
    DUP ,       ( wpisuje wymiar Dim2 )
    * 2 * ALLOT ( rezerwuje miejsce )
  DOES>
  ROT           ( przenosi wskaźnik i1 na szczyt stosu)
  OVER @ +      ( mnoży i1 przez Dim2 )
  ROT +         ( dodaje wskaźnik i2 )
  2 * + 2+ ;    ( oblicza adres komórki [i1, i2] )
4 5 2DARRAY PROSTOKAT

( PONIŻEJ NIE DZIAŁA W APX, NIE MA 0> W WIELU WERSJACH; DZIAŁA W VAL )
( ALE TAM NIE MA R@, ZAMIAST TEGO UŻYWAMY R )

: MATDEF ( dim1 dim2 --- )
  <BUILDS
    OVER OVER SWAP , , * 2 * ALLOT
  DOES> ( i1 i2 pfa+2 )
  >R ( i1 i2 )
  OVER OVER ( i1 12 i1 12 )
  R @ ( i1 i2 i1 i2 dim1 )
  R 2 + @ ( i1 12 i1 i2 dim1 dim2 )
  ROT - 0> ROT
  ROT - 0< ( ind1 ind2 f1 f2 )
  * ( ind1 ind2 f )
  IF
    R @ * + 2 * R> 4 + ( przesunięcie pfa+6 ) ( * ZMIANA R@ NA R @ )
    + ( adres )
  ELSE
    R> DROP DROP DROP
    ." ZLE WSKAZNIKI" ( sygnał o błędzie )
  THEN ;


: MATDISP ( --- ) ( MATDISP matrix )
  [COMPILE]' 6 + DUP >R 4 - @ R>
  2 - @ 0
  DO
    SWAP OVER 0
	DO DUP ? 2+ LOOP
    SWAP
  LOOP DROP DROP ;

: ARRAY2 ( n n --- ) ( n n ARRAY2 matrix )
  <BUILDS
    OVER , * ALLOT
  DOES>
  DUP @ ROT * + + 2+ ;

2 3 ARRAY2 MATRIX
11 1 1 MATRIX C!
22 2 1 MATRIX C!
33 1 2 MATRIX C!
44 2 2 MATRIX C!
2 2 MATRIX C@ . ( *TUTAJ BŁĘDNY WYNIK )
1 1 MATRIX C@ .
1 2 MATRIX C@ .
2 1 MATRIX C@ .

( PRAWIE OK )

DECIMAL

: SETNE <# # # 46 HOLD #S #> TYPE ;
123489. SETNE ( [Return] 1234.89 ok )

: SEXTAL 6 BASE ! ;
: XX # SEXTAL # DECIMAL 58 HOLD ;
: SEK ( n --- )
  <# XX XX #S #> TYPE ;
15610. CR SEK CR

( OK )




  
