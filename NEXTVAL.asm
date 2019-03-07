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
         push      ax                  ;Save the address of di
         push      cx                  ;Save the address of si
         push      bx                  ;Save the address of bx
         push      bp                  ;Save the address of the maze
         mov       al,[di]             ;Load al with the y value
         mov       bl,[si]             ;Load bl with the x value
         mov       ch,byte ptr [bx]    ;Save the direction value
         dec       al                  ;Decrement y
         dec       bl                  ;Decrement x
         mul       [a]                 ;Multiply y by columns
         add       ax,bx               ;Add x to calculate offset
;---------------------------------------
; Code to make 1 move in the maze
;---------------------------------------
         add       ax,30               ;
         add       bp,ax               ;
         mov       cl,ds:[bp]          ;
         mov       south,cl            ;
                                       ;
         sub       bp,60               ;
         mov       cl,ds:[bp]          ;
         mov       north,cl            ;
                                       ;
         add       bp,61               ;
         mov       cl,ds:[bp]          ;
         mov       east,cl             ;
                                       ;
         sub       bp,2                ;
         mov       cl,ds:[bp]          ;
         mov       west,cl             ;
increment:                             ;
         inc       ch                  ;
         cmp       ch,5                ;
         jne       check               ;
         mov       ch,1                ;
check:                                 ;
         cmp       ch,2                ;
         jb        right               ;
         je        down                ;
         cmp       ch,4                ;
         jb        left                ;
         je        upward              ;
right:                                 ;
         cmp       [east],20h          ;Check if empty
         jne       increment           ;Not empty, try again
         inc       byte ptr [si]       ;Update x coordinate
         jmp       exit                ;Done, go to exit and restore
upward:                                ;
         cmp       [north],20h         ;Check if empty
         jne       increment           ;Not empty, try again
         dec       byte ptr [di]       ;Update y coordinate
         jmp       exit                ;Done, go to exit and restore
left:                                  ;
         cmp       [west],20h          ;Check if empty
         jne       increment           ;Not empty, try again
         dec       byte ptr [si]       ;Update x coordinate
         jmp       exit                ;Done, go to exit and restore
down:                                  ;
         cmp       [south],20h         ;Check if empty
         jne       increment           ;Not empty, try again
         inc       byte ptr [di]       ;Update y coordinate                              
;---------------------------------------
; Restore registers and return
;---------------------------------------
exit:
         mov       byte ptr [bx],ch    ;Restore the direction value
         pop       bp                  ;Restore the address of the maze
         pop       bx                  ;Restore the address of the direction
         pop       cx                  ;Restore the address of si
         pop       ax                  ;Restore the address of di
         ret                           ;return
;---------------------------------------
         end
