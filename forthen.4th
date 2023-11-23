( FORTHEN v0.1 )

( ** SETTINGS, CONSTANTS, VARIABLES )
: TASK ;
21   CONSTANT #DEBUG
27   CONSTANT #EDIT
( ** IMPORTS )
#EDIT LOAD CR 
#DEBUG LOAD CR
( DONE ) ( DO NOT REMOVE )

: <TODO ; : <BUG ;
( -1  WARNING  !  )
131  CONSTANT #BGCOLOR
0    VARIABLE &HOOK

( ** BASIC WORDS )
: PAPER ( -- ) 0 81 ! #BGCOLOR 710 ! ;
: HOME ( -- ) PAPER 125 EMIT ;
: CASE ( -- ) <TODO ;
: ANY-KEY CR ." Press any key." CR KEY DROP ;

: ASK ( -- n ) ." ?" KEY <TODO ;
( ** LOGIC)
VOCABULARY APP IMMEDIATE
APP APP DEFINITIONS
  : E ." EDITOR" CR ;
  : D ." DEBUG" CR ;
  : H ." HELP" CR ;
  : C ." COMPILE" CR ;
  : B ABORT ;
  : S ." SETUP" ;
  : I ." cOpy formaT Verify" CR ;
FORTH FORTH DEFINITIONS

( ** GUI )
: MENU ( -- )
  HOME
  ." FORTHEN, a Forth development environment"  
  ." Edit Debug Help Compile Boot Setup drIve" 
  SPACE ." DSD:xx RSD:xx SCR:xx 0:MASTER 1:SOURCE"
  CR ." CURRENT: xx CONTEXT: xx" CR CR ." "?";

( ** MAIN LOOP )
: RUN ( -- )
  MENU BEGIN
    QUERY APP
      INTERPRET
    FORTH
  AGAIN ;  

( ** AUTO-RUN )   
: ((ABORT)) CR ANY-KEY RUN ;  
' ((ABORT)) CFA ' ABORT 4 + !  

RUN
