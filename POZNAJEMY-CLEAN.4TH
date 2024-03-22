( ********************************************************** )
( This is a batch for Atari 800XL's APX Extended Fig-Forth.  )
( It prepares SD floppy with listings from "Poznajemy Forth" )
( Polish book, published by SOETO in '87 and RETRONICS in '24)
( - adds some public domain tools, published in the 80s/90s. )
(                                                            )
( Collected, formatted and tuned by BartGo.                  )
(                                                            )
( To install:                                                )
( - use a clean copy of APX Forth, CRC F64B50DA or E6B43BB4  )
( - make sure you have a copy, the script overwrites the ATR )
( - boot Altirra with it, depress CAPS, paste LOADING HELPER )
( - to ensure a clean "install", do then: 88 16 CLEARS       )
( - paste the code below /LOADING HELPER                     )
( - reboot, enjoy new screens 16-88                          )
( - screens 16-17 are an index with source and # of screens  )
( - pF is "Poznajemy FORTH"                                  )
( - FD is "Forth Dimensions": https://www.forth.org/fd/      )
( - apx is from the APX Forth floppy itself /FIG sources/    )
( - micro is: https://archive.org/details/6502-micro-journal )
( - ta is "Tajemnice Atari": https://tajemnice.atari8.info/  )
( - comp! is: https://archive.org/details/compute-magazine   )
( ********************************************************** )
( NICE TO ADD FOR FUTURE VERSIONS:                           )
( TRACE: https://www.forth.org/fd/FD-V03N2.pdf p. 58         )
( RP@/UNRAVEL/?ENOUGH: https://www.forth.org/fd/FD-V06N2.pdf )
( DEFER/IS: ?                                                )
( ********************************************************** )


( ********************** )
( *** LOADING HELPER *** ) 
( ********************** )

: TASK ;

( grey border under HEX - only for new words using HEX )
: HEX     DECIMAL 5 712 ! HEX ;
: DECIMAL DECIMAL 0 712 ! ;

CR

FORTH DEFINITIONS HEX 

: TEXT HERE C/L 1+ BLANKS WORD HERE
  PAD C/L 1+ CMOVE ; 
: LINE DUP FFF0 AND 17 ?ERROR
  SCR @ (LINE) DROP ; 
: MARK 10 0 DO I LINE UPDATE DROP LOOP ;

VOCABULARY EDITOR IMMEDIATE
EDITOR DEFINITIONS HEX

: WHERE DUP B/SCR / DUP SCR ! ." SCR # " DECIMAL .
  SWAP C/L /MOD C/L * ROT BLOCK + CR
  C/L -TRAILING TYPE CR HERE
  C@ - SPACES 1 2FE C! 1C EMIT 0 2FE
  C! [COMPILE] EDITOR QUIT ;
: -MOVE LINE C/L CMOVE UPDATE ;
: P 1 TEXT PAD 1+ SWAP -MOVE ; 
: E LINE C/L BLANKS UPDATE ;
: TOP 0 R# ! ; 
: #LOCATE R# @ C/L /MOD ;
: #LEAD #LOCATE LINE SWAP ;
: #LAG  #LEAD DUP >R + C/L R> - ;
: M R# +! CR SPACE #LEAD TYPE
  17 EMIT #LAG TYPE #LOCATE . DROP ;
: 1LINE #LAG PAD COUNT MATCH R# +! ; 
: CLEAR  SCR ! 10 0 DO FORTH I
  EDITOR E LOOP ;
: CLEARS DO I CLEAR FLUSH LOOP ; CR
: COPY B/SCR * OFFSET @ + SWAP
       B/SCR * B/SCR OVER +
       SWAP DO DUP FORTH I
       BLOCK 2 - ! 1+ UPDATE
       LOOP DROP FLUSH ;
." Fig-Editor subset loaded."

DECIMAL CR

( ADDITIONAL WORDS TO SIMPLIFY CODE PASTING AND BROWSING)

15 VARIABLE #SC ( starting scr-1 )
 0 VARIABLE #LN ( & line )
: LN? ( -- ) DECIMAL #LN @ 16 = IF 23 ERROR COLD THEN ;
: PREPARE ( -- ) ( next scr )
  CR CR 0 #LN ! 
  SCR @ 1 + SCR ! 
  SCR @ CLEAR
  DECIMAL ." #" SCR ? CR ;
: Q ( -- ) ( new line: Q ccc )
  LN? #LN @ EDITOR P
  ( new line after P!) 1 #LN +! ; 
: V ( -- ) ( skip line: V )
  LN? #LN @ EDITOR E
  ( new line after P!) 1 #LN +! ; 

#SC @ SCR !

( ********************** )
( *** /LOADING HELPER ** ) 
( ********************** )

EDITOR

PREPARE ( scr 16 )
Q ( ** Poznajemy FORTH 1/2 ** ) ;S
Q #14 (standard error messages)       apx             [2]
Q #16 (this index)                    here            [2]  
Q #18 KOT, NAPIS, KWADRATY            pF 2.1-3.4.3    [1]
Q #19 2DUP, 2DROP, ... DUMP[debug]    pF 3.5-4        [1]
Q #20 PRZEDZIAL, FIBO, ...            pF 3.5-5.5      [1]
Q #21 TEST1, NWP, TABLICZKA           pF 5.5-5.7      [1]
Q #22 TABLICZKA2                      pF 5.6          [1]
Q #23 ERATOS, ..., PIERWSZE           pF 5.8          [2]
Q #25 NAZWISKO?, ..., DATY            pF 6.2-8.3      [1]
Q #26 SILNIA, SILNIA2, ...            pF 8.5          [1]
Q #27 ARRAY, 2DARRAY                  pF 9.1          [1]
Q #28 MATDEF                          pF 9.1          [1]
Q #29 ARRAY2                          pF 9.1          [1]
Q #30 SETNE, SEXTAL, XX, SEK          pF 9.2          [1]
Q #31 DBL - D*, FIX, F., ..., D=      pF 9.2-9.3 FIXME[2]

PREPARE                                                          
Q ( ** Poznajemy FORTH 2/2 ** ) ;S
Q #33 3DUP, TAM, ..., HANOI           pF 12.1         [1]
Q #34 HETMANY                         pF 12.2         [5]
Q #39 ZESPOLONE                       pF 12.4         [1]
Q #40 FUNKCJE                         pF 12.5         [2]
Q #42 LIFE                            pF 12.3         [5]
Q #47 SORTOWANIE                      pF 12.6         [7]
Q #54 PSY                             pF 10.4         [4]
Q #58 (empty)                         --              [1]
Q #59 EDIT /M.Dougherty  (or: #60)    micro 57/feb/83 [b]
Q #70 RAGSDALE ASSEMBLER   [asmWR]    apx             [3]
Q #73 EDIT /R.Pantola    re:asmWR     ta              [a]
Q #83 VECTORED EXEC, USING FENCE      fd v4nr4p17, pF [1]
Q #84 BLINKING asm exmpl re:asmPM     comp! 12/81     [1]
Q #85 GOIN decompiler                 fd v4nr2p28     [2]
Q #87 Fig-EDIT subset, SEARCH, ...    apx/fd v3nr1p10 [2]

PREPARE
Q ( KOT, NAPIS, KWADRATY  )
Q : KOT CR ." Kot pije mleko" ; 
Q : NAPIS KOT SPACE
Q   ." i poluje na myszy" ;
Q : S0 18 +ORIGIN @ ; ( APX s#85 )
Q : .S ( --- ) 2 SPACES SP@ S0 =
Q     0= IF SP@ 2 - S0 2 - DO
Q       I @ . -2 +LOOP THEN ;
Q : TEST ( -- ) 1 2 3   DUP  .S         ( 1 2 3 3 )
Q   DROP .S   ( 1 2 3 ) SWAP .S         ( 1 3 2 )
Q   ROT  .S   ( 3 2 1 ) OVER .S         ( 3 2 1 2 )
Q  SP! ;  : KWADRAT DUP * . ;
Q : SZESCIAN DUP OVER * * . ; 
Q : KWADRATY CR DO I DUP U* 15            D.R CR LOOP ;
Q ( 45001 44980 KWADRATY ) ;S

PREPARE
Q ( 2DUP,2DROP,...        )   
Q : 2DUP OVER OVER ;                  : 2DROP DROP DROP ;
Q : 2SWAP ROT >R ROT R> ; : 2OVER     >R >R 2DUP R> R> 2SWAP ;
Q : 2ROT ( n1 n2 n3 n4 n5 n6 ... )    ( --- n3 n4 n5 n6 n1 n2 )
Q    >R ( n1 n2 n3 n4 n5 )            ( – n6 na stos powrotow )
Q    >R ( n1 n2 n3 n4 )               ( – n5 na stos powrotow )
Q    2SWAP ( n3 n4 n1 n2 )            ( – zamienia pary liczb )
Q    R> ( n3 n4 n1 n2 n5 )            ( – przenosi z powrotem n5 )
Q    R> ( n3 n4 n1 n2 n5 n6 )         ( – przenosi z powrotem n6 )
Q    2SWAP ; ( n3 n4 n5 n6 n1 n2 )    ( – zamiana wykonana! )
Q ;S
Q ( *** DUMP-INDEX: req. APX DEBUG )
Q : DUMP-INDEX ' INDEX NFA ' TRIAD    
Q   NFA OVER - DUMP ;         
Q ( HEX DUMP-INDEX DECIMAL ) ;S


PREPARE
Q ( PRZEDZIAL, FIBO, ...  )        
Q : PRZEDZIAL                         ( dolna-gr. n gorna-gran. )
Q    OVER                             ( dol-gr n gor-gr n )
Q    > >R                             ( dol-gr n f1 ) ( dol-gr n )
Q    <  R> ;                          ( f2 ) ( f2 f1 ) ( f )  
Q ( 20 370 400 PRZEDZIAL . CR )
Q : FIBO ( n --- ) ( max n: 23 )
Q   0 1 ROT 0 CR DO
Q     DUP 10 .R CR SWAP OVER + LOOP ;  
Q : DFIBO ( n --- ) ( max n: 46 )
Q   0. ROT 1. ROT 0 CR DO       
Q     2DUP 14 D.R CR
Q     2SWAP 2OVER D+ LOOP ;           : KWADRAT2 DUP * ; 
Q : KWADRAT3 DO I KWADRAT2 DUP 32760 IF DROP LEAVE THEN . LOOP ;
Q ( -- ) ;S

PREPARE
Q ( TEST1, NWP, TABLICZKA )
Q : TEST1 51  1 DO I .  2 +LOOP ; 
Q : TEST2  0 20 DO I . -1 +LOOP ; 
Q : IKSY BEGIN ." X" 1 - DUP 0= UNTIL ; 
Q : NWP BEGIN SWAP OVER MOD -DUP 0= UNTIL ;
Q ( 128 1024 NWP . CR 324 556 NWP . CR 1933 821 NWP . CR )
Q 0 VARIABLE AA : TABLICZKA ( -- )
Q   125 EMIT CR CR 8 SPACES
Q   ." TABLICZKA MNOZENIA"
Q   CR CR 3 SPACES
Q   10 1 DO I 3 .R LOOP CR
Q   30 0 DO ." _" LOOP CR
Q   10 1 DO I DUP AA ! 		
Q     . ." |" 10 1 DO
Q       I AA @ *	3 .R 					
Q     LOOP CR LOOP ; TABLICZKA ;S

PREPARE
Q ( TABLICZKA2 ) 
Q : J R> R> R> R R# !
Q     >R >R >R R# @ ; 
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
Q   LOOP ;
Q : TABLICZKA2 TAB2 ;
Q TABLICZKA2 ;S

PREPARE
Q ( 1/2 ERATOS - WSTAW, USUN )
Q 0 VARIABLE ERATOS 254 ALLOT
Q : WSTAW ( adr --- )
Q   256 1 DO 
Q     I OVER C! 1+
Q   LOOP
Q   DROP ;
Q : USUN ( n --- )
Q   256 OVER DO
Q     I 1 - ERATOS + 0 SWAP C!
Q     DUP
Q  +LOOP
Q  DROP ;
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
Q     THEN
Q  LOOP DROP ;
V
Q PIERWSZE ;S

PREPARE
Q ( NAZWISKO?, DRUKUJ, ...)
Q : QUERY TIB @ 80 EXPECT 0 IN ! ; 
Q : NAZWISKO?
Q   CR ." PODAJ SWOJE NAZWISKO: "
Q   CR QUERY 155 WORD HERE ; 
Q : DRUKUJ NAZWISKO? CR COUNT TYPE ;
Q : INPUT CR QUERY BL WORD HERE
Q   NUMBER DROP ; 
Q : DATY <BUILDS , , , DOES>
Q   DUP 2+ DUP 2+ ? ? ? CR ;
Q 12  9 1683 DATY WIEDEN               
Q  4  4 1794 DATY RACLAWICE
Q 18  6 1815 DATY WATERLOO
Q  1  9 1870 DATY SEDAN
Q 12 10 1943 DATY LENINO
Q 15 08 1920 DATY WARSZAWA ;S 

PREPARE
Q ( SILNIA, SILNIA2, ... )
Q : TENKOD ( -- n ) CURRENT @ @
Q   PFA CFA ; IMMEDIATE
Q : SILNIA ( n -- )
Q   1 SWAP 1+ 1 DO I * LOOP ;
Q : SILNIA2 ( n -- ) DUP 2 = IF
Q   ELSE DUP 1 - TENKOD LITERAL
Q   EXECUTE * THEN ;
Q : SILNIA3 ( n -- ) [ SMUDGE ]
Q   DUP 2 = IF ELSE DUP 1 - SILNIA3 *
Q   THEN [ SMUDGE ] ;
Q : FACTORIAL ( JB ) DUP IF DUP
Q   1 - [ SMUDGE ] FACTORIAL 
Q   [ SMUDGE ] * ELSE 1+ THEN ;
Q 8 SILNIA  U.  8 SILNIA2 U.
Q 8 SILNIA3 U.  8 FACTORIAL U. ;S

PREPARE
Q ( ARRAY, 2DARRAY )
Q : ARRAY <BUILDS 2 * ALLOT DOES>
Q   SWAP 2 * + ;
Q : 2DARRAY
Q   <BUILDS 
Q     DUP , * 2 * ALLOT
Q   DOES>
Q     ROT OVER @ + ROT + 2 * + 2+ ;
V
Q 10 ARRAY LICZBY 
Q      7 3 LICZBY ! 6 4 LICZBY ! 
Q        3 LICZBY ?   4 LICZBY ?
Q 4 5 2DARRAY PROSTOKAT
Q      44 2 1 PROSTOKAT !
Q         2 1 PROSTOKAT ?     ;S

PREPARE
Q ( MATDEF ) 
Q : 0> 0 MAX ; 
Q : MATDEF <BUILDS OVER OVER           SWAP , , * 2 * ALLOT
Q    DOES> >R OVER OVER R @ R          2 + @ ROT - 0> ROT
Q    ROT - 0< * IF R @ * + 2 *         R> 4 + + 
Q    ELSE R> DROP DROP DROP            ." ZLE WSKAZNIKI" THEN ;
Q 2 3 MATDEF MATRIX2                   CR CR
Q 11 0 0 MATRIX2 C!                    22 0 1 MATRIX2 C!
Q 33 1 0 MATRIX2 C!                    44 1 1 MATRIX2 C!
Q 55 0 2 MATRIX2 C!                    66 1 2 MATRIX2 C!
Q ( 77 2 3 MATRIX2 C! ) ( !! )
Q    0 0 MATRIX2 C@                    . CR  0 1 MATRIX2 C@ . CR
Q    1 0 MATRIX2 C@                    . CR  1 1 MATRIX2 C@ . CR
Q    0 2 MATRIX2 C@                    . CR  1 2 MATRIX2 C@ . CR
Q CR ;S

PREPARE
Q ( ARRAY2 )
Q : ARRAY2 ( n n --- )                 ( n n ARRAY2 matrix )
Q   <BUILDS OVER , * ALLOT DOES>       DUP @ ROT * + + 2+ ;
Q    2 3 ARRAY2 MATRIX 
Q 11 0 0 MATRIX C!                     22 0 1 MATRIX C!
Q 33 1 0 MATRIX C!                     44 1 1 MATRIX C!
Q 55 0 2 MATRIX C!                     66 1 2 MATRIX C!
Q CR CR 
Q    0 0 MATRIX C@ . CR                0 1 MATRIX C@ . CR
Q    1 0 MATRIX C@ . CR                1 1 MATRIX C@ . CR
Q    0 2 MATRIX C@ . CR                1 2 MATRIX C@ . CR
Q CR ;S

PREPARE
Q ( SETNE, SEXTAL, XX, SEK )
Q DECIMAL
Q : SETNE <# # # 46 HOLD #S #> TYPE ;
V
Q 123489. SETNE ( 1234.89 )
Q : SEXTAL 6 BASE ! ;
Q : XX # SEXTAL # DECIMAL 58 HOLD ;
Q : SEK ( n --- ) 
Q   CR <# XX XX #S #> TYPE CR ;
V
Q CR 15610. SEK
Q CR 36000. SEK
Q CR ;S

PREPARE
Q ( 1/2 DBL - D*, FIX, F. )  
Q 0 VARIABLE A_  0 VARIABLE B_       0 VARIABLE C_  0 VARIABLE D_
Q ( from "COMPLETE FORTH" )
Q : D* A_ ! B_ ! C_ ! D_ !           
Q   D_ @ B_ A_ U* D_ @ A_ @ U* DROP + C_ @ B_ @ U* DROP + ; 
Q ( from FD-V03N2.pdf )
Q ( : D* DUP ROT * ROT ROT U* ROT + ; )
Q : FIX DPL @ 0< IF                   ( jezeli lb byla pojed.   )
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
Q : D0= OR 0= ;                       ( test na liczbe podw. 0   )
Q : D0< SWAP DROP 0< ;                ( " ujemna liczbe podw.    )
Q : D= D- D0= ;                       ( " rownosc dwoch lb podw. )
V
Q  0.04   FIX 
Q  0.3    FIX D+ 
Q  0.625  FIX D+
Q  0.0001 FIX D+ 
Q 10      FIX D+
Q         F. ( 10.9651 ) ( FIXME )
Q CR ;S

PREPARE
Q ( WIEZE Z HANOI )
Q : 3DUP >R 2DUP R ROT ROT R> ;
Q : TAM 3DUP ROT ROT OVER + 6
Q   SWAP - ROT 1 - ;
Q : Z.POWROTEM 
Q   3DUP SWAP ROT OVER + 6 SWAP -
Q   SWAP ROT 1 - ;
Q : DRUKUJ 3DUP DROP SWAP
Q   . ." NA " . ." ," ;
Q : WIEZE [ SMUDGE ] DUP IF 
Q     TAM WIEZE DRUKUJ
Q     Z.POWROTEM WIEZE THEN
Q   DROP DROP DROP [ SMUDGE ] ;
Q : HANOI 1 3 ROT CR WIEZE ;
Q 5 HANOI ( n -- ) ;S
Q ( patrz tez: FD II/2 p. 32 )

PREPARE
Q ( 1/5 HETMANY:WEKTOR,LHET,... )
Q 0 VARIABLE ROZWIAZANIE
Q : WEKTOR
Q   <BUILDS HERE OVER ERASE ALLOT
Q   DOES> + ;
Q 1024 WEKTOR WSPOLRZEDNA
Q : LHET ( --- liczba hetmanow+1 )
Q   0 WSPOLRZEDNA C@ ;
Q : POSTAW ( rzad kolumna --- )
Q   SWAP WSPOLRZEDNA C! ; ( umieszcza h. )
Q : USUN ( rzad --- )
Q   0 POSTAW ;            ( kasuje h. )
Q -->

PREPARE
Q ( 2/5 HETMANY:WOLNE,... )
Q : WOLNE ( rzad n --- rzad f )
Q   2DUP = >R
Q   OVER WSPOLRZEDNA C@
Q   OVER WSPOLRZEDNA C@ -
Q   ROT ROT - ABS OVER ABS =
Q   SWAP 0= OR 0=
Q   R> OR ;
Q : WSZYSTKIE-WOLNE ( rzad --- rzad f )
Q   1 OVER 1 DO
Q     OVER I WOLNE AND
Q   LOOP ;
Q -->

PREPARE
Q ( 3/5 HETMANY:BRZEG,DRUK,INIC )
Q : BRZEG ( rzad --- rzad f )
Q  LHET OVER WSPOLRZEDNA C@ > ;
Q : DRUK ( --- ) CR LHET 1 DO
Q     I WSPOLRZEDNA C@ LHET 1
Q     DO DUP I =
Q       IF ." X " ELSE ." . " THEN
Q     LOOP DROP CR LOOP
Q   1 ROZWIAZANIE +! CR ." Rozwiazanie nr "
Q   ROZWIAZANIE ?    CR ;
Q : INIC ( --- ) ( inic. sz. z hetm. w rz. 0 ) 
Q   LHET 1 DO I USUN LOOP 0 ROZWIAZANIE ! ; -->

PREPARE
Q ( 4/5 HETMANY:NAPRZOD,... )
Q : NAPRZOD ( rzad --- rzad f )     ( f=1, gdy het. w rz. "rzad" )
Q                                   ( mozna przes. do nast. kol. )
Q   DUP DUP WSPOLRZEDNA
Q   C@ 1+ POSTAW BRZEG
Q   IF 1 ELSE DUP USUN 0 THEN ;
Q : PIERWSZA-WOLNA ( rz --- rz f )  ( f=1,gdy hetman moze ... )
Q   ( ... przejsc do nast. kol. w rz                          )
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
Q	          1+ POZYCJA -DUP
Q	        ELSE 1 - 0 1 THEN
Q       UNTIL
Q     ELSE DRUK 1 - 0 THEN
Q  [ SMUDGE ] ;
Q : HETMANY ( --- )
Q   9 0 SWAP POSTAW INIC
Q   1 POZYCJA 2 DROP ;        ;S

PREPARE
Q ( LICZBY ZESPOLONE )
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
Q ( 1/2 FN TRYGONOMETRYCZNE )
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
Q DOES> SWAP 2 * + @ ;            ( APX/1.4S )
Q 91 TABLICA SINTABLICA -->

PREPARE
Q ( 2/2 FN TRYGONOMETRYCZNE )
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
Q : ARRAY                            ( dimX dimY --- )
Q   <BUILDS                            
Q     OVER ,                         ( dimY pod adresem pfa+2 )
Q     * ALLOT                        ( dimX*dimY bajtow )
Q   DOES>                             
Q   DUP @                            ( dimX na stosie )
Q   ROT *                            ( dimY*dimX )
Q   + + 2+ ;                         ( bezwzgledny adres komorki )
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
Q : WERYFIKACJA                     ( liczba stanu sasiadow --- )
Q  DUP 3 =                          ( liczba stanu f )
Q  IF DROP 2+ ELSE                    
Q    2 = 0=                         ( stan stan nr2 )
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
Q ( 1/7 SORT:ARRAY,WSTAW,POKAZ )
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
Q   IF ROT     ( n2 L1 L2 n1 ) 
Q     LICZBY ! ( n2 L1 )
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

( Be careful - below we stop using PREPARE   )
( and start using explicit screen selection! )
( Everything can use PREPARE if we remove    )
( from PSY hard-coded references to screen #!)

54 DUP CLEAR SCR !
0 P ( 1/4 PSY RASOWE ) -->
1 P bokser             165
2 P cocker-spaniel      98
3 P dog                163
4 P doberman            35
5 P bernardyn          221
6 P owczarek alzacki   171
7 P foksterier          46
8 P seter               27
9 P jamnik             194
10 P ratler             32
11 P chow-chow         172
12 P pekinczyk          28

55 DUP CLEAR SCR !
0 P ( 2/4 CECHY PSOW ) -->
1 P   C z y  m a:
2 P 1 wiecej niz 60 cm wzrostu?
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
 2 P     DUP I CECHY C@ XOR
 3 P     0= IF
 4 P       I 1+ #PSY .LINE CR
 5 P     THEN
 6 P   LOOP DROP ;
 7 P : PSY ( -- ) HOME 12 1 DO
 8 P     I #CECHY .LINE CR
 9 P   LOOP CR ." Napisz liczby:"
10 P   CR WLASNOSCI
11 P   CR CR CR ." To moze byc:"
12 P   CR DAJ DROP ;
13 P     ( .. 6 0 - ratler 32 )
14 P ;S  ( .. 2 3 4 6 0 - foks. 46 )

58 CLEAR ( - )

59 CLEAR ( CONST #HLP = 59 )
  0 P ( EDIT - HELP ) -->
  2 P Arrows, Insert, BckSpc: standard
  3 P Return: next line;  Tab: tab (2)
  4 P Clear: clear screen  (Shf> Ctl>)
  5 P Esc-Z: undo scr chng (empty-buf)
  6 P Shf-Ins: insert whole line*
  7 P Shf-Del: delete whole line*
  8 P Ctl-Ins: ins space;  Esc-H: help
  9 P Ctl-BckSpc: del;  Esc-0: cold
 10 P Esc-R: rotate/sides;       ( / )
 11 P Esc-N: screen +1, no flush ( > )
 12 P Esc-L: screen -1, no flush ( < )
 13 P Esc-S: save (flush) ; Esc-B: 4th
 14 P Esc-Q: quit (empty-buf)
 15 P Esc-V: put last deleted line*

60 CLEAR
  0 P ( EDIT - BY M. DOUGHERTY )
  1 P : TASK ; DECIMAL 0 VARIABLE CLINE 0 VARIABLE CCHAR
  2 P 752 CONSTANT CRSINH             59 CONSTANT #HLP 
  3 P 3   VARIABLE LINEOFF             3 VARIABLE CHAROFF
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
  0 P ( EDIT - SCREEN-CURSOR, ... ) 
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
 13 P  POINT-CURSOR XLINE ; : FRE 741 @ HERE - ;
 14 P : 2TOP LINEOFF @ 1 - CHAROFF @ 1 -
 15 P  POINT-CURSOR HLINE ;  -->

62 CLEAR 
  0 P ( EDIT - DISPLAY, CASE )
  1 P : BOT LINEOFF @ 16 + CHAROFF @ 1 -
  2 P  POINT-CURSOR HLINE ; 
  3 P : ETITLE 0 CHAROFF @ POINT-CURSOR
  4 P  ." EDIT / Dr" OFFSET @ 0= 0= . ." Scr" SCR ?
  5 P  ." Side" SIDE ? ." Free" FRE U. ; 
  6 P : DISPLAY ECLEAR ETITLE 2TOP CLINE @ 16 0 DO
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
13 P : (KEYJOY) 632 C@ CASES 15 CASE KEY IS
14 P   11 CASE 30 IS 7 CASE 31 IS 14 CASE 28 IS 
15 P   13 CASE 29 IS CEND ( FIXME ) ; -->

65 CLEAR
 0 P ( EDIT - REFORTH, SCREEN<>, HLP )
 1 P : SH CLS 0 CRSINH C! IN @ >R BLK @ >R 0 IN ! 
 2 P   0 BLK ! CR QUERY INTERPRET R> BLK ! R> IN ! ANYK ; 
 3 P : ENEXT ( FLUSH ) SCR @ 1 + SCR ! EREAD DISPLAY ;
 4 P : ELAST ( FLUSH ) SCR @ 1 - SCR ! EREAD DISPLAY ;  
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
 8 P : UNDOSCR EMPTY-BUFFERS EREAD DISPLAY ;
 9 P : SAVESCR FLUSH EREAD DISPLAY ;
10 P : THEME 710 C@ 148 XOR 710 C! ;
11 P ( empty )
12 P ( empty )
13 P ( empty )
14 P ( empty )
15 P -->
 
68 CLEAR
 0 P ( EDIT - COMMANDS )
 1 P : REVB 712 @ 128 XOR 712 ! ; ( CLR4 )
 2 P : ESC REVB KEY CASES        
 3 P   82 CASE CHANGE-SIDE IS ( R )   47 CASE CHANGE-SIDE IS ( / )
 4 P   78 CASE ENEXT       IS ( N )   62 CASE ENEXT IS ( > )
 5 P   76 CASE ELAST       IS ( L )   60 CASE ENEXT IS ( < )
 6 P   83 CASE SAVESCR     IS ( S )   
 7 P   81 CASE EABORT      IS ( Q )
 8 P   86 CASE PUT-LINE    IS ( V )
 9 P   90 CASE UNDOSCR     IS ( Z )
10 P   66 CASE SH DISPLAY  IS ( B )   84 CASE THEME       IS ( T )   
11 P   48 CASE BOOT        IS ( 0 )   66 CASE SH DISPLAY  IS ( B )
12 P   72 CASE HLP DISPLAY IS ( H )          
13 P   BEEP CEND REVB ;
14 P : DEPTH SP@ 12 +ORIGIN @ SWAP - 2 / ;
15 P : SETSCR DEPTH 0= IF #HLP ENDIF SCR ! ;  -->
 
69 CLEAR
 0 P ( EDIT - ends ) ( n -- ) : EDIT 
 1 P   SETSCR EREAD DISPLAY 0 STOP ! BEGIN KEY
 2 P   CASES 27 CASE ESC IS 
 3 P     28  CASE UP-CURSOR    IS
 4 P     29  CASE DOWN-CURSOR  IS
 5 P     31  CASE RIGHT-CURSOR IS
 6 P     30  CASE LEFT-CURSOR  IS
 7 P     155 CASE RETURN       IS
 8 P     255 CASE INSERT       IS
 9 P     254 CASE DELETE       IS
10 P     157 CASE INSERT-LINE  IS
11 P     156 CASE DELETE-LINE  IS
12 P     126 CASE DEL IS 127 CASE TAB IS
13 P     125 CASE CLEAR-SCR IS 
14 P DUP ADDKEY CEND STOP @ UNTIL 
15 P 125 EMIT 0 CRSINH ! ; : /EDIT ; ;S
 

70 CLEAR
 0 P ( 1/3 RAGSDALE ASSEMBLER )
 1 P VOCABULARY ASSEMBLER IMMEDIATE ASSEMBLER DEFINITIONS BASE @ HEX
 2 E 
 3 P 0 VARIABLE INDEX -2 ALLOT 0909 , 1505 , 0115 , 8011 , 8009 ,
 4 P 1D0D , 8019 , 8080 , 0080 , 1404 , 8014 , 8080 , 8080 ,
 5 P 1C0C , 801C , 2C80 ,
 6 P 2 VARIABLE MODE : .A 0 MODE ! ; : # 1 MODE ! ; : MEM 2 MODE ! ;
 7 P : ,X 3 MODE ! ; : ,Y 4 MODE ! ; : X) 5 MODE ! ; : )Y 6 MODE ! ;
 8 P : ) F MODE ! ; : BOT ,X 0 ; : SEC ,X 2 ; : RP) ,X 101 ;
 9 P : UPMODE IF MODE @ 8 AND 0= IF 8 MODE +! THEN THEN
10 P 1 MODE @ F AND -DUP IF 0 DO DUP + LOOP THEN OVER 1+ @ AND 0= ;
11 P : CPU <BUILDS C, DOES> C@ C, MEM ;
12 P 00 CPU BRK, 18 CPU CLC, D8 CPU CLD, 58 CPU CLI, B8 CPU CLV,
13 P CA CPU DEX, 88 CPU DEY, E8 CPU INX, C8 CPU INY, EA CPU NOP,
14 P 48 CPU PHA, 08 CPU PHP, 68 CPU PLA, 28 CPU PLP, 40 CPU RTI,
15 P 60 CPU RTS, 38 CPU SEC, F8 CPU SED, 78 CPU SEI, AA CPU TAX, -->


71 CLEAR
 0 P ( 2/3 RAGSDALE ASSEMBLER )
 1 P A8 CPU TAY, BA CPU TSX, 8A CPU TXA, 9A CPU TXS, 98 CPU TYA,
 2 P : MCP <BUILDS C, , DOES> DUP 1+ @ 80 AND IF 10 MODE +! THEN
 3 P OVER FF00 AND UPMODE UPMODE IF MEM CR LATEST ID. 3 ERROR THEN
 4 P C@ MODE C@ INDEX + C@ + C, MODE C@ 7 AND IF MODE C@ F AND 7 <
 5 P IF C, ELSE , THEN THEN MEM ;
 6 P 1C6E 60 MCP ADC, 1C6E 20 MCP AND, 1C6E C0 MCP CMP,
 7 P 1C6E 40 MCP EOR, 1C6E A0 MCP LDA, 1C6E 00 MCP ORA,
 8 P 1C6E E0 MCP SBC, 1C6C 80 MCP STA, 0D0D 01 MCP ASL,
 9 P 0C0C C1 MCP DEC, 0C0C E1 MCP INC, 0D0D 41 MCP LSR,
10 P 0D0D 21 MCP ROL, 0D0D 61 MCP ROR, 0414 81 MCP STX,
11 P 0486 E0 MCP CPX, 0486 C0 MCP CPY, 1496 A2 MCP LDX,
12 P 0C8E A0 MCP LDY, 048C 80 MCP STY, 0480 14 MCP JSR,
13 P 8480 40 MCP JMP, 0484 20 MCP BIT,
14 P : BEGIN, HERE 1 ; IMMEDIATE
15 P : UNTIL, ?EXEC >R 1 ?PAIRS R> C, HERE 1+ - C, ; IMMEDIATE -->


72 CLEAR
 0 P ( 3/3 RAGSDALE ASSEMBLER )
 1 P : IF, C, HERE 0 C, 2 ; IMMEDIATE
 2 P : THEN, ?EXEC 2 ?PAIRS HERE OVER C@ IF SWAP ! ELSE OVER 1+
 3 P - SWAP C! THEN ;  IMMEDIATE
 4 P : ELSE, 2 ?PAIRS HERE 1+ 1 JMP, SWAP HERE OVER 1+ - SWAP C!
 5 P 2 ;  IMMEDIATE
 6 P : NOT 20 + ;
 7 P 90 CONSTANT CS D0 CONSTANT 0= 10 CONSTANT 0< 90 CONSTANT >=
 8 P : END-CODE CURRENT @ CONTEXT ! ?EXEC ?CSP SMUDGE ;  IMMEDIATE
 9 P ( NOTE: alternative to END-CODE could be C; or ;C )
10 P FORTH DEFINITIONS DECIMAL
11 P : CODE ?EXEC CREATE [COMPILE] ASSEMBLER ASSEMBLER MEM !CSP ;
12 P IMMEDIATE
13 P ' ASSEMBLER CFA ' ;CODE 8 + ! LATEST 12 +ORIGIN !
14 P HERE 28 +ORIGIN ! HERE 30 +ORIGIN ! HERE FENCE !
15 P ' ASSEMBLER 6 + 32 +ORIGIN !     BASE ! FORTH ;S

73 CLEAR
 0 P ( EDYTOR-FORTH /Roland Pantola       [c] '92 Tajemnice Atari )
 1 P : TASK ; : MAC  -FIND 0= 0 ?ERROR DROP 32 C, , ; IMMEDIATE
 2 P : <=< OVER > >R < R> * ; ASSEMBLER DEFINITIONS : C; CURRENT
 3 P @ CONTEXT ! ?EXEC ?CSP SMUDGE ;  IMMEDIATE  FORTH DEFINITIONS
 4 P 0 VARIABLE #GGE : GGE #GGE @ ;  129 #GGE !    CODE INSTR
 5 P 3 ,X LDA, XSAVE 3 + STA,        2 ,X LDY,
 6 P 0= IF, XSAVE 3 + DEC,           THEN, DEY, XSAVE 2+ STY,
 7 P 0 ,X LDY, 4 ,X LDA,             BEGIN, XSAVE 2+ )Y CMP,
 8 P 0= NOT IF, DEY, THEN,           0= UNTIL, 4 ,X STY,
 9 P POPTWO JMP, C;                  ( A ADR DLU --- NR )
10 P : SELECT <BUILDS SMUDGE ] DOES> SWAP 2 * + @ EXECUTE ;
11 P : % COMPILE CLIT BL WORD HERE   NUMBER DROP -1 OVER 256 <=< 0=
12 P IF CR ." Error: % " DUP .       ENDIF C, ;
13 P IMMEDIATE                       0 VARIABLE #C 2 ALLOT
14 P 64 #C C!                        0 #C 1+ C!
15 P 32 #C 2+ C!                     96 #C 3 + C! -->

74 CLEAR
 0 P ( EDYTOR-FORTH c.d. )
 1 P CODE CMOVE> 2 ,X LDA, XSAVE 2+  STA, 4 ,X LDA, XSAVE 4 + STA,
 2 P 1 ,X LDA, CLC, 5 ,X ADC,        XSAVE 5 + STA, 1 ,X LDA,
 3 P CLC, 3 ,X ADC, XSAVE 3 + STA,   BEGIN, 0 ,X LDY,
 4 P BEGIN, DEY, XSAVE 4 + )Y LDA,   XSAVE 2+ )Y STA, 0 # CPY, 0=
 5 P UNTIL, XSAVE 5 + DEC, XSAVE     3 + DEC, 0 ,X LDA, 0= IF,
 6 P 1 ,X LDA, 0= NOT                IF, 1 ,X DEC, THEN, THEN,
 7 P 0 # LDA, 0 ,X STA,              1 ,X LDA, 0= UNTIL,
 8 P INX, INX, XSAVE STX, POPTWO     JMP, C;
 9 P                                 CODE ASC-PEEK XSAVE STX,
10 P 2 ,X LDA, XSAVE 2+ STA,         3 ,X LDA, XSAVE 3 + STA,
11 P 0 ,X LDY,                       BEGIN, DEY, XSAVE 2+ )Y LDA,
12 P 96 # AND, .A LSR, .A LSR,       .A LSR, .A LSR, .A LSR, TAX,
13 P XSAVE 2+ )Y LDA,                255 96 - # AND, #C ,X ORA,
14 P XSAVE 2+ )Y STA, 0 # CPY,       0= UNTIL, XSAVE LDX,
15 P POPTWO JMP, C;	-->

75 CLEAR
 0 P ( EDYTOR-FORTH c.d. )
 1 P : PEEK-ASC OVER OVER 2 0        DO ASC-PEEK LOOP ;
 2 P ( ADDR DLU --- )                4 VARIABLE XPOS 4 VARIABLE YPOS
 3 P : XPOS@ XPOS @ ;                : YPOS@ YPOS @ ;
 4 P : POSE YPOS ! XPOS ! ;          48 CONSTANT ZERO
 5 P : X! % 85 ! ; : Y! % 84 C! ;    : X@ % 85 @ ; : Y@ % 84 C@ ;
 6 P : POS Y! X! ;                   : 0.R ' ZERO CFA ' SPACE ! .R
 7 P ' BL CFA ' SPACE ! ;            : BEEP 253 EMIT ;
 8 P                                 VOCABULARY EDITOR IMMEDIATE
 9 P EDITOR DEFINITIONS              : #DLE [ 112 C, 66 C, 48032 ,
10 P 2 C, 2 C, 2 C, 2 C, 2 C, 2 C,   2 C, 2 C, 2 C, 2 C, 2 C, 2 C, 2
11 P C, 2 C, 2 C, 2 C, 2 C, 2 C, 2   C, 2 C, 2 C, 2 C, 2 C, 2 C, 2
12 P C, 2 C, 2 C, 65 C, 47998 , ] ;  : #SCR? 0 % 10 POS ." SCR"
13 P   0 % 12 POS SCR @ 3 0.R ;      : ADBUFF HERE 260 + ;
14 P : LBUFF ADBUFF 2 - ;            : CZYBUFF ADBUFF % 4 -
15 P @ 31886 = ;                     -->

76 CLEAR
 0 P ( EDYTOR-FORTH c.d. )
 1 P : #BUFF? CZYBUFF IF LBUFF       @ ELSE 0 ADBUFF 2 - ! 31886
 2 P ADBUFF 4 - ! 0 ENDIF 0 % 16 POS ." BUF" 0 % 18 POS % 3 0.R ;
 3 P : #DISPE ' #DLE 47998 % 34      CMOVE 47998 560 ! 48032 % 88 !
 4 P ; : #RAMKA % 125 EMIT % 88 @    % 28 0 DO DUP I % 40 * + % 3 +
 5 P % 124 SWAP OVER OVER % 33 + ! ! LOOP DROP #SCR? #BUFF? ;
 6 P 0 VARIABLE #LINIA0              : #W# SCR @ B/SCR * DUP B/SCR +
 7 P SWAP ; : #WEJ #W# DO I          BLOCK % 128 ASC-PEEK LOOP ;
 8 P : #WYJ #W# DO I BLOCK % 128     PEEK-ASC LOOP ;
 9 P 48036 CONSTANT ADE: : ADLINE    % 40 * ADE: + ;
10 P : #KP SWAP OVER OVER 1 - C!     OVER OVER 32 + C! DROP DROP ;
11 P : KK? ADLINE % 84 #KP ;         : PP? ADLINE % 124 #KP ;
12 P : #LIN# DUP % 4 /MOD SCR @      B/SCR * + BLOCK SWAP % 32 * +
13 P SWAP ADLINE #LINIA0 @ % 40 * -  ; : LIN-E: #LIN# % 32 CMOVE ;
14 P : EK-E: #LINIA0 @ DUP % 28 +    SWAP DO I LIN-E: LOOP ;
15 P : LIN-BUF #LIN#  SWAP % 32      CMOVE ; -->

77 CLEAR
 0 P ( EDYTOR-FORTH c.d. )
 1 P : EK-BUF #LINIA0 @ DUP % 28 +   SWAP DO I LIN-BUF LOOP ;
 2 P : E:V ADLINE DUP % 40 - % 26    ADLINE DO I DUP % 40 + % 32
 3 P CMOVE -40 +LOOP % 32 ERASE ;
 4 P : E:^ ADLINE % 40 +             % 28 ADLINE
 5 P SWAP DO I DUP % 40 - % 32       CMOVE % 40 +LOOP % 27 ADLINE
 6 P % 32 ERASE ;
 7 P : LINB #LINIA0 @ + ;            : E: ADE: % 4 -
 8 P XPOS@ + YPOS@                   % 40 * + ; : E:@ E: C@ ;
 9 P : E:! E: C! ;
10 P : #KUR E:@ DUP % 127 >          IF % 128
11 P - ELSE % 128 +                  ENDIF E:! ;
12 P                                 : &PP
13 P POSE #LINIA0 @ DUP 0=           IF 0 KK? ELSE 0 PP? ENDIF
14 P % 4 = IF % 27 KK? ELSE % 27     PP? ENDIF ;
15 P                                 -->

78 CLEAR
 0 P ( EDYTOR-FORTH c.d. )
 1 P : #POS SWAP DUP % 4 < IF DROP   % 35 SWAP % 1 - SWAP ENDIF
 2 P DUP % 35 > IF DROP % 4 SWAP     1+ SWAP ENDIF SWAP
 3 P DUP 0 < IF #LINIA0 @ IF % 27    LINB LIN-BUF
 4 P -1 #LINIA0 +! 0 E:V 0 LINB      LIN-E: DROP 0
 5 P ELSE DROP % 27 ENDIF ENDIF      DUP % 27 > IF #LINIA0 @ 4 =
 6 P IF DROP 0 ELSE                  0 LINB LIN-BUF 1 #LINIA0 +! 0
 7 P E:^ % 27 LINB LIN-E:            DROP % 27 ENDIF ENDIF &PP ;
 8 P : #PISZ DUP SP@ 1 ASC-PEEK #KUR E:! XPOS@ 1+ YPOS@ #POS #KUR ;
 9 P : #KXY@ #KUR XPOS@ YPOS@ ;      : #PK #POS #KUR ;
10 P : ?< #KXY@ SWAP 1 - SWAP #PK ;  : ?> #KXY@ SWAP 1+ SWAP #PK ;
11 P : ?^ #KXY@ 1 - #PK ;            : ?V #KXY@ 1+ #PK ;
12 P : #RET #KXY@ 1+ SWAP DROP % 4     SWAP #PK 0 LBUFF ! #BUFF? ;
13 P : #COF #KXY@ SWAP 1 - SWAP #POS 0 E:! #KUR ; : BFREE 430 LBUFF
14 P @ % 32 * + 471 @ HERE - U< ;    : >BUFF YPOS@ ADLINE ADBUFF
15 P LBUFF @ % 32 * + % 32 CMOVE     1 LBUFF +! #BUFF? ; -->

79 CLEAR
 0 P ( EDYTOR-FORTH c.d. )
 1 P 0 VARIABLE #CM 67 ALLOT         : #BU# % 28 #LIN# DROP DUP
 2 P % 32 + % 96 ;                   : #EB# % 27 ADLINE % 28 LINB
 3 P #LIN# DROP ;                    : BUFV #BU#  CMOVE> ;
 4 P                                 : BUF^ #BU# OVER >R >R SWAP R>
 5 P CMOVE R> % 64 + % 32 ERASE ;    : XSP DO I C@ 0= 0= IF DROP I
 6 P LEAVE ENDIF LOOP ;
 7 P : OSTLIN #LINIA0 @ % 4 = IF 0   % 27 ADLINE DUP % 32 +
 8 P SWAP XSP ELSE 0 % 31 #LIN#      DROP DUP % 32 + SWAP XSP
 9 P ENDIF 0= ;
10 P : #^^ BFREE IF #KUR >BUFF       YPOS@ E:^ #LINIA0 @
11 P % 4 < IF #EB# SWAP % 32         CMOVE ENDIF BUF^ #KUR
12 P ELSE BEEP BEEP ENDIF ;
13 P : #VV OSTLIN IF                 #KUR BUFV #LINIA0 @ % 4 <
14 P IF #EB# % 32 CMOVE ENDIF        YPOS@ E:V #KUR ELSE BEEP
15 P ENDIF ;                         -->

80 CLEAR
 0 P ( EDYTOR-FORTH c.d. )
 1 P : #<BF OSTLIN IF LBUFF @ IF #VV -1 LBUFF +! ADBUFF LBUFF @
 2 P 32 * + YPOS@ ADLINE % 32        CMOVE #BUFF? #KUR ENDIF ELSE
 3 P BEEP ENDIF ;                    : X#CM #CM XPOS@ + % 4 - ;
 4 P : XSPAC #CM % 63 + DUP X#CM     XSP #CM % 64 + DUP ROT
 5 P DO I C@ 0= I 1+ C@              0= * IF DROP I LEAVE
 6 P ENDIF LOOP X#CM - ;             : <#CM> YPOS@ #LINIA0 @ XPOS@
 7 P YPOS@ 1+ #POS #LINIA0 @ = 0=    - YPOS !
 8 P YPOS@ ADLINE #CM OVER OVER      YPOS@ % 27 < IF SWAP % 40
 9 P + SWAP % 32 + ENDIF ;           : 32CM % 32 CMOVE ;
10 P : >#CM  #KUR <#CM> #CM 66       ERASE 32CM 32CM ;
11 P : <#CM <#CM> SWAP 32CM SWAP     32CM #KUR ;
12 P : #>> >#CM XSPAC #CM % 63 +     C@ 0= OVER X#CM + #CM - % 63
13 P < + IF X#CM DUP 1+ ROT          CMOVE> 0 X#CM C! ELSE BEEP
14 P DROP ENDIF <#CM ;               : #<< >#CM X#CM 1+ DUP 1 -
15 P XSPAC CMOVE <#CM ;              -->

81 CLEAR
 0 P ( EDYTOR-FORTH ends )
 1 P : #DUP DUP DUP % 127 >          IF % 128 - ENDIF ;
 2 P : ESC DROP KEY #DUP BL = IF     DROP 300 ELSE #PISZ ENDIF ;
 3 P : #KLA0 [ 27 C, 28 C, 29 C, 30  C, 31 C, 155 C, 126 C, 254 C,
 4 P 255 C, 156 C, 157 C, 127 C,     ] ;
 5 P : #NR-KLAW ' #KLA0 % 12 INSTR ;
 6 P SELECT #WYB0 #PISZ ESC ?^ ?V ?< ?> #RET #COF #<< #>> #^^ #VV
 7 P #<BF ;                          FORTH DEFINITIONS
 8 P : (E) EDITOR  #WEJ              1 752 C! #DISPE #RAMKA
 9 P XPOS@ YPOS@ #POS                EK-E: #KUR
10 P BEGIN                           KEY DUP #NR-KLAW #WYB0
11 P 300 = UNTIL                     #KUR EK-BUF #WYJ FORTH ;
12 P                                 : EXFO % 125 EMIT % 80 % 88 +!
13 P ." FORTH" CR 0 752 C! ;         : CLEAR % 16 0 DO I SCR @
14 P (LINE) DROP C/L BLANKS UPDATE   LOOP ;
15 P ( END ) -->

82 CLEAR
 0 P ( EDYTOR-FORTH / ED-DYSK )
 1 P : MARK SCR @ % 8 * % 8 0 DO I   OVER + BLOCK DROP UPDATE
 2 P LOOP DROP ;                     : E. (E) EXFO ;
 3 P : L. SCR ! E. ;                 : F. MARK FLUSH ;
 4 P : INDE EMPTY-BUFFERS            GGE SWAP GGE 1 - MIN
 5 P DO I 8 * BLOCK 32 -TRAILING     OVER @ DUP 8224 = 0= * IF CR
 6 P I . SPACE TYPE ELSE 2DROP ENDIF ?TERMINAL IF LEAVE ENDIF
 7 P LOOP EMPTY-BUFFERS ;            : IND 1 INDE ;
 8 P CR ." EDYTOR-FORTH: screen L." CR 
 9 P ( END ) ;S
  
 
83 CLEAR
 0 P ( VECTORED EXECUTION )
 1 P ( adapted from R. W. Sommers - FD V/4/P17 )
 2 P : TASK ; 0 VARIABLE 'param
 3 P : WHO 'param @ CFA EXECUTE ;
 4 P : WELCOME CR ." HELLO, DEAR "
 5 P   WHO ." !" ;
 6 P : DEFAULT ; ' DEFAULT 'param !
 7 P : BARTOSZ  ." BARTOSZ" ;
 8 P : MATYLDA  ." MATYLDA"  ;
 9 P CR WELCOME
10 P CR ' BARTOSZ 'param ! WELCOME
11 P CR ' MATYLDA 'param ! WELCOME
12 P CR ;S
13 P ( ** Hint of the day ************** )
14 P ( Example usage of FENCE and FORGET )
15 P (  ' X FENCE !     Y FORGET    SAVE )


84 CLEAR
 0 P ( "Blinking Characters" )
 1 P ( "39 LOAD" from APX floppy to load Mullarky's ASM )
 2 P HEX : TASK ; CODE Blink ( -- )
 3 P   02F3 LDA,  2 # AND, 2 #  EOR,
 4 P   02F3 STA, 15 # LDA, 021A STA,
 5 P RTS,
 6 P CODE BlinkStart ( -- )
 7 P   15 # LDA, 021A STA,
 8 P NEXT JMP,
 9 P : BlinkInit ( -- ) ' Blink 228 ! ;
10 P : BlinkCursor ( -- ) BlinkInit BlinkStart ; DECIMAL ;S
11 P ( *** RM COMPUTE 12/81 )


85 CLEAR
 0 P ( 1/2 GoesInto Decompiler )
 1 P ( FD Vol4 Nr2 p28, R. D. Ackermann )
 2 P : TASK ; 0 VARIABLE GIN 
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

86 CLEAR
 0 P ( 2/2 "GOIN x" RET/SPC/Q ) 
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

86 DUP #SC ! SCR !

PREPARE 
Q ( 1/2 FIG-EDITOR SUBSET ) : /START ; CR CR SPACE BASE @ 
Q : HEX DECIMAL 5 712 ! HEX ; :  DECIMAL DECIMAL 0 712 ! ; HEX
Q : TEXT HERE C/L 1+ BLANKS WORD HERE PAD C/L 1+ CMOVE ;
Q : LINE DUP FFF0 AND 17 ?ERROR SCR @ (LINE) DROP ; : MARK 10 0 
Q   DO I LINE UPDATE DROP LOOP ; VOCABULARY EDITOR IMMEDIATE
Q : WHERE DUP B/SCR / DUP SCR ! ." SCR # " DECIMAL .
Q   SWAP C/L /MOD C/L * ROT BLOCK +   CR C/L -TRAILING TYPE CR
Q   HERE C@ - SPACES 1 2FE C! 1C EMIT 0 2FE  C! [COMPILE] EDITOR
Q   QUIT SP! ; EDITOR DEFINITIONS : #LOCATE R# @ C/L /MOD ;
Q : #LEAD #LOCATE LINE SWAP ; : #LAG  #LEAD DUP >R + C/L R> - ;
Q : -MOVE LINE C/L CMOVE UPDATE ; : P 1 TEXT PAD 1+ SWAP -MOVE ; 
Q : E LINE C/L BLANKS UPDATE ; : TOP 0 R# ! ; 
Q : M R# +! CR SPACE #LEAD TYPE 17 EMIT #LAG TYPE
Q   #LOCATE . DROP ; : 1LINE #LAG PAD COUNT MATCH R# +!  ;
Q : CLEAR  SCR ! 10 0 DO FORTH I EDITOR E LOOP ;
Q : L SCR @ LIST 0 M ; --> ( idea of subset: FD III/2/p40 & pF )

PREPARE
Q ( 2/2 FIG-EDITOR & SEARCH & .CC ) 
Q : COPY   B/SCR * OFFSET @ + SWAP    B/SCR * B/SCR OVER + SWAP
Q   DO DUP FORTH I BLOCK 2 - ! 1+ UPDATE LOOP DROP FLUSH ; 
Q CR ." Fig-Editor subset loaded." CR DECIMAL FORTH DEFINITIONS
Q DECIMAL LATEST 12 +ORIGIN !  HERE 28 +ORIGIN ! HERE 30 
Q +ORIGIN ! ' EDITOR 6 + 32 +ORIGIN ! HERE FENCE ! BASE ! 
Q : (I @ 4 - NFA ID. ; : .CON CONTEXT (I ; : .CUR CURRENT (I ; 
Q : .CC CR ." Context, Current: " .CON .CUR CR ; ( FDIII1p10/KH )
Q 0 VARIABLE SRCHCNT : BUMP 1 SRCHCNT +! SRCHCNT @ 56    ( "/JJ )
Q   > IF 0 SRCHCNT ! CR THEN ; : SEARCH ( FROM TO -- STRING )
Q   CR 01 TEXT 0 SRCHCNT ! 1+ SWAP DO FORTH I SCR ! EDITOR TOP
Q   BEGIN 1LINE IF 0 M SCR ? BUMP THEN    1023 R# @ < UNTIL 
Q   LOOP ; : (LINE/2) >R C/L 2 / B/BUF */MOD R> B/SCR * + BLOCK +
Q   C/L 2 / ; : LI CR ( N -- ) SCR ! 32 0 DO CR I SCR @ (LINE/2)
Q   -TRAILING TYPE LOOP CR ." === SCR#" SCR ? CR CR ; CR
Q ." SEARCH loaded, try: 16 18 SEARCH KOT" CR CR : /FIGEDIT ; ;S

FLUSH
FORTH
