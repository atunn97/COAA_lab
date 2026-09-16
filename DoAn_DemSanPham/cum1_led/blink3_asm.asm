;=====================================================================
;  CUM 1  -  NHAP NHAY 3 LED DON        8051 / ASxxxx (sdas8051)
;---------------------------------------------------------------------
;  MUC DICH: bai nap dau tien cua de tai "he thong dem san pham".
;  No khong tinh toan gi - viec duy nhat cua no la CHUNG MINH BA THU:
;      1. Con chip trong Proteus song va chay code cua minh
;      2. Ba LED noi dung chan va dung CUC TINH
;      3. Thuoc tinh Clock Frequency cua U1 da dat dung
;
;  PHAN CUNG (theo bang chan da chot):
;    P2.4 -> LED XANH   (RUN)
;    P2.5 -> LED VANG   (PAUSE)
;    P2.6 -> LED DO     (ALARM)
;
;    Mac ACTIVE LOW:  +5V -- tro 330R -- anode LED -- cathode LED -- chan MCU
;    => ghi 0 ra chan thi LED SANG, ghi 1 thi LED TAT.
;    Vi sao active LOW: chan 8051 HUT dong khoe (~10-20 mA) nhung
;    DAY dong rat yeu (chi ~60 uA tu tro keo noi).
;
;    EA (chan 31) phai noi +5V.
;    Thach anh 11,0592 MHz  ->  1 chu ky may = 12/11059200 s = 1,085 us
;    (chon 11,0592 chu khong phai 12 MHz vi de tai co UART - xem muc 4.5
;     cua HANDOFF-TTKTMT-8051-KHUNG-BAI.md)
;
;  THANH GHI DUNG: R3, R4, R5 cho chuong trinh tre.
;    Chua A va R7 cho ham goi, khoi phai PUSH/POP.
;=====================================================================

        .module blink3
        .area   CODE (ABS)

;--- ASM khong co san ten thanh ghi, phai tu dinh nghia ---
P2      =       0xA0            ; dia chi byte cua Port 2

;--- Mau bit xuat ra P2 ---
;    bit:      7   6   5   4   3   2   1   0
;              |   DO  VANG XANH|   |   |   |
;    0xFF = 1111 1111 -> tat het
;    0xEF = 1110 1111 -> P2.4 = 0 -> XANH sang
;    0xDF = 1101 1111 -> P2.5 = 0 -> VANG sang
;    0xBF = 1011 1111 -> P2.6 = 0 -> DO   sang
;
;    P2.7 giu = 1 vi sau nay no la nut RESET (muon DOC mot chan thi
;    phai GHI 1 ra chot cua no truoc - port 8051 la quasi-bidirectional).
;    P2.0..P2.3 giu = 1 o day cho gon; sang cum 3 chung se lam chan
;    chon so cua LED 7 doan.

;=====================================================================
;  0x0000 = vector RESET. 0x0003..0x002A la vung vector ngat -> tranh ra.
;=====================================================================
        .org    0x0000
        ljmp    start

        .org    0x0030
start:
        mov     P2, #0xFF       ; tat het 3 LED truoc khi vao vong lap

loop:
        mov     P2, #0xEF       ; XANH
        lcall   delay500

        mov     P2, #0xDF       ; VANG
        lcall   delay500

        mov     P2, #0xBF       ; DO
        lcall   delay500

        sjmp    loop            ; lap mai mai

;=====================================================================
;  CHUONG TRINH TRE ~500 ms  @ 11,0592 MHz
;---------------------------------------------------------------------
;  Vong lap 3 tang. DJNZ ton 2 chu ky may, MOV ton 1, RET ton 2.
;
;    tang trong : djnz r3 chay 250 lan          = 250 x 2      =    500
;    than tang 2: mov r3 (1) + 500 + djnz (2)                  =    503
;    r4 = 183   : 183 x 503                                    = 92 049
;    than tang 3: mov r4 (1) + 92 049 + djnz (2)               = 92 052
;    r5 = 5     : 5 x 92 052                                   = 460 260
;    cong mov r5 (1) + ret (2)                                 = 460 263
;
;    460 263 chu ky x 1,085 us = 499 395 us = 499,4 ms   (sai so -0,12%)
;=====================================================================
delay500:
        mov     r5, #5
d3:     mov     r4, #183
d2:     mov     r3, #250
d1:     djnz    r3, d1
        djnz    r4, d2
        djnz    r5, d3
        ret
