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
: HEADER ( -- )
  HOME
  ." FORTHEN, a Forth development environment" CR CR ;
: CASE ( -- ) <TODO ;
: ANY-KEY CR ." Press any key..." CR KEY DROP ;

( ** LOGIC)
VOCABULARY APP IMMEDIATE
APP APP DEFINITIONS
: C ." COMPILE" CR ;
: D ." DEBUG" CR ;
: E ." EDITOR" CR ;
: B ABORT ;
FORTH FORTH DEFINITIONS

( ** GUI )
: >ASK ( -- n ) ." ?" KEY <TODO ;
: >SETUP ( -- )
  HEADER ." SETUP:" CR CR
  >ASK DROP ;
: >MENU ( -- )
  HEADER 
  CR 5 SPACES ." Edit Debug Forget Help Compile"
  CR 5 SPACES ." Boot Setup Verify cOpy formaT"
  CR 5 SPACES ." Sxx Pxx Rxx 0:MASTER 1:SOURCE"
  CR 5 SPACES ." CURRENT: xx CONTEXT: xx"
  CR CR ;

( ** MAIN LOOP )
: RUN ( -- ) BEGIN
    >MENU CR ." "?"
    QUERY APP
      INTERPRET
    FORTH
  AGAIN ;  

( ** AUTO-RUN )   
: <ABORT CR ANY-KEY RUN ;  
' <ABORT CFA ' ABORT 4 + !  

( EOF )
