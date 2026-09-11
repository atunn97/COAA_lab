;=====================================================================
;  DICH LED 3 HIEU UNG  -  8051  -  ASSEMBLY (cu phap ASxxxx / sdas8051)
;---------------------------------------------------------------------
;  Phan cung: 8 LED active LOW tren P1.0..P1.7
;             +5V -- R330 -- LED -- P1.x    => bit 0 = SANG, bit 1 = TAT
;             Thach anh 12 MHz  ->  1 chu ky may = 1 us
;  Quy uoc  : LED trai nhat = D8 = P1.7 = bit 7
;---------------------------------------------------------------------
;  Ba hieu ung chay noi tiep, lap vo tan, moi hinh 300 ms:
;    1. Sang dan tu D1 sang D8      (9 hinh)
;    2. Chop ca 8 LED, 8 lan        (16 hinh)
;    3. Mot LED chay tu D1 sang D8  (8 hinh)
;---------------------------------------------------------------------
;  PHAN CHIA THANH GHI (phai noi duoc khi thay hoi):
;    A      : mau dang hien thi
;    R7     : dem so hinh con lai cua hieu ung
;    R3,R4,R5 : rieng cho chuong trinh tre  -> KHONG dung A va R7,
;               nho vay ham goi khong can PUSH/POP gi ca
;=====================================================================

        .module dichled_asm
        .area   CODE (ABS)

;--- ASM khong co san ten thanh ghi nhu file 8051.h, phai tu dinh nghia ---
P1      =       0x90            ; dia chi BYTE cua Port 1

;=====================================================================
;  0x0000 la vector RESET - phan cung ep CPU bat dau chay tu day
;=====================================================================
        .org    0x0000
        ljmp    start

;=====================================================================
;  0x0003..0x002A la vung vector NGAT. Bai nay khong dung ngat,
;  nhung van phai tranh ra, nen chuong trinh chinh dat tu 0x0030.
;=====================================================================
        .org    0x0030
start:
        mov     P1, #0xFF       ; khoi dong: tat het 8 LED

main_loop:
        lcall   hieuung1
        lcall   hieuung2
        lcall   hieuung3
        sjmp    main_loop       ; lap vo tan

;=====================================================================
;  HIEU UNG 1 - SANG DAN tu D1 sang D8   (9 hinh)
;---------------------------------------------------------------------
;  Bang mau: FF FE FC F8 F0 E0 C0 80 00
;  Phep bien doi: day trai 1 bit, o trong ben phai duoc dien bit 0.
;  Bit 0 = LED SANG, nen moi buoc sang them mot con.
;
;  Dung cap lenh:  CLR C  roi  RLC A
;    - RLC A = quay trai QUA CO NHO: C -> bit0, bit7 -> C
;    - CLR C truoc de bit chui vao la 0 (= LED SANG)
;  Vi sao khong dung RL A ? RL A quay vong kin, bit 7 vong ve bit 0,
;  mau se khong bao gio "day them LED sang" ma chi xoay tai cho.
;=====================================================================
hieuung1:
        mov     a, #0xFF        ; hat giong: tat het
        mov     r7, #9          ; 9 hinh
hu1_loop:
        mov     P1, a           ; xuat mau ra 8 chan
        lcall   delay_300ms
        clr     c               ; bit sap chui vao = 0 = LED SANG
        rlc     a               ; day trai 1 bit
        djnz    r7, hu1_loop    ; giam r7, chua ve 0 thi lam hinh ke
        ret

;=====================================================================
;  HIEU UNG 2 - CHOP ca 8 LED, dung 8 lan   (16 hinh)
;---------------------------------------------------------------------
;  Khong can dich, khong can mat na. Chi hai gia tri thay phien:
;      0x00 = sang ca 8   |   0xFF = tat ca 8
;  Bo dem R7 = 8 doc thang ra "chop 8 lan", khong phai giai thich.
;=====================================================================
hieuung2:
        mov     r7, #8          ; 8 lan chop
hu2_loop:
        mov     P1, #0x00       ; sang ca 8
        lcall   delay_300ms
        mov     P1, #0xFF       ; tat ca 8
        lcall   delay_300ms
        djnz    r7, hu2_loop
        ret

;=====================================================================
;  HIEU UNG 3 - MOT LED chay tu D1 sang D8   (8 hinh)
;---------------------------------------------------------------------
;  Bang mau: FE FD FB F7 EF DF BF 7F
;  Cung cap lenh RLC A nhu hieu ung 1, chi khac HAI diem:
;    - hat giong 0xFE : dung MOT bit 0 duy nhat, nam o D1
;    - SETB C thay vi CLR C : bit chui vao la 1 (= LED TAT),
;      no lap dung cho o ma bit 0 vua roi khoi
;  => luon con dung mot LED sang, va no bo sang trai.
;
;  So sanh de tra loi thay: cung mot cong thuc, doi hat giong thi
;  doi han hieu ung. Nap 0x00 (tam o SANG) thi LED tat dan;
;  nap 0xFE (mot o SANG) thi con LED do chay.
;=====================================================================
hieuung3:
        mov     a, #0xFE        ; hat giong: chi D1 sang
        mov     r7, #8          ; 8 hinh
hu3_loop:
        mov     P1, a
        lcall   delay_300ms
        setb    c               ; bit sap chui vao = 1 = LED TAT
        rlc     a               ; day trai 1 bit
        djnz    r7, hu3_loop
        ret

;=====================================================================
;  TRE 300 ms bang 3 vong DJNZ long nhau
;---------------------------------------------------------------------
;  Tai 12 MHz: 1 chu ky may = 12 chu ky dao dong = 1 us
;  So chu ky may cua tung lenh:  MOV Rn,#data = 1   |   DJNZ = 2
;
;  Vong trong : 250 x 2                     =     500 chu ky
;  Vong giua  : 199 x (1 + 500 + 2)         = 100 097
;  Vong ngoai :   3 x (1 + 100 097 + 2)     = 300 300
;  Cong MOV R3 (1) + RET (2)                = 300 303 chu ky
;                                           = 300,303 ms   (sai so +0,1%)
;
;  Ham nay chi dung R3, R4, R5 -> khong dap vao A va R7 cua ham goi.
;=====================================================================
delay_300ms:
        mov     r3, #3          ; vong ngoai
d_outer:
        mov     r4, #199        ; vong giua
d_mid:
        mov     r5, #250        ; vong trong
d_inner:
        djnz    r5, d_inner
        djnz    r4, d_mid
        djnz    r3, d_outer
        ret

;=====================================================================
;  DOI CHIEU CU PHAP - neu chuyen sang Keil A51 / ASEM-51
;---------------------------------------------------------------------
;   ASxxxx (file nay)      |  Keil A51
;   -----------------------+------------------
;   .area CODE (ABS)       |  CSEG
;   .org  0x0030           |  ORG   0030H
;   P1  =  0x90            |  P1    EQU  90H
;   mov  r7, #9            |  MOV   R7, #9
;   0xFE                   |  0FEH
;   (khong co)             |  END
;
;  Cac LENH (mov, rlc, clr, setb, djnz, lcall, sjmp, ljmp, ret)
;  thi GIONG HET NHAU, vi do la tap lenh cua chip chu khong phai
;  cua trinh dich. Chi khac DIRECTIVE va cach ghi so hex.
;=====================================================================
