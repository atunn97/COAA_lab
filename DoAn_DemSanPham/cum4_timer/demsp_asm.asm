;=====================================================================
;  CUM 4b  -  DEM SAN PHAM BANG NGAT NGOAI INT1     8051 / ASxxxx
;---------------------------------------------------------------------
;  Ban ASM cua demsp.c - chay giong het.
;
;  HAI NGUON NGAT:
;    Timer 0 (000Bh) moi 1 ms : quet man hinh + dem thoi gian + nha khoa
;    INT1    (0013h) canh xuong P3.3 (cam bien) : product_count++ khi RUN
;
;  BA CHE DO HIEN THI (nut MODE xoay vong):
;    COUNT  -> 0125     TIME -> 12.35     TARGET -> P020
;  LED: XANH = RUN, VANG = PAUSE, DO = product_count >= target_count
;
;  NUT: P3.2 START/STOP   P3.6 MODE   P2.7 RESET   (nhan = 0)
;
;  BO NHO:
;    30h..33h HIENTHI[4] (ma 7 doan)
;    34h TICK_L  35h TICK_H  36h GIAY  37h PHUT  38h VITRI  39h KHOA
;    3Ah CNT_L   3Bh CNT_H   (product_count)
;    3Ch TGT_L   3Dh TGT_H   (target_count = 20)
;    3Eh CHE_DO  0 = COUNT, 1 = TIME, 2 = TARGET
;    bit 00h DANG_CHAY (byte 20h)
;    Bank 1 rieng cho ISR, stack tu 60h
;=====================================================================

        .module demsp_asm
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

IT1     =       0x8A
TR0     =       0x8C
ET0     =       0xA9
EX1     =       0xAA
EA      =       0xAF

LED_XANH  =     0xA4
LED_VANG  =     0xA5
LED_DO    =     0xA6
NUT_RESET =     0xA7            ; P2.7
NUT_SS    =     0xB2            ; P3.2
NUT_MODE  =     0xB6            ; P3.6 (doi tu P3.5 ngay 16/09)

RAMBIT  =       0x20
HIENTHI =       0x30
TICK_L  =       0x34
TICK_H  =       0x35
GIAY    =       0x36
PHUT    =       0x37
VITRI   =       0x38
KHOA    =       0x39
CNT_L   =       0x3A
CNT_H   =       0x3B
TGT_L   =       0x3C
TGT_H   =       0x3D
CHE_DO  =       0x3E

DANG_CHAY =     0x00

DAU_CHAM  =     0x80
MA_CHU_P  =     0x73            ; chu "P": a b e f g

        .org    0x0000
        ljmp    start
        .org    0x000B          ; Timer 0
        ljmp    t0_isr
        .org    0x0013          ; INT1
        ljmp    int1_isr

        .org    0x0030
start:
        mov     SP, #0x5F

        mov     P2, #0xFF
        mov     P3, #0xFF       ; ⭐ P3.3 phai tha noi cao thi moi co canh xuong
        mov     P1, #0x00

        clr     a               ; xoa toan bo bien 30h..3Eh + byte bit
        mov     RAMBIT, a
        mov     r0, #HIENTHI
xoa_ram:
        mov     @r0, a
        inc     r0
        cjne    r0, #CHE_DO+1, xoa_ram
        mov     TGT_L, #20      ; muc tieu = 20
        mov     TGT_H, #0

        mov     TMOD, #0x01     ; Timer 0 che do 1
        mov     TH0, #0xFC
        mov     TL0, #0x66

        setb    IT1             ; ⚠ IT1 = 1: canh xuong - moi lan nhan dem 1.
                                ;   IT1 = 0 la theo muc: giu nut la dem loan
        setb    ET0
        setb    EX1
        setb    EA
        setb    TR0

main_loop:
        lcall   cap_nhat_hienthi

        ;--- START/STOP ---
        jb      NUT_SS, xet_mode
        lcall   delay20ms
        jb      NUT_SS, xet_mode
        cpl     DANG_CHAY
cho_ss: jnb     NUT_SS, cho_ss

xet_mode:
        ;--- MODE: COUNT -> TIME -> TARGET -> COUNT ---
        jb      NUT_MODE, xet_reset
        lcall   delay20ms
        jb      NUT_MODE, xet_reset
        inc     CHE_DO
        mov     a, CHE_DO
        cjne    a, #3, cho_md
        mov     CHE_DO, #0
cho_md: jnb     NUT_MODE, cho_md

xet_reset:
        ;--- RESET: xoa so dem va thoi gian ---
        jb      NUT_RESET, cap_led
        lcall   delay20ms
        jb      NUT_RESET, cap_led
        clr     a
        clr     EA              ; bien 2 byte ma ISR dang sua -> vung gang
        mov     CNT_L, a
        mov     CNT_H, a
        mov     TICK_L, a
        mov     TICK_H, a
        setb    EA
        mov     GIAY, a
        mov     PHUT, a
cho_rs: jnb     NUT_RESET, cho_rs

cap_led:
        mov     c, DANG_CHAY
        cpl     c
        mov     LED_XANH, c
        cpl     c
        mov     LED_VANG, c

        ;-------------------------------------------------------------
        ;  LED DO = (product_count >= target_count)
        ;  Tru 16 bit count - target: co C = 1 khi count < target.
        ;  C = 1 -> ghi 1 -> LED tat;  C = 0 -> ghi 0 -> LED sang.
        ;  => co nho C chep THANG ra chan LED, khong can re nhanh.
        ;-------------------------------------------------------------
        clr     EA
        mov     r7, CNT_L
        mov     r6, CNT_H
        setb    EA
        clr     c
        mov     a, r7
        subb    a, TGT_L
        mov     a, r6
        subb    a, TGT_H
        mov     LED_DO, c
        ljmp    main_loop

