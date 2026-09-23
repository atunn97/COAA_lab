;=====================================================================
;  CUM 3 - BAI TEST CHAN g    8051 / ASxxxx   (tu kiem chung, khong nop)
;---------------------------------------------------------------------
;  Ban ASM cua testquet.c. Quet 4 so nhu that, nhung so hien CO DINH.
;  Nhan MODE de xoay vong 3 mau:
;
;    Mau 0:  0 0 0 0  -> chan g (P1.6) NAM IM muc 0      LED XANH
;    Mau 1:  8 8 8 8  -> chan g NAM IM muc 1             LED VANG
;    Mau 2:  1 2 3 4  -> chan g BAT BUOC nhap nhay       LED DO
;
;  Ban co TRANSISTOR NPN: chan chon = 1 la so sang.
;
;  THANH GHI:
;    R7 = vitri (0..3)    R6 = mau (0..2)    R3,R4 = rieng cho delay5ms
;    bit 00h = MODE_DA  (nut MODE da xu ly, cho nha ra)
;=====================================================================

        .module testquet_asm
        .area   CODE (ABS)

P1      =       0x90
P2      =       0xA0
P3      =       0xB0
RAMBIT  =       0x20

NUT_MODE  =     0xB5            ; P3.5
MODE_DA   =     0x00            ; bit 20h.0

        .org    0x0000
        ljmp    start

        .org    0x0030
start:
        mov     P2, #0xF0
        mov     P3, #0xFF
        mov     P1, #0x00
        mov     r6, #0          ; mau = 0
        mov     RAMBIT, #0x00   ; MODE_DA = 0

main_loop:
        ;--- quet mot vong du 4 so ---
        mov     r7, #0
quet:
        anl     P2, #0xF0       ; 1. tat het chan chon

        mov     a, r6           ; 2. doi du lieu: MA7DOAN[ MAU[mau][vitri] ]
        rl      a               ;    chi so trong bang MAU = mau*4 + vitri
        rl      a               ;    (hai lan RL = nhan 4, mau <= 2 nen
        add     a, r7           ;     khong tran)
        mov     dptr, #MAU
        movc    a, @a+dptr      ;    -> chu so
        mov     dptr, #MA7DOAN
        movc    a, @a+dptr      ;    -> ma 7 doan
        mov     P1, a

        mov     a, r7           ; 3. bat so moi
        mov     dptr, #CHON_NPN
        movc    a, @a+dptr
        orl     P2, a

        lcall   delay5ms
        inc     r7
        cjne    r7, #4, quet

        ;--- nut MODE: xoay vong 3 mau, moi lan nhan an mot lan ---
        jb      NUT_MODE, mode_nha
        jb      MODE_DA, cap_led        ; da xu ly roi -> bo qua
        setb    MODE_DA
        inc     r6
        cjne    r6, #3, cap_led
        mov     r6, #0
        sjmp    cap_led
mode_nha:
        clr     MODE_DA

cap_led:
        ;-------------------------------------------------------------
        ;  3 LED don bao dang o mau nao.
        ;  Tat ca ba (ORL) roi bat mot (ANL voi mat na) - ca hai lenh
        ;  deu la READ-MODIFY-WRITE: doc CHOT chu khong doc CHAN, nen
        ;  P2.7 van giu 1 du nut RESET dang bi nhan.
        ;  (Neu viet "mov a,P2 ... mov P2,a" thi doc CHAN: dang nhan
        ;   RESET la ghi 0 vao chot P2.7 va khoa chet nut do.)
        ;-------------------------------------------------------------
        mov     a, r6
        mov     dptr, #MAT_NA_LED
        movc    a, @a+dptr
        orl     P2, #0x70
        anl     P2, a
        sjmp    main_loop

;--- tre ~4,9 ms: 9 x 503 + 5 = 4 532 chu ky x 1,085 us ---
delay5ms:
        mov     r4, #9
d5_2:   mov     r3, #250
d5_1:   djnz    r3, d5_1
        djnz    r4, d5_2
        ret

MA7DOAN:
        .db     0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F

MAU:    .db     0, 0, 0, 0              ; g phai NAM IM muc 0
        .db     8, 8, 8, 8              ; g phai NAM IM muc 1
        .db     1, 2, 3, 4              ; g BAT BUOC nhap nhay

CHON_NPN:                               ; 1 bit = 1 cho moi vitri
        .db     0x01, 0x02, 0x04, 0x08

MAT_NA_LED:                             ; bit 4/5/6 = 0 -> xanh/vang/do sang
        .db     0xEF, 0xDF, 0xBF
