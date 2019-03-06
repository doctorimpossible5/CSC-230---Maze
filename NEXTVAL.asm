;---------------------------------------------------------------------
; Program:   nextval subroutine
;
; Function:  Find next mouse move in an array 15 by 30.
;            We can move into a position if its contents is blank ( 20h ).
;
; Input:     Calling sequence is:
;            x    pointer   si
;            y    pointer   di
;            dir  pointer   bx
;            maze pointer   bp
;
; Output:    x,y,dir modified in caller's data segment
;
; Owner:     Dana A. Lasher, Ian Smart
;
; Date:      Update Reason
; --------------------------
; 11/06/2016 Original version
; 03/05/2019 First Draft
;
;---------------------------------------
         .model    small               ;64k code and 64k data
         .8086                         ;only allow 8086 instructions
         public    nextval             ;allow extrnal programs to call
;---------------------------------------


;---------------------------------------
         .data                         ;start the data segment
a         db       30                  ;char to represent a new 
b         db       0                   ;char to represent a new
y         db       0                   ;char to hold y coordinate
empty     db       20h                 ;char to represent a empty tile
east      db       1                   ;Represents east direction
south     db       2                   ;Represents south direction
west      db       3                   ;Represents west direction
north     db       4                   ;Represents north direction
;---------------------------------------


;---------------------------------------
         .code                         ;start the code segment
start:                                 ;start of the program
         mov       ax,@data            ;set accessability
         mov       ds,ax               ;to the data segment
;---------------------------------------
; Save any modified registers
;---------------------------------------
nextval:                               ;
         push      di                  ;Save the address of di
         push      si                  ;Save the address of si
         push      bx                  ;Save the address of bx
         push      bp                  ;Save the address of the maze
         mov       al,[di]             ;Load al with the y value
         mov       bl,[si]             ;Load bl with the x value
         mov       ch,byte ptr [bx]    ;Save the direction value
         mov       b,bl                ;Save x coordinate to b variable
         mov       y,al                ;Save y coordinate to y variable
         dec       al                  ;Decrement y
         dec       bl                  ;Decrement x
         mul       a                   ;Multiply y by columns
         add       ax,bx               ;Add x to calculate offset
;---------------------------------------
; Code to make 1 move in the maze
;---------------------------------------
right:                                 ;
         mov       ch,2                ;Set the direction to south         
         add       ax,30               ;Add 30 to find box to the south
         add       bp,ax               ;Point to the south box
         mov       cl,ds:[bp]          ;Get the value at the pointed box
         cmp       cl,[empty]          ;Check if empty
         jne       forward             ;Not empty, try forward
         dec       y                   ;Update y coordinate
         jmp       exit                ;Done, go to exit and restore
forward:                               ;
         mov       ch,1                ;Set the direction variable
         sub       bp,ax               ;Reset the pointer to mouse location
         sub       ax,29               ;Find the box to the east
         add       bp,ax               ;Point to the east box
         mov       cl,ds:[bp]          ;Get the value at the pointed box
         cmp       cl,[empty]          ;Check if empty
         jne       left                ;Not empty, try left
         inc       b                   ;Update x coordinate
         jmp       exit                ;Done, go to exit and restore
left:                                  ;
         mov       ch,4                ;Set the direction variable
         sub       bp,ax               ;Reset the pointer to mouse location
         sub       ax,31               ;Find the box to the north
         add       bp,ax               ;Point to the north box
         mov       cl,ds:[bp]          ;Get the value at the pointed box
         cmp       cl,[empty]          ;Check if empty
         jne       back                ;Not empty, try backwards
         dec       y                   ;Update y coordinate
         jmp       exit                ;Done, go to exit and restore
back:                                  ;
         mov       ch,3                ;Set the direction variable
         dec       b                   ;Update x coordinate                              
;---------------------------------------
; Restore registers and return
;---------------------------------------
exit:                                  ;
         mov       bh,b                ;Move x into bh
         mov       al,y                ;Move y into ch
         mov       byte ptr [di],al    ;Restore new y value
         mov       byte ptr [si],bh    ;Restore new x value
         mov       byte ptr [bx],ch    ;Restore the direction value
         pop       bp                  ;Restore the address of the maze
         pop       bx                  ;Restore the address of the direction
         pop       si                  ;Restore the address of si
         pop       di                  ;Restore the address of di
         ret                           ;return
;---------------------------------------
         end
