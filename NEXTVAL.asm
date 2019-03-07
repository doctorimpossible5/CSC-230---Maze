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
;---------------------------------------


;---------------------------------------
         .code                         ;start the code segment
;---------------------------------------
; Save any modified registers
;---------------------------------------
nextval:                               ;
         push      ax                  ;Save the address of di
         push      cx                  ;Save the address of si
         push      bx                  ;Save the address of bx
         push      bp                  ;Save the address of the maze
         push      dx                  ;
;---------------------------------------
; Code to make 1 move in the maze
;---------------------------------------
         add       byte ptr [bx],2     ;
increment:                             ;
         mov       al,[di]             ;Load al with the y value
         mov       cl,[si]             ;Load cl with the x value
         sub       byte ptr [bx],1     ;
         cmp       byte ptr [bx],0     ;
         jne       check               ;
         mov       byte ptr [bx],4     ;
check:                                 ;
         cmp       byte ptr [bx],2     ;
         jb        right               ;
         je        down                ;
         cmp       byte ptr [bx],4     ;
         jb        left                ;
         je        upward              ;
above:                                 ;
         mov       byte ptr [bx],1     ;
         jmp       right               ;
upward:                                ;
         sub       al,1                ;
         jmp       calculate           ;
right:                                 ;
         add       cl,1                ;
         jmp       calculate           ;
left:                                  ;
         sub       cl,1                ;
         jmp       calculate           ;
down:                                  ;
         add       al,1                ;
calculate:                             ;
         mov       dh,al               ;
         mov       dl,cl               ;
         dec       al                  ;Decrement y
         dec       cl                  ;Decrement x
         mul       [a]                 ;Multiply y by columns
         add       ax,cx               ;Add x to calculate offset
         add       bp,ax               ;
         mov       cl,ds:[bp]          ;
         sub       bp,ax               ;
         cmp       cl,20h              ;Check if empty
         jne       increment           ;Not empty, try again
;---------------------------------------
; Restore registers and return
;---------------------------------------
exit:
         mov       [di],dh             ;
         mov       [si],dl             ;
         pop       dx                  ;
         pop       bp                  ;Restore the address of the maze
         pop       bx                  ;Restore the address of the direction
         pop       cx                  ;Restore the address of si
         pop       ax                  ;Restore the address of di
         ret                           ;return
;---------------------------------------
         end
