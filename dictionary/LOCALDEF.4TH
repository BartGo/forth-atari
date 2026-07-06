( ----------------------------- )
( Local/scoped words by BartGo; )
( for Atari 8-bit APX fig-Forth )
( ----------------------------- )
( based on an idea published in )
( Forth Dimensions [FD] - V06N6 )
( by Carol Pruitt, 11-Jun-84 w/ )
( the below licence note:       )
( ----------------------------- )
( Copyright[c] 1985 by the      )
( University of Rochester. All  )
( rights reserved. Permission is)
( hereby granted for personal,  )
( non-commercial use provided   )
( this notice accompanies such  )
( use. 
( ----------------------------- )
( the original idea used a bit  )
( to mark local words; instead, )
( I follow an existing fig-Forth)
( convention of word names in   )
( paretheses meaning "internal" )
( ones. by FOLD'ing [ n -- ] we )
( request that lfa links are    )
( only preserved in non-internal)
( words, so the internal/local  )
( ones are not searchable - but )
( the references are preserved. )
( ----------------------------- )
( purpose: hide non-local words )
( ----------------------------- )
( usage: HERE ..declare.. FOLD  )
( or: ' FIRST-TO-CLEAN NFA FOLD )
( ----------------------------- )

FORTH DEFINITIONS DECIMAL

40 CONSTANT CHAR.LOC     ( ; names starting with left par / ascii 40 dec / become local )
0 VARIABLE LINK.FROM     ( ; to store the last non-local nfa [originally, lfa] )     
: FOLD                   ( here -- )
  LATEST DUP LINK.FROM ! ( ; set most recent's nfa parent as the sentinel for traversing the tree )
  BEGIN 2DUP < WHILE     ( ; do not traverse deeper than 'here' - hopefully stored on the data stack )
    DUP	1+ C@ CHAR.LOC   ( here nfa+1 f ; is the 1st char of the name saying it's a local word? )
    = IF                 ( ; if a local word - kill the link, otherwise preserve in the LINK.FROM )
	  PFA LFA @ DUP      ( here pnfa pnfa )
	  LINK.FROM @ !      ( here pnfa )
    ELSE                 ( ; global word )
	  PFA LFA DUP        ( here lfa lfa )
	  LINK.FROM ! @      ( here pnfa )
    THEN REPEAT 2DROP ;  ( -- )

( example )

: MYWORD1 ;
: (MYWORD3) MYWORD1 ;
: MYWORD2 (MYWORD3) ;
: (MYWORD4) ;
: MYWORD5 (MYWORD4)
  MYWORD2 ;

' MYWORD1 NFA FOLD

FORTH DEFINITIONS DECIMAL

