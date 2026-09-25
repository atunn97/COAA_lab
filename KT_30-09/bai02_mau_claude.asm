; ============================================================
;  BAI 02 - 8 LED SANG DAN MOT PHIA, 500 ms, LAP MAI
;  BAN SO BO CUA CLAUDE (24/09) - DE DOC, KHONG PHAI BAI CUA A
;  Mach thi: 8 LED P2.0..P2.7, xuat 1 = SANG, P2.0 = LED phai nhat
;  Thach anh 12 MHz -> 1 chu ky may = 1 us
;  Co che (A noi): 00 01 03 07 0F 1F 3F 7F FF roi ve 00
;                  cach 2 = dich trai + keo so 1 vao
;                  500 ms = goi DELAY 100 ms 5 lan (bien dem R5)
;                  toi FF thi quay ve dau, gan lai 00
; ============================================================
        ORG   0000H

MAIN:   MOV   A,#00H          ; buoc 0: tat het
LOOP:   MOV   P2,A            ; xuat ra 8 LED
        ACALL DELAY500        ; giu hinh nay 500 ms
        CJNE  A,#0FFH,TIEP    ; chua sang het -> sang buoc ke
        SJMP  MAIN            ; da FF -> ve buoc 0

TIEP:   SETB  C               ; bit se keo vao ben phai = 1
        RLC   A               ; dich trai 1 o, C chui vao bit 0
        SJMP  LOOP

;------------------------------------------------------------
DELAY500:
        MOV   R5,#5           ; dem 5 lan
D500:   ACALL DELAY           ; 100 ms
        DJNZ  R5,D500
        RET

;--- chep nguyen tu tai lieu thay: 100 ms @12 MHz -----------
DELAY:  MOV   R7,#200
D1:     MOV   R6,#250
D2:     DJNZ  R6,D2
        DJNZ  R7,D1
        RET

        END
