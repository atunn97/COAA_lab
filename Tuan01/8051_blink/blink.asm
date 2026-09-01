;=====================================================================
;  BLINK 1 LED DON  -  AT89C51  -  viet bang ASSEMBLY
;  Cu phap: ASxxxx  (danh cho sdas8051 di kem SDCC)
;  Xem cuoi file de doi chieu voi cu phap Keil A51
;---------------------------------------------------------------------
;  Mach: +5V -- R330 -- LED -- P1.0 (chan 1)
;  Thach anh 12MHz  ->  1 machine cycle = 1us
;=====================================================================

        .module blink
        .area   CODE (ABS)

;--- Dinh nghia dia chi thanh ghi (ASM khong co san nhu file 8051.h) ---
P1      =       0x90            ; dia chi byte cua Port 1
P1_0    =       0x90            ; dia chi BIT cua P1.0

;=====================================================================
;  Dia chi 0x0000 = vector RESET.
;  Khi cap nguon / nhan nut reset, 8051 LUON bat dau chay tu day.
;=====================================================================
        .org    0x0000
        ljmp    start           ; nhay toi chuong trinh chinh

;=====================================================================
;  Chuong trinh chinh dat tu 0x0030
;  (0x0003..0x002A la vung vector ngat, tranh ra cho an toan)
;=====================================================================
        .org    0x0030
start:
        setb    P1_0            ; khoi dau: chan len 5V -> LED TAT

main_loop:
        clr     P1_0            ; keo chan xuong 0V -> LED SANG
        lcall   delay_500ms

        setb    P1_0            ; tha chan len 5V   -> LED TAT
        lcall   delay_500ms

        sjmp    main_loop       ; lap lai mai mai

;=====================================================================
;  Ham tre ~500ms bang 3 vong lap DJNZ long nhau
;
;  DJNZ = "Decrement and Jump if Not Zero" = giam 1, khac 0 thi nhay.
;  Tai 12MHz, lenh DJNZ ton 2 machine cycle = 2us.
;
;  Vong trong  : 250 lan x 2us              = 500us
;  Vong giua   : 100 lan x (500us + ~3us)   = 50.3ms
;  Vong ngoai  :  10 lan x 50.3ms           = 503ms  ~ 0,5 giay
;=====================================================================
delay_500ms:
        mov     r7, #10         ; vong ngoai
d_outer:
        mov     r6, #100        ; vong giua
d_mid:
        mov     r5, #250        ; vong trong
d_inner:
        djnz    r5, d_inner     ; giam r5, chua ve 0 thi lap lai
        djnz    r6, d_mid       ; giam r6, chua ve 0 thi lam lai vong trong
        djnz    r7, d_outer     ; giam r7, chua ve 0 thi lam lai vong giua
        ret                     ; tra ve cho noi da goi lcall

;  (ASxxxx khong dung .end - Keil moi can END)

;=====================================================================
;  DOI CHIEU CU PHAP  -  neu ban chuyen sang Keil A51 / ASEM-51
;---------------------------------------------------------------------
;   ASxxxx (file nay)        |  Keil A51
;   -------------------------+---------------------------
;   .area CODE (ABS)         |  CSEG
;   .org  0x0030             |  ORG   0030H
;   P1_0  =  0x90            |  LED   BIT  P1.0
;   mov   r7, #10            |  MOV   R7, #10
;   0x90  (so hex)           |  90H   (so hex)
;   .end                     |  END
;
;  Ban than cac LENH (setb, clr, mov, djnz, lcall, sjmp, ret)
;  thi GIONG HET NHAU - vi day la tap lenh cua chip, khong phai
;  cua trinh dich. Chi khac cach viet DIRECTIVE va cach ghi so hex.
;=====================================================================
