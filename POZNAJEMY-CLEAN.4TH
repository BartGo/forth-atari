( This is a batch for Atari 800XL's APX Extended Fig-Forth.  )
( It empties and prepares SD floppy with listings from       )
( "Poznajemy Forth", together with some public domain tools. )
( To install:                                                )
( - boot Altirra with Forth, 18 LOAD, paste the below,       )
(    replace D1: with an empty image, size should be SD/90KB )
(                                                version 0.2 )


( TRACE: https://www.forth.org/fd/FD-V03N2.pdf p. 58 )

( jesli zrobie RP@ to poprzez UNRAVEL i ?ENOUGH mozna _
( robic lepsza kontrole parametrow )
( https://www.forth.org/fd/FD-V06N2.pdf )

( przyda sie defer oraz IS ale nie wiem skad )

( edytory na druga strone? przynajmniej jeden na ta! )


( *** LOADING HELPER *** ) 

: TASK ;

( DODAĆ COPY ?! )

HEX  VOCABULARY EDITOR  EDITOR DEFINITIONS
: TEXT HERE C/L 1+ BLANKS WORD HERE
  PAD C/L 1+ CMOVE ; 
: LINE DUP FFF0 AND 17 ?ERROR
  SCR @ (LINE) DROP ; 
: WHERE DUP B/SCR / DUP SCR ! ." SCR # " DECIMAL .
  SWAP C/L /MOD C/L * ROT BLOCK + CR
  C/L -TRAILING TYPE CR HERE
  C@ - SPACES 1 2FE C! 1C EMIT 0 2FE
  C! [COMPILE] EDITOR QUIT ;
: MARK 10 0 DO I LINE UPDATE DROP LOOP ;
: -MOVE LINE C/L CMOVE UPDATE ;
: P 1 TEXT PAD 1+ SWAP -MOVE ; 
: E LINE C/L BLANKS UPDATE ;
 TOP 0 R# ! ; 
: #LOCATE R# @ C/L /MOD ;
: #LEAD #LOCATE LINE SWAP ;
: #LAG  #LEAD DUP >R + C/L R> - ;
: M R# +! CR SPACE #LEAD TYPE
  17 EMIT #LAG TYPE #LOCATE . DROP ;
: 1LINE #LAG PAD COUNT MATCH R# +! ;
: CLEAR  SCR ! 10 0 DO FORTH I
  EDITOR E LOOP ;
: CLEARS DO I CLEAR FLUSH LOOP ; CR
." EDITOR subset (incl. P, E) loaded."
CR 

DECIMAL

15 VARIABLE #SC ( starting scr-1 ) 
 0 VARIABLE #LN ( & line )
: LN+ ( -- ) #LN @ 1 + #LN ! ;
: LN? ( -- ) #LN @ 15 = IF 23 ERROR ABORT THEN ;
: PREPARE ( -- ) ( next scr )
  CR CR
  0 #LN ! 
  #SC @ 1 + #SC ! #SC @ CLEAR #SC @ SCR !
  ." #" #SC ? CR ;
: Q ( -- ) ( new line: Q ccc )
  LN? #LN @ EDITOR P
  LN+ ; 
: V ( -- ) ( skip line: V )
  LN? #LN @ EDITOR E
  LN+ ; 

( *** /LOADING HELPER *** ) 

EDITOR

89 16 CLEARS


PREPARE
Q (     ** Poznajemy Forth ** ) ;S
Q (  1.0    -- screen=21 )            (                         ) 
Q (  2.0    -- screen=21 )
Q (  3.0    -- screen=21 )
Q (  4.0    -- screen=21 )
Q (  5.0    -- screen=21 )
Q (  6.0    -- screen=21 )
Q (  7.0    -- screen=21 )
Q (  8.0    -- screen=21 )
Q (  9.0    -- screen=21 )
Q ( 10.0    -- screen=21 )
Q ( 11.0    -- screen=21 )
Q ( 12.0    -- screen=21 )
Q ( Aneksy  -- screen=21 )            (                         ) 

PREPARE
Q ( 1/1 KOT,NAPIS,.S,...,KWADRATY )   ( PF rozdzial xx.xx-yy.xx ) 
Q : KOT CR ." Kot pije mleko" ; 
Q : NAPIS KOT SPACE
Q   ." i poluje na myszy" ;
Q : S0 18 +ORIGIN @ ; ( APX s#85 )
Q : .S ( --- ) 2 SPACES SP@ S0 =
Q     0= IF SP@ 2 - S0 2 - DO
Q       I @ . -2 +LOOP THEN ;
Q : TEST ( -- ) 1 2 3   DUP  .S       ( 1 2 3 3 )
Q   DROP .S   ( 1 2 3 ) SWAP .S       ( 1 3 2 )
Q   ROT  .S   ( 3 2 1 ) OVER .S       ( 3 2 1 2 )
Q  SP! ;  : KWADRAT DUP * . ;
Q : SZESCIAN DUP OVER * * . ; 
Q : KWADRATY CR DO I DUP U* 15
Q   D.R CR LOOP ;
Q  CR 45001 44980 KWADRATY CR  ;S

PREPARE
Q ( 1/1 2DUP,2DROP,...,DUMP INDEX )   ( PF rozdzial xx.xx-yy.xx )
Q : 2DUP OVER OVER ;                  : 2DROP DROP DROP ;
Q : 2SWAP ROT >R ROT R> ; : 2OVER     >R >R 2DUP R> R> 2SWAP ;
Q : 2ROT ( n1 n2 n3 n4 n5 n6 ... )    ( --- n3 n4 n5 n6 n1 n2 )
Q    >R ( n1 n2 n3 n4 n5 )            ( – n6 na stos powrotow )
Q    >R ( n1 n2 n3 n4 )               ( – n5 na stos powrotow )
Q    2SWAP ( n3 n4 n1 n2 )            ( – zamienia pary liczb )
Q    R> ( n3 n4 n1 n2 n5 )            ( – przenosi z powrotem n5 )
Q    R> ( n3 n4 n1 n2 n5 n6 )         ( – przenosi z powrotem n6 )
Q    2SWAP ; ( n3 n4 n5 n6 n1 n2 )    ( – zamiana wykonana! )
Q : DUMP-INDEX ' INDEX NFA ' TRIAD    ( HEX DUMP-INDEX DECIMAL ) 
Q   NFA OVER - DUMP ;  ;S             ( ^ przyklad uzycia      )

PREPARE
Q ( 1/1 PRZEDZIAL,IKSY,NWP )
Q : PRZEDZIAL                         ( dolna-gr. n gorna-gran. )
Q    OVER                             ( dol-gr n gor-gr n )
Q    > >R                             ( dol-gr n f1 ) ( dol-gr n )
Q    <  R> ;                          ( f2 ) ( f2 f1 ) ( f )  
Q ( 20 370 400 PRZEDZIAL . CR )
Q : IKSY BEGIN
Q     ." X" 1 - DUP 0=
Q  UNTIL ; 
Q : NWP BEGIN
Q     SWAP OVER MOD -DUP 0=
Q  UNTIL ;
Q ( 128 1024 NWP . CR )               
Q ( 324  556 NWP . CR )               
Q ( 1933 821 NWP . CR ) ;S

PREPARE
Q ( 1/1 FIBO,DFIBO,KWADRAT,... )
Q : FIBO ( n --- ) ( max n: 23 )
Q   0 1 ROT 0 CR DO
Q     DUP 10 .R CR SWAP OVER + LOOP ;  
Q : DFIBO ( n --- ) ( max n: 46 )
Q   0. ROT 1. ROT 0 CR DO       
Q     2DUP 14 D.R CR
Q     2SWAP 2OVER D+ LOOP ;   
Q : KWADRAT2 DUP * ;
Q : KWADRAT3
Q   DO I KWADRAT2 DUP 32760
Q     IF DROP LEAVE THEN
Q   . LOOP ;
Q : TEST1 51 1 DO I . 2 +LOOP ;
Q : TEST2 0 20 DO I . -1 +LOOP ; ;S

PREPARE
Q ( 1/1 TABLICZKA )
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
Q  TABLICZKA ;S

PREPARE
Q ( 1/1 TABLICZKA2 )
Q : J R> R> R> R R# ! >R >R >R R# @ ; 
Q : TAB2 ( -- ) 125 EMIT
Q   CR CR 8 SPACES 
Q   ." TABLICZKA MNOZENIA"
Q   CR CR 3 SPACES
Q   10 1 DO I 3 .R LOOP CR
Q   30 0 DO ." _" LOOP CR 
Q   10 1 DO
Q     I . ." |" 10 1 DO
Q       I J * 3 .R
Q     LOOP CR
Q   LOOP ; : TABLICZKA2 TAB2 ;
V
Q TABLICZKA2 ;S

PREPARE
Q ( 1/2 ERATOS - WSTAW, USUN )
Q 0 VARIABLE ERATOS 254 ALLOT
Q : WSTAW ( adr --- ) 256 1 DO 
Q    I OVER C! 1+ LOOP DROP ;
Q : USUN ( n --- ) 256 OVER DO
Q     I 1 - ERATOS + 0 SWAP C!
Q     DUP +LOOP DROP ;
Q -->

PREPARE
Q ( 2/2 ERATOS - PIERWSZE )
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

PREPARE
Q ( 1/1 NAZWISKO?, DRUKUJ, INPUT, DATY )
Q : QUERY TIB @ 80 EXPECT 0 IN ! ; 
Q : NAZWISKO?
Q   CR ." PODAJ SWOJE NAZWISKO: "
Q   CR QUERY 155 WORD HERE ; 
Q : DRUKUJ NAZWISKO? CR COUNT TYPE ;
Q : INPUT CR QUERY BL WORD HERE
Q   NUMBER DROP ; 
Q : DATY <BUILDS , , , DOES>          ( n n n --- )
Q   DUP 2+ DUP 2+ ? ? ? CR ;
Q 12  9 1683 DATY WIEDEN               4  4 1794 DATY RACLAWICE
Q 18  6 1815 DATY WATERLOO             1  9 1870 DATY SEDAN
Q 12 10 1943 DATY LENINO              15 08 1920 DATY WARSZAWA
Q ( WARSZAWA ) ;S 

PREPARE
Q ( 1/1 SILNIA,SILNIA2,... )
Q : TENKOD ( -- n ) CURRENT @ @
Q   PFA CFA ; IMMEDIATE
Q : SILNIA ( n -- ) 
Q   1 SWAP 1+ 1 DO I * LOOP ;
Q : SILNIA2 ( n -- ) DUP 2 = IF ELSE 
Q     DUP 1 - TENKOD LITERAL EXECUTE 
Q   * THEN ;
Q : SILNIA3 ( n -- ) [ SMUDGE ]
Q   DUP 2 = IF ELSE DUP 1 - SILNIA3 *
Q   THEN [ SMUDGE ] ;
Q : FACTORIAL ( J. BIELECKI "FORTH" )
Q   DUP IF DUP 1 - [ SMUDGE ] FACTORIAL 
Q   [ SMUDGE ] * ELSE 1+ THEN ;
Q 8 SILNIA  U.  8 SILNIA2 U. ( NIE 1.4S )
Q 8 SILNIA3 U.  8 FACTORIAL U. ;S

PREPARE
Q ( 1/1 ARRAY, 2DARRAY )
Q : ARRAY <BUILDS 2 * ALLOT DOES>
Q   SWAP 2 * + ;
Q : 2DARRAY
Q   <BUILDS DUP , * 2 * ALLOT DOES>
Q   ROT OVER @ + ROT + 2 * + 2+ ;
V
Q 10 ARRAY LICZBY
Q 7 LICZBY 7 LICZBY ! 7 LICZBY @ .
V
Q 4 5 2DARRAY PROSTOKAT
Q ( TODO: przyklady uzycia ) ;S

PREPARE
Q ( 1/1 MATDEF - valFORTH ) 
Q : 0> 0 MAX ; 
Q : MATDEF <BUILDS OVER OVER           SWAP , , * 2 * ALLOT
Q    DOES> >R OVER OVER R @ R          2 + @ ROT - 0> ROT
Q    ROT - 0< * IF R @ * + 2 *         R> 4 + + 
Q    ELSE R> DROP DROP DROP            ." ZLE WSKAZNIKI" THEN ;
Q 2 3 MATDEF MATRIX2                   CR CR
Q 11 0 0 MATRIX2 C!                    22 0 1 MATRIX2 C!
Q 33 1 0 MATRIX2 C!                    44 1 1 MATRIX2 C!
Q 55 0 2 MATRIX2 C!                    66 1 2 MATRIX2 C!
Q 77 2 3 MATRIX2 C! ( PRZEKROCZONE )
Q    0 0 MATRIX2 C@                    . CR  0 1 MATRIX2 C@ . CR
Q    1 0 MATRIX2 C@                    . CR  1 1 MATRIX2 C@ . CR
Q    0 2 MATRIX2 C@                    . CR  1 2 MATRIX2 C@ . CR
Q CR ;S

PREPARE
Q ( 1/1 ARRAY2, ARRAY3 [JB] )
Q : ARRAY2 ( n n --- )                 ( n n ARRAY2 matrix )
Q   <BUILDS OVER , * ALLOT DOES>       DUP @ ROT * + + 2+ ;
Q : ARRAY3 ( n n --- )     <BUILDS     ( n n ARRAY2 matrix )
Q   OVER C, DUP C, * ALLOT   DOES>     1+ ROT OVER C@ * + + 1+ ;
Q 2 3 ARRAY2 MATRIX   2 3 ARRAY3 BUF     
Q 11 0 0 MATRIX C!                     22 0 1 MATRIX C!
Q 33 1 0 MATRIX C!                     44 1 1 MATRIX C!
Q 55 0 2 MATRIX C!                     66 1 2 MATRIX C!
Q    0 0 MATRIX C@ . CR                0 1 MATRIX C@ . CR
Q    1 0 MATRIX C@ . CR                1 1 MATRIX C@ . CR
Q    0 2 MATRIX C@ . CR                1 2 MATRIX C@ . CR CR
Q 13 2 1 BUF C!                        2 1 BUF C@ .    CR ;S

PREPARE
Q ( 1/1 SETNE, SEXTAL, XX, SEK )
Q DECIMAL
Q : SETNE <# # # 46 HOLD #S #> TYPE ;
V
Q 123489. SETNE ( 1234.89 )
Q : SEXTAL 6 BASE ! ;
Q : XX # SEXTAL # DECIMAL 58 HOLD ;
Q : SEK ( n --- ) 
Q   CR <# XX XX #S #> TYPE CR ;
V
Q 15610. SEK
Q CR ;S

PREPARE
Q ( 1/2 DBL - D*, FIX, F. )  
Q 0 VARIABLE A_  0 VARIABLE B_        0 VARIABLE C_  0 VARIABLE D_
Q : D* A_ ! B_ ! C_ ! D_ !            ( "COMPLETE FORTH" )
Q   D_ @ B_ A_ U* D_ @ A_ @ U* DROP + C_ @ B_ @ U* DROP + ; 
Q   ( TODO: FD-V03N2.pdf: -- : D* DUP ROT * ROT ROT U* ROT + ; )
Q : FIX DPL @ 0< IF                   ( jezeli liczba byla pojed.
Q     S->D 0 DPL !                    ( przeksztalca ja w podw. )
Q   THEN
Q   DPL @ DUP 4 < IF 4 SWAP           DO 10. D* LOOP 
Q   ELSE
Q     4 > IF ." Poza zakresem" 2DROP  THEN THEN ; 
Q : F. SWAP OVER DABS
Q  <# # # # # 46 HOLD #S SIGN #> TYPE SPACE ;
Q -->

PREPARE
Q ( 2/2 DBL - UD.,D-,D0=,D0<,D= )  
Q : UD. <# #S #> TYPE ;
Q : D- DMINUS D+ ;
Q : D0= OR 0= ;                       ( test na liczbę podw. 0 )
Q : D0< SWAP DROP 0< ;                ( " ujemna liczbę podw. )
Q : D= D- D0= ;                       ( " rownosc dwoch liczb podw. )
V
Q 0.04 FIX        0.3 FIX D+ 
Q 0.625 FIX D+ 0.0001 FIX D+ 
Q 10 FIX D+  ( BUG: cos tu sie wywala !! ) 
Q F. 10.9651 
Q CR ;S

PREPARE
Q ( 1/1 WIEZE Z HANOI )
Q : 3DUP >R 2DUP R ROT ROT R> ;
Q : TAM 3DUP ROT ROT OVER + 6 SWAP -
Q   ROT 1 - ;
Q : Z.POWROTEM 
Q   3DUP SWAP ROT OVER + 6 SWAP -
Q   SWAP ROT 1 - ;
Q : DRUKUJ 3DUP DROP SWAP
Q   . ." NA " . ." ," ;
Q : WIEZE [ SMUDGE ] DUP IF 
Q     TAM WIEZE DRUKUJ
Q     Z.POWROTEM WIEZE 
Q   THEN DROP DROP DROP [ SMUDGE ] ;   
Q : HANOI 1 3 ROT CR WIEZE ;           ( n -- )
Q 5 HANOI           ;S                 ( Patrz tez: FD II/2 p. 32 )

PREPARE
Q ( 1/5 HETMANY:WEKTOR,LHET,... )
Q 0 VARIABLE ROZWIAZANIE
Q : WEKTOR
Q   <BUILDS HERE OVER ERASE ALLOT
Q   DOES> + ;
Q 1024 WEKTOR WSPOLRZEDNA
Q : LHET ( --- liczba hetmanów+1 )
Q   0 WSPOLRZEDNA C@ ;
Q : POSTAW ( rząd kolumna --- )
Q   SWAP WSPOLRZEDNA C! ;              ( umieszcza hetmana )
Q : USUN ( rząd --- )
Q   0 POSTAW ;                         ( kasuje hetmana )
Q -->

PREPARE
Q ( 2/5 HETMANY:WOLNE,... )
Q : WOLNE                              ( rząd n --- rząd f )
Q   2DUP = >R
Q   OVER WSPOLRZEDNA C@
Q   OVER WSPOLRZEDNA C@ -
Q   ROT ROT - ABS OVER ABS =
Q   SWAP 0= OR 0=
Q   R> OR ;
Q : WSZYSTKIE-WOLNE                    ( rząd --- rząd f )
Q   1 OVER 1 DO
Q     OVER I WOLNE AND
Q   LOOP ;
Q -->

PREPARE
Q ( 3/5 HETMANY:BRZEG,DRUK,INIC )
Q : BRZEG ( rząd --- rząd f )
Q  LHET OVER WSPOLRZEDNA C@ > ;
Q : DRUK ( --- ) CR LHET 1 DO
Q     I WSPOLRZEDNA C@ LHET 1
Q     DO DUP I =
Q       IF ." X " ELSE ." . " THEN
Q     LOOP DROP CR LOOP
Q   1 ROZWIAZANIE +! CR ." Rozwiazanie nr "
Q   ROZWIAZANIE ?    CR ;
Q : INIC ( --- )                       ( inic. sz. z hetm. w rz. 0 ) 
Q   LHET 1 DO I USUN LOOP 0 ROZWIAZANIE ! ;
Q -->

PREPARE
Q ( 4/5 HETMANY:NAPRZOD,... )
Q : NAPRZOD ( rzad --- rzad f )       ( f=1, gdy het. w rz. "rzad" )
Q                                     ( mozna przes. do nast. kol. )
Q   DUP DUP WSPOLRZEDNA
Q   C@ 1+ POSTAW BRZEG
Q   IF 1 ELSE DUP USUN 0 THEN ;
Q : PIERWSZA-WOLNA ( rz --- rz f )    ( f=1,gdy hetman moze )
Q                                     ( przejsc do nast. kol. w rz )
Q  BEGIN
Q    NAPRZOD
Q    IF WSZYSTKIE-WOLNE -DUP
Q    ELSE 0 1 THEN
Q  UNTIL ;
Q -->

PREPARE
Q ( 5/5 HETMANY:POZYCJA,HETMANY )
Q : POZYCJA ( rzad --- f )
Q   [ SMUDGE ]
Q     LHET OVER > IF
Q       BEGIN
Q         PIERWSZA-WOLNA IF
Q	    1+ POZYCJA -DUP
Q	  ELSE
Q	    1 - 0 1
Q         THEN
Q      UNTIL
Q    ELSE DRUK 1 - 0 THEN
Q  [ SMUDGE ] ;
Q : HETMANY ( --- )
Q   9 0 SWAP POSTAW INIC
Q   1 POZYCJA 2 DROP ;        ;S

PREPARE
Q ( 1/1 LICZBY ZESPOLONE )
Q : COMPLEX <BUILDS , ,  DOES> ; 
Q : X@ DUP @ SWAP 2+ @ SWAP  ;
Q : X! SWAP OVER ! 2+ ! ;
Q : X+ ROT + >R + R> ;
Q : X- ROT SWAP - >R - R> ;
Q : X*' SWAP OVER * ROT ROT * SWAP ;
Q : X*
Q   2OVER 2OVER ROT
Q   * >R * R> - >R ROT ROT
Q   * >R * R> + R> SWAP ;
Q : TEST-COMPLEX 3 2 1 7 X* . .  ; 
V
Q CR TEST-COMPLEX CR ( -11 23 ok ) ;S     
  
PREPARE 
Q ( 1/2 FN TRYGONOMETRYCZNE - APX/1.4S )
Q : TABLICA <BUILDS 0 ,
Q  174 , 348  ,  522 ,  696 ,  870 , 1044 , 1218 , 1390 , 1564 , 
Q 1736 , 1908 , 2078 , 2248 , 2418 , 2588 , 2756 , 2922 , 3090 , 
Q 3254 , 3420 , 3582 , 3746 , 3906 , 4066 , 4226 , 4382 , 4538 , 
Q 4694 , 4848 , 5000 , 5150 , 5298 , 5446 , 5590 , 5734 , 5876 , 
Q 6018 , 6156 , 6292 , 6426 , 6560 , 6690 , 6818 , 6946 , 7070 , 
Q 7192 , 7312 , 7430 , 7546 , 7660 , 7770 , 7880 , 7986 , 8090 , 
Q 8190 , 8290 , 8386 , 8480 , 8570 , 8660 , 8746 , 8828 , 8910 , 
Q 8986 , 9062 , 9134 , 9204 , 9270 , 9334 , 9396 , 9454 , 9510 ,
Q 9562 , 9612 , 9658 , 9702 , 9742 , 9780 , 9816 , 9848 , 9876 ,
Q 9902 , 9924 , 9944 , 9960 , 9974 , 9986 , 9992 , 9998 , 10000 ,
Q DOES> SWAP 2 * + @ ;
Q 91 TABLICA SINTABLICA -->

PREPARE
Q ( 2/2 FN FUNKCJE [FIXED] )
Q : S180 DUP 90 > IF 180 SWAP -        THEN SINTABLICA ;
Q : SIN 360 MOD DUP 0< IF 360 +        THEN DUP 180 > IF 
Q     180 - S180 MINUS ELSE S180       THEN ;
Q : COS 90 + SIN ;
Q : TAN DUP SIN SWAP COS DUP ABS 2920
Q   > IF 10000 SWAP */  ELSE DROP      DROP ." ZA DUZE! " THEN ;
Q CR
Q  0 SIN . (     0 )                   90 SIN . ( 10000 ) 
Q 45 SIN . (  7070 )                   44 SIN . (  6946 )
Q 44 TAN . (  9657 )                   46 SIN . (  7192 )
Q 45 SIN . (  7070 )                   30 SIN . (  5000 )
Q 89 SIN . (  9998 )                   0 TAN .  (     0 )
Q 30 TAN . (  5773 )                   45 TAN . ( 10000 )
Q 30 COS . (  8660 )                   CR ;S

PREPARE
Q ( 1/5 LIFE:ARRAY,UNIVERSUM,J )
Q 10 CONSTANT DIMX
Q 10 CONSTANT DIMY
Q : ARRAY                              ( dimX dimY --- )
Q   <BUILDS                            
Q     OVER ,                           ( dimY pod adresem pfa+2 )
Q     * ALLOT                          ( dimX*dimY bajtów )
Q   DOES>                              
Q   DUP @                              ( dimX na stosie )
Q   ROT *                              ( dimY*dimX )
Q   + + 2+ ;                           ( bezwzgledny adres komorki )
Q DIMX DIMY ARRAY UNIVERSUM
Q : HOME 125 EMIT ;
Q : J R> R> R> R R# !
Q   >R >R >R R# @ ; -->

PREPARE
Q ( 2/5 LIFE:WSTAW,USUN,ZERUJ  )
Q : WSTAW ( indX indY --- )
Q   UNIVERSUM 1 SWAP C! ;
Q : USUN ( indX indY --- )
Q   UNIVERSUM 0 SWAP C! ;
Q : ZERUJ ( --- )
Q   DIMY 0 DO
Q     DIMX 0 DO I J USUN LOOP
Q   LOOP ;
Q : WERYFIKACJA                       ( liczba stanu sąsiadów --- )
Q  DUP 3 =                            ( liczba stanu f )
Q  IF DROP 2+ ELSE                    
Q    2 = 0=                           ( stan stan nr2 )
Q    IF 4 + THEN
Q  THEN ; -->
  
PREPARE
Q ( 3/5 LIFE:PRZYGOTOWANIE   )
Q : PRZYGOTOWANIE ( --- )
Q   DIMY 0 DO DIMX 0 DO
Q     0 J 2+ DIMY MIN	J 1 - 0 MAX    DO
Q	      J 2+ DIMX MIN J 1 - 0 MAX    DO
Q         I J UNIVERSUM C@ 1 AND +    ( 1+ *** chyba nie )
Q       LOOP                          
Q     LOOP                            
Q     I J UNIVERSUM C@ 1 AND          ( liczba sasiadow )
Q     SWAP OVER - WERYFIKACJA         ( koduje przyszlosc )
Q     I J UNIVERSUM C!                ( 1+ ** chyba nie )
Q     LOOP LOOP ; -->

PREPARE
Q ( 4/5 LIFE:DRUK,TWORZENIE   )
Q : DRUK ( --- )
Q   HOME DIMY 0 DO
Q     DIMX 0 DO
Q       I J UNIVERSUM C@
Q       IF ." *" ELSE SPACE THEN
Q     LOOP CR LOOP ;
Q : TWORZENIE
Q   DIMY 0 DO DIMX 0 DO
Q     I J UNIVERSUM DUP C@ DUP
Q     3 > IF DROP 0 ELSE
Q       DUP 1 > IF DROP 1 THEN
Q 	  THEN SWAP C!
Q   LOOP LOOP ; -->   

PREPARE
Q ( 5/5 LIFE:GRA,GRA1   )
Q : GRA ( n --- )
Q   0 DO
Q     DRUK   ( wysw. pokol. N )
Q     PRZYGOTOWANIE ( gasi pokol. N i zostawia dane dla nast. )
Q     TWORZENIE  ( tworzy pokol. N+1 )
Q   LOOP
Q   DRUK ; ( druk. ostatnie pokol. )
Q : GRA1 ( -- )
Q   BEGIN
Q     ?TERMINAL IF ;S THEN
Q     DRUK PRZYGOTOWANIE TWORZENIE
Q   AGAIN
Q   DRUK ; ;S

PREPARE
Q ( 1/7 SORT:ARRAY,WSTAW,POKAZ - APX/1.4S? )
Q : ARRAY <BUILDS 2 * ALLOT
Q   DOES> SWAP 2 * + ;
Q 5 ARRAY LICZBY
Q 0 VARIABLE NAST
Q : WSTAW 120 23 157 18 93
Q   5 0 DO I LICZBY ! LOOP ;
Q : POKAZ 5 0 DO I LICZBY ? LOOP ;
Q -->

PREPARE
Q ( 2/7 SORT:POROWNAJ )
Q : POROWNAJ ( n1 n2 --- )
Q   DUP      ( n1 n2 n2 )
Q   LICZBY @ ( n1 n2 L2 )
Q   ROT DUP  ( n2 L2 n1 n1 )
Q   LICZBY @ ( n2 L2 n1 L1 )
Q   ROT      ( n2 n1 L1 L2 )
Q   OVER     
Q   OVER ( n2 n1 L1 L2 L1 L2 )
Q   >    ( n2 n1 L1 L2 f )
Q   IF   ( n2 n1 L1 L2 )
Q     ROT      ( n2 L1 L2 n1 ) 
Q     LICZBY ! ( n2 Li )
Q     SWAP     ( L1 n2 )
Q     LICZBY ! ( --- )
Q   ELSE 2DROP 2DROP THEN ; -->

PREPARE
Q ( 3/7 SORT:PRZEJRZYJ,EXSORT )
Q : PRZEJRZYJ DUP 1+ NAST !
Q   BEGIN OVER 1+ NAST @ >
Q   WHILE DUP NAST @ POROWNAJ
Q   NAST @ 1+ NAST ! REPEAT
Q   2DROP ;
Q : EXSORT ( n1 n2 -- )
Q   BEGIN OVER OVER
Q     PRZEJRZYJ 1+ OVER OVER
Q   = UNTIL 2DROP ;
Q WSTAW 4 0 EXSORT
Q CR ." EXSORT: " CR POKAZ CR -->

PREPARE
Q ( 4/7 SORT:PORBUB,..,BUBSORT )
Q 0 VARIABLE KONIEC?
Q : PORBUB ( n1 n2 -- )
Q   DUP LICZBY @ ROT DUP LICZBY @
Q   ROT OVER OVER >
Q   IF ROT LICZBY ! SWAP LICZBY !
Q 	0 KONIEC? ! ELSE 2DROP 2DROP THEN ;
Q : PRZESUN BEGIN
Q     DUP DUP 1+ PORBUB 1+ 
Q   OVER OVER = UNTIL DROP DROP ;
Q : BUBSORT BEGIN 1 KONIEC?
Q     ! OVER OVER PRZESUN
Q   KONIEC? @ UNTIL 2DROP ;
Q WSTAW 4 0 BUBSORT
Q CR ." BUBSORT: " CR POKAZ CR -->

PREPARE
Q ( 5/7 SORT:WSTAW,LEWY,PRAWY )
Q 0 VARIABLE POCZ  0 VARIABLE KON
Q 0 VARIABLE LW    0 VARIABLE PW
Q : POCZATEK WSTAW ;
Q : LEWY BEGIN
Q     DUP LW @ LICZBY @
Q   > WHILE LW @ 1+ LW !
Q   REPEAT DROP ;
Q : PRAWY BEGIN
Q     DUP PW @ LICZBY @
Q   < WHILE PW @
Q     1 - PW !
Q   REPEAT DROP ;
Q : CZYTAJ @ LICZBY @ ;
Q : WSTAW @ LICZBY ! ; -->

PREPARE
Q ( 6/7 SORT:ZAM,SORTUJ,KOMPARAND )
Q : ZAM
Q   LW CZYTAJ PW CZYTAJ
Q   LW WSTAW PW WSTAW
Q   LW @ 1+ LW ! PW @ 1 - PW ! ;
Q : SORTUJ BEGIN
Q     DUP DUP LEWY PRAWY
Q 	LW @ PW @ > DUP
Q 	IF ELSE ZAM THEN
Q   UNTIL DROP ;
Q : KOMPARAND
Q   OVER OVER LW ! PW ! + 2 /
Q   LICZBY @ ;
Q -->  
  
PREPARE
Q ( 7/7 SORT:QUICK,QUICKSORT )
Q : QUICK [ SMUDGE ]
Q    KOMPARAND SORTUJ 
Q    POCZ @ PW @ <
Q    IF
Q      PW @ DUP KON ! POCZ @ QUICK
Q    THEN
Q    LW @ KON @ < IF
Q      KON @ LW @ DUP POCZ ! QUICK
Q    THEN [ SMUDGE ] ;
Q : QUICKSORT
Q   OVER OVER POCZ ! KON ! QUICK ;
Q POCZATEK 4 0 QUICKSORT CR
Q ." QUICKSORT: " CR POKAZ CR ;S



54 DUP CLEAR SCR !
0 P ( 1/4 PSY RASOWE ) -->
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
12 P pekinczyk 28

55 DUP CLEAR SCR !
0 P ( 2/4 CECHY PSOW ) -->
1 P Czy ma:
2 P 1 wiecej niż 60 cm wzrostu?
3 P 2 wydluzona glowe?
4 P 3 kwadratowy lub plaski pysk?
5 P 4 obfita siersc?
6 P 5 dlugi wlos?
7 P 6 stojace lub przyciete uszy?
8 P 7 dlugie uszy?
9 P 8 krepa lub mocna budowe?

56 DUP CLEAR SCR !
 0 P ( 3/4 PSY ) : HOME 125 EMIT ;
 1 P : #PSY 54 ; : #CECHY 55 ;         
 2 P : CARRAY <BUILDS ALLOT DOES> + ;
 3 P 15 CARRAY CECHY : X CECHY C! ;
 4 P  165 0 X 98  1 X 163  2 X 35  3 X
 5 P  221 4 X 171 5 X 46   6 X 27  7 X
 6 P  194 8 X 32  9 X 172 10 X 28 11 X
 7 P 0 VARIABLE BAJT
 8 P : BITY 1 SWAP 0 DO 2 * LOOP 
 9 P   2 / BAJT @ OR BAJT ! ;
10 P : WLASNOSCI 0 BAJT ! BEGIN
11 P     QUERY BL WORD HERE NUMBER
12 P     DROP DUP MINUS 0<
13 P   WHILE 1 SWAP BITY CR DROP
14 P   REPEAT ; 
15 P -->

57 DUP CLEAR SCR !
 0 P ( 4/4 PSY )
 1 P : DAJ BAJT @ 12 0 DO
 2 P     DUP I CECHY C@ OR          ( !! XOR/OR zmienia tryb? )
 3 P     0= IF
 4 P       I 1+ #PSY .LINE CR
 5 P     THEN
 6 P   LOOP DROP ;
 7 P : PSY ( -- ) HOME 12 1 DO
 8 P     I #CECHY .LINE CR
 9 P   LOOP CR ." Napisz liczby:"
10 P   CR WLASNOSCI CR CR
11 P   CR ." To moze byc:"
12 P   CR DAJ DROP ;
13 P PSY ( .. 6 0 - ratler 32 )
14 P ;S  ( .. 2 3 4 6 0 - foks. 46 )

( TODO: nie znajduje foksa! )

58 #SC !

PREPARE
Q ( 1/2 FIG-EDITOR, mini subset )     ( FD III/2 p.40 )
Q ( First set edit screen: m SCR ! )  (  to edit line n: n P ccc  )
Q HEX VOCABULARY EDITOR               EDITOR DEFINITIONS
Q : TEXT HERE C/L 1+ BLANKS WORD      HERE PAD C/L 1+ CMOVE ; 
Q : LINE DUP FFF0 AND 17 ?ERROR       SCR @ (LINE) DROP ; 
Q : MARK 10 0 DO I LINE UPDATE        DROP LOOP ;
Q : -MOVE LINE C/L CMOVE UPDATE ;     : P 1 TEXT PAD 1+ SWAP -MOVE ; 
Q : E LINE C/L BLANKS UPDATE ;        : TOP 0 R# ! ; 
Q : #LOCATE R# @ C/L /MOD ;           : #LEAD #LOCATE LINE SWAP ;
Q : #LAG  #LEAD DUP >R + C/L R> - ;
Q : M R# +! CR SPACE #LEAD TYPE 17    EMIT #LAG TYPE #LOCATE . DROP ;
Q : 1LINE #LAG PAD COUNT MATCH R# +!  ;
Q : CLEAR  SCR ! 10 0                 DO FORTH I EDITOR E LOOP ; 
Q CR ." EDITOR subset (incl. P, E) loaded."       CR DECIMAL -->

PREPARE
Q ( 2/2 SEARCH/WHERE w/ EDITOR wrds ) ( FD Vol03 Nr1 /WFR )
Q HEX 00 VARIABLE SRCHCNT  
Q : WHERE DUP B/SCR / DUP SCR ! ."    SCR # " DECIMAL .
Q   SWAP C/L /MOD C/L * ROT BLOCK +   CR C/L -TRAILING
Q   TYPE CR HERE C@ - SPACES 1 2FE C! 1C EMIT 0 2FE
Q   C! [COMPILE] EDITOR QUIT ;        DECIMAL
Q : BUMP ( ln nr and paging )         1 SRCHCNT +! SRCHCNT @ 56 
Q   > IF 0 SRCHCNT ! CR THEN ; 
Q : SEARCH ( FROM TO -- STRING )      CR 01 TEXT 0 SRCHCNT !
Q   1+ SWAP DO FORTH I SCR ! EDITOR   TOP BEGIN
Q     1LINE IF 0 M SCR ? BUMP THEN    1023 R# @ < UNTIL LOOP ; 
Q CR ." SEARCH (uppercase only) loaded." CR 
Q ." Usage: 21 44 SEARCH KEYWORD"     CR CR FORTH ;S

( >> https://github.com/BartGo/forth-atari/blob/main/DBGTOOLS.4TH )



( >> https://github.com/BartGo/forth-atari/blob/main/EDIT.4TH )

60 CLEAR
  0 P ( EDIT - BY M. DOUGHERTY )       ( APX FORTH ONLY )
  1 P : TASK ; 752 CONSTANT CRSINH     70 CONSTANT #HLP 
  2 P 0  VARIABLE CLINE                0 VARIABLE CCHAR
  3 P 3  VARIABLE LINEOFF              3 VARIABLE CHAROFF
  4 P 18 CONSTANT TOP-BOT              2 CONSTANT REDGE
  5 P 22 CONSTANT LEDGE                0 VARIABLE SIDE 
  6 P 17 VARIABLE EXTRAOFF             0 VARIABLE STOP
  7 P 0  VARIABLE SAV-BUF  64 ALLOT 
  8 P : EREAD 16 0 DO I SCR @ (LINE)   DROP
  9 P   UPDATE DROP LOOP 0 CLINE !
 10 P   0 CCHAR ! 0 SIDE ! ; 
 11 P : CLS 125 EMIT ; : ECLEAR CLS 1  CRSINH C! ; 
 12 P : POINT-CURSOR 85 ! 84 C! ;
 13 P : CURSOR@ CLINE @ LINEOFF @ +
 14 P   CCHAR @ SIDE @ IF 32 - ENDIF   CHAROFF @ + ;
 15 P : CURSOR CURSOR@ POINT-CURSOR ;  -->
61 CLEAR
  0 P ( EDIT - SCREEN-CURSOR, ..., TOP ) 
  1 P : SCREEN-CURSOR CURSOR@ SWAP 40 * + 106 C@ 256 *
  2 P  960 - + DUP C@ 128 XOR SWAP C! ;
  3 P : HLINE 34 0 DO TOP-BOT EMIT LOOP ;
  4 P : LADDR CLINE @ SCR @ (LINE) DROP
  5 P  SIDE @ IF 32 + ENDIF ;
  6 P : EADDR CLINE @ SCR @ (LINE) DROP
  7 P  SIDE @ 0= IF 32 + ENDIF ;
  8 P : ELINE LEDGE EMIT LADDR 32 TYPE REDGE EMIT ;
  9 P : XLINE LEDGE EMIT EADDR 32 TYPE REDGE EMIT ;
 10 P : WRITE-LINE CLINE @ LINEOFF @ + CHAROFF @ 1 -
 11 P  POINT-CURSOR ELINE ;
 12 P : WRITE-EXTRA EXTRAOFF @ LINEOFF @ + CHAROFF @ 1 -
 13 P  POINT-CURSOR XLINE ; : FRE 741 @ HERE - 1024 / ;
 14 P : TOP LINEOFF @ 1 - CHAROFF @ 1 -
 15 P  POINT-CURSOR HLINE ;  -->
62 CLEAR 
  0 P ( EDIT - DISPLAY, CASE )
  1 P : BOT LINEOFF @ 16 + CHAROFF @ 1 -
  2 P  POINT-CURSOR HLINE ; 
  3 P : ETITLE 0 CHAROFF @ POINT-CURSOR
  4 P  ." EDIT / Dr" OFFSET @ 0= 0= . ." Scr" SCR ?
  5 P  ." Side" SIDE ? ." / Free " FRE U. ; ( BUG? )
  6 P : DISPLAY ECLEAR ETITLE TOP CLINE @ 16 0 DO
  7 P  I CLINE ! WRITE-LINE LOOP CLINE !
  8 P  SIDE @ IF 32 ELSE 0 ENDIF CCHAR ! BOT
  9 P  WRITE-EXTRA CURSOR SCREEN-CURSOR ;
 10 P : CASES ?COMP CSP @ !CSP 4 ; IMMEDIATE
 11 P : CASE 4 ?PAIRS COMPILE OVER COMPILE =
 12 P  COMPILE 0BRANCH HERE 0 , COMPILE DROP 5 ; IMMEDIATE
 13 P : IS 5 ?PAIRS COMPILE BRANCH HERE 0 ,
 14 P  SWAP 2 [COMPILE] ENDIF 4 ; IMMEDIATE
 15 P : ANYK CR ." (Return)" KEY DROP ; -->
63 CLEAR
  0 P ( EDIT - CASE, MOVEMENT )
  1 P : CEND 4 ?PAIRS COMPILE DROP
  2 P   BEGIN SP@ CSP @ = 0= WHILE
  3 P   2 [COMPILE] ENDIF REPEAT
  4 P   CSP ! ; IMMEDIATE
  5 P : MOVE-RIGHT CCHAR @ 1 + SIDE @ IF
  6 P   DUP 64 = IF DROP 32 ENDIF ELSE
  7 P   DUP 32 = IF DROP 0  ENDIF ENDIF
  8 P   CCHAR ! ;
  9 P : RIGHT MOVE-RIGHT SCREEN-CURSOR ;
 10 P : RIGHT-CURSOR SCREEN-CURSOR RIGHT ;
 11 P : MOVE-LEFT CCHAR @ 1 - SIDE @ IF
 12 P  DUP 31 = IF DROP 63 ENDIF ELSE
 13 P  DUP -1 = IF DROP 31 ENDIF ENDIF
 14 P  CCHAR ! ; 
 15 P : LEFT MOVE-LEFT SCREEN-CURSOR ; -->
64 CLEAR 
  0 P ( EDIT - MOVEMENT, KEYJOY )
  1 P : LEFT-CURSOR SCREEN-CURSOR LEFT ;
  2 P : MOVE-UP CLINE @ 1 - 15 AND
  3 P   CLINE ! WRITE-EXTRA ;
  4 P : EUP MOVE-UP SCREEN-CURSOR ;
  5 P : UP-CURSOR SCREEN-CURSOR EUP ;
  6 P : MOVE-DOWN CLINE @ 1 + 15 AND
  7 P   CLINE ! WRITE-EXTRA ;
  8 P : DOWN MOVE-DOWN SCREEN-CURSOR ;
  9 P : DOWN-CURSOR SCREEN-CURSOR DOWN ;
 10 P : RETURN SCREEN-CURSOR SIDE @ IF
 11 P   32 ELSE 0 ENDIF CCHAR ! DOWN ;
 12 P : EABORT EMPTY-BUFFERS 1 STOP ! ;
 13 P : KEYJOY 632 C@ CASES 15 CASE KEY IS
 14 P   11 CASE 30 IS 7 CASE 31 IS 14 CASE 28 IS 
 15 P   13 CASE 29 IS CEND ; -->
65 CLEAR
  0 P ( EDIT - REFORTH, SCREEN NAVG, HELP )
  1 P : SH CLS 0 CRSINH C! IN @ >R BLK @ >R 0 IN ! 
  2 P   0 BLK ! CR QUERY INTERPRET R> BLK ! R> IN ! ANYK ; 
  3 P : ENEXT FLUSH SCR @ 1 + SCR ! EREAD DISPLAY ;
  4 P : ELAST FLUSH SCR @ 1 - SCR ! EREAD DISPLAY ;  
  5 P : ADDR CLINE @ SCR @ (LINE) DROP
  6 P   CCHAR @ + ; #HLP VARIABLE HLPM ( BEFORE HLP )
  7 P : ADDKEY DUP ADDR C! CURSOR EMIT RIGHT ;
  8 P : CHANGE-SIDE SIDE @ 1 XOR SIDE ! DISPLAY ;
  9 P : INSERT-CHAR ADDR SWAP CCHAR @ -
 10 P   SWAP OVER + SWAP -DUP IF 0 DO
 11 P   DUP 1 - C@ OVER C! 1 - LOOP
 12 P   ENDIF BL SWAP C! ; : INSERT SIDE @ IF
 13 P   63 ELSE 31 ENDIF INSERT-CHAR WRITE-LINE
 14 P   CURSOR SCREEN-CURSOR ; : HLP SCR @ 70 = IF
 15 P   HLPM @ SCR ! ELSE SCR @ HLPM ! #HLP SCR ! ENDIF ; -->
66 CLEAR
  0 P ( EDIT - DELETE, INSERT )
  1 P : DELETE-CHAR ADDR SWAP CCHAR @ -
  2 P   -DUP IF 0 DO DUP 1 + C@ OVER C!
  3 P   1 + LOOP ENDIF BL SWAP C! ;
  4 P : DELETE SIDE @ IF 63 ELSE 31 ENDIF
  5 P   DELETE-CHAR WRITE-LINE CURSOR SCREEN-CURSOR ;
  6 P : L-A SCR @ (LINE) DROP ;
  7 P : DELETE-L CLINE @ L-A SAV-BUF 64 CMOVE
  8 P   15 CLINE @ - IF 15 CLINE @ DO
  9 P   I 1+ L-A I L-A 64 CMOVE LOOP ENDIF
 10 P   15 L-A 64 BLANKS ;
 11 P : INSERT-L 15 CLINE @ - IF
 12 P   CLINE @ 15 DO I 1 - L-A I L-A 64 CMOVE
 13 P   -1 +LOOP ENDIF CLINE @ L-A 64 BLANKS ;
 14 P : INSERT-LINE INSERT-L DISPLAY ;
 15 P : DELETE-LINE DELETE-L DISPLAY ; -->
67 CLEAR 
  0 P ( EDIT - PUTLINE, TAB )
  1 P : PUT-LINE INSERT-L SAV-BUF CLINE @
  2 P   L-A 64 CMOVE DISPLAY ;
  3 P : TAB 2 0 DO RIGHT-CURSOR LOOP ;
  4 P : DEL LEFT-CURSOR BL DUP ADDR C!
  5 P   CURSOR EMIT SCREEN-CURSOR ;
  6 P : CLEAR-SCR 16 0 DO I L-A 64 BLANKS
  7 P   LOOP DISPLAY ; 
  8 P ( empty )
  9 P ( empty )
 10 P ( empty )
 11 P ( empty )
 12 P ( empty )
 13 P ( empty )
 14 P ( empty )
 15 P -->
68 CLEAR
  0 P ( EDIT - COMMANDS )
  1 P : REVB 712 @ 128 XOR 712 ! ; ( CLR4 )
  2 P : ESC REVB KEY CASES        
  3 P     82 CASE CHANGE-SIDE IS ( R )
  4 P     78 CASE ENEXT       IS ( N )
  5 P     76 CASE ELAST       IS ( L )
  6 P     83 CASE FLUSH       IS ( S )
  7 P     81 CASE EABORT      IS ( Q )
  8 P     86 CASE PUT-LINE    IS ( V )
  9 P     90 CASE EMPTY-BUFFERS DISPLAY IS ( Z ) 
 10 P     66 CASE SH DISPLAY  IS ( B )             
 11 P     48 CASE BOOT        IS ( 0 ) 
 12 P     72 CASE HLP DISPLAY IS ( H )          
 13 P   BEEP CEND REVB ;
 14 P : DEPTH SP@ 12 +ORIGIN @ SWAP - 2 / ;
 15 P : SETSCR DEPTH 0= IF #HLP ENDIF SCR ! ;  -->
69 CLEAR
  0 P ( EDIT - MAIN, END. ) : EDIT ( n -- ) 
  1 P SETSCR EREAD DISPLAY 0 STOP ! BEGIN 
  2 P   KEYJOY CASES 27 CASE ESC IS 
  3 P   28 CASE UP-CURSOR IS
  4 P   29 CASE DOWN-CURSOR IS
  5 P   31 CASE RIGHT-CURSOR IS
  6 P   30 CASE LEFT-CURSOR IS
  7 P   155 CASE RETURN IS
  8 P   255 CASE INSERT IS
  9 P   254 CASE DELETE IS
 10 P   157 CASE INSERT-LINE IS
 11 P   156 CASE DELETE-LINE IS
 12 P   126 CASE DEL IS 127 CASE TAB IS
 13 P   125 CASE CLEAR-SCR IS 
 14 P DUP ADDKEY CEND STOP @ UNTIL 
 15 P 125 EMIT 0 CRSINH ! ; : /EDIT ; ;S
70 CLEAR ( CONST #HLP = 70 )
  0 P ( EDIT - HELP ONLY, END. ) ;S
  2 P Arrows, Insert, BckSpc: standard
  3 P Return: next line, Tab: tab (2)
  4 P Clear: clear screen (Shf> Ctl>)
  5 P Esc-Z: undo scrn chn (empty-buf)
  6 P Shf-Insert: insert whole line*
  7 P Shf-Delete: delete whole line*
  8 P Ctl-Insert: insert space
  9 P Ctl-BckSpc: delete;  Esc-0: cold
 10 P Esc-R: rotate/sides; Esc-H: help
 11 P Esc-N: next screen, save (flush)
 12 P Esc-L: last screen, save (flush)
 13 P Esc-S: save (flush) ; Esc-B: 4th
 14 P Esc-Q: quit (empty-buf)
 15 P Esc-V: put last deleted line



71 CLEAR ( EDYTOR R. PANTOLY ZAJMIE 9-10 EKRANOW? APX ONLY )
         ( : C; CURRENT @ CONTEXT ! ?EXEC ?CSP SMUDGE ; IMMEDIATE   )
72 CLEAR ( + DEASSEMBLER? BLINKING CHARS JAKO PRZYKŁAD!    )
73 CLEAR
74 CLEAR
75 CLEAR 
76 CLEAR
77 CLEAR
78 CLEAR
79 CLEAR
80 CLEAR
81 CLEAR
82 CLEAR
83 CLEAR
84 CLEAR
85 CLEAR



86 SCR !
 0 P ( 1/2 GoesInto - Decomp by RDA - APX only? )
 1 P ( -- Forth Dimension Vol14 Nr2 )
 2 P   0 VARIABLE GIN 
 3 P : MYSELF LATEST PFA CFA , ; IMMEDIATE
 4 P : GIN+ CR GIN @ 2+ DUP GIN ! SPACES ;
 5 P : GCHK DUP @ 2+ ' COMPILE =
 6 P   IF  2+ DUP @ 2+ NFA ID. 2+
 7 P   ELSE DUP @ 2+ DUP ' LIT =
 8 P   OVER ' BRANCH  = OR OVER ' 0BRANCH = OR
 9 P   OVER ' (LOOP)  = OR SWAP ' (+LOOP) = OR
10 P   IF 2+ DUP @ SPACE . 2+ ELSE DUP @ 2+ ' CLIT =
11 P   IF 2+ DUP C@ SPACE . 1+ ELSE DUP @ 2+ 
12 P   ' (.") = IF 2+ DUP COUNT TYPE 
13 P   DUP C@ 1+ + ELSE 2+ THEN THEN THEN THEN 
14 P   -2 GIN +! ; 
15 P : DIN CR GIN @ SPACES ; -->

87 SCR !
 0 P ( 2/2 Use: "GOIN x" RET/SPC/Q ) 
 1 P : (GOESINTO) DUP CFA @ ' : CFA 
 2 P   @ = OVER ' ERROR = 0= AND
 3 P   IF BEGIN DUP @ DUP ' ;S CFA =
 4 P     OVER ' (;CODE) CFA = OR 0=
 5 P   WHILE 2+ DUP GIN+ NFA ID. KEY 
 6 P     DUP 81 = IF SP! QUIT ELSE 155 =
 7 P     IF MYSELF ELSE DROP THEN THEN
 8 P     GCHK REPEAT 2+ DIN NFA ID.
 9 P   THEN DROP ; ( 81=Q, 155=RETURN )
10 P : GOESINTO -FIND IF DROP 0 GIN !
11 P   (GOESINTO) ELSE ." NOT FOUND" CR THEN ;
12 E
13 P : GOIN GOESINTO ; 
14 E
15 P ;S 

88 CLEAR 88 SCR !
 0 P ( "Blinking Characters" RM COMPUTE 12/81 )
 1 P ( "39 LOAD" to load req. assembler /APX/ )
 2 P HEX CODE Blink ( -- )
 3 P   02F3 LDA,  2 # AND, 2 #  EOR,
 4 P   02F3 STA, 15 # LDA, 021A STA,
 5 P RTS,
 6 P CODE BlinkStart ( -- )
 7 P   15 # LDA, 021A STA,
 8 P NEXT JMP,
 9 P : BlinkInit ( -- ) ' Blink 228 ! ;
10 P : BlinkCursor ( -- ) BlinkInit BlinkStart ;
11 P DECIMAL ;S

89 CLEAR 89 SCR !
0 P ( 1/1 VECTORED EXECUTE EXAMPLE )
1 P (     adapted from: FD V/4/P17 )
2 P 0 VARIABLE 'WHO 
3 P : WHO 'WHO @ CFA EXECUTE ;
4 P : WELCOME ( -- ) CR 
5 P   ." HELLO, DEAR " WHO ." !" CR ;
6 P : WHO! 'WHO ! ;
7 P : DEFAULT ; 
8 P : BARTOSZ ." BARTOSZ" ;
9 P : STEFAN  ." MATYLDA"  ;
10 P ' DEFAULT WHO!   WELCOME
11 P ' BARTOSZ WHO!   WELCOME
12 P ' STEFAN  WHO!   WELCOME
13 P ;S 
14 P       ( T H E   E N D )
15 P ;S

FLUSH

FORTH
