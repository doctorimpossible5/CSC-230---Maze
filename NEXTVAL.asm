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
block     db       20h                 ;char to represent a blocked tile
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
         mov       bl,[di]             ;Load bl with the y value
         mov       bh,[si]             ;Load bh with the x value
         mov       dh,0                ;Set the direction variable
         mov       al,bl               ;
         mov       b,bh                ;
         dec       al                  ;
         dec       b                   ;
         mul       a                   ;
         add       al,b                ;
         add       ax,ds:[bp]          ;
;---------------------------------------
; Code to make 1 move in the maze
;---------------------------------------
         cmp       block,ax ;
         jne       right               ;
back:                                  ;         
                                       ;
left:                                  ;
                                       ;
forward:                               ;
                                       ;
right:                                 ;
                                       ;
;---------------------------------------
; Restore registers and return
;---------------------------------------
exit:                                  ;
         mov       byte ptr [di],bl    ;
         mov       byte ptr [si],bh    ;
         mov       byte ptr [bx],dh    ;
         ret                           ;return
;---------------------------------------
         end
