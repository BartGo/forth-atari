( * not yet working under Altirra * )

( 39 LOAD ) ( asm )
( 81 LOAD ) ( i/o )
( 83 LOAD ) ( 850 )
( BOOT850 )

82 CONSTANT #R:
4  CONSTANT #CHANNEL
12 CONSTANT #MODE

#CHANNEL CLOSE .
#R: #CHANNEL #MODE 0 OPEN .
#CHANNEL STATUS .
ASCII H #CHANNEL PUTC . 
ASCII I #CHANNEL PUTC . 
ASCII ! #CHANNEL PUTC . 
#CHANNEL STATUS .
#CHANNEL GETC . .     
#CHANNEL STATUS .
#CHANNEL CLOSE .       
#CHANNEL STATUS .

;S

( errors )
129 Already open
130 Device Not Existent
133 Device or File Not Open
135 IOCB Read Only Error
