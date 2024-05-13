(
---
( Source Screen Documentation Tool WF25 2Apr82 KRH
( Kim Harris / Laxen & Harris, Inc. 
( https://archive.org/details/Forth_Dimension_Volume_04_Number_2/page/n22/mode/1up
( Modified by BartGo, to use (LINE)
( instead of BLOCK, renamed OUTLINE-OUTLINES, 1OUTLINE-OUTLINE
---
)

: OUTLINE ( #scr -- ) 
  DUP CR CR ." Screen # " . DUP SCR !
  15 0 DO
    DUP I SWAP  ( scr#, ln#, scr# )
    (LINE) SWAP ( scr#, 64, lineaddr )
    DUP C@ BL = 0=      
    I 0= OR IF  ( 1st line or non-space? )         
      SWAP -TRAILING CR TYPE ( print line )
    ELSE DROP DROP THEN ( skip line )
  LOOP DROP CR ;                
: OUTLINES ( #1st-screen #last-screen -- )
  1+ SWAP DO I 1OUTLINE LOOP ;

;S


