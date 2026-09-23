;=====================================================================
;  CUM 2  -  BA NUT NHAN          8051 / ASxxxx (sdas8051)
;---------------------------------------------------------------------
;  Ban ASM cua nut3.c - chay GIONG HET ban C:
;    Luc bat nguon    : PAUSE  -> LED VANG sang
;    Nhan START/STOP  : doi qua lai RUN <-> PAUSE  (xanh <-> vang)
;    Nhan MODE        : bat/tat LED DO
;    Nhan RESET       : ve PAUSE, tat LED DO
;
;  PHAN CUNG (cum 1 + ba nut):
;    P2.4 -> LED XANH   P2.5 -> LED VANG   P2.6 -> LED DO  (active LOW)
;    P3.2 (chan 12) -> nut START/STOP
;    P2.7 (chan 28) -> nut RESET
;    P3.5 (chan 15) -> nut MODE
;    Moi nut noi xuong GND, khong can tro keo ngoai => nhan = muc 0.
;    Thach anh 11,0592 MHz -> 1 chu ky may = 1,085 us
;
;  ⭐ KHAC BAN C O CHO NAO:
;    Hai bien trang thai dang_chay / den_do la BIT, khong phai byte.
;    8051 co "bo xu ly Boolean": 128 bit o vung RAM 20h..2Fh danh dia
;    chi tung bit duoc. Lat trang thai chi can MOT lenh CPL, va chep
;    bit ra chan LED qua co nho C (mov c,bit / mov bit,c) - khong can
;    if/else nhu ban C.
;
;  PHAN CHIA THANH GHI:
;    R3, R4 : rieng cho delay20ms
;    bit 00h (= 20h.0) : DANG_CHAY   1 = RUN,  0 = PAUSE
;    bit 01h (= 20h.1) : DEN_DO      1 = sang, 0 = tat
;=====================================================================

        .module nut3_asm
        .area   CODE (ABS)

;--- dia chi byte ---
P2      =       0xA0
P3      =       0xB0
RAMBIT  =       0x20            ; byte chua 8 bit trang thai

;--- dia chi BIT (dia chi byte cua port + so thu tu bit) ---
LED_XANH  =     0xA4            ; P2.4
LED_VANG  =     0xA5            ; P2.5
LED_DO    =     0xA6            ; P2.6
NUT_RESET =     0xA7            ; P2.7
NUT_SS    =     0xB2            ; P3.2  START/STOP
NUT_MODE  =     0xB5            ; P3.5

;--- bit trang thai trong RAM ---
DANG_CHAY =     0x00            ; 20h.0
DEN_DO    =     0x01            ; 20h.1

        .org    0x0000
        ljmp    start

        .org    0x0030
start:
        ;-------------------------------------------------------------
        ;  ⚠ Ghi 1 ra chot P2, P3 truoc khi doc nut. Port 8051 la
        ;    QUASI-BIDIRECTIONAL: chot dang giu 0 thi chan bi keo xuong
        ;    mass, doc vao luon ra 0 du nut co nhan hay khong.
        ;-------------------------------------------------------------
        mov     P2, #0xFF
        mov     P3, #0xFF
        mov     RAMBIT, #0x00   ; PAUSE, den do tat (RAM sau reset
                                ; KHONG chac bang 0 - phai tu xoa)

main_loop:
        ;--- NUT START/STOP: doi RUN <-> PAUSE ---
        jb      NUT_SS, xet_mode        ; buoc 1: muc 1 = khong nhan
        lcall   delay20ms               ; buoc 2: cho het doi ...
        jb      NUT_SS, xet_mode        ;         ... roi doc lai
        cpl     DANG_CHAY               ; lat trang thai - MOT lenh
cho_ss: jnb     NUT_SS, cho_ss          ; buoc 3: cho NHA ra

xet_mode:
        ;--- NUT MODE: bat/tat LED DO ---
        jb      NUT_MODE, xet_reset
        lcall   delay20ms
        jb      NUT_MODE, xet_reset
        cpl     DEN_DO
cho_md: jnb     NUT_MODE, cho_md

xet_reset:
        ;--- NUT RESET: ve trang thai ban dau ---
        jb      NUT_RESET, cap_nhat
        lcall   delay20ms
        jb      NUT_RESET, cap_nhat
        clr     DANG_CHAY
        clr     DEN_DO
cho_rs: jnb     NUT_RESET, cho_rs

cap_nhat:
        ;-------------------------------------------------------------
        ;  Chep bit trang thai ra 3 chan LED qua co nho C.
        ;  LED active LOW nen phai DAO: dang_chay = 1 -> ghi 0 -> sang.
        ;
        ;    XANH = NOT dang_chay      VANG = dang_chay
        ;    DO   = NOT den_do
        ;
        ;  Ghi tung BIT, khong ghi ca byte P2 - ghi ca byte se keo luon
        ;  P2.7 (nut RESET) xuong 0 va tu do khong doc duoc nut nua.
        ;-------------------------------------------------------------
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
;  TRE ~20 ms  @ 11,0592 MHz  - cho het doi phim
;---------------------------------------------------------------------
;    vong trong : 250 x 2 (djnz)                  =    500
;    vong ngoai : 37 x (1 + 500 + 2)              = 18 611
;    cong lcall (2) + mov r4 (1) + ret (2)        = 18 616 chu ky
;    18 616 x 1,085 us = 20 198 us = 20,2 ms
;
;  Ban C (delay20ms trong nut3.c) ra 18 128 chu ky = 19,7 ms.
;=====================================================================
delay20ms:
        mov     r4, #37
d20_2:  mov     r3, #250
d20_1:  djnz    r3, d20_1
        djnz    r4, d20_2
        ret
