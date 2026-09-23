;=====================================================================
;  CUM 3 - TEST BON CHAN CHON SO    8051 / ASxxxx   (do loi, khong nop)
;---------------------------------------------------------------------
;  Ban ASM cua testdigit.c (ban CO TRANSISTOR NPN: 1 = so SANG).
;  Moi luc chi bat DUNG MOT so, giu 1 giay roi chuyen so ke:
;
;      1 _ _ _   ->   _ 2 _ _   ->   _ _ 3 _   ->   _ _ _ 4
;
;    A. Moi luc mot so, chay trai -> phai  => 4 chan chon doc lap, dung
;    B. 1111 -> 2222 -> ...                => 4 chan chon NOI CHUNG
;    C. Mot vi tri sang mai, so doi tai cho => chi mot transistor dan
;
;  PHAN CUNG:  P1.0..P1.7 -> doan a..dp     P2.0..P2.3 -> chon so 1..4
;              P2.4/5/6   -> LED xanh/vang/do (active LOW)
;
;  ⭐ KHAC BAN C: thay switch 4 nhanh bang BANG TRA P2. Moi o bang la
;    ca byte P2 cua mot buoc: 1 bit chon so + mau 3 LED don.
;    Ghi ca byte P2 o day KHONG hong nut RESET (P2.7) vi bit 7 cua moi
;    o bang deu = 1.
;
;  THANH GHI: R7 = vitri (0..3)   R3,R4,R5 = rieng cho delay1s
;=====================================================================

        .module testdigit_asm
        .area   CODE (ABS)

P1      =       0x90
P2      =       0xA0
P3      =       0xB0

        .org    0x0000
        ljmp    start

        .org    0x0030
start:
        mov     P2, #0xF0       ; tat 4 so, tat 3 LED don, P2.7 len 1
        mov     P3, #0xFF
        mov     P1, #0x00
        mov     r7, #0          ; vitri = 0

main_loop:
        anl     P2, #0xF0       ; 1. tat het chan chon (P2.0..3 = 0)

        mov     a, r7           ; 2. dat du lieu: vitri 0 hien so 1 ...
        inc     a
        mov     dptr, #MA7DOAN
        movc    a, @a+dptr
        mov     P1, a

        mov     a, r7           ; 3. bat DUNG MOT so + doi 3 LED don
        mov     dptr, #BANG_P2
        movc    a, @a+dptr
        mov     P2, a

        lcall   delay1s

        inc     r7              ; vitri = (vitri + 1) mod 4
        anl     0x07, #0x03     ; 0x07 = dia chi cua R7 o bank 0
        sjmp    main_loop

;=====================================================================
;  TRE ~1 giay  @ 11,0592 MHz
;---------------------------------------------------------------------
;    vong trong : 250 x 2                         =       500
;    vong giua  : 200 x (1 + 500 + 2)             =   100 600
;    vong ngoai :   9 x (1 + 100 600 + 2)         =   905 427
;    cong lcall + mov r5 + ret = 5                =   905 432 chu ky
;    905 432 x 1,085 us = 0,982 giay   (ban C: 0,98 giay)
;=====================================================================
delay1s:
        mov     r5, #9
d1_3:   mov     r4, #200
d1_2:   mov     r3, #250
d1_1:   djnz    r3, d1_1
        djnz    r4, d1_2
        djnz    r5, d1_3
        ret

;--- ma 7 doan COMMON CATHODE, bit0 = a ... bit6 = g, bit7 = dp ---
MA7DOAN:
        .db     0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F

;--- byte P2 cho tung vitri ---
;           bit: 7=nut  6=DO  5=VANG  4=XANH  3..0 = chon so
;   vitri 0: 1110 0001  chon so 1, XANH sang
;   vitri 1: 1101 0010  chon so 2, VANG sang
;   vitri 2: 1011 0100  chon so 3, DO   sang
;   vitri 3: 1000 1000  chon so 4, ca ba sang
BANG_P2:
        .db     0xE1, 0xD2, 0xB4, 0x88
