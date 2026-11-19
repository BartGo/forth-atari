( from fig-forth_PDP-11_Users_Guide )
( John S. James, Sept. 1979 )

( ** UNTESTED - yet unclear how to use the built word ** )
 
( 'VARRAY' CREATES A VIRTUAL ARRAY ON DISK SCREENS.)            
: VARRAY ( LRECL #RECS STARTSCREEN -> )                         
   <BUILDS , , DUP , 1024 SWAP / ,                              
   ( STARTSCREEN, #RECS, LRECL, RECS/SCREEN)                    
   DOES> >R DUP R 2 + @ < 0= OVER 0< OR                         
     IF ." ERROR, V-ARRAY RANGE " . R> DROP                     
     ELSE R 6 + @ /MOD R @ + BLOCK SWAP R> 4 + @ * + THEN ;  


( 'VARRAY' CREATES A VIRTUAL ARRAY ON DISK SCREENS )
( PORTED TO ATARI 8-BIT APX FORTH by Gemini )
( to be tested! )

( Defining: lrecl #recs start-scr -- )
( Runtime:  rec# -- addr )
( lrecl: Record length in bytes (e.g., 2, 16, 128)
( #recs: Total number of records in the array (valid indices are 0 to #recs - 1)
( start-scr: First disk screen number allocated for storage
( rec#: Zero-based index of the record you want to access
( addr: Memory address of that record inside the disk buffer (returns rec# unchanged if an out-of-range error occurs)
: VARRAY ( LRECL #RECS STARTSCREEN -- )
  <BUILDS
    ,              ( PFA+0: STARTSCREEN )
    ,              ( PFA+2: #RECS )
    DUP ,          ( PFA+4: LRECL - record length in bytes )
    1024 SWAP / ,  ( PFA+6: RECS/SCREEN )
  DOES> ( rec# pfa -- addr )
    >R
    DUP I 2+ @ < 0= OVER 0< OR
    IF
      ." ERROR, V-ARRAY RANGE " . R> DROP
    ELSE
      I 6 + @ /MOD      ( rem quot -> rec_in_scr scr_offset )
      I @ +             ( rec_in_scr actual_screen )
      B/SCR * BLOCK     ( rec_in_scr buffer_addr )
      SWAP R> 4 + @ * + ( buffer_addr + rec_in_scr * LRECL )
    THEN ;


( DEFINE the ARRAY: 32 200 40 VARRAY MYDATA
( WRITE data: 1234 5 MYDATA !  UPDATE )
( READ data: 5 MYDATA @ . )
( SAVE to disk: FLUSH )

--- sector safe variant

( Defining: lrecl #recs start-scr -- )
( Runtime:  rec# -- addr )
: VARRAY ( lrecl #recs start-scr --  /  rec# -- addr )
  <BUILDS
    B/SCR * ,        ( PFA+0: start-blk = start-scr * 8 )
    ,                ( PFA+2: #recs )
    DUP ,            ( PFA+4: lrecl )
    B/BUF SWAP / ,   ( PFA+6: recs/blk = 128 / lrecl )
  DOES> ( rec# pfa -- addr )
    >R
    DUP I 2+ @ < 0= OVER 0< OR
    IF
      ." ERROR, V-ARRAY RANGE " . R> DROP
    ELSE
      I 6 + @ /MOD       ( rem quot -> rec_in_blk blk_offset )
      I @ + BLOCK        ( rec_in_blk buffer_addr )
      SWAP R> 4 + @ * +  ( buffer_addr + rec_in_blk * lrecl )
    THEN ;


( Example: 160 records of 32 bytes each, starting at Screen 40 )
( 128 / 32 = 4 recs per block -> 32 recs per screen -> 5 screens used )
32 160 40 VARRAY CUSTOMERS

( Write and save record 12 )
9999 12 CUSTOMERS !
UPDATE
FLUSH
