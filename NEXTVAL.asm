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
         
;---------------------------------------


;---------------------------------------
         .code                         ;start the code segment
;---------------------------------------
; Save any modified registers
;---------------------------------------
nextval:                               ;
                                       ;
                                       ;
;---------------------------------------
; Code to make 1 move in the maze
;---------------------------------------
                                       ;
                                       ;
                                       ;
;---------------------------------------
; Restore registers and return
;---------------------------------------
exit:                                  ;
                                       ;
         ret                           ;return
;---------------------------------------
         end
