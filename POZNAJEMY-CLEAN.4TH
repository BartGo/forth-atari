( This is a batch for Atari 800XL's APX Extended Fig-Forth.  )
( It empties and prepares SD floppy with listings from       )
( "Poznajemy Forth", together with some public domain tools. )
( To install:                                                )
( - boot Altirra with Forth, 18 LOAD, paste the below,       )
(    replace D1: with an empty image, size should be SD/90KB )
(                                                version 0.2 )

( *** LOADING HELPER *** ) 

: TASK ;
HEX EDITOR DEFINITIONS
11 VARIABLE #SC ( starting scr-1 ) ( $11 )
 0 VARIABLE #LN ( & line )
: LN+ ( -- ) #LN @ 1 + #LN ! ;
: LN? ( -- ) #LN @ F = IF 17 ERROR THEN ;
: PREPARE ( -- ) ( next scr )
  0 #LN ! 
  #SC @ 1 + #SC ! #SC @ CLEAR #SC @ SCR !
  ." Preparing #" #SC ? CR  ;
: Q ( -- ) ( new line: Q ccc )
  LN? #LN @ P LN+ ; 
: V ( -- ) ( skip line: V )
  LN? #LN @ E LN+ ; 

( *** /LOADING HELPER *** ) 

DECIMAL EDITOR

PREPARE
Q ( ** Poznajemy Forth ** ) ;S
Q (  1.0    --> screen=21 )
Q (  2.0    --> screen=21 )
Q (  3.0    --> screen=21 )
Q (  4.0    --> screen=21 )
Q (  5.0    --> screen=21 )
Q (  6.0    --> screen=21 )
Q (  7.0    --> screen=21 )
Q (  8.0    --> screen=21 )
Q (  9.0    --> screen=21 )
Q ( 10.0    --> screen=21 )
Q ( 11.0    --> screen=21 )
Q ( 12.0    --> screen=21 )
Q ( Aneksy  --> screen=21 ) 
Q ..
Q ( ** Public Domain Tools ** )


PREPARE
Q ( Poznajemy FORTH 1-2       )
Q : TEST 30000 0 DO LOOP BEEP ; 
Q : ZMIENNA VARIABLE ; : TU HERE ;
Q : KASUJ DROP ; : LICZBA NUMBER ;
Q : KOT ; FORGET KOT
Q : KOT CR ." Kot pije mleko" ;
Q : NAPIS ( -- )
Q   KOT ."  i poluje na myszy" ;
Q : TEST2 11 0 DO I . LOOP ; 
Q : TEST3 7 0 DO ." A " LOOP ;
Q : .USER ( -- )
Q    B/SCR . ( 8 ) 
Q    B/BUF . ( 128 ) 
Q    C/L .   ( 64 ) ;
Q ;S


PREPARE
Q ( SP!, .S )
Q SP! : S0@ ( --- n )
Q   [ SP@ ] LITERAL ; 
Q : .S ( --- )
Q   2 SPACES
Q   SP@ S0@ =
Q   0= IF
Q     SP@ 2 - S0@ 2 - 
Q     DO I @ . -2 +LOOP
Q   THEN ;
V
Q 1 2 3 SWAP DUP .S
Q ;S

PREPARE
Q : TEST ( -- )
Q   1 2 3 DUP .S ( 1 2 3 3 ok )
Q   DROP .S ( 1 2 3 ok )
Q   SWAP .S ( 1 3 2 ok )
Q   ROT .S ( 3 2 1 ok )
Q   OVER .S ( 3 2 1 2 ok ) SP! ;
Q : SZESCIAN DUP OVER * * . ;
Q : KWADRAT DUP * . ;
Q : KWADRATY CR DO
Q     I DUP U* 15 D.R CR LOOP ;
V 
Q   CR P" TEST:" CR TEST 
Q   CR P" SZESCIAN:" 5 SZESCIAN
Q   CR P" KWADRAT:" CR 7 KWADRAT
Q   CR P" KWADRATY:" CR
Q   45001 44980 KWADRATY CR  ;S

PREPARE
Q : 2DUP OVER OVER ;
Q : 2DROP DROP DROP ;
Q : 2SWAP ROT >R ROT R> ;
Q : 2OVER >R >R 2DUP R> R> 2SWAP ;
Q : 2ROT ( n1 n2 n3 n4 n5 n6 ... )
Q        ( --- n3 n4 n5 n6 n1 n2 )
Q    >R ( n1 n2 n3 n4 n5 )       ( – przenosi n6 na stos powrotów )
Q    >R ( n1 n2 n3 n4 )          ( – przenosi n5 na stos powrotów )
Q    2SWAP ( n3 n4 n1 n2 )       ( – zamienia pary liczb )
Q    R> ( n3 n4 n1 n2 n5 )       ( – przenosi z powrotem n5 )
Q    R> ( n3 n4 n1 n2 n5 n6 )    ( – przenosi z powrotem n6 )
Q    2SWAP ( n3 n4 n5 n6 n1 n2 ) ( – zamiana wykonana! )
Q  ;                         ;S

PREPARE
Q : DUMP-INDEX
Q   ' INDEX NFA ' TRIAD NFA OVER - DUMP ;
Q HEX DUMP-INDEX DECIMAL

PREPARE
Q : PRZEDZIAL ( dolna-granica n gorna-granica )
Q  OVER ( dol-gr n gor-gr n )
Q  >    ( dol-gr n f1 )
Q  >R   ( dol-gr n )
Q  <    ( f2 )
Q  R>   ( f2 f1 )
Q  ;    ( f )  
V
Q 20 370 400 PRZEDZIAL .
Q ;S

PREPARE
Q : FIBO ( n --- ) ( max n: 23 )
Q   0 1 ROT 0 CR DO
Q     DUP 10 .R CR SWAP OVER + LOOP ;  
Q : DFIBO ( n --- ) ( max n: 46 )
Q   0. ROT 1. ROT 0 CR DO       
Q    2DUP 14 D.R CR
Q    2SWAP 2OVER D+ LOOP ;   
Q : KWADRAT2 DUP * ;
Q : KWADRAT3
Q   DO I KWADRAT2 DUP 32760
Q     IF DROP LEAVE THEN . LOOP ;
Q: TEST1 51 1 DO I . 2 +LOOP ;
Q: TEST2 0 20 DO I . -1 +LOOP ; ;S

PREPARE
Q 0 VARIABLE AA : TABLICZKA ( -- )
Q  125 EMIT CR CR 8 SPACES
Q  ." TABLICZKA MNOZENIA"
Q  CR CR 3 SPACES
Q  10 1 DO I 3 .R LOOP CR
Q  30 0 DO ." _" LOOP CR
Q  10 1 DO I DUP AA ! 		
Q    . ." |" 				
Q    10 1 DO
Q      I AA @ *	3 .R 					
Q    LOOP CR
Q  LOOP ;
V
Q  TABLICZKA ;S

PREPARE
Q : J R> R> R> R R# ! >R >R >R R# @ ; 
Q : TAB2 ( -- ) 125 EMIT CR CR 8 SPACES 
Q  ." TABLICZKA MNOZENIA" CR CR 3 SPACES
Q  10 1 DO I 3 .R LOOP CR
Q  30 0 DO ." _" LOOP CR 
Q  10 1 DO
Q    I . ." |" 10 1 DO
Q      I J * 3 .R
Q    LOOP CR LOOP ;
V
Q TAB2 ;S

( OK )


( * 5.7 )

PREPARE
Q : IKSY BEGIN ." X" 1 - DUP 0= UNTIL ;
V
Q 4 IKSY
V
Q : NWP BEGIN SWAP OVER MOD -DUP 0= UNTIL ;
V
Q 128 1024 NWP .  ( wynik: 128 -- a nie 126, plus brak był kropki w listingu )
Q 324 556 NWP .   ( wynik: 4 )
Q 1933 821 NWP .    ( wynik: 1 )


( * 5.8 )

( poniższe sprawdzone z Salman / Tisserand / T )

PREPARE
Q ( ERATOS 1/2: WSTAW, USUN )
Q 0 VARIABLE ERATOS 254 ALLOT
Q : WSTAW ( adr --- ) 256 1 DO 
Q    I OVER C! 1+ LOOP DROP ;
Q : USUN ( n --- ) 256 OVER DO
Q     I 1 - ERATOS + 0 SWAP C!
Q     DUP +LOOP DROP ;
Q -->

PREPARE
Q ( ERATOS 2/2: PIERWSZE )
Q : PIERWSZE ( --- )
Q  ERATOS WSTAW CR ERATOS ( adr )
Q  256 2     ( adr 256 2 )
Q  DO        ( adr )
Q     I 1 -  ( adr I-1 )
Q     OVER   ( adr I-1 adr )
Q     +      ( adr adr+I-1 )
Q     C@     ( adr n )
Q     -DUP IF DUP . 
Q       USUN ( adr ) ( gdy n<>0 )
Q     THEN LOOP DROP ;
V
Q PIERWSZE ;S
 

( * 6.2 )  


: QUERY TIB @ 80 EXPECT 0 IN ! ; 
: NAZWISKO? CR ." PODAJ SWOJE NAZWISKO: " CR QUERY ; 
NAZWISKO?

: NAZWISKO? CR ." PODAJ SWOJE NAZWISKO: " CR QUERY 155 WORD HERE ; 
: DRUKUJ NAZWISKO? CR COUNT TYPE ;
DRUKUJ

: INPUT CR QUERY BL WORD HERE NUMBER DROP ;  ( *Z CR ŁADNIEJ )
INPUT .


( * rozdział 7  - tu chyba nic )


( * rozdział 8 )

PREPARE
Q ( 1/1 DATY )
Q : DATY ( n n n --- )
Q   <BUILDS , , , DOES>
Q   DUP 2+ DUP 2+ ? ? ? CR ;
V
Q 12  9 1683 DATY WIEDEN
Q  4  4 1794 DATY RACLAWICE
Q 18  6 1815 DATY WATERLOO
Q  1  9 1870 DATY SEDAN
Q 12 10 1943 DATY LENINO
Q 15 08 1920 DATY WARSZAWA
V 
Q CR WATERLOO CR
Q CR LENINO   CR
Q CR WARSZAWA CR
Q ;S

( OK )

PREPARE
Q ( 1/1 TENKOD, SILNIA, SILNIA2, SILNIA3, FACTORIAL [JB] )
Q : TENKOD ( --- n ) CURRENT @ @ PFA CFA ; IMMEDIATE
Q : SILNIA ( n --- ) 1 SWAP 1+ 1 DO I * LOOP ;
Q : SILNIA2 ( n --- ) DUP 2 = IF ELSE
Q     DUP 1 - TENKOD LITERAL EXECUTE * THEN ;
Q : SILNIA3 ( n --- ) [ SMUDGE ]
Q   DUP 2 = IF ELSE
Q     DUP 1 - SILNIA3 *
Q   THEN [ SMUDGE ] ;
Q : FACTORIAL ( JAN BIELECKI, "FORTH" )
Q   DUP IF DUP 1 - [ SMUDGE ] FACTORIAL [ SMUDGE ] * 
Q   ELSE 1+ THEN ;
Q 8 SILNIA  U.   8 SILNIA2 U. ( FAIL: COIN-OP/1.4S )
Q 8 SILNIA3 U.   8 FACTORIAL U.
Q ;S


( * rozdział 9 )

PREPARE
Q ( 1/1 ARRAY, 2DARRAY )
Q : ARRAY <BUILDS 2 * ALLOT DOES> SWAP 2 * + ;
Q : 2DARRAY
  <BUILDS DUP , * 2 * ALLOT DOES>
  ROT OVER @ + ROT + 2 * + 2+ ;
V
Q 10 ARRAY LICZBY
Q 7 LICZBY 7 LICZBY ! 7 LICZBY @ .
V
Q 4 5 2DARRAY PROSTOKAT
Q ( TODO )
Q ;S

PREPARE
Q ( 1/1 MATDEF - valFORTH ) : 0> 0 MAX ; 
Q : MATDEF ( dim1 dim2 --- )
Q          ( dim1 dim2 MATDEF Array-name  )
Q          ( indl ind2 Array-name --- adr )
Q  <BUILDS OVER OVER SWAP , , * 2 * ALLOT
Q  DOES> >R OVER OVER R @ R 2 + @ ROT - 0> ROT
Q  ROT - 0< * IF R @ * + 2 * R> 4 + + 
Q  ELSE R> DROP DROP DROP ." ZLE WSKAZNIKI" THEN ;
Q 2 3 MATDEF MATRIX2
Q 11 0 0 MATRIX2 C!  22 0 1 MATRIX2 C! 33 1 0 MATRIX2 C!  44 1 1 MATRIX2 C!
Q 55 0 2 MATRIX2 C!  66 1 2 MATRIX2 C! 77 2 3 MATRIX2 C! ( WYKRYWA PRZEKROCZENIE )
Q 0 0 MATRIX2 C@ .   0 1 MATRIX2 C@ . 1 0 MATRIX2 C@ .   1 1 MATRIX2 C@ .
Q 0 2 MATRIX2 C@ .   1 2 MATRIX2 C@ .
Q ;S


PREPARE
Q ( 1/1 ARRAY2, ARRAY3 [JB] )
Q : ARRAY2 ( n n --- ) ( n n ARRAY2 matrix )
Q   <BUILDS OVER , * ALLOT DOES>
Q   DUP @ ROT * + + 2+ ;
Q 2 3 ARRAY2 MATRIX
Q 11 0 0 MATRIX C!  22 0 1 MATRIX C! 33 1 0 MATRIX C!  44 1 1 MATRIX C!
Q 55 0 2 MATRIX C!  66 1 2 MATRIX C!
Q 0 0 MATRIX C@ .   0 1 MATRIX C@ . 1 0 MATRIX C@ .   1 1 MATRIX C@ .
Q 0 2 MATRIX C@ .   1 2 MATRIX C@ .
Q : ARRAY3  <BUILDS OVER C, DUP C, * ALLOT
Q   DOES> 1+ ROT OVER C@ * + + 1+ ;
Q 2 3 ARRAY3 BUF   13 2 1 BUF C!
Q 2 1 BUF C@ .
Q ;S

PREPARE
Q ( 1/1 SETNE, SEXTAL, XX, SEK )
Q DECIMAL
Q : SETNE <# # # 46 HOLD #S #> TYPE ;
V
Q 123489. SETNE ( 1234.89 )
Q : SEXTAL 6 BASE ! ;
Q : XX # SEXTAL # DECIMAL 58 HOLD ;
Q : SEK ( n --- ) CR <# XX XX #S #> TYPE CR ;
V
Q 15610. SEK
Q ;S


( PONIŻSZE NAM NIE ZADZIAŁA JEŚLI NIE MAMY D*, JAK W "COMPLETE FORTH" )

0 VARIABLE A_  0 VARIABLE B_
0 VARIABLE C_  0 VARIABLE D_
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





80 DUP CLEAR SCR !
0 P ( PSY RASOWE -- PSY 1/4
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

81 DUP CLEAR SCR !
0 P ( CECHY PSOW -- PSY 2/4
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


PREPARE
Q ( PSY 3/4 )
Q : #PSY 80 ; : #CECHY 81 ; : HOME 125 EMIT ;
Q : CARRAY <BUILDS ALLOT DOES> + ;
Q 15 CARRAY CECHY : X CECHY C! ;
Q 165 0 X 98 1 X 163 2 X 35 3 X
Q  221 4 X 171 5 X 46 6 X 27 7 X
Q  194 8 X 32 9 X 172 10 X 28 11 X
Q 0 VARIABLE BAJT
Q : BITY 1 SWAP 0 DO 2 * LOOP 
Q   2 / BAJT @ OR BAJT ! ;
Q : WLASNOSCI 0 BAJT ! BEGIN
Q     QUERY BL WORD HERE NUMBER
Q     DROP DUP MINUS 0<
Q   WHILE 1 SWAP BITY CR DROP
Q   REPEAT ; 
Q -->

PREPARE
Q ( PSY 3/4 )
Q : DAJ BAJT @ 12 0 DO
Q     DUP I CECHY C@ XOR 0=
Q     IF I 1+ #PSY .LINE CR THEN
Q   LOOP DROP ;
Q : PSY ( -- ) HOME 12 1 DO
Q     I #CECHY .LINE CR
Q   LOOP CR ." Napisz liczby:" CR
Q   WLASNOSCI CR CR CR ." To moze byc:"
Q   CR DAJ DROP ;
Q PSY ( PSY .. 6 0 - ratler 32 )
Q ;S  ( .. 2 3 4 6 0 - foksterier 46 )

PREPARE
Q ( 1/n WIEZE Z HANOI )
Q : 3DUP >R 2DUP R ROT ROT R> ;
Q : TAM 3DUP ROT ROT OVER + 6 SWAP -
Q   ROT 1 - ;
Q : Z.POWROTEM 
Q   3DUP SWAP ROT OVER + 6 SWAP -
Q   SWAP ROT 1 - ;
Q : DRUKUJ 3DUP DROP SWAP
Q   . ." NA " . ." ," ;
Q : WIEZE [ SMUDGE ] DUP IF 
Q     TAM WIEZE DRUKUJ Z.POWROTEM WIEZE 
Q   THEN DROP DROP DROP [ SMUDGE ] ;   
Q : HANOI 1 3 ROT CR WIEZE ; ( n -- )
V
Q 5 HANOI           ;S



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

PREPARE
Q ( 1/1 LICZBY ZESPOLONE )
Q : COMPLEX <BUILDS , ,  DOES> ; 
Q : X@ DUP @ SWAP 2+ @ SWAP  ;
Q : X! SWAP OVER ! 2+ ! ;
Q : X+ ROT + >R + R> ;
Q : X- ROT SWAP - >R - R> ;
Q : X*' SWAP OVER * ROT ROT * SWAP ;
Q : X* 2OVER 2OVER ROT * >R * R> - >R
Q   ROT ROT * >R * R> + R> SWAP ;
V 
Q : TEST-COMPLEX 3 2 1 7 X* . .  ; 
Q ;S     ( -11 23 ok )
  
====


12.5 fn trig

PREPARE 
Q ( 1/2 FUNKCJE TRYGONOMETRYCZNE [FIXED] )
Q : TABLICA <BUILDS
Q 0 , 174 , 348 , 522 , 696 , 870 , 1044 , 1218 , 1390 , 1564 , 1736 ,
Q 1908 , 2078 , 2248 , 2418 , 2588 ,  2756 , 2922 , 3090 , 3254 , 3420 ,
Q 3582 , 3746 , 3906 , 4066 , 4226 , 4382 , 4538 , 4694 , 4848 , 5000 ,
Q 5150 , 5298 , 5446 , 5590 , 5734 , 5876 , 6018 , 6156 , 6292 , 6426 ,
Q 6560 , 6690 , 6818 , 6946 , 7070 , 7192 , 7312 , 7430 , 7546 , 7660 ,
Q 7770 , 7880 , 7986 , 8090 , 8190 , 8290 , 8386 , 8480 , 8570 , 8660 ,
Q 8746 , 8828 , 8910 , 8986 , 9062 , 9134 , 9204 , 9270 , 9334 , 9396 ,
Q 9454 , 9510 , 9562 , 9612 , 9658 , 9702 , 9742 , 9780 , 9816 , 9848 ,
Q 9876 , 9902 , 9924 , 9944 , 9960 , 9974 , 9986 , 9992 , 9998 , 10000 ,
Q DOES> SWAP 2 * + @ ;
V
Q 91 TABLICA SINTABLICA
Q -->

PREPARE
Q ( 2/2 FUNKCJE TRYGONOMETRYCZNE [FIXED] )
Q : S180 DUP 90 > IF 180 SWAP - THEN SINTABLICA ;
Q : SIN 360 MOD DUP 0< IF 360 + THEN
Q   DUP 180 > IF 180 - S180 MINUS ELSE S180 THEN ;
Q : COS 90 + SIN ;
Q : TAN DUP SIN SWAP COS DUP ABS 2920 >
Q   IF 10000 SWAP */  ELSE DROP DROP ." ZA DUZE! " THEN ;
V
Q  0 SIN . (     0 ) 90 SIN . ( 10000 ) 
Q 45 SIN . (  7070 ) 44 SIN . (  6946 )
Q 44 TAN . (  9657 ) 46 SIN . (  7192 )
Q 45 SIN . (  7070 ) 30 SIN . (  5000 )
Q 89 SIN . (  9998 ) 0 TAN .  (     0 )
Q 30 TAN . (  5773 ) 45 TAN . ( 10000 )
Q 30 COS . (  8660 ) ;S



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
