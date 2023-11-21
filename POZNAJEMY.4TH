
( ROZDZIAL 1.3.1 )
: TEST 30000 0 DO LOOP BEEP ; 

( ROZDZIAL 1.3.4 )

: ZMIENNA VARIABLE ;
: TU HERE ;
: KASUJ DROP ;
: LICZBA NUMBER ;

( ROZDZIAL 2.1 )

: KOT ; 
KOT
FORGET KOT
: KOT CR ." Kot pije mleko" ;
7 SPACES

( ROZDZIAL 2.2 )

: TEST2 11 0 DO I . LOOP ; 

TEST2

: TEST3 7 0 DO ." A " LOOP ;

TEST3

( ROZDZIAL 2.3 )

B/SCR . ( 8 ) 
B/BUF . ( 128 ) 
C/L .   ( 64 )

. ." " : ; SPACES VLIST B/BUF B/SCR C/L CR FORGET SPACE 
( w listingu błędnie ," )

( ROZDZIAL 3.3 )

2 3 +
2 3 + 7 *
5 7 - 10 8 + *

7 5 * 3 + 2 / 4 - 7 /
( wynik: 2 , czy tak w odpowiedziach? )

22 3 5 + / 7 10 + *
( wynik: 34 , czy tak w odpowiedziach?  )

17 34 + 3 / +
( błąd, za mało liczb na stosie, czy tak w odpowiedziach? )
 
( ROZDZIAL 3.4.2 ) 
 
40000   .    ( wynik: -25536   )
40000  U.    ( wynik:  40000   )
1000000 .    ( wynik:  16960   )
1000000. . . ( wynik: 15 16960 )
1000000. D.  ( wynik: 1000000  )

.R  ( n długość-pola --- )
D.R ( d długość-pola --- )

( oryginalnie źle: .R  długość-pola n --- )
( oryginalnie źle: D.R długość-pola d --- )

: TEST
  7 333 55 9999 20000 CR
  5 0 DO 6 .R CR LOOP ;

TEST

-----------

( ROZDZIAL 3.4.3 )
 
: .S 2 SPACES SP@ S0 @ = 0=
  IF
    SP@ 2 – S0 @ -
    DO I @ . -2 +LOOP
  THEN ;

( sugerowany przypis: "Być może, S0 należy zmniejszyć o 2, jak w następnym fragmencie kodu zrobiono z wartością 188." )

( w kodzie SO (es-ooo) zamiast S0 (es-zero), do poprawki )

COLD SP@ . ( 188 )
: .S ( --- )
  2 SPACES
  SP@ 188 =
  0= IF
    SP@ 2 - 188 2 - 
    DO I @ . -2 +LOOP
  THEN ;
1 2 3 
.S ( wynik: 1 2 3 )

( OK )

( POZA KONKURSEM, JEŚLI NIE PODOBA NAM SIĘ MAGICZNA STAŁA 188 )
( SUGESTIA PRZYPISU )
SP! : S0@ ( --- n )
  [ SP@ ]
  LITERAL ; 
: .S ( --- )
  2 SPACES
  SP@ S0@ =
  0= IF
    SP@ 2 - S0@ 2 - 
    DO I @ . -2 +LOOP
  THEN ;

( OK )

: SZESCIAN DUP OVER * * . ;
: KWADRAT DUP * . ;
: KWADRATY CR DO I DUP U* 15 D.R CR LOOP ;
45001 44980 KWADRATY 
( w książce była czwórka zamiast jedynki )

( OK )

( ROZDZ. 3.4.4 )  

TODO: do sprawdzenia

( ROZDZ. 3.5 )

warto dodać przypis (sprawdzić) że R czasem jest zastąpione przez R@

: 2DUP OVER OVER ;
: 2DROP DROP DROP ;
: 2SWAP ROT >R ROT R> ;
: 2OVER >R >R 2DUP R> R> 2SWAP ;
: 2ROT >R >R 2SWAP R> R> 2SWAP ; ( nadmiarowa spacja )
( powyższe zgadza się z Salman / Tisserant / T )

: 2ROT ( n1 n2 n3 n4 n5 n6 --- n3 n4 n5 n6 n1 n2 )
    >R ( n1 n2 n3 n4 n5 )       ( – przenosi n6 na stos powrotów )
    >R ( n1 n2 n3 n4 )          ( – przenosi n5 na stos powrotów )
    2SWAP ( n3 n4 n1 n2 )       ( – zamienia pary liczb )
    R> ( n3 n4 n1 n2 n5 )       ( – przenosi z powrotem n5 )
    R> ( n3 n4 n1 n2 n5 n6 )    ( – przenosi z powrotem n6 )
    2SWAP ( n3 n4 n5 n6 n1 n2 ) ( – zamiana wykonana! )
    ;

( OK )

( ROZDZ. 3.6.1 ) 

TODO: DO SPRAWDZENIA ROZDZIAL
	
: /MOD 2DUP MOD ROT ROT / ;
( ! niewyraźna spacja przed średnikiem )

: / /MOD SWAP DROP ;
( ! niewyraźna spacja przed średnikiem )

( ROZDZ. 3.6.2 )

D+ /d1 d2 --- d1+d2/
D- /d1 d2 --- d1-d2/
( ! - niekonsekwentne nawiasy, tutaj ukośne, gdzie indziej zwykłe )
D+ ( d1 d2 --- d1+d2 )
D- ( d1 d2 --- d1-d2 )

S->D n --- d
( ! brak nawiasów )
S->D ( n --- d )

( ROZDZ. 3.7 )

255 2 BASE ! . DECIMAL
32767 2 BASE ! CR . DECIMAL ( * bylo BASB )


( ************** )

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

( poniższe sprawdzone z Salman / Tisserand / T )


0 VARIABLE ERATOS 254 ALLOT
: WSTAW ( adr --- )
  256 1 DO 
    I OVER C! 1+
  LOOP DROP ;
: USUN ( n --- )
  256 OVER ( n 256 n )
  DO ( n )
     I 1 - ERATOS ( n I-1 adres ) ( * brakowało minusa )
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
 
PIERWSZE
 
( OK - CHYBA )
( faktycznie nawet poprawione lekko w stos. do STT )

  
  
  
: FIBO ( n --- ) ( max n: 23 ) ( * a nie trzydziesta trzecia! )
  0 1 ROT 0 CR
  DO
    DUP 10 .R CR SWAP OVER +
  LOOP ; 
  
24 FIBO
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
  
( uruchomienie: )
47 DFIBO
( OK )

: IKSY BEGIN ." X" 1 - DUP 0= UNTIL ;

( uruchomienie: )
4 IKSY

( OK )

: NWP BEGIN SWAP OVER MOD -DUP 0= UNTIL ;

( uruchomienie: )
128 1024 NWP .
( wynik: 128 -- a nie 126, plus brak był kropki w listingu )
324 556 NWP .
( wynik: 4 )
1933 821 NWP .
( wynik: 1 )



: QUERY TIB @ 80 EXPECT 0 IN ! ; ( *ZGADZA SIĘ Z DECOMP )
: NAZWISKO? CR ." PODAJ SWOJE NAZWISKO: " CR QUERY ; ( *DODANE CR, ŁADNIEJ )

( uruchomienie: )
NAZWISKO?

: NAZWISKO? CR ." PODAJ SWOJE NAZWISKO: " CR QUERY 155 WORD HERE ; 
: DRUKUJ NAZWISKO? CR COUNT TYPE ;

( uruchomienie: )
DRUKUJ

( OK )  

: INPUT CR QUERY BL WORD HERE NUMBER DROP ;  ( *Z CR ŁADNIEJ )

( uruchomienie: )
INPUT .


: DATY ( n n n --- )
 <BUILDS , , , DOES>
 DUP 2+ DUP 2+ ? ? ?
 CR ;

( uruchomienie: )

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

( uruchomienie: )
8 SILNIA  U.
8 SILNIA2 U. ( * NIE ZADZIAŁA W COIN-OP/1.4S ITP; DOBRE W APX )
8 SILNIA3 U.

( co na to JB? )
: FACTORIAL
  DUP IF
    DUP 1 -
    [ SMUDGE ] FACTORIAL [ SMUDGE ]
    * 
  ELSE 1+ THEN ;
  8 FACTORIAL U.

: ARRAY <BUILDS 2 * ALLOT DOES> SWAP 2 * + ;

( uruchomienie: )
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

( uruchomienie: )
4 5 2DARRAY PROSTOKAT



( PONIŻEJ NIE DZIAŁA W APX, NIE MA 0> W WIELU WERSJACH; DZIAŁA W VAL )
( ALE TAM NIE MA R@, ZAMIAST TEGO UŻYWAMY R - ??? )

: 0> 0 MAX ; ( HELPER )
: MATDEF ( dim1 dim2 --- )
         ( dim1 dim2 MATDEF Array-name  )
         ( indl ind2 Array-name --- adr )
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
    R @ * + 2 * R> 4 + ( przesunięcie pfa+6 ) ( * NIE R@ ALE R @ )
    + ( adres )
  ELSE
    R> DROP DROP DROP
    ." ZLE WSKAZNIKI" ( sygnał o błędzie )
  THEN ;

2 3 MATDEF MATRIX2

11 0 0 MATRIX2 C!
22 0 1 MATRIX2 C!
33 1 0 MATRIX2 C!
44 1 1 MATRIX2 C!
55 0 2 MATRIX2 C!
66 1 2 MATRIX2 C!
77 2 3 MATRIX2 C! ( DOBRZE, WYKRYWA PRZEKROCZONE GRANICE )
0 0 MATRIX2 C@ .
0 1 MATRIX2 C@ .
1 0 MATRIX2 C@ .
1 1 MATRIX2 C@ .
0 2 MATRIX2 C@ .
1 2 MATRIX2 C@ .



( NIE UMIEM TEGO NAPRAWIĆ, NAWET Z SALMANA NIE DZIAŁA )
: MATDISP ( --- ) ( MATDISP matrix )
  [COMPILE] '
  6 + DUP >R
  4 - @
  R> 2 - @ 0
  DO
    SWAP OVER 0
	DO DUP @ . 2+ LOOP 
    SWAP
  LOOP DROP DROP ;




: ARRAY2 ( n n --- ) ( n n ARRAY2 matrix )
  <BUILDS
    OVER , * ALLOT
  DOES>
  DUP @ ROT * + + 2+ ;

2 3 ARRAY2 MATRIX

11 0 0 MATRIX C!
22 0 1 MATRIX C!
33 1 0 MATRIX C!
44 1 1 MATRIX C!
55 0 2 MATRIX C!
66 1 2 MATRIX C!

0 0 MATRIX C@ .
0 1 MATRIX C@ .
1 0 MATRIX C@ .
1 1 MATRIX C@ .
0 2 MATRIX C@ .
1 2 MATRIX C@ .

( OK )

( co na to JB? )
: ARRAY-JB  <BUILDS OVER C, DUP C, * ALLOT
  DOES> 1+ ROT OVER C@ * + + 1+ ;
2 3 ARRAY-JB BUF
13 2 1 BUF C!
2 1 BUF C@ .


DECIMAL



: SETNE <# # # 46 HOLD #S #> TYPE ;

( uruchomienie: )
123489. SETNE ( [Return] 1234.89 ok )

: SEXTAL 6 BASE ! ;
: XX # SEXTAL # DECIMAL 58 HOLD ;
: SEK ( n --- )
  CR <# XX XX #S #> TYPE CR ;

( uruchomienie: )
15610. SEK

( OK )




: PRZEDZIAL ( dolna-granica n gorna-granica )
  OVER ( dol-gr n gor-gr n )
  > ( dol-gr n f1 )
  >R ( dol-gr n )
  < ( f2 )
  R> ( f2 f1 )
  * ; ( f )  ( * tu był brak spacji )





( PONIŻSZE NAM NIE ZADZIAŁA JEŚLI NIE MAMY D*, JAK W "COMPLETE FORTH" )

0 VARIABLE A_
0 VARIABLE B_
0 VARIABLE C_
0 VARIABLE D_
: D* A_ ! B_ ! C_ ! D_ !
  D_ @ B_ A_ U*
  D_ @ A_ @ U* DROP +
  C_ @ B_ @ U* DROP + ; 


( --- )

: FIX DPL @ 0< IF ( jeżeli liczba była pojedyncza)
S->D 0 DPL ! ( przekształca ją w podwójną )
THEN
DPL @ DUP 4 < IF 4 SWAP
DO 10. D* LOOP ( skaluje )
ELSE
4 > IF ." Poza zakresem" 2DROP THEN THEN ; ( * TO NIE ZADZIAŁA DOPÓKI NIE ZDEFINIUJEMY D* )
: F. SWAP OVER DABS
<# # # # # 46 HOLD #S SIGN #> TYPE SPACE ;

0.04 FIX 
0.3 FIX D+ 
0.625 FIX D+ 
0.0001 FIX D+ 
10 FIX D+ 
F. 10.9651 

WCALE NIE, TO NIE DZIAŁA!!

( ROZDZ. 9.3 )

( przed UD. brakowało dwukropka; D+- oraz DABS już istnieje )
: UD. <# #S #> TYPE ;
: D- DMINUS D+ ;
: D0= OR 0= ; ( test na liczbę podwójną 0 )
: D0< SWAP DROP 0< ; ( test na ujemną liczbę podwójna )
: D= D- D0= ; ( test na równość dwóch liczb podwójnych )
: D+- 0< IF DMINUS THEN ;
: DABS DUP D+- ;



( 9.5 bez błędów )


HETMANY - wydziwione
==================================================================

( *** MAKRA *** )

: DEF [COMPILE] : ; IMMEDIATE

( *** TYPY DANYCH *** )

DEF T:Wektor
  <BUILDS HERE OVER ERASE ALLOT DOES> + ;

( *** STAŁE I ZMIENNE *** )

ASCII X CONSTANT %hetman
ASCII . CONSTANT %plansza

      0 VARIABLE &rozwiazanie
   1024 T:Wektor &wspolrzedna

( *** SŁOWA PODSTAWOWE *** )

DEF LHet ( --- liczba hetmanów+1 )
  0 &wspolrzedna C@ ;

DEF ))Postaw ( rząd kolumna --- )
  SWAP &wspolrzedna C! ; ( umieszcza hetmana )
  
