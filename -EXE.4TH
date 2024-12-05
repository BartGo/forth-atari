( execute word if exists & )
( do nothing if not exists )

: -EXE ( -EXE myword -- )
  -FIND IF DROP CFA EXECUTE
  THEN ; IMMEDIATE  
