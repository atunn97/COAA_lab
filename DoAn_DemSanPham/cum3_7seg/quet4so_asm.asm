;=====================================================================
;  CUM 3  -  LED 7 DOAN 4 SO, QUET DA HOP        8051 / ASxxxx
;---------------------------------------------------------------------
;  Ban ASM cua quet4so.c - chay giong het:
;    Man hinh dem 0000 -> 0001 -> ... moi giay mot don vi (~50 vong quet)
;    START/STOP : doi RUN <-> PAUSE  (xanh <-> vang)
;    MODE       : bat/tat LED DO
;    RESET      : ve 0000, PAUSE, tat LED DO
;
;  PHAN CUNG:
;    P1.0..P1.7 -> 8 doan a..dp (qua tro 330R, dung chung cho 4 so)
;    P2.0..P2.3 -> 4 chan chon so, NOI THANG (tu 16/09): 0 = chon so
;    P2.4/5/6   -> LED xanh/vang/do (active LOW)
;    P3.2 START/STOP   P2.7 RESET   P3.5 MODE   (nhan = 0)
;    Thach anh 11,0592 MHz
;
;  ⚠ THU TU BA BUOC QUET LA BAT BUOC: 1. TAT het chan chon
;    2. DOI du lieu doan   3. BAT chan chon moi. Dao la bi BONG MA.
;
;  BO NHO:
;    30h..33h  HIENTHI[4]  chu so dang hien, [0] = so trai nhat
;    34h, 35h  DEM         so dang hien 0..9999 (34h byte thap)
;    36h       VONG        dem so vong quet, 50 vong ~ 1 giay
;    bit 00h..03h (byte 20h): DANG_CHAY, DEN_DO, SS_DA, MODE_DA
;
;  THANH GHI: R7 = vitri (quet), R0 = con tro HIENTHI,
;             R2..R7 cho tach_so, R3,R4 cho delay
;=====================================================================

        .module quet4so_asm
        .area   CODE (ABS)

P1      =       0x90
P2      =       0xA0
P3      =       0xB0
B       =       0xF0
SP      =       0x81

LED_XANH  =     0xA4
LED_VANG  =     0xA5
LED_DO    =     0xA6
NUT_RESET =     0xA7
NUT_SS    =     0xB2
NUT_MODE  =     0xB5

;--- RAM ---
RAMBIT  =       0x20
HIENTHI =       0x30
DEM_L   =       0x34
DEM_H   =       0x35
VONG    =       0x36

DANG_CHAY =     0x00
DEN_DO    =     0x01
SS_DA     =     0x02
MODE_DA   =     0x03

        .org    0x0000
        ljmp    start

        .org    0x0030
start:
        mov     SP, #0x5F       ; stack len 60h..7Fh, tranh xa vung bien

        mov     P2, #0xFF       ; 4 chan chon = 1 -> tat (noi thang)
                                ; 3 LED don = 1 -> tat, P2.7 = 1 doc nut
        mov     P3, #0xFF
        mov     P1, #0x00

        ;--- ASM khong co "= 0" tu dong nhu C: phai tu xoa RAM ---
        clr     a
        mov     RAMBIT, a
        mov     DEM_L, a
        mov     DEM_H, a
        mov     VONG, a
        mov     HIENTHI+0, a
        mov     HIENTHI+1, a
        mov     HIENTHI+2, a
        mov     HIENTHI+3, a

        clr     LED_VANG        ; khoi dong o PAUSE

main_loop:
        lcall   quet_mot_vong   ; ~20 ms

        ;-------------------------------------------------------------
        ;  Chua co Timer: dem giay bang so vong quet, 50 vong ~ 1 giay.
        ;  Ban C dem LIEN TUC ke ca khi PAUSE - ban nay cung vay.
        ;-------------------------------------------------------------
        inc     VONG
        mov     a, VONG
        cjne    a, #50, xet_nut
        mov     VONG, #0

        inc     DEM_L           ; dem++ (16 bit)
        mov     a, DEM_L
        jnz     kt_tran
        inc     DEM_H
kt_tran:                        ; dem == 10000 (0x2710) -> ve 0
        cjne    a, #0x10, nap
        mov     a, DEM_H
        cjne    a, #0x27, nap
        mov     DEM_L, #0
        mov     DEM_H, #0
nap:    lcall   nap_so