DEF )Usun ( rząd --- )
  0 ))Postaw ; ( kasuje hetmana )
  
DEF ))Wolne ( rząd n --- rząd f )
  2DUP = >R OVER
  &wspolrzedna C@ OVER
  &wspolrzedna C@ -
  ROT ROT - ABS OVER ABS =
  SWAP 0= OR 0= R> OR ;
  
DEF )WszystkieWolne ( rząd --- rząd f )
  1 OVER 1
  DO
    OVER I Wolne AND
  LOOP ;
  
DEF )Brzeg ( rząd --- rząd f )
  LHet OVER &wspolrzedna C@ > ;

DEF )Naprzod ( rząd --- rząd f ) 
  DUP DUP &wspolrzedna C@ 1+
  ))Postaw )Brzeg
  IF 1 ELSE DUP )Usun 0 THEN ;

DEF )PierwszaWolna ( rząd --- rząd f )
  BEGIN
    Naprzod IF
	  )WszystkieWolne -DUP
	ELSE
	  0 1
	THEN
  UNTIL ;

( *** INICJOWANIE *** )
  
DEF Inic ( --- )
  LHet 1 
  DO
	I )Usun
  LOOP
  0 &rozwiazanie ! ;
  
( *** PLANSZA *** )
  
DEF Druk ( --- )
  CR LHet 1
  DO
    I &wspolrzedna C@ LHet 1
    DO
	  DUP I =
      IF %hetman EMIT
	  ELSE %plansza EMIT
	  THEN
    LOOP DROP CR
  LOOP CR
  1 &rozwiazanie +!
  ." Rozwiazanie nr "
  &rozwiazanie ? CR ;

