;=====================================================================
;  CUM 5  -  HE THONG DEM SAN PHAM + UART        8051 / ASxxxx
;---------------------------------------------------------------------
;  Ban ASM cua demsp_uart.c - chay giong het.
;
;  PHAN CUNG THEM: COMPIM noi THANG (khong cheo)
;      P3.1 TXD -> chan "TXD" COMPIM    P3.0 RXD -> chan "RXD" COMPIM
;      9600 baud, 8-N-1.   ⚠ Clock U1 PHAI la 11.0592MHz.
;
;  BA NGUON NGAT + mot bo tao baud:
;      Timer 0 (000Bh) 1 ms : quet man hinh + dem gio + nha khoa
;      INT1    (0013h)      : cam bien san pham
;      Serial  (0023h)      : nhat ky tu lenh tu PC vao bo dem
;      Timer 1              : KHONG ngat - chi lam bo tao baud
;
;  LENH TU PC (Enter de gui, chu thuong cung nhan):
;      START  STOP  RESET  STATUS  SET COUNT n
;
;  TRANG THAI: PAUSE <-> RUN --(count >= target)--> ALARM
;      ALARM: dung day chuyen, LED do. Thoat bang RESET hoac SET COUNT
;      voi muc tieu moi cao hon so da dem.
;
;  BO NHO:
;    30h..33h HIENTHI[4]
;    34h TICK_L 35h TICK_H 36h GIAY 37h PHUT 38h VITRI 39h KHOA
;    3Ah CNT_L  3Bh CNT_H  3Ch TGT_L 3Dh TGT_H 3Eh CHE_DO 3Fh GIAY_CU
;    40h BUF_LEN    41h..54h BUF[20]
;    bit 00h DANG_CHAY  01h ALARM  02h CO_LENH   (byte 20h)
;    Bank 1 (08h..0Fh) rieng cho ISR. Stack tu 60h.
;
;  QUY UOC HAM:
;    uart_gui   : ky tu trong A. Chi pha A.
;    uart_chuoi : DPTR tro chuoi trong ROM, ket thuc bang 0.
;    uart_so    : R6:R7 -> 4 chu so.   tach_so: R6:R7 -> R2..R5
;=====================================================================

        .module demsp_uart_asm
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
TL1     =       0x8B
TH0     =       0x8C
TH1     =       0x8D
SCON    =       0x98
SBUF    =       0x99

;--- bit SFR ---
IT1     =       0x8A            ; TCON.2
TR0     =       0x8C            ; TCON.4
TR1     =       0x8E            ; TCON.6
RI      =       0x98            ; SCON.0
TI      =       0x99            ; SCON.1
ET0     =       0xA9            ; IE.1
EX1     =       0xAA            ; IE.2
ES      =       0xAC            ; IE.4
EA      =       0xAF            ; IE.7

LED_XANH  =     0xA4
LED_VANG  =     0xA5
LED_DO    =     0xA6
NUT_RESET =     0xA7            ; P2.7
NUT_SS    =     0xB2            ; P3.2
NUT_MODE  =     0xB6            ; P3.6

;--- RAM ---
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
GIAY_CU =       0x3F
BUF_LEN =       0x40
BUF     =       0x41
BUF_MAX =       20

DANG_CHAY =     0x00
ALARM     =     0x01
CO_LENH   =     0x02

DAU_CHAM  =     0x80
MA_CHU_P  =     0x73

;=====================================================================
;  BANG VECTOR
;=====================================================================
        .org    0x0000
        ljmp    start
        .org    0x000B          ; Timer 0
        ljmp    t0_isr
        .org    0x0013          ; INT1
        ljmp    int1_isr
        .org    0x0023          ; Serial (chung cho RI va TI)
        ljmp    uart_isr

        .org    0x0030
start:
        mov     SP, #0x5F

        mov     P2, #0xFF
        mov     P3, #0xFF
        mov     P1, #0x00

        clr     a               ; xoa 30h..40h + byte bit
        mov     RAMBIT, a
        mov     r0, #HIENTHI
