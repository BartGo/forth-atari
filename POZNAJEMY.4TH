
( * ROZDZIAL 1.3.1 )
( * OK, BRAK BŁĘDÓW )

: TEST 30000 0 DO LOOP BEEP ; 

( * ROZDZIAL 1.3.4 )
( * POPRAWIONE BŁĘDY - PRZED ŚREDNIKAMI MUSZĄ BYĆ SPACJE )
( * PRZYKŁAD Z "NUMBER" NIE ZADZIAŁA ALE JAK PRZYKŁAD KONCEPCJI JEST OK )

: ZMIENNA VARIABLE ;
: TU HERE ;
: KASUJ DROP ;
: LICZBA NUMBER ;

( * ROZDZIAL 2.1 )
( * kod jest OK, uwaga żeby nie zgubić spacji )
( * informacje zwracane przez Forth - czcionką mono? )

: KOT
KOT
FORGET KOT
: KOT CR ." Kot pije mleko" ; ( Return )
FORGET KOT
7 SPACES


( * ROZDZIAL 2.2 )
( * OK )

: TEST2 11 0 DO I . LOOP ; 

TEST2

: TEST3 7 0 DO ." A " LOOP ;

TEST3

( * ROZDZIAL 2.3 )

B/SCR . ( 8 ) 
B/BUF . ( 128 ) 
C/L .   ( 64 )

( * poprawka w listingu - błędnie ," zamiast ." )
. ." " : ; SPACES VLIST B/BUF B/SCR C/L CR FORGET SPACE 

( * Ćwiczenie 1 - ODPOWIEDŹ W ANEKSIE 4 JEST DOBRA )
: NAPIS KOT ." i poluje na myszy" ;

( * ROZDZIAL 3.3 )

( * OK )

2 3 +
2 3 + 7 *
5 7 - 10 8 + *

( * Ćwiczenie 2 - PYTANIA DOBRE ALE NA KOŃCU WSZYTSKIE BŁĘDNE ODPOWIEDZI (ANEKS 4) )

( * DO TEGO NIE BYŁO ODPOWIEDZI )
(A+B)*(C–D) ===> A B + C D - * 

( * TU BYŁA NIEKOMPLETNA, URWANA PO MINUSIE )
A*(B-C)+D ===> A B C - * D + 

( * TU BYŁA NIEKOMPLETNA, NIE DOPISANO MNOŻENIA )
(A+B)/C+(D+E)*F ===> A B + C / D E + F * +

( * TU BYŁA NIEKOMPLETNA, NIE DOPISANO MNOŻEŃ )
A/(B+C)*(D+A)*(C+D) ===> A B C + / D A + * C D + *

( * Ćwiczenie 3 )
( * MOŻEMY DOPISAĆ ODPOWIEDZI W ANEKSIE 4 )
( * NIE BYŁO ICH )

7 5 * 3 + 2 / 4 - 7 /
( * wynik: 2 )

( * POPRAWKA: MUSI BYĆ SPACJA MIĘDZY + ORAZ * )
22 3 5 + / 7 10 + *
( * wynik: 34 )

17 34 + 3 / +
( * błąd - za mało liczb na stosie )
 
( ROZDZIAL 3.4.2 ) 
 
40000        ( ok )
.            ( wynik: -25536   )
40000  U.    ( wynik:  40000   )
1000000 .    ( wynik:  16960   )
( * NIŻEJ ORYGINALNIE BRAK KROPKI ZA LICZBĄ, POPRAWIONE )
1000000. . . ( wynik: 15 16960 )
1000000. D.  ( wynik: 1000000  )

.R  ( n długość-pola --- )
D.R ( d długość-pola --- )
( * oryginalnie źle: .R  długość-pola n --- )
( * oryginalnie źle: D.R długość-pola d --- )

: TEST
  7 333 55 9999 20000 CR
  5 0 DO
    6 .R CR
  LOOP ;

TEST

( * ROZDZIAL 3.4.3 )
 
