( LINE COMMENT AND RE-FORTH )
( https://archive.org/details/dr_dobbs_journal_vol_06/page/32/mode/2up ) 

: \ IN @ C/L / 1+ C/L * IN ! ;
  
: SH IN @ >R BLK @ >R 0 IN ! 0 BLK !
QUERY INTEPRET R> BLK ! R> IN ! ;
