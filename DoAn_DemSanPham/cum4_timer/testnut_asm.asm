;=====================================================================
;  TEST BA NUT    8051 / ASxxxx   (do loi, khong nop)
;---------------------------------------------------------------------
;  Ban ASM cua testnut.c. Soi guong muc logic ba chan nut len ba LED:
;
;      LED XANH  <-  P3.2  (START/STOP)
;      LED VANG  <-  P3.6  (MODE)
;      LED DO    <-  P2.7  (RESET)
;
;  Nut nhan = 0, LED active LOW ghi 0 la sang => NHAN NUT NAO, LED DO
;  SANG. Trong ASM viec "chep chan sang chan" chi la hai lenh:
;      mov c, <chan nut>     mov <chan LED>, c
;
;  ⭐ Phep thu khong can dung tay: de DCLOCK chay - neu LED VANG nhap
;    nhay theo clock thi P3.3 va chan MODE dang CHUNG MOT NET.
;=====================================================================

        .module testnut_asm
        .area   CODE (ABS)

P1      =       0x90
P2      =       0xA0
P3      =       0xB0

LED_XANH  =     0xA4
LED_VANG  =     0xA5
LED_DO    =     0xA6
NUT_RESET =     0xA7            ; P2.7
NUT_SS    =     0xB2            ; P3.2
NUT_MODE  =     0xB6            ; P3.6

        .org    0x0000
        ljmp    start

        .org    0x0030
start:
        mov     P2, #0xFF       ; day chot len 1 de doc duoc nut, dong thoi
                                ; P2.0..P2.3 = 1 -> tat 4 so
        mov     P3, #0xFF
        mov     P1, #0x00

main_loop:
        mov     c, NUT_SS
        mov     LED_XANH, c
        mov     c, NUT_MODE
        mov     LED_VANG, c
        mov     c, NUT_RESET
        mov     LED_DO, c
        sjmp    main_loop
