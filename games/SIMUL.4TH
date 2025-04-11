( *WIP* )
( THE FORTH KINGDOM )
( HAMURABI-LIKE GAME )
( FOR APX FORTH BY BARTGO )

( TODO: document the algorithms better )
( TODO: count # of productive people )
(  minus children and retired, and only )
(  allow as many buildings as people, e.g. )
(  farm/plant/storage requires two )
(  factory requires ten )
(  make charts to visualize this and record history of goods and spends )

FORTH DEFINITIONS DECIMAL

: DEV( ; 
	( SHOW STACK )
	: .S ( -- )
	  40 EMIT SPACE
	  SP@ 188 = 0= IF SP@ 2 -
	  186 DO
	  I @ . -2 +LOOP THEN 41
	  EMIT SPACE ;
	( RE-DEFINING A COLON WORD )
	( by EHS )
	( https://www.forth.org/fd )
	( /FD-V06N3.pdf )
	' : CFA @ CONSTANT DOCOL
	: RE-CREATE ( -- )
	  -FIND 0= IF
		HERE COUNT
		TYPE ."  NOT FOUND"
		ABORT
	  THEN
	  DROP DUP CFA @ DOCOL = 0=
	  IF
		HERE COUNT TYPE
		."  NOT A COLON WORD"
		ABORT
	  THEN HERE SWAP ! ;
	: RE-EXIT ( -- ) R> R>
	  2DROP ;
	: R: ( -- )
	  SP@ CSP ! CURRENT @
	  CONTEXT ! 
	  RE-CREATE DOCOL , ] ;
	: ;R ( -- )
	  ?CSP COMPILE RE-EXIT
	  [COMPILE] [ ; IMMEDIATE
    ( TODO: ADD BREAK / GO )
    ( TODO: ADD TRACING )	
	( * CRASH IF A WORD IS NOT )
	( * COMPILED )
	: DONE: -FIND 0= IF
	    ." (!) NOT COMPILED" CR
	    BEGIN
 	      KEY 27 = IF QUIT THEN
	    AGAIN
	  THEN ; IMMEDIATE
: )DEV ;

1    CONSTANT #H  ( APETITE )
10   CONSTANT #G  ( PRICE )
30   CONSTANT #A  ( PRICE )
120  CONSTANT #F  ( PRICE )
10   CONSTANT #FC ( ENERGY USE )
40   CONSTANT #SP ( PRICE )
90   CONSTANT #CP ( PRICE )
10   CONSTANT #EP ( PRICE )
50   CONSTANT #FF ( YIELD )
10   CONSTANT #AA ( YIELD )
10   CONSTANT #CC ( YIELD )
100  CONSTANT #SS ( CAPCT )
1    CONSTANT #LASTYR ( LASTYR )
52 7 *
  CONSTANT #D/YR 
20 4 / DUP *     ( 25 MAX BLD )
  CONSTANT #MAXB ( ON SCREEN  )
9999 CONSTANT #MAXM ( TODO )
9999 CONSTANT #MAXE ( TODO )
9999 CONSTANT #MAXG ( TODO )
#D/YR
  CONSTANT #MAXH

: VAR 0 VARIABLE ; IMMEDIATE

VAR P ( PEOPLE )
VAR G ( GOODS )
VAR E ( ENERGY )
VAR C ( SOLAR CELLS/PLANTS )
VAR M ( MONEY )
VAR A ( FARMS / AGRO )
VAR F ( FACTORIES )
VAR S ( STORAGE )
VAR T ( TIME )
VAR H ( HUNGRY DAYS )

: >= < 0= ( a b -- f ) ;
: ASSERT< ( a b -- )
  < 1 ?PAIRS ;

84   CONSTANT #Y
85   CONSTANT #X

: POS  ( x y -- ) #Y C! #X ! ; 
: XYRE ( x y -- )
       ( 10 10 XYRE Q )
  POS [COMPILE] ASCII 128 +
  EMIT ; 

: #GROW    ( a -- a )
  8 * 7 /   ; ( POPULATION )
: SCAP@    (   -- a )
   S @ #SS * ; ( TOTAL STORAGE )
: AYIELD@  (   -- a ) 
   A @ #AA * ; ( TOTAL AGR YLD )
: CYIELD@  (   -- a ) 
   C @ #CC * ; ( TOTAL CLL YLD )
: FYIELD@  (   -- a ) 
   F @ #FF * ; ( TOTAL FCT YLD )
: FEUSAGE@ (   -- a ) 
   F @ #FC * ; ( TOTAL FCT E U )
: PGUSAGE@ (   -- a ) 
   P @ #H  * ; ( TOTAL PPL G U )
: PEUSAGE@ (   -- a ) 
   P @       ; ( TOTAL PPL E U )
: ELEFT@   (   -- a ) 
   E @ FEUSAGE@ -
   PEUSAGE@ - ; ( E LEFT )
: GLEFT@   (   -- a ) 
   G @ PGUSAGE@ - ; ( G LEFT )
: PLEFT@   (   -- a ) 
   P @ H @ -      ; ( P LEFT )
: ?BLD     (   -- f )
   S @ A @ + C @ F @ + +
   #MAXB < ;

: CONSUME ( -- )
  ELEFT@ 0 > IF
    ( FACTORIES AND PEOPLE ) 
    ELEFT@ E ! ELSE 0 E !
	( USE ENERGY )
  THEN
  GLEFT@ 0 > IF
    ( BUT ONLY PEOPLE )   
    GLEFT@ G !
	( CONSUME GOODS ) 
    0 H !
	( SO NO HUNGER HAPPENS )
  ELSE
    0 G !
	( IF NOTHING LEFT TO EAT )
    H @ 0 > IF
  	  ( AND HUNGER PERSISTS )
      PLEFT@ 0 > IF
  	    ( AND ANY PEOPLE LEFT )
  	    PLEFT@ P !
		( THE MORE HUNGRY )
		( THE MORE DIE )
      ELSE 0 P ! THEN
	  ( UNTIL ALL ARE DEAD )
    THEN
    1 H +!
	( ANOTHER DAY OF HUNGER )
  THEN
  H @ T @ ASSERT< ;
DONE: CONSUME
	
: PRODUCE ( -- )
  AYIELD@ G +!   ( FARMING  )
  CYIELD@ E +!   ( ENERGY   )
  SCAP@ E @ < IF ( E CAP )
    SCAP@ E !
  THEN
  ELEFT@ 0 >= IF ( ENERGY?  )
    FYIELD@ ELEFT@ MIN G +!
	( INDUSTRY )
  ELSE
    FYIELD@ ELEFT@ + G +!
  THEN
  SCAP@ G @ < IF ( G CAP )
    SCAP@ G !
  THEN ;
DONE: PRODUCE
	
: BREED ( -- )
	T @ #D/YR MOD 0= IF
	  ( EVERY NEW YEAR )
	  P @ #GROW P !     
	  ( INCREASE POPULATION )
	THEN ;

: SUNRISE ( -- ) 1 T +! ;

: SEP ( -- )
  CR 24 0 DO 18 EMIT LOOP ;
   
: UI ( -- )
  125 EMIT
  F @ A @ > IF
    ." THE 4TH INDUSTRIAL KINGDOM" 
  ELSE  ." THE 4TH FARMING KINGDOM"
  THEN	
  SEP CR ."   DATE: YR "
  T @ #D/YR / 1+ .
  ." / DAY " T @ . 

  H @ 0 > IF
    ." - IN HUNGER: " H ?
  THEN
  CR ."  MONEY: " M @ .
  CR ." PEOPLE: " P @ . 
  CR ."  GOODS: " G @ . 
  CR ." ENERGY: " E @ . 
  SEP
  CR ."     FARMS: " A @ .
  ." ( " A @ #AA * . ."  )"
  CR ." FACTORIES: " F @ .
  ." ( " F @ #FF * . ."  )"
  CR ." POWPLANTS: " C @ .
  ." ( " C @ #CC * . ."  )"
  CR ."   STORAGE: " S @ .
  ." ( " S @ #SS * . ."  )"
     SEP
  CR ." -> (A)groFrm:/$" #A .
  CR ." -> (S)torage /$" #SP .
  CR ." -> (P)wrPlnt /$" #CP .
  CR ." -> (F)actory /$" #F .
  CR ." -> (G)dsSell /$" #G .
  CR ." -> (E)nrgSell/$" #EP .
  CR ." -> (C)harts (M)ap"
  CR ." -> (W)iseMen"
  CR ." -> (D)ebug"
  CR ." -> (N)ext (Q)uit" ; 
DONE: UI

: INIT ( -- ) 
  20  P ! ( people )
  0   E ! ( energy )
  0   C ! ( cells / pwr plants )
  200 M ! ( money )
  0   A ! ( agro-farms )
  0   F ! ( factories )
  2   S ! ( storages / silos )
  SCAP@ G ! ( fill silos ) 
  0   T ! ( time )
  0   H ! ( days of hunger ) ;

: FINALIZE ( -- )
  2 82 C! 148 710 ! ;

: GET-INPUT ( -- )
  0 BEGIN
	ASCII N = 0= ( f )
  WHILE
	UI KEY ( S: a )
	DUP ASCII A = M @ #A >=
	  AND ?BLD AND IF ( agro )
		  1 A +! M @ #A - M !
	  THEN
	DUP ASCII F = M @ #F >=
	  AND ?BLD AND IF ( fctry )
	      1 F +! M @ #F - M !
	  THEN	
	DUP ASCII S = M @ #SP >=
	  AND ?BLD AND IF ( strge )
	    1 S +! M @ #SP - M !
	  THEN
	DUP ASCII P = M @ #CP >=
	  AND ?BLD AND IF ( pwrplnt )
	    1 C +! M @ #CP - M !
	  THEN
	( S: a )
	DUP ASCII G = G @   0 >
	  AND IF ( sellgd )
	      -1 G +! #G M +!     
      THEN
	DUP ASCII E = E @   0 >
	  AND IF ( sell energy )
	    -1 E +! #EP M +!     
	  THEN
	DUP ASCII Q = IF 
	    DROP FINALIZE 125 EMIT
		QUIT
	THEN ( S: - )
	DUP ASCII D = IF 
	    DROP CR .S CR
		BEGIN QUERY INTERPRET
	AGAIN THEN ( S: - )
	( TODO: to implement C/M/W )
  REPEAT ;
DONE: GET-INPUT
 
: MAIN ( -- )
  8 82 C! 210 710 !
  BEGIN
	#D/YR #LASTYR * T @ >
  WHILE
	SUNRISE	CONSUME	PRODUCE
	BREED GET-INPUT
  REPEAT ;
DONE: MAIN
  
: X INIT MAIN ;

;S


pieniadze $, towary @, ludzie #, czas *
Money Goods People Time

x(n): obecny okres, x(n+1): nastepny

M(n=0): 200; M(n+1)= 5*F+1*A (kazdego dnia fabryka produkuje 20 a farma 1)
G(n=0): 100; G(n+1)= 20*F+4*A (kazdego dnia fabryka produkuje 50 a farma 10)
ludzie zuzywaja G - kazda osoba 1 dziennie
brak G, ludzie sie nie mnoza a potem zaczynaja umierac 
P(n=0): 20; P(n+[7*52]) / |P/2*0,5| co 52 tygodnie (1 dziecko); tez ubywa - 1 osoba na rok?
ogolnie: P(n)=P(0)*(1.25-m)^n (m=mortality rate, e.g. 0.02)
P(n+1)=P(n)*1.23^n
-> zmiana na 1.14, wyglada realniej (#8476 po 50 latach)
dobra sie psuja z niskim prawdopodobienstwem, w lato wyzsze
farma produkuje malo jedzenia w zime, fabryka lepiej ale i tak bez zapasow nie dacie rady
T(n=0): 0; T(n+1); 1 = tydzien; T(max) = 18200 (7 dni*52 tygodnie*50 lat )

najlepiej zrobic serie liczb i wykresy, na razie pominmy pieniadze, tylko G
farmy to A, fabryki to F
T(0)=0; P(0)=20; G(0)=100; A(0)=0; F(0)=0
T(1)=1; P(1)=20; G(1)=G(0)-P(0)=80; 
T(2)=2; P(2)=20; G(2)=G(1)-P(1)=60; 

IF MOD(T(n))/(52*7)==0
  P(n)=P(n-1)*8/7
THEN
----

nowe
$ iles na start, produkowane w fabrykach - i moze z podatkow??
@ z farm (A) lub fabryk (F)
# z innych ludzi (pewien procent par, zalezny od warunkow)
* postarza, eliminuje lub dodaje ludzi i towary

ludzie: #, wymagają towarow do zycia i mnozenia sie, generuja troche $ (podatki)?
farmy: produkują towary, potrzebuja ludzi (minimum 2 osoby) i deszczu, dotarczaja wiecej $
fabryki: produkują towary, wymagają ludzi (minimum 10) i $, dotarczaja duzo $

może upgrade - ludzie płacą podatki ale konsumują energię i więcej dóbr, może być wojsko

drzewko rozwoju, jak zrobić - state machine?

uwaga na przepełnienie typów

===
