;=====================================================================
;  CUM 4  -  NGAT TIMER 0: DONG HO mm.ss        8051 / ASxxxx
;---------------------------------------------------------------------
;  Ban ASM cua timer_dongho.c - chay giong het:
;    Man hinh hien mm.ss, dau cham o giua
;    START/STOP : chay / dung dong ho   (xanh = chay, vang = dung)
;    RESET      : ve 00.00
;    MODE       : bat/tat LED do
;
;  Phan cung: y nguyen mach cum 3 (chon so NOI THANG, 0 = chon).
;
;  ⭐ Viec quet man hinh nam trong ngat Timer 0, nen chuong trinh chinh
;    lai duoc dung vong CHO NHA NUT - giu nut bao lau man hinh van sang.
;
;  BO NHO:
;    30h..33h HIENTHI[4]  ma 7 doan san (co ca dau cham o [1])
;    34h TICK_L  35h TICK_H   dem so lan ngat, 1000 = 1 giay
;    36h GIAY    37h PHUT     38h VITRI
;    bit 00h DANG_CHAY   bit 01h DEN_DO    (byte 20h)
;    Bank 1 rieng cho ISR, stack tu 60h
;=====================================================================

        .module timer_dongho_asm
        .area   CODE (ABS)

P1      =       0x90
P2      =       0xA0
P3      =       0xB0
PSW     =       0xD0
ACC     =       0xE0
B       =       0xF0
SP      =       0x81
TMOD    =       0x89
TL0     =       0x8A
TH0     =       0x8C

TR0     =       0x8C
ET0     =       0xA9
EA      =       0xAF

LED_XANH  =     0xA4
LED_VANG  =     0xA5
LED_DO    =     0xA6
NUT_RESET =     0xA7            ; P2.7
NUT_SS    =     0xB2            ; P3.2
NUT_MODE  =     0xB5            ; P3.5

RAMBIT  =       0x20
HIENTHI =       0x30
TICK_L  =       0x34
TICK_H  =       0x35
GIAY    =       0x36
PHUT    =       0x37
VITRI   =       0x38

DANG_CHAY =     0x00
DEN_DO    =     0x01

DAU_CHAM  =     0x80

        .org    0x0000
        ljmp    start
        .org    0x000B          ; vector Timer 0
        ljmp    t0_isr

        .org    0x0030
start:
        mov     SP, #0x5F

        mov     P2, #0xFF       ; tat 4 so, tat 3 LED, P2.7 len 1
        mov     P3, #0xFF
        mov     P1, #0x00

        clr     a
        mov     RAMBIT, a
        mov     TICK_L, a
        mov     TICK_H, a
        mov     GIAY, a
        mov     PHUT, a
        mov     VITRI, a

        ;-------------------------------------------------------------
        ;  CAI DAT TIMER 0 - bon buoc, thieu buoc nao cung cam
        ;    TMOD = 0x01 : Timer 0, GATE 0, C/T 0 (dem chu ky may),
        ;                  M1M0 = 01 = che do 1, 16 bit
        ;    TH0:TL0 = 65536 - 922 = 0xFC66
        ;              922 x 1,085 us = 1 000,4 us = 1 ms
        ;-------------------------------------------------------------
        mov     TMOD, #0x01
        mov     TH0, #0xFC
        mov     TL0, #0x66
        setb    ET0             ; cho phep rieng Timer 0
        setb    EA              ; cong tac TONG
        setb    TR0             ; Timer 0 chay

main_loop:
        lcall   cap_nhat_hienthi

        ;--- START/STOP ---
        jb      NUT_SS, xet_mode
        lcall   delay20ms
        jb      NUT_SS, xet_mode
        cpl     DANG_CHAY
cho_ss: jnb     NUT_SS, cho_ss          ; ⭐ cho nha - man hinh VAN SANG

xet_mode:
        jb      NUT_MODE, xet_reset
        lcall   delay20ms
        jb      NUT_MODE, xet_reset
        cpl     DEN_DO