( * NIEPOPRAWNIE: SO (es-ooo)  zamiast S0, RÓWNIEŻ DALEJ )

: .S 2 SPACES SP@ S0 @ = 0=
  IF
    SP@ 2 – S0 @ - DO I @ . -2 +LOOP
  THEN ;

( * PROPOZYCJA DODANEJ SEKCJI WYDANIA 2023 )
( * ZA ZDANIEM: 
Następnie liczbą która zostanie przy tym wydrukowana, zastępujemy w dwóch miejscach
definicji pary słów: SO @. )

----------------------------

Można to zrobić tak (przykład wykorzystuje wcześniej nie wymieniane polecenia):

SP!   ( opróżnienie stosu )
: S0@ ( --- n )
  [ SP@ ]
  LITERAL ; 
: .S ( --- )
  2 SPACES
  SP@ S0@ =
  0= IF
    SP@ 2 - S0@ 2 - 
    DO I @ . -2 +LOOP
  THEN ;

----------------------------
I dalej wracamy do tekstu: "Wypróbujmy nasze nowe słowo:"..


( * sekcja poniżej jest OK chociaż wytłuszczenie jest mało wyraźne )
DUP .S ( 1 2 3 3 ok )
DROP .S ( 1 2 3 ok )
SWAP .S ( 1 3 2 ok )
ROT .S ( 3 2 1 ok )
OVER .S ( 3 2 1 2 ok )

( * poniżej okej )
: SZESCIAN DUP OVER * * . ;
: KWADRAT DUP * . ;
: KWADRATY CR DO I DUP U* 15 D.R CR LOOP ;

( * poniżej w książce była czwórka zamiast jedynki )
45001 44980 KWADRATY 

( ROZDZ. 3.4.4 )  

( * diagram rozjechany )

( * OK )
7 8 9 DUP ROT OVER DROP ROT ROT DROP

( * podzielić SWAP ( n1 n2 --- n2 n1 ) OVER ( n1 n2 --- n1 n2 n1 ) na dwie linie jak u SOETO )

( ROZDZ. 3.5 )

: 2DUP OVER OVER ;
: 2DROP DROP DROP ;
: 2SWAP ROT >R ROT R> ;
: 2OVER >R >R 2DUP R> R> 2SWAP ;

( * fix: usunięta nadmiarowa spacja z 2ROT )
: 2ROT >R >R 2SWAP R> R> 2SWAP ;


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
( * podkreślenie z SOETO jest wyraźniejsze niż pogrubienie Retronics; mnie sie podobają nawiasy: )

19 5 / . ( 3 ok )
20 5 / . ( 4 ok )
19 5 MOD . ( 4 ok )
154 7 MOD . ( 0 ok )
19 5 /MOD . . ( 3 4 ok )

( * niewyraźna spacja przed średnikiem )
: /MOD 2DUP MOD ROT ROT / ;

( * niewyraźna spacja przed średnikiem )
: / /MOD SWAP DROP ;

( * chyba OK )
*/ ( n1 n2 n3 --- n1*n2/n3 )
*/MOD ( n1 n2 n3 --- reszta wynik )


22220 45 100 */ . ( 9999 ok )
( * brak kilku spacji )
22220 100 / 45 * . ( 9990 ok )
22220 45 100 */MOD . . ( 9999 0 ok )

( * reszta okej chociaż słabe wyjaśnienie +- )

( ROZDZ. 3.6.2 )

D+ /d1 d2 --- d1+d2/
D- /d1 d2 --- d1-d2/
( * - niekonsekwentne nawiasy, tutaj ukośne, gdzie indziej zwykłe, tak lepiej: )
D+ ( d1 d2 --- d1+d2 )
D- ( d1 d2 --- d1-d2 )

( * LITERÓWKA: DMONUS )
DMINUS czy też DNEGATE 

S->D n --- d
( * brak nawiasów )
S->D ( n --- d )

( ROZDZ. 3.6.3 )

