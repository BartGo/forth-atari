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
     
