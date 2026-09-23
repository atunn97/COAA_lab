;=====================================================================
;  TEST NGAT NGOAI INT1    8051 / ASxxxx   (do loi, khong nop)
;---------------------------------------------------------------------
;  Ban ASM cua testint1.c. Man hinh CHI hien product_count, dem ngay tu
;  luc bat nguon (khong can START). Moi lan INT1 chay, LED XANH DAO.
;
;    A. LED xanh nhap nhay + so dem tang  -> INT1 TOT
;    B. LED xanh dung yen, so = 0000      -> INT1 KHONG chay: kiem DCLOCK
;                                            o chan 13 (P3.3), Frequency,
;                                            nut cu o P3.3 da xoa chua
;    C. LED nhap nhay, so dung yen        -> loi phan mem
;
;  HAI NGAT:
;    Timer 0 (000Bh) moi 1 ms : quet 1 chu so + nha khoa chong doi
;    INT1    (0013h) canh xuong P3.3 : dem + dao LED xanh
;
;  BO NHO:
;    30h..33h HIENTHI[4] - MA 7 DOAN san (ISR chi viec xuat ra)
;    34h VITRI   35h KHOA   36h CNT_L   37h CNT_H
;    Bank 1 (08h..0Fh) rieng cho ISR -> ISR khong dap thanh ghi cua main
;    Stack tu 60h
;=====================================================================

        .module testint1_asm
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

;--- bit SFR ---
IT1     =       0x8A            ; TCON.2
TR0     =       0x8C            ; TCON.4
ET0     =       0xA9            ; IE.1
EX1     =       0xAA            ; IE.2
EA      =       0xAF            ; IE.7

LED_XANH =      0xA4
LED_VANG =      0xA5
LED_DO   =      0xA6

;--- RAM ---
HIENTHI =       0x30
VITRI   =       0x34
KHOA    =       0x35
CNT_L   =       0x36
CNT_H   =       0x37

;=====================================================================
;  BANG VECTOR - moi nguon ngat co DUNG 8 byte, chi du cho mot LJMP
;=====================================================================
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
        mov     P3, #0xFF       ; bat buoc: P3.3 phai tha noi cao
        mov     P1, #0x00

        mov     HIENTHI+0, #0x3F        ; "0000"
        mov     HIENTHI+1, #0x3F
        mov     HIENTHI+2, #0x3F
        mov     HIENTHI+3, #0x3F
        clr     a
        mov     VITRI, a
        mov     KHOA, a
        mov     CNT_L, a
        mov     CNT_H, a

        mov     TMOD, #0x01     ; Timer 0 che do 1 (16 bit)
        mov     TH0, #0xFC      ; 65536 - 922 = 0xFC66 -> 1 ms
        mov     TL0, #0x66

        setb    IT1             ; INT1 kich theo CANH XUONG
        setb    ET0
        setb    EX1
        setb    EA
        setb    TR0

main_loop:
        ;--- doc product_count 2 byte trong vung gang ---
        clr     EA
        mov     r7, CNT_L
        mov     r6, CNT_H
        setb    EA

        lcall   tach_so         ; -> R2..R5
        lcall   nap_ma
        sjmp    main_loop

;=====================================================================
;  ISR TIMER 0 - moi 1 ms
;---------------------------------------------------------------------
;  ⭐ Dung BANK THANH GHI 1 (MOV PSW,#08h) thay vi PUSH tung R:
;    R0 cua ISR nam o 08h, khong phai 00h cua main. Chi can cat PSW va
;    A. Day la ly do SP phai dat len 5Fh - SP mac dinh 07h thi stack
;    se ghi de len chinh bank 1.
;=====================================================================
t0_isr:
        push    PSW
        push    ACC
        mov     PSW, #0x08      ; sang bank 1

        mov     TH0, #0xFC      ; che do 1 KHONG tu nap lai
        mov     TL0, #0x66

        orl     P2, #0x0F       ; 1. tat het chan chon
        mov     a, VITRI        ; 2. xuat ma cua so dang den luot
        add     a, #HIENTHI
        mov     r0, a
        mov     P1, @r0
        mov     a, VITRI        ; 3. bat so moi
        add     a, #2           ;    bang ngay sau lenh sjmp (2 byte)
        movc    a, @a+pc        ;    MOVC @A+PC: doc bang trong ROM ma
        sjmp    t0_chon         ;    KHONG dung DPTR - main dang dung no
        .db     0xFE, 0xFD, 0xFB, 0xF7
t0_chon:
        anl     P2, a

        inc     VITRI           ; vitri = (vitri + 1) mod 4
        anl     VITRI, #0x03

        mov     a, KHOA         ; nha dan khoa chong doi cam bien
        jz      t0_ra
        dec     KHOA
t0_ra:
        pop     ACC
        pop     PSW             ; tra PSW = tra luon bank 0 cho main
        reti

;=====================================================================
;  ISR INT1 - cam bien (P3.3). Co IE1 phan cung tu xoa (IT1 = 1).
;=====================================================================
int1_isr:
        push    PSW
        push    ACC

        mov     a, KHOA
        jnz     i1_ra           ; con khoa -> bo qua xung nay
        mov     KHOA, #20       ; khoa 20 ms

        inc     CNT_L           ; product_count++
        mov     a, CNT_L
        jnz     i1_dao
        inc     CNT_H
i1_dao:
        cpl     LED_XANH        ; dau hieu song: ngat vua chay
i1_ra:
        pop     ACC
        pop     PSW
        reti

;=====================================================================
;  nap_ma: R2..R5 (4 chu so) -> ma 7 doan -> HIENTHI[0..3]
;=====================================================================
nap_ma:
        mov     dptr, #MA7DOAN
        mov     a, r2
        movc    a, @a+dptr
        mov     HIENTHI+0, a
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
;  tach_so: R6:R7 (0..9999) -> R2 nghin, R3 tram, R4 chuc, R5 don vi
;  Tru lap 1000 roi 100, phan con lai < 100 thi DIV AB.
;  (giai thich day du o cum3_7seg\quet4so_asm.asm)
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

MA7DOAN:
        .db     0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F
