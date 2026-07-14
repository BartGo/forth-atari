( an example of dependency inclusion )
( using "preproc.sh" script          )

: PROGRAM ;

: REQUIRE -FIND 0= IF
    CR ." Not found; halted!"
    CR KEY DROP BEGIN AGAIN
  THEN 2DROP ;

REQUIRE ASCII

( -- ERROR HANDLING -- )
{ $$../mods/msg4-off.fth }
{ $$../mods/message.4th }

( -- TRUE EXTENSIONS -- )
{ $$../mods/argres-val.4th }
{ $$../mods/algebraic.fth }
{ !-- $$../mods/pick&roll.4th }
{ $$../dictionary/localdef.4th }
{ $$../dictionary/recolon.4th }

( -- DEBUG TOOLS -- )
REQUIRE ASSEMBLER
REQUIRE EDITOR
REQUIRE DECOMP
REQUIRE RE-CREATE
( TODO: is our asm using END-CODE? )
{ $$../debug/break&go.4th }
{ $$../debug/stack-prompt.4th }

REQUIRE ALGEBRAIC
REQUIRE ARGUMENTS
REQUIRE RESULTS
REQUIRE VAL

: MAIN ;

MAIN
