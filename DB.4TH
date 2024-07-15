( mentioned by bfox9900 in https://www.reddit.com/r/Forth/comments/1e26nsn/fun_little_realization/ )
( "This feature of /MOD can be used to create records in block files as well. For example assuming 64 byte records:" )

: RECORD  ( rec# -- addr)
  64 UM*  1024 UM/MOD ( offset blk#) BLOCK + ;

  