( * błąd też z SOETO - ostatnie działanie to M*/ a nie M* )

( * Ćwiczenie 7 - brak odpowiedzi na końcu jest okej ; kod pytań OK )


( * Ćwiczenie 8 - nie policzyłem ale wygląda OK )

( ROZDZ. 3.7 )

255 HEX . DECIMAL ( FF ok )
65535 HEX U. DECIMAL ( FFFF ok )
32767 HEX . DECIMAL ( 7FFF ok )

255 2 BASE ! . DECIMAL ( 11111111 ok )

( * bylo BASB )
32767 2 BASE ! CR . DECIMAL
( 111111111111111 ok )

32768 DUP 2 BASE ! CR U. CR . DECIMAL
( 1000000000000000 )

( * zgubione zero z wyniku )
( -1000000000000000 ok )

32769 DUP 2 BASE ! CR U. CR . DECIMAL
( 1000000000000001 )
( -111111111111111 ok )

27777 DUP 2 BASE ! CR . HEX CR . DECIMAL
( 110110010000001 )
( 6C81 ok )



( OK )
: H. BASE @ HEX OVER U. BASE ! ;
: B? BASE @ DUP DECIMAL . BASE ! ;


( * ROZDZ. 3.8 )

7ABBCCDD. ( ok )
D.

7ABBCCDD. U. U. ( 7ABB CCDD ok )


( * ROZDZIAŁ 4 )

( * 4.1 ok )
( * 4.2 ok )
( ... ) 

( * 4.5 )

( * niejednolita forma )
NFA / --- pfa nfa/
LFA / --- pda lfa/
CFA / --- pfa cfa/
PFA / --- nfa pfa/

lepiej:

NFA ( --- pfa nfa )
LFA ( --- pda lfa )
CFA ( --- pfa cfa )
PFA ( --- nfa pfa )

Przykład:

: DUMP-INDEX
  ' INDEX NFA
  ' TRIAD NFA
  OVER -
  DUMP ;

HEX DUMP-INDEX DECIMAL

( * rozdział 5.2.2 )

( kod jest okej )

: PRZEDZIAL ( dolna-granica n gorna-granica )
  OVER ( dol-gr n gor-gr n )
  > ( dol-gr n f1 )
  >R ( dol-gr n )
  < ( f2 )
  R> ( f2 f1 )
  * ; ( f )  ( * tu był brak spacji )


20 370 400 PRZEDZIAŁ .


( 5.5 )


  
  
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
46 DFIBO
47 DFIBO ( ujemne )
( OK )


( poniżej okej )
: KWADRAT2 DUP * ;
: KWADRAT3 DO I KWADRAT2 DUP 32760
IF DROP LEAVE THEN . LOOP ;


: TEST1 51 1 DO I . 2 +LOOP ;
: TEST2 0 20 DO I . -1 +LOOP ;

( * 5.6 )

0 VARIABLE AA

: TABLICZKA ( --- )
  125 EMIT					( patrz uwagi powyżej )
  CR CR 8 SPACES 			( nowy wiersz i przesunięcie kursora ) 
  ." TABLICZKA MNOZENIA" 	( tytuł )
  CR CR 3 SPACES
  10 1 DO I 3 .R LOOP CR 	( nagłówek )
  30 0 DO ." _" LOOP CR		( podkreślenie )  
  10 1 DO I DUP AA ! 		( wskaźnik zewnętrznej pętli wprowadzamy do zmiennej AA )
    . ." |" 				( kopię drukujemy, pionowa kreska ) 
    10 1 DO
      I AA @ *				( wskaźnik wewnętrznej pętli mnożymy przez AA )
      3 .R 					( drukujemy wynik mnożenia )
    LOOP					( koniec wewnętrznej pętli )
	CR 						( nowy wiersz )
  LOOP						( koniec zewnętrznej pętli )
  ; 						( koniec definiowania słowa ) 

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


( * 5.7 )


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


( * 5.8 )

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

