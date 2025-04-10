( Tracing colon-definitions )
( Paul van der Eijk FDv03n2 )
( * traces: at colons     * )
FORTH DEFINITIONS DECIMAL
1 VARIABLE TFLAG
: (TRACE)
  TFLAG @ IF CR R 2 - NFA DUP
  ID. C@ 31 AND 32 SWAP -
  SPACES -2 4 DO SP@ I + @
  7 .R -2 +LOOP CR THEN ;
: ['] [COMPILE] ' ; IMMEDIATE
: :
  ?EXEC !CSP CURRENT @ CONTEXT !
  CREATE ['] (TRACE) CFA DUP @
  HERE 2 - ! , ] ; IMMEDIATE

( redefine to trace )
( : ! ! ; )
( : C! C! ; )

( * Tracing colon definition * )
( - shows stack, R and ID. of  )
(   each compiled word         )
( Bruce W. Walker ver./FDv05n6 )
( * traces: during INTERPRET * )
 
1 VARIABLE TRACE : NOP ;
: .S 40 EMIT SPACE SP@ 188 = 0=
  IF SP@ 2 - 186 DO I @ . -2
  +LOOP THEN 41 EMIT SPACE ; 
: ['] [COMPILE] ' ; IMMEDIATE
: (TR) CR ." > " .S R . R 4 - @
  2 + NFA ID. ?TERMINAL IF
  KEY 27 = IF ABORT THEN THEN ;
: TRC CFA , TRACE @ IF ['] (TR)
  CFA , THEN ;
' NOP CFA 7610 ! ( ex: CFA )
' TRC CFA 7612 ! ( ex: ,   )

( see also: )
( FD-V05N2p17 Tracer for Colon Definitions by Rieks Joosten)

( below bad OCR to be corrected )

OVALUE?TMX ( flag telling whether tracer is active or not )
OVAILTEYINIZWT ( contains the number of indentation spaces )
: TRII~=E ?TRACE O= MTP To ?TRpaE ( toggle tracer flag. If tracer is )
IF 0 ~o #- THW : ( turned on, the indentation is reset)
-. : srp~ CR#IN .I "ST- : " ( print the contents of the stack, or )
m ?Em ( print 'stack my'. If the contents )
IFlswA?? ( of the stack is printed, the element )
( on tap of the stack is printed right- )
( mt. A '#' character is printed to )
ELSE ." "EMPPY THW ; ( prevent any other output to trouble )
( the picture of the stack 1
Do I PICK . -1
+113op ASCII-# EMIT
: (:)
IF
-
STACK ( If in trace mode, print the stack )
( and print the name of the calling )
( routine. )
( Special for pre-increment SyStenrS
( CR#IN R CFA "PME) ( for post-increment systems 1
CR#IN R 2- CFA "PME
lUrO#~ ( increment the indentation counter )
THaJ;
: (:) ?TRpI=E ( If in trace mode, decrement the )
IF -1 UrO #INDlWT STPM ( indentation counter and print the )
THW; ( contents of the stack )
: X [COMpIm] : ~ILE (:) ; ( redefine : 1 : Y COMPILE (;) [~(~M~ILE] : ; MEDIATE ( redefine : : 1
ASCII-: ' X NFA 1+ C! ( Store : in the -field of X 1
ASCII-; ' Y NFA 1+ C! ( Store ; in the namefield of Y 1
( The last two lines change the headers of the routines X and Y into
( headers of : and :



FD-V06N5.pdf
( An Augmented TRACE by Andreas Goppold )
