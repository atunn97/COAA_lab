;=====================================================================
;  TEST BA LED DON    8051 / ASxxxx   (do loi, khong nop)
;---------------------------------------------------------------------
;  Ban ASM cua testled3.c. Khong ngat, khong quet, KHONG DOC NUT NAO.
;  Bat lan luot tung LED, moi cai ~1 giay:  XANH -> VANG -> DO -> ...
;
;    A. Ca ba lan luot sang deu     -> ba LED noi dung chan
;    B. DO khong bao gio sang        -> LED do khong o P2.6 (hay o P2.7,
;                                       chung chan nut RESET?)
;    C. Hai LED cung sang mot luc    -> hai chan chung net
;
;  P2.0..P2.3 giu = 1 -> tat 4 so (noi thang: 1 la tat).
;  THANH GHI: R7 = buoc (0..2)   R3,R4,R5 = rieng cho delay1s
;=====================================================================

        .module testled3_asm
        .area   CODE (ABS)

P1      =       0x90
P2      =       0xA0
P3      =       0xB0

        .org    0x0000
        ljmp    start

        .org    0x0030
start:
        mov     P2, #0xFF
        mov     P3, #0xFF
        mov     P1, #0x00       ; tat 8 doan
        mov     r7, #0

main_loop:
        mov     a, r7
        mov     dptr, #BANG_P2
        movc    a, @a+dptr
        mov     P2, a           ; bit 7 = 1 va bit 0..3 = 1 trong moi o

        lcall   delay1s

        inc     r7
        cjne    r7, #3, main_loop
        mov     r7, #0
        sjmp    main_loop

;--- tre ~0,98 giay: 9 x 100 603 + 5 = 905 432 chu ky x 1,085 us ---
delay1s:
        mov     r5, #9
d1_3:   mov     r4, #200
d1_2:   mov     r3, #250
d1_1:   djnz    r3, d1_1
        djnz    r4, d1_2
        djnz    r5, d1_3
        ret

;   bit: 7=nut 6=DO 5=VANG 4=XANH 3..0=chon so (1 = tat)
BANG_P2:
        .db     0xEF            ; 1110 1111  XANH
        .db     0xDF            ; 1101 1111  VANG
        .db     0xBF            ; 1011 1111  DO