;=====================================================================
;  cap_nhat_hienthi - theo CHE_DO
;=====================================================================
cap_nhat_hienthi:
        mov     dptr, #MA7DOAN
        mov     a, CHE_DO
        jz      hien_count
        dec     a
        jz      hien_time

        ;--- TARGET: P + 3 chu so thap ---
        mov     r7, TGT_L
        mov     r6, TGT_H
        lcall   tach_so
        mov     r2, #0xFF       ; danh dau: o [0] la chu P, khong tra bang
        sjmp    nap_ma

hien_count:
        ;---------------------------------------------------------------
        ;  ⚠ product_count 2 byte, ISR tang no bat cu luc nao. Doc 2 byte
        ;    roi rac co the vo khe: doc byte thap, ngat tran sang byte
        ;    cao, doc byte cao -> so chua tung ton tai (0x00FF -> 0x01FF).
        ;    Tat ngat tong DUNG hai lenh doc roi bat lai ngay.
        ;---------------------------------------------------------------
        clr     EA
        mov     r7, CNT_L
        mov     r6, CNT_H
        setb    EA
        lcall   tach_so
        sjmp    nap_ma

hien_time:
        ;  Ghi thang tung o, gan dau cham TRUOC khi ghi vao HIENTHI+1.
        ;  (Ghi so roi moi ORL dau cham thi ISR co the xuat o do luc chua
        ;   co cham -> dau cham sang yeu hon cac doan khac.)
        mov     a, PHUT
        mov     B, #10
        div     ab
        movc    a, @a+dptr
        mov     HIENTHI+0, a
        mov     a, B
        movc    a, @a+dptr
        orl     a, #DAU_CHAM
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

;--- R2..R5 -> ma 7 doan -> HIENTHI.  R2 = FFh nghia la chu "P" ---
nap_ma:
        mov     a, r2
        cjne    a, #0xFF, nm_so
        mov     a, #MA_CHU_P
        sjmp    nm_0
nm_so:  movc    a, @a+dptr
nm_0:   mov     HIENTHI+0, a
        mov     a, r3
        movc    a, @a+dptr
        mov     HIENTHI+1, a
        mov     a, r4
        movc    a, @a+dptr
        mov     HIENTHI+2, a
        mov     a, r5
        movc    a, @a+dptr
        mov     HIENTHI+3, a
        ret

;=====================================================================
;  ISR TIMER 0 - moi 1 ms (bank 1)
;=====================================================================
t0_isr:
        push    PSW
        push    ACC
        mov     PSW, #0x08

        mov     TH0, #0xFC
        mov     TL0, #0x66

        ;--- quet mot chu so ---
        orl     P2, #0x0F
        mov     a, VITRI
        add     a, #HIENTHI
        mov     r0, a
        mov     P1, @r0
        mov     a, VITRI
        add     a, #2
        movc    a, @a+pc
        sjmp    t0_chon
        .db     0xFE, 0xFD, 0xFB, 0xF7
t0_chon:
        anl     P2, a
        inc     VITRI
        anl     VITRI, #0x03

        ;--- nha dan khoa chong doi cam bien ---
        mov     a, KHOA
        jz      t0_gio
        dec     KHOA

t0_gio: ;--- dem thoi gian khi RUN ---
        jnb     DANG_CHAY, t0_ra
        inc     TICK_L
        mov     a, TICK_L
        jnz     t0_kt
        inc     TICK_H
t0_kt:  cjne    a, #0xE8, t0_ra         ; tick == 1000 ?
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

;=====================================================================
;  ISR INT1 - cam bien san pham
;---------------------------------------------------------------------
;  ⚠ Trong ISR TUYET DOI khong cho 20 ms de chong doi. Dat KHOA = 20,
;    ngat Timer go dan moi 1 ms. ISR nay khong cho mot micro giay nao.
;  Co IE1 phan cung tu xoa (IT1 = 1).
;=====================================================================
int1_isr:
        push    PSW
        push    ACC

        mov     a, KHOA
        jnz     i1_ra           ; dang khoa -> bo qua
        mov     KHOA, #20
        jnb     DANG_CHAY, i1_ra        ; PAUSE thi khong dem
        inc     CNT_L
        mov     a, CNT_L
        jnz     i1_ra
        inc     CNT_H
i1_ra:
        pop     ACC
        pop     PSW
        reti

;=====================================================================
;  tach_so: R6:R7 (0..9999) -> R2 nghin, R3 tram, R4 chuc, R5 don vi
;  (giai thich o cum3_7seg\quet4so_asm.asm)
;=====================================================================
tach_so:
        mov     r2, #0
ts_1000:
        clr     c
        mov     a, r7
        subb    a, #0xE8
        mov     B, a
        mov     a, r6
        subb    a, #0x03
        jc      ts_100_bd
        mov     r6, a
        mov     r7, B
        inc     r2
        sjmp    ts_1000
ts_100_bd:
        mov     r3, #0
ts_100:
        clr     c
        mov     a, r7
        subb    a, #100
        mov     B, a
        mov     a, r6
        subb    a, #0
        jc      ts_10
        mov     r6, a
        mov     r7, B
        inc     r3
        sjmp    ts_100
ts_10:
        mov     a, r7
        mov     B, #10
        div     ab
        mov     r4, a
        mov     r5, B
        ret

;--- tre ~20,2 ms: 37 x 503 + 5 = 18 616 chu ky ---
delay20ms:
        mov     r4, #37
d20_2:  mov     r3, #250
d20_1:  djnz    r3, d20_1
        djnz    r4, d20_2
        ret

MA7DOAN:
        .db     0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F