( * 6.2 )  


: QUERY TIB @ 80 EXPECT 0 IN ! ; ( *ZGADZA SIĘ Z DECOMP )
: NAZWISKO? CR ." PODAJ SWOJE NAZWISKO: " CR QUERY ; ( *DODANE CR, ŁADNIEJ )

( uruchomienie: )
NAZWISKO?

: NAZWISKO? CR ." PODAJ SWOJE NAZWISKO: " CR QUERY 155 WORD HERE ; 
: DRUKUJ NAZWISKO? CR COUNT TYPE ;

( uruchomienie: )
DRUKUJ

( * 6.3 )



: INPUT CR QUERY BL WORD HERE NUMBER DROP ;  ( *Z CR ŁADNIEJ )

( uruchomienie: )
INPUT .


( * rozdział 7  - tu chyba nic )


( * rozdział 8 )

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


( * rozdział 9 )

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

( * rozdział 10 )



( * 10.4 (psy ) )



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
2  1 wiecej niz 60 cm wzrostu?
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


( ----- )

: TASK ; 
: #PSY 80 ; : #CECHY 81 ; 
: HOME 125 EMIT ;
: CARRAY <BUILDS ALLOT DOES> + ;
15 CARRAY CECHY
  : X CECHY C! ;
  165 0 X 98 1 X 163 2 X 35 3 X
  221 4 X 171 5 X 46 6 X 27 7 X
  194 8 X 32 9 X 172 10 X 28 11 X
0 VARIABLE BAJT
: BITY 1 SWAP 0 DO 2 * LOOP 
  2 / BAJT @ OR BAJT ! ;
: WLASNOSCI 0 BAJT !
  BEGIN
    QUERY BL WORD HERE NUMBER
    DROP DUP MINUS 0<
  WHILE 1 SWAP BITY CR DROP
  REPEAT ;
: DAJ BAJT @ 12 0
  DO
    DUP I CECHY C@ XOR 0=
    IF I 1+ #PSY .LINE CR THEN
  LOOP DROP ;
: PSY ( -- )
  HOME 12 1 DO
    I #CECHY .LINE CR
  LOOP CR ." Napisz liczby:" CR
  WLASNOSCI CR CR
  CR ." To moze byc:"
  CR DAJ DROP ;
;S 
( PSY .. 6 0 - ratler 32 )
( .. 2 3 4 6 0 - foksterier 46 )

====





: 3DUP >R 2DUP R ROT ROT R> ;
: TAM ( a c n -- a c n a b n-1 ) 
  3DUP ROT ROT OVER + 6 SWAP -
  ROT 1 - ;
: Z.POWROTEM ( a c n -- a c n b c n-1 )
  3DUP SWAP ROT OVER + 6 SWAP -
  SWAP ROT 1 - ;
: DRUKUJ 3DUP DROP SWAP
  . ." NA " . ." ," ;
: WIEZE ( a c n -- ) [ SMUDGE ] DUP IF 
    TAM WIEZE DRUKUJ 
    Z.POWROTEM WIEZE 
  THEN DROP DROP DROP [ SMUDGE ] ;   
: HANOI 1 3 ROT CR WIEZE ; ( n -- )



( 12.2 osiem hetmanów )
( * błędy: brak dwukropków przed definicjami, )
( * jeśli poprzednie słowo kończy się średnikiem, )
( * definicja nastepnego zaczyna sie od ":" )
( * brakowało też czasem spacji po definiowanym słowie )
( * a przed nawiasem komentarza, lub po nawiasie )
( * zaczynającym komentarz )
( * poprawione wcięcia )

( --------------------------------------- )

0 VARIABLE ROZWIAZANIE
: WEKTOR
  <BUILDS HERE OVER ERASE ALLOT
  DOES> + ;
1024 WEKTOR WSPOLRZEDNA

: LHET ( --- liczba hetmanów+1 )
  0 WSPOLRZEDNA C@ ;
