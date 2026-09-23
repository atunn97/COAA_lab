;=====================================================================
;  CUM 3 - BAI TEST TINH   8051 / ASxxxx   (do loi mach, khong nop)
;---------------------------------------------------------------------
;  Ban ASM cua testtinh.c. Ghi dung HAI gia tri roi dung yen:
;
;    P2 = 0xCF = 1100 1111
;        P2.0..P2.3 = 1 -> bat ca 4 so (qua NPN: 1 la dan)
;        P2.4 = 0, P2.5 = 0 -> XANH + VANG sang = chip dang chay
;        P2.6 = 1 -> DO tat,  P2.7 = 1 -> chot len 1 (nut RESET)
;    P1 = 0xFF -> ca 8 doan sang -> moi so hien "8."
;
;    Thay 8888 co dau cham -> MACH DUNG
;    Khong thay gi         -> LOI MACH phia transistor / chan chung
;=====================================================================

        .module testtinh_asm
        .area   CODE (ABS)

P1      =       0x90
P2      =       0xA0

        .org    0x0000
        ljmp    start

        .org    0x0030
start:
        mov     P2, #0xCF
        mov     P1, #0xFF
dung:   sjmp    dung            ; dung yen mai mai