( *** GŁÓWNY PROGRAM *** )

DEF )Pozycja ( rząd --- f )
  [ SMUDGE ]
    LHet OVER >
	IF
      BEGIN
	    )PierwszaWolna
		IF
		  1+ )Pozycja -DUP
		ELSE
		  1 - 0 1
		THEN
	  UNTIL
	ELSE
	  Druk 1 - 0
	THEN
  [ SMUDGE ] ;

( *** WYWOŁANIE *** )

DEF Hetmany ( --- )
  9 0 SWAP ))Postaw 
  Inic
  1 )Pozycja ( --- f )
  2DROP ; 



( NIE DZIAŁA )

36 CONSTANT DIMX
23 CONSTANT DIMY

: ARRAY ( dimX dimY --- )
  <BUILDS 
    OVER ,  ( umieszcza dimY pod adresem pfa+2 )
    * ALLOT ( rezerwuje dimX*dimY bajtów )
  DOES>
  DUP @  ( umieszcza dimX na stosie )
  ROT *  ( oblicza dimY*dimX )
  + + 2+ ( oblicza bezwzględny adres komórki )
 ;
  
DIMX DIMY ARRAY UNIVERSUM

: HOME 125 EMIT ;

: J R> R> R> R R# ! >R >R >R R# @ ;