: POSTAW ( rząd kolumna --- )
  SWAP WSPOLRZEDNA C! ; ( umieszcza hetmana )
: USUN ( rząd --- )
  0 POSTAW ; ( kasuje hetmana )

: WOLNE ( rząd n --- rząd f )
  2DUP = >R
  OVER WSPOLRZEDNA C@
  OVER WSPOLRZEDNA C@ -
  ROT ROT - ABS OVER ABS =
  SWAP 0= OR 0=
  R> OR ;

: WSZYSTKIE-WOLNE ( rząd --- rząd f )
  1 OVER 1 DO
    OVER I WOLNE AND
  LOOP ;

: BRZEG ( rząd --- rząd f )
  LHET OVER WSPOLRZEDNA C@ > ;

: DRUK ( --- )
  CR LHET 1 DO
    I WSPOLRZEDNA C@ LHET 1
    DO DUP I =
      IF ." X " ELSE ." . " THEN
    LOOP DROP CR
  LOOP
  1 ROZWIAZANIE +! CR ." Rozwiazanie nr "
  ROZWIAZANIE ? CR ;
: INIC ( --- )
  ( inicjuje szachownice z hetmanami w rz. 0 ) 
  LHET 1 DO
    I USUN
  LOOP 0 ROZWIAZANIE ! ;
: NAPRZOD ( rząd --- rząd f )
  ( f=1, gdy hetmana w rzędzie "rząd" )
  ( można przesunąć do następnej kolumny )
  DUP DUP WSPOLRZEDNA
  C@ 1+ POSTAW BRZEG
  IF 1 ELSE DUP USUN 0 THEN ;
: PIERWSZA-WOLNA ( rząd --- rząd f )
  ( f=1,gdy hetman może )
  ( przejść do następnej kolumny w rzędzie )
  BEGIN
    NAPRZOD
    IF WSZYSTKIE-WOLNE -DUP ELSE 0 1 THEN
  UNTIL ;
: POZYCJA ( rząd --- f )
  [ SMUDGE ]
  LHET OVER > IF
    BEGIN
	  PIERWSZA-WOLNA IF
	    1+ POZYCJA -DUP
	  ELSE
	    1 - 0 1
      THEN
	UNTIL
  ELSE
    DRUK 1 - 0
  THEN
  [ SMUDGE ] ;

: HETMANY ( --- )
  9 0 SWAP POSTAW INIC
  1 POZYCJA
  2 DROP ; 


( --------------------------------------- )


( NIE DZIAŁA JAKOŚ SUPER )

10 CONSTANT DIMX
10 CONSTANT DIMY

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


 

12.4 liczby zespolone


: COMPLEX <BUILDS
  , , ( wprowadza do słownika 2 wartości ze stosu )
  DOES> ; ( potrzebny adres jest już na stosie )

: X@   ( adr --- rz ur )
  DUP  ( adr dr )
  @    ( adr ur )
  SWAP ( ur adr )
  2+   ( ur adr+2 )
  @    ( ur rz )
  SWAP ( rz ur ) ;

: X!   ( rz ur adr --- )
  SWAP OVER ! 2+ ! ;

: X+   ( rz1 ur1 rz2 ur2 --- rz1+rz2 ur1+ur2 )
  ROT  ( rz1 rz2 ur2 ur1 )
  +    ( rz1 rz2 ur1+ur2 )
  >R   ( rz1 rz2 )
  + R> ( rz1+rz2 ur1+ur2 )
  ;
  
: X-
  ROT SWAP - >R - R> ;
  
: X*' ( rz ur rzecz --- rz*rzecz ur*rzecz )
  SWAP OVER   ( rz rzecz ur rzecz )
  * ROT ROT * ( ur*rzecz rz*rzecz )
  SWAP ;      ( rz*rzecz ur*rzecz )

