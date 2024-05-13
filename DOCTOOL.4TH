( FIXME )

(
Source Screen Documentation Tool
Kim Harris
Laxen & Harris, Inc. 
https://archive.org/details/Forth_Dimension_Volume_04_Number_2/page/n22/mode/1up
)

( Source screen documentation tool WF25 2Apr82 KRH )


( FIXME )
: 1OUTLINE              ( #scr -- ) 
  DUP SCR ! CR CR ." Screen # "
  DUP . 1024 0          ( scr#, 1024, 0 )
  DO
    DUP BLOCK           ( scr#, blockaddr )
    I +                 ( scr#, blockaddr+I )
    DUP C@ BL = 0=      ( scr#, blockaddr+I, if blockaddr+I]@!=BL )
    I 0= OR IF          (   or I=0 \ 1st line or starts with non-space  )
      64 -TRAILING TYPE ( scr#, TYPE-TRAILING at blockaddr+I \ print line ) 
    ELSE DROP THEN      ( scr#, DROP blockaddr+I \ do nothing with the block )
  64 +LOOP              ( keep scr# on stack, take next line [64 bytes] )
  DROP ;                ( finally - drop the scr# )

: OUTLINE ( #1st-screen #last-screen -- ) ( print line 0 & )
( lines with non-blank in column 1 for range of screens    )
  1+ SWAP
  DO I 1OUTLINE
  LOOP ;

;S

Assumptions:
* Line 0 should be used for a comment only.
* Line 15 should be left blank. (?!)
* Any line may have text from the first column UP TO the last column. The last column of each hne should be blank to avoid running into the start of the next line.
* Start each definition in the first column of a new line. This applies to colon definitions and all other classes (e.g. CONSTANTs, VARIABLEs, etc.]
* Follow each defined name by a "stack comment" similar to that of a glossary entry.
* Follow each stack comment by a "purpose comment" (i.e., WHAT the word does, not HOW it does it). If the comment is continued to the next line, put an open parenthesis in the first column of the second line. Although this is not required for FORTH, it allows OUTLINE to pick up this comment line.
* The documentation tool is compatible with the following dialects (except as noted below): 79-STANDARD, Starting FORTH, fig-FORTH, and polyFORTH
* The implementation assumes 1024 byte disk buffers and 64 byte lines for screens.
* On a single-user FORTH system, TYPE may be used instead of >TYPE.

