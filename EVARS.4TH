BASE @ 

: (V
 DUP NFA ID. SPACE CFA EXECUTE
 DUP HEX 6 .R DUP @ 6 .R
 DUP DECIMAL 6 .R @ 6 .R CR ;

: EVARS
  CR CR
  ( System Constants )
  ' FIRST (V ' LIMIT (V
  ' B/SCR (V ' B/BUF (V
  '   C/L (V   CR CR
  ( User Variables )
  ( S0, R0: hidden )
  ' TIB      (V ' WARNING (V
  ' FENCE    (V ' DP      (V
  ' VOC-LINK (V ' BLK     (V
  ' IN       (V	' OUT     (V
  ' SCR      (V	' OFFSET  (V
  ' CONTEXT  (V	' CURRENT (V
  ' STATE    (V	' BASE    (V
  ' DPL      (V	' FLD     (V
  ' CSP      (V	' R#      (V
  ' HLD      (V ; 

BASE !
