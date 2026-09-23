;=====================================================================
;  CUM 3 - TEST 4 CHAN CHON, BAN NOI THANG    8051 / ASxxxx  (khong nop)
;---------------------------------------------------------------------
;  Ban ASM cua testdigit_truc.c. Giong het testdigit_asm.asm, CHI KHAC
;  logic chon so bi DAO vi da bo transistor:
;
;    Ban co NPN   : MCU = 1 -> so SANG
;    Ban noi thang: MCU = 0 -> keo cathode xuong mass -> so SANG
;
;  ⚠ Chi lam duoc trong MO PHONG - mach that mot so sang ca 8 doan rut
;    ~80 mA qua mot chan MCU. Bao cao van phai ve transistor.
;
;  KET QUA MONG DOI: 1 _ _ _  ->  _ 2 _ _  ->  _ _ 3 _  ->  _ _ _ 4
;
;  THANH GHI: R7 = vitri (0..3)   R3,R4,R5 = rieng cho delay1s
;=====================================================================

        .module testdigit_truc_asm
        .area   CODE (ABS)

P1      =       0x90
P2      =       0xA0
P3      =       0xB0

        .org    0x0000
        ljmp    start

        .org    0x0030
start:
        mov     P2, #0xFF       ; chan chon = 1 -> tat het (0 moi la chon)
        mov     P3, #0xFF
        mov     P1, #0x00
        mov     r7, #0

main_loop:
        orl     P2, #0x0F       ; 1. tat het chan chon (ghi 1 = tat)

        mov     a, r7           ; 2. dat du lieu
        inc     a
        mov     dptr, #MA7DOAN
        movc    a, @a+dptr
        mov     P1, a

        mov     a, r7           ; 3. bat DUNG MOT so + doi 3 LED don
        mov     dptr, #BANG_P2
        movc    a, @a+dptr
        mov     P2, a

        lcall   delay1s

        inc     r7
        anl     0x07, #0x03     ; vitri = (vitri + 1) mod 4
        sjmp    main_loop

;--- tre ~0,98 giay, tinh chu ky xem testdigit_asm.asm ---
delay1s:
        mov     r5, #9
d1_3:   mov     r4, #200
d1_2:   mov     r3, #250
d1_1:   djnz    r3, d1_1
        djnz    r4, d1_2
        djnz    r5, d1_3
        ret

MA7DOAN:
        .db     0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F

;--- byte P2 cho tung vitri - nua thap DAO so voi ban NPN ---
;           bit: 7=nut  6=DO  5=VANG  4=XANH  3..0 = chon so (0 = chon)
;   vitri 0: 1110 1110  chon so 1, XANH sang
;   vitri 1: 1101 1101  chon so 2, VANG sang
;   vitri 2: 1011 1011  chon so 3, DO   sang
;   vitri 3: 1000 0111  chon so 4, ca ba sang
BANG_P2:
        .db     0xEE, 0xDD, 0xBB, 0x87
