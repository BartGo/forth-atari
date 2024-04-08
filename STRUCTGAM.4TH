FORTH DEFINITIONS DECIMAL

( ### base & types ### )

: TASK ;
: J R> R> R> R R# ! >R >R >R R# @ ;
: (( ;
: Rnd 0 ; ( TO DO ) 
: TArray2D
  <BUILDS DUP , * 2 * ALLOT
  DOES> ROT OVER @ + ROT + 2 * + 2+ ;

( ### constants ### )
  
 16 CONSTANT GRID
250 CONSTANT FUEL
100 CONSTANT RNG
200 CONSTANT CPCT
5   CONSTANT LSR
10  CONSTANT ARM
3   CONSTANT MSL  ( missiles: class and # on bits )

( ### variables ### )

GRID GRID
  TArray2D ))galaxy ( each field's bit: 0 nothing 1 trash 254 goat-soup )

( ### init ### )

: GalaxyInit ( -- )
  SIZE SIZE DO (( 0 i j ))galaxy ! ;

( ### ui ### )

: Home 125 EMIT ;
: XGr ;
: 

( ### logic ### )

( ### main ### )
: Main ;

: RUN Main ;

CR
CR ." To start: RUN" CR
CR
