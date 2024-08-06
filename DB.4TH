( mentioned by bfox9900 in https://www.reddit.com/r/Forth/comments/1e26nsn/fun_little_realization/ )
( "This feature of /MOD can be used to create records in block files as well. For example assuming 64 byte records:" )

( NOT WORKING YET ON A8 )
( TODO: DEFINE UM* and UM/MOD, TEST )

FORTH DEFINITIONS DECIMAL 
64   CONSTANT #REC
1024 CONSTANT #PAG
: RECORD  ( rec# -- addr)
  #REC UM*
  #PAG UM/MOD ( offset blk#)
  BLOCK + ;

( example: extract 2nd line from 40th screen ) 
#PAG 40 * #REC 2 * +
#PAG TYPE
  