: WSTAW ( indX indY --- )
  UNIVERSUM 1 SWAP C! ;

: USUN ( indX indY --- )
  UNIVERSUM 0 SWAP C! ;

: ZERUJ ( --- )
  DIMY 0 DO
    DIMX 0 DO
      I J USUN
    LOOP
  LOOP ;

: WERYFIKACJA ( liczba stanu sąsiadów --- )
  DUP 3 = ( liczba stanu f )
  IF DROP 2+ ELSE
    2 = 0= ( stan stan nr2 )
    IF 4 + THEN
  THEN ;
  
: PRZYGOTOWANIE ( --- )
  DIMY 0 DO
    DIMX 0 DO
      0
	  J 2+ DIMY MIN
	  J 1 - 0 MAX
      DO
	    J 2+ DIMX MIN
		J 1 - 0 MAX
        DO
		  I J UNIVERSUM C@ 1 AND + ( 1+ *** chyba nie )
        LOOP
      LOOP
      I J UNIVERSUM C@ 1 AND ( liczba sąsiadów )
      SWAP OVER - WERYFIKACJA ( koduje przyszłość )
      I J UNIVERSUM C! ( 1+ ** chyba nie )
    LOOP
  LOOP ;

: DRUK ( --- )
  HOME
  DIMY 0 DO
    DIMX 0 DO
      I J UNIVERSUM C@
      IF ." *" ELSE SPACE THEN
    LOOP CR
  LOOP ;