xoa_ram:
        mov     @r0, a
        inc     r0
        cjne    r0, #BUF_LEN+1, xoa_ram
        mov     TGT_L, #20
        mov     TGT_H, #0

        ;-------------------------------------------------------------
        ;  TMOD = 0x21
        ;    nua CAO  0010 : Timer 1 che do 2 (8 bit TU NAP LAI) - baud
        ;    nua THAP 0001 : Timer 0 che do 1 (16 bit) - ngat 1 ms
        ;
        ;  TH1 = 0xFD: baud = 11 059 200 / 12 / 32 / (256 - 253) = 9600
        ;  SCON = 0x50: che do 1 (UART 8 bit), REN = 1 (cho phep nhan)
        ;-------------------------------------------------------------
        mov     TMOD, #0x21
        mov     TH0, #0xFC
        mov     TL0, #0x66
        mov     TH1, #0xFD
        mov     TL1, #0xFD
        mov     SCON, #0x50
        setb    TR1             ; ⚠ Timer 1 phai CHAY thi moi co xung baud

        setb    IT1
        setb    ET0
        setb    EX1
        setb    ES              ; ⭐ nhan bang ngat - khong bo sot ky tu
        setb    EA
        setb    TR0

        mov     dptr, #S_CHAO
        lcall   uart_chuoi
        mov     dptr, #S_HUONGDAN
        lcall   uart_chuoi
        lcall   gui_trang_thai

