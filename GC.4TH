( AN EXCERSIZE IN FORTH, bartgo )
( *********** non-working draft )

\ PSEUDO-HEAP: N KB ALLOCATED ON THE DATA STACK

0 VARIABLE &heapmem [ 1024 4 * ] ALLOT ( heap )
0 VARIABLE &heapcnt    ( # of objects on heap )
0 VARIABLE &heaplst    ( last fre adr on heap )
4 CONSTANT #heapfld    ( # of fields per objc )

: +1! DUP @ 1+ ! ; : -1! DUP @ 1- ! ;
: HEAP &heapcnt +1! 0 [COMPILE] VARIABLE ; 
: IND! SWAP 0 SWAP ! heapcnt +1! ;
: STA! 1 SWAP DUP >R ;
: LEN! 2 DUP >R DUP &heaplst @ +! ;
: MALLOC &heapfld ALLOT LAST IND! ;
: FREE ( obj_adr -- ) 
  2+ ( start_adr ) 
;

10 HEAP list MALLOC
( allocate on heap size = 10 bytes   )
( start from &heaplst + 1            )
( dec &heapmem by size, inc &heapcnt )
list FREE / właściwie, kto to będzie sprawdzał