: X* ( r1 u1 r2 u2 --- r1.r2-u1.u2 r1.u2+r2.u1 )
  2OVER 2OVER ( C1 C2 C1 C2 )
  ROT *       ( Cl C2 r1 r2 u1.u2 )
  >R * R> -   ( C1 C2 r1.r2-u1.u2 )
  >R          ( r1 u1 r2 u2 )
  ROT ROT *   ( r1 u2 u1.r2 )
  >R * R> +   ( r1.u2+u1.r2 )
  R> SWAP ;   ( r1.r2-u1.u2 r1.u2+u1.r2 )
  
 
3 2 1 7 X* . .  ( -11 23 ok )
( wynik odpowiada −11 + 23i )
  
====


12.5 fn trig

 ( poniższy kod z książki "Poznajemy FORTH", jak również )      
 ( z bibliografii [5], nie działa - nie jest tam opisane )
 ( umieszczanie w tablicy wartości sinusów dla zadanych  )
 ( kątów (?) - stos jest za mały żeby go użyć do tego    )
 ( celu, brak innych sugestii w książce nie pomoże       )
 ( czytelnikowi w zrozumieniu działania....              ) 
 

 : TABLICA                        
  <BUILDS 0 DO I , LOOP DOES>  
  SWAP 2 * + @ ;                  

 ( poniżej przykładowe "obejście" tego problemu, przy    )
 ( pomocy serii wartości, wygenerowanych w arkuszu       )
 ( kalkulacyjnym - dzięki temu możemy uruchomić następne )
 ( "słowa" i przetestować ich działanie                  )
FORGET TABLICA

: TABLICA <BUILDS
 0 , 174 , 348 , 522 , 696 , 870 ,
 1044 , 1218 , 1390 , 1564 , 1736 ,
 1908 , 2078 , 2248 , 2418 , 2588 ,
 2756 , 2922 , 3090 , 3254 , 3420 ,
 3582 , 3746 , 3906 , 4066 , 4226 ,
 4382 , 4538 , 4694 , 4848 , 5000 ,
 5150 , 5298 , 5446 , 5590 , 5734 ,
 5876 , 6018 , 6156 , 6292 , 6426 ,
 6560 , 6690 , 6818 , 6946 , 7070 ,
 7192 , 7312 , 7430 , 7546 , 7660 ,
 7770 , 7880 , 7986 , 8090 , 8190 ,
 8290 , 8386 , 8480 , 8570 , 8660 ,
 8746 , 8828 , 8910 , 8986 , 9062 ,
 9134 , 9204 , 9270 , 9334 , 9396 ,
 9454 , 9510 , 9562 , 9612 , 9658 ,
 9702 , 9742 , 9780 , 9816 , 9848 ,
 9876 , 9902 , 9924 , 9944 , 9960 ,
 9974 , 9986 , 9992 , 9998 , 10000 ,
DOES> SWAP 2 * + @ ;

91 TABLICA SINTABLICA

: S180
  DUP 90 >
  IF
    180 SWAP -
  THEN SINTABLICA ;

: SIN ( arg --- sin[arg] )
  360 MOD
  DUP 0<
  IF 360 + THEN
  DUP 180 >
  IF 180 - S180 MINUS ELSE S180 THEN ;
: COS 90 + SIN ;
: TAN DUP SIN SWAP COS DUP ABS 2920 >
  IF 10000 SWAP */
  ELSE DROP DROP ." ZA DUZE! " THEN ;

( URUCHAMIANIE I WYNIKI )
 0 SIN . (     0 ok )
90 SIN . ( 10000 ok )
45 SIN . (  7070 ok )
44 SIN . (  6946 ok )
44 TAN . (  9657 ok )
46 SIN . (  7192 ok )
45 SIN . (  7070 ok )
30 SIN . (  5000 ok )
89 SIN . (  9998 ok )
 0 TAN . (     0 ok )
30 TAN . (  5773 ok )
45 TAN . ( 10000 ok )
30 COS . (  8660 ok )



=====


  
12.6 sortowanie


: ARRAY <BUILDS 2 * ALLOT
  DOES> SWAP 2 * + ;