;=====================================================================
;  VONG LAP CHINH
;=====================================================================
main_loop:
        lcall   cap_nhat_hienthi

        ;--- ISR da nhat du mot dong lenh -> main xu ly ---
        ;    JBC = nhay neu bit = 1 VA xoa bit do, trong MOT lenh.
        ;    Ban C phai viet hai dong: if (co_lenh) { co_lenh = 0; ...
        jnb     CO_LENH, xet_giay
        clr     CO_LENH
        lcall   xu_ly_lenh

xet_giay:
        ;--- dang RUN va giay vua doi -> tu bao trang thai len PC ---
        jnb     DANG_CHAY, xet_ss
        mov     a, GIAY
        cjne    a, GIAY_CU, bao_giay
        sjmp    xet_ss
bao_giay:
        mov     GIAY_CU, a
        lcall   gui_trang_thai

xet_ss:
        jb      NUT_SS, xet_mode
        lcall   delay20ms
        jb      NUT_SS, xet_mode
        jb      ALARM, cho_ss           ; dang ALARM thi phai RESET truoc
        cpl     DANG_CHAY
cho_ss: jnb     NUT_SS, cho_ss

xet_mode:
        jb      NUT_MODE, xet_reset
        lcall   delay20ms
        jb      NUT_MODE, xet_reset
        inc     CHE_DO
        mov     a, CHE_DO
        cjne    a, #3, cho_md
        mov     CHE_DO, #0
cho_md: jnb     NUT_MODE, cho_md

xet_reset:
        jb      NUT_RESET, xet_alarm
        lcall   delay20ms
        jb      NUT_RESET, xet_alarm
        lcall   xoa_het
cho_rs: jnb     NUT_RESET, cho_rs

xet_alarm:
        ;-------------------------------------------------------------
        ;  RUN -> ALARM khi count >= target.  Dat o main, khong o ISR:
        ;  ISR phai ngan, va target co the vua bi SET COUNT sua.
        ;-------------------------------------------------------------
        jnb     DANG_CHAY, cap_led
        clr     EA
        mov     r7, CNT_L
        mov     r6, CNT_H
        setb    EA
        clr     c
        mov     a, r7
        subb    a, TGT_L
        mov     a, r6
        subb    a, TGT_H
        jc      cap_led                 ; C = 1 -> count < target
        clr     DANG_CHAY               ; DUNG day chuyen
        setb    ALARM
        mov     dptr, #S_BAO_DONG
        lcall   uart_chuoi
        lcall   gui_trang_thai

cap_led:
        jnb     ALARM, led_thuong
        setb    LED_XANH
        setb    LED_VANG
        clr     LED_DO
        ljmp    main_loop
led_thuong:
        mov     c, DANG_CHAY
        cpl     c
        mov     LED_XANH, c
        cpl     c
        mov     LED_VANG, c
        setb    LED_DO
        ljmp    main_loop

;--- xoa so dem, thoi gian, ALARM (nut RESET va lenh RESET dung chung) ---
xoa_het:
        clr     a
        clr     EA
        mov     CNT_L, a
        mov     CNT_H, a
        mov     TICK_L, a
        mov     TICK_H, a
        setb    EA
        mov     GIAY, a
        mov     PHUT, a
        clr     ALARM
        ret

;=====================================================================
;  XU LY MOT DONG LENH trong BUF
;=====================================================================
xu_ly_lenh:
        mov     a, BUF_LEN      ; buf[buf_len] = 0: ket thuc chuoi
        add     a, #BUF
        mov     r0, a
        mov     @r0, #0

        ;--- START ---
        mov     dptr, #K_START
        lcall   khop
        jnc     xl_stop
        mov     dptr, #S_ERR_ALARM
        jb      ALARM, xl_gui
        setb    DANG_CHAY
        mov     dptr, #S_OK_RUN
        sjmp    xl_gui

xl_stop:
        mov     dptr, #K_STOP
        lcall   khop
        jnc     xl_reset
        clr     DANG_CHAY
        mov     dptr, #S_OK_PAUSE
        sjmp    xl_gui

xl_reset:
        mov     dptr, #K_RESET
        lcall   khop
        jnc     xl_status
        lcall   xoa_het
        mov     dptr, #S_OK_RESET
        sjmp    xl_gui

xl_status:
        mov     dptr, #K_STATUS
        lcall   khop
        jnc     xl_set
        lcall   gui_trang_thai
        sjmp    xl_xong

xl_set:
        mov     dptr, #K_SET
        lcall   khop
        jc      xl_doc_so
        mov     dptr, #S_ERR    ; khong khop lenh nao
xl_gui:
        lcall   uart_chuoi
xl_xong:
        mov     BUF_LEN, #0
        ret

        ;-------------------------------------------------------------
        ;  SET COUNT n: tim chu so dau tien, doc so thap phan tu do.
        ;  R0 = con tro vao BUF, R2 = so ky tu con lai
        ;-------------------------------------------------------------
xl_doc_so:
        mov     r0, #BUF
        mov     r2, BUF_LEN
tim_so:
        mov     a, r2
        jz      khong_so
        mov     a, @r0
        lcall   la_chu_so
        jc      doc_so
        inc     r0
        dec     r2
        sjmp    tim_so
khong_so:
        mov     dptr, #S_ERR_NONUM
        sjmp    xl_gui

doc_so:
        mov     r7, #0          ; n = 0  (R6:R7)
        mov     r6, #0
doc_lap:
        mov     a, r2
        jz      doc_xong
        mov     a, @r0
        lcall   la_chu_so
        jnc     doc_xong
        clr     c
        subb    a, #0x30        ; ky tu -> gia tri 0..9
        mov     r3, a
        ;---------------------------------------------------------
        ;  n = n * 10 + chu_so   (16 bit)
        ;  MUL AB chi nhan 8 bit x 8 bit -> 16 bit (B:A). So 16 bit
        ;  thi nhan tung byte:
        ;    thap x 10 -> B:A      A la byte thap moi, B mang sang
        ;    cao  x 10 -> A        + phan mang sang = byte cao moi
        ;---------------------------------------------------------
        mov     a, r7
        mov     B, #10
        mul     ab
        mov     r7, a
        mov     r4, B
        mov     a, r6
        mov     B, #10
        mul     ab
        add     a, r4
        mov     r6, a
        mov     a, r7           ; + chu so, nho sang byte cao
        add     a, r3
        mov     r7, a
        clr     a
        addc    a, r6
        mov     r6, a
        inc     r0
        dec     r2
        sjmp    doc_lap
doc_xong:
        mov     TGT_L, r7
        mov     TGT_H, r6

        ;--- muc tieu moi cao hon so da dem -> thoat ALARM ---
        clr     EA
        jnb     ALARM, set_bao
        clr     c
        mov     a, CNT_L
        subb    a, TGT_L
        mov     a, CNT_H
        subb    a, TGT_H
        jnc     set_bao                 ; count >= target -> van ALARM
        clr     ALARM
set_bao:
        setb    EA

        mov     dptr, #S_OK_TARGET
        lcall   uart_chuoi
        mov     r7, TGT_L
        mov     r6, TGT_H
        lcall   uart_so
        mov     dptr, #S_CRLF
        sjmp    xl_gui

;--- la_chu_so: A la '0'..'9' thi C = 1, khong thi C = 0. Giu nguyen A ---
la_chu_so:
        cjne    a, #0x30, lcs_1         ; CJNE dat C = 1 neu A < toan hang
lcs_1:  jc      lcs_khong               ; A < '0'
        cjne    a, #0x3A, lcs_2         ; 3Ah = ky tu ngay sau '9'
lcs_2:  ret                             ; C = 1 dung khi A <= '9'
lcs_khong:
        clr     c
        ret

;=====================================================================
;  khop: so BUF voi tu khoa o DPTR (ROM). Khop het tu khoa -> C = 1.
;  Giong ban C: chi so PHAN DAU - "SET COUNT 50" khop "SET".
;=====================================================================
khop:
        mov     r0, #BUF
kh_lap:
        clr     a
        movc    a, @a+dptr
        jz      kh_dung                 ; het tu khoa -> khop
        xrl     a, @r0                  ; A = 0 khi hai ky tu bang nhau
        jnz     kh_sai
        inc     r0
        inc     dptr
        sjmp    kh_lap
kh_dung:
        setb    c
        ret
kh_sai:
        clr     c
        ret

;=====================================================================
;  gui_trang_thai:  COUNT=0012 TIME=01:05 TARGET=0020 STATE=RUN
;=====================================================================
gui_trang_thai:
        clr     EA
        mov     r7, CNT_L
        mov     r6, CNT_H
        setb    EA

        mov     dptr, #S_COUNT
        lcall   uart_chuoi
        lcall   uart_so

        mov     dptr, #S_TIME
        lcall   uart_chuoi
        mov     a, PHUT
        lcall   uart_hai_so
        mov     a, #0x3A                ; ':'
        lcall   uart_gui
        mov     a, GIAY
        lcall   uart_hai_so

        mov     dptr, #S_TARGET
        lcall   uart_chuoi
        mov     r7, TGT_L
        mov     r6, TGT_H
        lcall   uart_so

        mov     dptr, #S_STATE
        lcall   uart_chuoi
        mov     dptr, #S_ALARM
        jb      ALARM, gt_gui
        mov     dptr, #S_RUN
        jb      DANG_CHAY, gt_gui
        mov     dptr, #S_PAUSE
gt_gui:
        lcall   uart_chuoi
        mov     dptr, #S_CRLF
        ljmp    uart_chuoi              ; goi cuoi: RET cua uart_chuoi
                                        ; tra thang ve ham goi minh

;=====================================================================
;  UART - GUI
;---------------------------------------------------------------------
;  ⚠ ES = 0 trong luc gui: TI cung goi vector 0023h. De ES = 1 thi ISR
;    nhay vao ngay sau khi ghi SBUF, va vong cho TI treo mai.
;  ⚠ TI KHONG tu xoa - phai CLR bang tay sau moi byte.
;=====================================================================
uart_gui:
        clr     ES
        mov     SBUF, a         ; ghi SBUF = bat dau gui
ug_cho: jnb     TI, ug_cho      ; 10 bit x 104 us = 1,04 ms
        clr     TI
        setb    ES
        ret

uart_chuoi:
        clr     a
        movc    a, @a+dptr
        jz      uc_het
        lcall   uart_gui
        inc     dptr
        sjmp    uart_chuoi
uc_het: ret

;--- uart_so: R6:R7 -> 4 chu so ASCII ---
uart_so:
        lcall   tach_so
        mov     a, r2
        add     a, #0x30
        lcall   uart_gui
        mov     a, r3
        add     a, #0x30
        lcall   uart_gui
        mov     a, r4
        add     a, #0x30
        lcall   uart_gui
        mov     a, r5
        add     a, #0x30
        ljmp    uart_gui

;--- uart_hai_so: A (0..99) -> 2 chu so ASCII ---
uart_hai_so:
        mov     B, #10
        div     ab
        add     a, #0x30
        lcall   uart_gui        ; uart_gui khong dung B
        mov     a, B
        add     a, #0x30
        ljmp    uart_gui

;=====================================================================
;  ISR CONG NOI TIEP - vector 0023h (bank 1)
;---------------------------------------------------------------------
;  Chi NHAT ky tu vao BUF, khong xu ly lenh - xu ly co gui tra loi,
;  rat lau. Het dong thi dat CO_LENH cho main.
;  ⚠ RI KHONG tu xoa - CLR ngay dau ISR, neu khong ISR goi lai vo tan.
;=====================================================================
uart_isr:
        push    PSW
        push    ACC
        mov     PSW, #0x08

        jnb     RI, u_ra
        clr     RI
        mov     a, SBUF

        cjne    a, #0x0D, u_lf          ; '\r'
        sjmp    u_het_dong
u_lf:   cjne    a, #0x0A, u_kytu        ; '\n'
u_het_dong:
        mov     a, BUF_LEN
        jz      u_ra                    ; dong rong -> bo qua
        setb    CO_LENH
        sjmp    u_ra

u_kytu:
        mov     r2, a                   ; cat ky tu (R2 cua bank 1)
        mov     a, BUF_LEN              ; con cho? (chua 1 o cho so 0 cuoi)
        cjne    a, #BUF_MAX-1, u_1
u_1:    jnc     u_ra                    ; BUF_LEN >= 19 -> bo ky tu

        mov     a, r2                   ; chu thuong 'a'..'z' -> chu hoa
        cjne    a, #0x61, u_2
u_2:    jc      u_luu                   ; < 'a'
        cjne    a, #0x7B, u_3           ; 7Bh = ngay sau 'z'
u_3:    jnc     u_luu                   ; > 'z'
        clr     c
        subb    a, #32
        mov     r2, a
u_luu:
        mov     a, BUF_LEN              ; buf[buf_len++] = c
        add     a, #BUF
        mov     r0, a
        mov     a, r2
        mov     @r0, a
        inc     BUF_LEN
u_ra:
        pop     ACC
        pop     PSW
        reti

;=====================================================================
;  ISR TIMER 0 - moi 1 ms (bank 1)
;=====================================================================
t0_isr:
        push    PSW
        push    ACC
        mov     PSW, #0x08

        mov     TH0, #0xFC
        mov     TL0, #0x66

        orl     P2, #0x0F               ; quet mot chu so
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

        mov     a, KHOA                 ; nha khoa chong doi cam bien
        jz      t0_gio
        dec     KHOA

t0_gio: jnb     DANG_CHAY, t0_ra        ; dem thoi gian khi RUN
        inc     TICK_L
        mov     a, TICK_L
        jnz     t0_kt
        inc     TICK_H
t0_kt:  cjne    a, #0xE8, t0_ra
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
;=====================================================================
int1_isr:
        push    PSW
        push    ACC
        mov     a, KHOA
        jnz     i1_ra
        mov     KHOA, #20
        jnb     DANG_CHAY, i1_ra
        inc     CNT_L
        mov     a, CNT_L
        jnz     i1_ra
        inc     CNT_H
i1_ra:
        pop     ACC
        pop     PSW
        reti

;=====================================================================
;  cap_nhat_hienthi - theo CHE_DO  (giong demsp_asm.asm)
;=====================================================================
cap_nhat_hienthi:
        mov     dptr, #MA7DOAN
        mov     a, CHE_DO
        jz      hien_count
        dec     a
        jz      hien_time

        mov     r7, TGT_L               ; TARGET: P + 3 chu so thap
        mov     r6, TGT_H
        lcall   tach_so
        mov     r2, #0xFF               ; o [0] la chu P
        sjmp    nap_ma

hien_count:
        clr     EA
        mov     r7, CNT_L
        mov     r6, CNT_H
        setb    EA
        lcall   tach_so
        sjmp    nap_ma

hien_time:
        mov     a, PHUT
        mov     B, #10
        div     ab
        movc    a, @a+dptr
        mov     HIENTHI+0, a
        mov     a, B
        movc    a, @a+dptr
        orl     a, #DAU_CHAM            ; cham gan truoc khi ghi
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

;=====================================================================
;  HANG SO TRONG ROM
;=====================================================================
MA7DOAN:
        .db     0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F

;--- tu khoa lenh (ket thuc bang 0) ---
K_START:  .ascii "START"
          .db    0
K_STOP:   .ascii "STOP"
          .db    0
K_RESET:  .ascii "RESET"
          .db    0
K_STATUS: .ascii "STATUS"
          .db    0
K_SET:    .ascii "SET"
          .db    0

;--- chuoi tra loi ---
S_CHAO:       .db    0x0D, 0x0A
              .ascii "HE THONG DEM SAN PHAM - AT89C51"
              .db    0x0D, 0x0A, 0
S_HUONGDAN:   .ascii "Lenh: START STOP RESET STATUS | SET COUNT n"
              .db    0x0D, 0x0A, 0
S_COUNT:      .ascii "COUNT="
              .db    0
S_TIME:       .ascii " TIME="
              .db    0
S_TARGET:     .ascii " TARGET="
              .db    0
S_STATE:      .ascii " STATE="
              .db    0
S_ALARM:      .ascii "ALARM"
              .db    0
S_RUN:        .ascii "RUN"
              .db    0
S_PAUSE:      .ascii "PAUSE"
              .db    0
S_CRLF:       .db    0x0D, 0x0A, 0
S_OK_RUN:     .ascii "OK RUN"
              .db    0x0D, 0x0A, 0
S_OK_PAUSE:   .ascii "OK PAUSE"
              .db    0x0D, 0x0A, 0
S_OK_RESET:   .ascii "OK RESET"
              .db    0x0D, 0x0A, 0
S_OK_TARGET:  .ascii "OK TARGET="
              .db    0
S_ERR:        .ascii "ERR"
              .db    0x0D, 0x0A, 0
S_ERR_NONUM:  .ascii "ERR NO NUMBER"
              .db    0x0D, 0x0A, 0
S_ERR_ALARM:  .ascii "ERR ALARM - RESET HOAC SET COUNT LON HON"
              .db    0x0D, 0x0A, 0
S_BAO_DONG:   .ascii "ALARM! DA DAT MUC TIEU"
              .db    0x0D, 0x0A, 0
