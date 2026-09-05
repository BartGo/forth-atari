( an example of dependency inclusion )
( using "preproc.sh" script          )

: PROGRAM ;

: REQUIRE -FIND 0= IF
    CR ." Not found; halted!"
    CR KEY DROP BEGIN AGAIN
  THEN 2DROP ;

REQUIRE ASCII

( -- ERROR HANDLING -- )
{ $$../mods/MSG4-OFF.FTH }
{ $$../mods/MESSAGE.4TH }

( -- TRUE EXTENSIONS -- )
{ $$../mods/ARGRES-VAL.4TH }
{ $$../mods/ALGEBRAIC.FTH }
{ !-- $$../mods/PICK&ROLL.4TH }
{ $$../dictionary/LOCALDEF.4TH }
{ $$../dictionary/RECOLON.4TH }

( -- DEBUG TOOLS -- )
REQUIRE ASSEMBLER
REQUIRE EDITOR
REQUIRE DECOMP
REQUIRE RE-CREATE
( TODO: is our asm using END-CODE? )
{ $$../debug/BREAK&GO.4TH }
{ $$../debug/STACK-PROMPT.4TH }

REQUIRE ALGEBRAIC
REQUIRE ARGUMENTS
REQUIRE RESULTS
REQUIRE VAL

: MAIN ;

MAIN