5 ARRAY LICZBY
0 VARIABLE NAST
: WSTAW 120 23 157 18 93
  5 0 DO I LICZBY ! LOOP ;
: POKAZ 5 0 DO I LICZBY ? LOOP ;
: POROWNAJ  ( n1 n2 --- )
  DUP       ( n1 n2 n2 )
  LICZBY @  ( n1 n2 L2 )
  ROT DUP   ( n2 L2 n1 n1 )
  LICZBY @  ( n2 L2 n1 L1 )
  ROT       ( n2 n1 L1 L2 )
  OVER OVER ( n2 n1 L1 L2 L1 L2 )
  >         ( n2 n1 L1 L2 f )
  IF        ( n2 n1 L1 L2 )
  ROT       ( n2 L1 L2 n1 ) 
  LICZBY !  ( n2 Li )
  SWAP      ( L1 n2 )
  LICZBY !  ( --- )
  ELSE 2DROP 2DROP THEN ;

: PRZEJRZYJ DUP 1+ NAST !
  BEGIN OVER 1+ NAST @ >
  WHILE DUP NAST @ POROWNAJ
  NAST @ 1+ NAST ! REPEAT
  2DROP ;
  
: EXSORT ( n1 n2 -- )
  BEGIN OVER OVER
    PRZEJRZYJ 1+ OVER OVER
  = UNTIL 2DROP ;

WSTAW
4 0 EXSORT
CR ." EXSORT: " CR POKAZ CR

( DZIAŁA: POSORTOWANE )


( BĄBELKOWE )

0 VARIABLE KONIEC?

: PORBUB ( n1 n2 -- )
  DUP LICZBY @
  ROT DUP LICZBY @
  ROT OVER OVER >
  IF
    ROT LICZBY ! SWAP LICZBY !
	0 KONIEC? !
  ELSE 2DROP 2DROP THEN ;
: PRZESUN
  BEGIN
    DUP DUP 1+ PORBUB 1+ OVER OVER
  = UNTIL
  DROP DROP ;
: BUBSORT
  BEGIN
    1 KONIEC? !
	OVER OVER PRZESUN
  KONIEC? @ UNTIL
  2DROP ;

WSTAW
4 0 BUBSORT
CR ." BUBSORT: " CR POKAZ CR

( OK )


0 VARIABLE POCZ
0 VARIABLE KON
0 VARIABLE LW
0 VARIABLE PW

: POCZATEK WSTAW ;

: LEWY
  BEGIN
    DUP LW @ LICZBY @
  > WHILE LW @
    1+ LW !
  REPEAT DROP ;
: PRAWY
  BEGIN
    DUP PW @ LICZBY @
  < WHILE PW @
    1 - PW !
  REPEAT DROP ;
: CZYTAJ @ LICZBY @ ;
: WSTAW @ LICZBY ! ;
: ZAM
  LW CZYTAJ PW CZYTAJ
  LW WSTAW PW WSTAW
  LW @ 1+ LW ! PW @ 1 - PW ! ;
: SORTUJ
  BEGIN
    DUP DUP LEWY PRAWY
	LW @ PW @ > DUP
	IF ELSE ZAM THEN
  UNTIL DROP ;
: KOMPARAND
  OVER OVER LW ! PW ! + 2 /
  LICZBY @ ;
: QUICK
 [ SMUDGE ]
   KOMPARAND SORTUJ
   POCZ @ PW @ <
   IF
     PW @ DUP KON ! POCZ @ QUICK
   THEN
   LW @ KON @ <
   IF
     KON @ LW @ DUP POCZ ! QUICK
   THEN
 [ SMUDGE ] ;
: QUICKSORT
  OVER OVER POCZ ! KON ! QUICK ;

POCZATEK
4 0 QUICKSORT
CR ." QUICKSORT: " CR POKAZ CR

( DZIAŁA )

************************************



/////////////////
HETMANY - wydziwione - pominąć
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


/////////////////
  
