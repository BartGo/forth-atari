( code from Mullarky's space forth, unique to this version )


SCR # 36 
  0 ( DISK COPY ROUTINE  40K RAM )
  1 ( 40 K RAM AND DRIVES #1 AND #2 )
  2 
  3 24576 CONSTANT BUFHEAD
  4 0 VARIABLE BLK#  0 VARIABLE ADRS
  5 : GET   ADRS @ BLK# @ ;
  6 : RD    GET DUP 718 = IF LEAVE THEN 1 R/W ;
  7 : WRT   GET 720 + DUP 1438 = IF LEAVE THEN  0 R/W ;
  8 : +BLK  1 BLK# +!  128 ADRS +! ;
  9 : SETUP   BLK# ! BUFHEAD ADRS ! ;
 10 
 11 : RDIN   SETUP 90 0 DO RD +BLK
 12          LOOP ;
 13 : WRTO   SETUP 90 0 DO WRT +BLK
 14          LOOP ;
 15 -->


SCR # 37 
  0 ( DISK COPY ROUTINE )
  1 
  2 ( INSERT SOURCE DISK IN DRIVE #1
  3 ( AND NEW DISK IN DRIVE #2. THEN,
  4 ( SIMPLY TYPE  "DISKCOPY" !
  5 
  6 : MS1 CR CR
  7 ." INSERT SOURCE IN DRIVE #1 AND"
  8 CR ." NEW DISK IN DRIVE #2" CR
  9 ."   HIT ANY KEY WHEN READY..."
 10 KEY DROP ;
 11 
 12 : %COPY      0 DO I 90 *
 13              DUP DUP RDIN WRTO
 14              90 +  . LOOP ;
 15 -->


SCR # 38 
  0 ( DISK COPY ROUTINE )
  1 
  2 
  3 : DISKCOPY   CR MS1 CR 8 %COPY ;
  4 
  5 
  6 : FORTHCOPY  CR MS1 CR 5 %COPY ;
  7 
  8 ;S
  9 
 10 
 11 
 12 
 13 
 14 
 15 

END OF TRIAD





SCR # 84 
  0 ( UTILITIES BOOT, MEMO-PAD )
  1 ( Lloyd Ollman Sep 81 )
  2 
  3 HEX
  4 
  5 CODE BOOT E477 JMP, ( COLD START )
  6 
  7 CODE MEMO-PAD E471 JMP,
  8 
  9 
 10 FORTH
 11 
 12 
 13 
 14 
 15 ;S