cho_md: jnb     NUT_MODE, cho_md

xet_reset:
        jb      NUT_RESET, cap_led
        lcall   delay20ms
        jb      NUT_RESET, cap_led
        clr     a
        clr     EA              ; TICK la 2 byte, ISR dang tang no ->
        mov     TICK_L, a       ; xoa trong vung gang cho tron ven
        mov     TICK_H, a
        mov     GIAY, a
        mov     PHUT, a
        setb    EA
cho_rs: jnb     NUT_RESET, cho_rs

cap_led:
        mov     c, DANG_CHAY
        cpl     c
        mov     LED_XANH, c
        cpl     c
        mov     LED_VANG, c
        mov     c, DEN_DO
        cpl     c
        mov     LED_DO, c
        sjmp    main_loop

;=====================================================================
;  cap_nhat_hienthi: PHUT, GIAY -> 4 ma 7 doan.  8 bit nen DIV AB du.
;=====================================================================
cap_nhat_hienthi:
        mov     dptr, #MA7DOAN
        mov     a, PHUT
        mov     B, #10
        div     ab              ; A = chuc, B = don vi
        movc    a, @a+dptr
        mov     HIENTHI+0, a
        mov     a, B
        movc    a, @a+dptr
        orl     a, #DAU_CHAM    ; dau cham ngan phut.giay
        mov     HIENTHI+1, a

        mov     a, GIAY
        mov     B, #10
        div     ab
        movc    a, @a+dptr
        mov     HIENTHI+2, a
        mov     a, B
        movc    a, @a+dptr
        mov     HIENTHI+3, a
        ret

;=====================================================================
;  ISR TIMER 0 - moi 1 ms - hai viec: quet 1 chu so + dem thoi gian
;  Bank 1, cat PSW + A. Co TF0 phan cung tu xoa khi vao ISR.
;=====================================================================
t0_isr:
        push    PSW
        push    ACC
        mov     PSW, #0x08

        mov     TH0, #0xFC      ; nap lai - che do 1 khong tu nap
        mov     TL0, #0x66

        ;--- viec 1: quet mot chu so ---
        orl     P2, #0x0F       ; tat het truoc
        mov     a, VITRI
        add     a, #HIENTHI
        mov     r0, a
        mov     P1, @r0         ; roi moi doi du lieu
        mov     a, VITRI        ; roi moi bat so moi
        add     a, #2
        movc    a, @a+pc
        sjmp    t0_chon
        .db     0xFE, 0xFD, 0xFB, 0xF7
t0_chon:
        anl     P2, a
        inc     VITRI
        anl     VITRI, #0x03

        ;--- viec 2: dem thoi gian ---
        jnb     DANG_CHAY, t0_ra
        inc     TICK_L          ; tick++
        mov     a, TICK_L
        jnz     t0_kt
        inc     TICK_H
t0_kt:                          ; tick == 1000 (0x03E8) ?
        cjne    a, #0xE8, t0_ra
        mov     a, TICK_H
        cjne    a, #0x03, t0_ra
        mov     TICK_L, #0
        mov     TICK_H, #0
        inc     GIAY
        mov     a, GIAY
        cjne    a, #60, t0_ra
        mov     GIAY, #0
        inc     PHUT
        mov     a, PHUT
        cjne    a, #100, t0_ra
        mov     PHUT, #0
t0_ra:
        pop     ACC
        pop     PSW
        reti

;--- tre ~20 ms: 37 x 503 + 5 = 18 616 chu ky x 1,085 us = 20,2 ms ---
;    Dung R3, R4 cua bank 0; ISR o bank 1 nen khong dap nhau.
delay20ms:
        mov     r4, #37
d20_2:  mov     r3, #250
d20_1:  djnz    r3, d20_1
        djnz    r4, d20_2
        ret

MA7DOAN:
        .db     0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F