: TWORZENIE
  DIMY 0 DO
    DIMX 0 DO
      I J UNIVERSUM DUP C@
	  DUP 3 >
      IF DROP 0
	  ELSE
	    DUP 1 > IF DROP 1 THEN
	  THEN
      SWAP C! ( wprowadza nową wartość )
    LOOP
  LOOP ;

: GRA ( n --- )
  0 DO
    DRUK ( wyświetla pokolenie N )
    PRZYGOTOWANIE ( gasi pokolenie N i zostawia dane dla następnego )
    TWORZENIE ( tworzy pokolenie N+1 )
  LOOP
  DRUK ; ( drukuje ostatnie pokolenie )

: GRA1
  BEGIN
    ?TERMINAL IF ;S THEN
    DRUK PRZYGOTOWANIE TWORZENIE
  AGAIN
  DRUK ;


=============================================


 

( SCR # 25 )
0  ( PSY RASOWE
1  bokser 165
2  cocker-spaniel 90
3  dog 163
4  doberman 35
5  bernardyn 221
6  owczarek alzacki 171
7  foksterier 46
8  seter 27
9  jamnik 194
10 ratler 32
11 chow-chow 172
12 pekińczyk 28
13 -->
14
15

( EDITED )
0 P ( PSY RASOWE
1 P bokser 165
2 P cocker-spaniel 90
3 P dog 163
4 P doberman 35
5 P bernardyn 221
6 P owczarek alzacki 171
7 P foksterier 46
8 P seter 27
9 P jamnik 194
10 P ratler 32
11 P chow-chow 172
12 P pekińczyk 28
13 P -->



( SCR # 26 )
0  ( CECHY PSOW
1  Czy ma:
2  1 wiecej niż 60 cm wzrostu?
3  2 wydluzona glowe?
4  3 kwadratowy lub plaski pysk?
5  4 obfita siersc?
6  5 dlugi wlos?
7  6 stojace lub przyciete uszy?
8  7 dlugie uszy?
9  8 krepa lub mocna budowe?
10 -->
11
12
13
14
15

( EDIT )
0 P ( CECHY PSOW
1 P Czy ma:
2 P 1 wiecej niż 60 cm wzrostu?
3 P 2 wydluzona glowe?
4 P 3 kwadratowy lub plaski pysk?
5 P 4 obfita siersc?
6 P 5 dlugi wlos?
7 P 6 stojace lub przyciete uszy?
8 P 7 dlugie uszy?
9 P 8 krepa lub mocna budowe?
10 P -->

( SCR # 27 )

: CARRAY <BUILDS ALLOT DOES> + ;
15 CARRAY CECHY
: X CECHY C! ;
165 0 X 98 1 X 163 2 X 35 3 X
221 4 X 171 5 X 46 6 X 27 7 X
194 8 X 32 9 X 172 10 X 28 11 X
0 VARIABLE BAJT
: BITY
  1 SWAP 0 DO 2 * LOOP 
  2 / BAJT @ OR BAJT ! ;
: WLASNOSCI
  0 BAJT ! BEGIN
  QUERY BL WORD HERE NUMBER
  DROP DUP MINUS 0< WHILE
  1 SWAP BITY CR DROP REPEAT ;
-->


( SCR # 28 )
: #QS 80 ; : #AS 81 ; ( #scr )
: DAJ BAJT @ 12 0 DO
    DUP I CECHY C@ XOR 0=
    IF I 1+ #QS .LINE CR THEN
  LOOP DROP ;
: HOME 125 EMIT ;
: PSY ( -- ) HOME 12 1
  DO
    I #AS .LINE CR
  LOOP CR ." Napisz liczby:" CR
  WLASNOSCI CR ." To moze byc:"
  CR DAJ DROP ;

;S
