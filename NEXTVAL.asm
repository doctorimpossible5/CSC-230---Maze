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
; Owner:     Dana A. Lasher, Ian Smart Thomas Landsberg
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
         push      bp                  ;Save the address of the maze
         push      dx                  ;Save the address of the dx
;---------------------------------------
; Start of the loop and increments the
; direction
;---------------------------------------
         add       byte ptr [bx],2     ;Add 2 to the address in the first pass
increment:                             ;Label for the begining of the loop
         mov       al,[di]             ;Load al with the y value
         mov       cl,[si]             ;Load cl with the x value
         sub       byte ptr [bx],1     ;Move to the next direction
         jnz       check               ;If not continue
         mov       byte ptr [bx],4     ;If it is out of bounds, reset it
;---------------------------------------
; Checks to see what the current direction
; is and passes it to the correct label 
;---------------------------------------
check:                                 ;
         cmp       byte ptr [bx],2     ;Check if the direction is down
         jb        right               ;Jump to right
         je        down                ;Jump to down
         cmp       byte ptr [bx],4     ;Check if the direction is upward
         jb        left                ;Jump to left
         je        upward              ;Jump to right
;---------------------------------------
; Resets the direction if the value is above 4
;---------------------------------------
above:                                 ;Handles direction being out of bounds
         mov       byte ptr [bx],1     ;Resets the direction
;---------------------------------------
; Set X and Y according to the direction
;---------------------------------------
right:                                 ;
         add       cl,1                ;Moves x up 1
         jmp       calculate           ;Jumps to calculation
upward:                                ;
         sub       al,1                ;Moves y down 1
         jmp       calculate           ;Jumps to calulation
left:                                  ;
         sub       cl,1                ;Moves x down 1
         jmp       calculate           ;Jumps to calculation
down:                                  ;
         add       al,1                ;Moves y up 1
;---------------------------------------
; Saves the x and y values in another register
; so the current ones can be used to calculate the offset
;---------------------------------------
calculate:                             ;
         mov       dh,al               ;Saves y value
         mov       dl,cl               ;Saves x value
;---------------------------------------
; Calculate the offset
;---------------------------------------
         dec       al                  ;Decrement y
         dec       cl                  ;Decrement x
         mul       [a]                 ;Multiply y by columns
         add       ax,cx               ;Add x to calculate offset
;---------------------------------------
; Checks to see if the space is empty.
; If its not, it starts over.
;---------------------------------------
         add       bp,ax               ;Offsets bp by the offset
         mov       cl,ds:[bp]          ;Copies over the 
         sub       bp,ax               ;Resets bp
         cmp       cl,20h              ;Check if empty
         jne       increment           ;Not empty, try again
;---------------------------------------
; Store the x and y values into the pointers
;---------------------------------------
exit:
         mov       [di],dh             ;Stores the new y value 
         mov       [si],dl             ;Stores the new x value
;---------------------------------------
; Restore registers and return
;---------------------------------------
         pop       dx                  ;Restore the address of dx
         pop       bp                  ;Restore the address of the maze\
         pop       cx                  ;Restore the address of si
         pop       ax                  ;Restore the address of di
;---------------------------------------
; Return to the calling program
;---------------------------------------
         ret                           ;return
;---------------------------------------
         end
