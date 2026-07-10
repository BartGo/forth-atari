( an example of dependency inclusion )
( using "preproc.sh" script )

( -- ERROR HANDLING -- )
0 WARNING !
{ $$../mods/msg4-off.fth }
{ $$../mods/message.4th }

( -- TRUE EXTENSIONS -- )
{ $$../dictionary/localdef.4th }
{ $$../dictionary/recolon.4th }
{ $$../mods/algebraic.fth }
{ $$../mods/pick&roll.4th }

( -- DEBUG TOOLS -- )
( TODO: is our asm using END-CODE? )
{ $$../debug/break&go.4th }
{ $$../debug/stack-prompt.4th }

: $ ( n -- ; push nth parameter)
  1 - DUP + R# @ + @ ;

: MAIN ;

MAIN
