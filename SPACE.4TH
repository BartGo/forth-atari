( code from Mullarky's space forth, unique to this version )

( DISK COPY ROUTINE              )
( 40 K RAM AND DRIVES #1 AND #2  )
( INSERT SOURCE DISK IN DRIVE #1 )
( AND NEW DISK IN DRIVE #2. THEN,)
( SIMPLY TYPE  "DISKCOPY" !      )

BASE @ DECIMAL 24576 CONSTANT BUFHEAD
0 VARIABLE BLK# 0 VARIABLE ADRS
: GET ADRS @ BLK# @ ;
: RD GET DUP 718 = IF LEAVE THEN 1 R/W ;
: WRT GET 720 + DUP 1438 = IF LEAVE THEN 0 R/W ;
: +BLK 1 BLK# +! 128 ADRS +! ;
: SETUP BLK# ! BUFHEAD ADRS ! ;
: RDIN SETUP 90 0 DO RD +BLK LOOP ;
: WRTO SETUP 90 0 DO WRT +BLK LOOP ;
: MS1 CR CR ." INSERT SOURCE IN DRIVE #1 AND"
  CR ." NEW DISK IN DRIVE #2" CR ." HIT ANY KEY WHEN READY..."
  KEY DROP ;
: %COPY 0 DO I 90 * DUP DUP RDIN WRTO 90 + . LOOP ;
: DISKCOPY  CR MS1 CR 8 %COPY ;
: FORTHCOPY CR MS1 CR 5 %COPY ;

;S

( UTILITIES BOOT, MEMO-PAD )
( Lloyd Ollman Sep 81 )
HEX CODE BOOT E477 JMP,
    CODE MEMO-PAD E471 JMP,
DECIMAL FORTH ;S