xet_nut:
        ;-------------------------------------------------------------
        ;  BA NUT - dung co "da xu ly" thay cho vong cho nha nut:
        ;  cho trong vong lap thi man hinh NGUNG QUET va tat ngom.
        ;-------------------------------------------------------------
        jb      NUT_SS, ss_nha
        jb      SS_DA, xet_mode
        setb    SS_DA
        cpl     DANG_CHAY
        sjmp    xet_mode
ss_nha: clr     SS_DA

xet_mode:
        jb      NUT_MODE, md_nha
        jb      MODE_DA, xet_reset
        setb    MODE_DA
        cpl     DEN_DO
        sjmp    xet_reset
md_nha: clr     MODE_DA

xet_reset:
        jb      NUT_RESET, cap_led
        clr     a
        mov     DEM_L, a
        mov     DEM_H, a
        mov     VONG, a
        clr     DANG_CHAY
        clr     DEN_DO
        lcall   nap_so

cap_led:                        ; LED active LOW -> dao bit trang thai
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
;  MOT VONG QUET DU 4 SO  (4 x ~4,9 ms ~ 20 ms -> 50 Hz)
;=====================================================================
quet_mot_vong:
        mov     r7, #0
        mov     r0, #HIENTHI
qv_lap:
        orl     P2, #0x0F       ; 1. TAT het (noi thang: 1 = tat)

        mov     a, @r0          ; 2. DOI du lieu
        mov     dptr, #MA7DOAN
        movc    a, @a+dptr
        mov     P1, a

        mov     a, r7           ; 3. BAT so moi: keo DUNG MOT bit xuong 0
        mov     dptr, #CHON_THANG
        movc    a, @a+dptr
        anl     P2, a

        lcall   delay5ms
        inc     r0
        inc     r7
        cjne    r7, #4, qv_lap
        ret

;=====================================================================
;  nap_so: tach DEM thanh 4 chu so, nap vao HIENTHI[0..3]
;=====================================================================
nap_so:
        mov     r7, DEM_L
        mov     r6, DEM_H
        lcall   tach_so
        mov     HIENTHI+0, r2
        mov     HIENTHI+1, r3
        mov     HIENTHI+2, r4
        mov     HIENTHI+3, r5
        ret

;=====================================================================
;  tach_so: so 16 bit 0..9999 -> 4 chu so thap phan
;---------------------------------------------------------------------
;  vao: R6:R7 = n  (R6 byte cao)
;  ra : R2 = nghin, R3 = tram, R4 = chuc, R5 = don vi.  Pha A, B, R6, R7
;
;  8051 chi co DIV AB chia 8 bit. So 16 bit thi TRU LAP: tru 1000 toi
;  khi am, so lan tru duoc la chu so hang nghin; roi tru 100. Moi chu
;  so toi da 9 vong. Con lai < 100 thi vua 1 byte -> DIV AB cho 10.
;  (Ban C: SDCC goi ham thu vien chia 16 bit, moi phep vai tram chu ky.)
;=====================================================================
tach_so:
        mov     r2, #0
ts_1000:
        clr     c               ; n - 1000  (1000 = 0x03E8)
        mov     a, r7
        subb    a, #0xE8
        mov     B, a            ; giu tam byte thap
        mov     a, r6
        subb    a, #0x03
        jc      ts_100_bd       ; am -> het hang nghin
        mov     r6, a
        mov     r7, B
        inc     r2
        sjmp    ts_1000
ts_100_bd:
        mov     r3, #0
ts_100:
        clr     c               ; n - 100
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
        mov     a, r7           ; con < 100
        mov     B, #10
        div     ab              ; A = chuc, B = don vi
        mov     r4, a
        mov     r5, B
        ret

;--- tre ~20 ms: 37 x 503 + 5 = 18 616 chu ky (xem nut3_asm.asm) ---
;    Ban C giu ham nay tu cum 2 nhung KHONG goi toi; ban ASM bo di.

;--- tre ~4,9 ms: 9 x 503 + 5 = 4 532 chu ky x 1,085 us ---
delay5ms:
        mov     r4, #9
d5_2:   mov     r3, #250
d5_1:   djnz    r3, d5_1
        djnz    r4, d5_2
        ret

MA7DOAN:
        .db     0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F

CHON_THANG:                     ; mat na ANL: bit cua vitri = 0, con lai = 1
        .db     0xFE, 0xFD, 0xFB, 0xF7
