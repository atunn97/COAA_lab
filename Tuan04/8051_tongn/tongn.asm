;=====================================================================
;  TINH TONG 1 + 2 + ... + n     -  8051  -  ASSEMBLY (ASxxxx / sdas8051)
;---------------------------------------------------------------------
;  DE BAI: nhap n bang cong input, n <= 13, tinh tong 1..n, hien ket qua.
;
;  PHAN CUNG:
;    Nhap n   : 4 cong tac tren P2.0..P2.3  (4 bit thap)
;               moi cong tac noi tu chan MCU xuong GND.
;               KHONG can tro keo ngoai - Port 2 co tro keo noi.
;               => cong tac DONG = chan xuong 0. Phan mem dao lai bang CPL.
;
;    Hien thi : 2 LED 7 doan loai COMMON CATHODE (chung cathode xuong GND)
;               doan sang khi chan = 1.
;               P1.0..P1.6 = a..g cua chu so HANG CHUC
;               P0.0..P0.6 = a..g cua chu so HANG DON VI
;
;    ==> P0 la cong OPEN-DRAIN, KHONG co tro keo noi.
;        BAT BUOC gan 8 tro keo len +5V (RESPACK-8 10k) cho P0,
;        neu khong LED hang don vi se khong sang. Day la cau hoi
;        van dap rat hay gap ve su khac nhau giua P0 va P1/P2/P3.
;
;    Thach anh 12 MHz -> 1 chu ky may = 1 us
;
;  VI SAO DE GIOI HAN n <= 13 ?
;    tong(13) = 91  -> vua 2 chu so
;    tong(14) = 105 -> tran mat 3 chu so, 2 LED 7 doan khong hien duoc.
;    Ngoai ra n(n+1) <= 182 < 256 nen moi phep tinh gon trong 8 bit.
;
;  n > 13 : hien "EE" (Error) va doc lai.
;
;  PHAN CHIA THANH GHI:
;    A        : n -> roi thanh tong -> roi thanh ma 7 doan
;    R7       : giu n (bo dem vong lap), sau do muon lai de giu chu so don vi
;    R6       : so hang dang cong (1, 2, 3, ...)
;    B        : so chia 10 / byte cao cua phep nhan
;=====================================================================

        .module tongn
        .area   CODE (ABS)

;--- ASM khong co san ten thanh ghi nhu file 8051.h, phai tu dinh nghia ---
P0      =       0x80            ; dia chi byte cua Port 0
P1      =       0x90            ; dia chi byte cua Port 1
P2      =       0xA0            ; dia chi byte cua Port 2

;=====================================================================
;  0x0000 = vector RESET, phan cung ep CPU bat dau chay tu day.
;  0x0003..0x002A la vung vector ngat -> tranh ra, code that tu 0x0030.
;=====================================================================
        .org    0x0000
        ljmp    start

        .org    0x0030
start:
;---------------------------------------------------------------------
;  ⚠ DONG QUAN TRONG NHAT CUA CA CHUONG TRINH
;  Port 8051 la QUASI-BIDIRECTIONAL: moi chan co mot chot (latch).
;  Chot dang giu 0 thi transistor keo chan xuong mass, luc do du cong
;  tac ben ngoai co noi len 5V, doc vao VAN RA 0.
;  Phai ghi 1 ra chot truoc de chan "tha noi cao" thi moi doc duoc.
;---------------------------------------------------------------------
        mov     P2, #0xFF       ; chuan bi P2 lam cong INPUT

main_loop:
;=====================================================================
;  BUOC 1 - DOC n TU 4 BIT THAP CUA P2
;=====================================================================
        mov     a, P2           ; doc ca byte
        cpl     a               ; cong tac dong = 0, dao lai thanh 1
        anl     a, #0x0F        ; che 4 bit cao, giu lai n = 0..15
        mov     r7, a           ; cat n vao R7 (A sap bi pha o buoc 2)

;=====================================================================
;  BUOC 2 - KIEM TRA n > 13
;---------------------------------------------------------------------
;  SUBB A,#data tru CA SO BI TRU LAN CO NHO, nen phai CLR C truoc.
;  Sau phep tru:  n < 14  -> co muon  -> C = 1
;                 n >= 14 -> khong muon -> C = 0
;=====================================================================
        clr     c
        subb    a, #14
        jnc     bao_loi         ; C = 0 nghia la n >= 14 -> sai

;=====================================================================
;  BUOC 3 - TINH TONG = 1 + 2 + ... + n
;---------------------------------------------------------------------
;  ⚠ BAY: DJNZ giam TRUOC roi moi so sanh, nen vao voi R7 = 0 thi no
;  chay 256 vong chu khong phai 0 vong. Bat buoc chan trang thai n = 0.
;=====================================================================
        mov     a, r7           ; lay lai n
        mov     r6, #0x00       ; so hang hien tai = 0
        jz      xuat_ket_qua    ; n = 0 -> tong = 0, ma A dang = 0 san

        mov     a, #0x00        ; A = tong = 0
sum_loop:
        inc     r6              ; so hang ke: 1, 2, 3, ...
        add     a, r6           ; cong don vao tong
        djnz    r7, sum_loop    ; lap dung n lan

;=====================================================================
;  BUOC 4 - TACH TONG THANH 2 CHU SO THAP PHAN
;---------------------------------------------------------------------
;  DIV AB:  A = thuong (hang chuc)   |   B = so du (hang don vi)
;  Vi tong <= 91 nen thuong luon <= 9, khong bao gio tran.
;=====================================================================
xuat_ket_qua:
        mov     b, #10
        div     ab              ; A = chuc, B = don vi     <- 4 chu ky may
        mov     r7, b           ; cat don vi lai, vi B se bi dung tiep

;=====================================================================
;  BUOC 5 - TRA BANG MA 7 DOAN VA XUAT RA 2 LED
;---------------------------------------------------------------------
;  MOVC A,@A+DPTR : doc mot byte trong ROM tai dia chi DPTR + A.
;  Day dung la ky thuat BANG TRA da dung o bai dich LED (ben C la __code).
;  Chi nap DPTR MOT lan - MOVC khong lam thay doi DPTR.
;=====================================================================
        mov     dptr, #bang7doan
        movc    a, @a+dptr      ; A = ma 7 doan cua chu so hang chuc
        mov     P1, a           ; xuat ra LED hang CHUC

        mov     a, r7           ; lay lai chu so hang don vi
        movc    a, @a+dptr      ; DPTR van con nguyen tu tren
        mov     P0, a           ; xuat ra LED hang DON VI

        sjmp    main_loop       ; doc lai - xoay cong tac la ket qua doi theo

;=====================================================================
;  NHANH BAO LOI - n > 13, hien "EE"
;=====================================================================
bao_loi:
        mov     P1, #0x79       ; chu E
        mov     P0, #0x79       ; chu E   -> man hinh hien "EE"
        sjmp    main_loop

;=====================================================================
;  BANG MA 7 DOAN - LOAI COMMON CATHODE (doan sang khi bit = 1)
;---------------------------------------------------------------------
;  Thu tu bit:  bit0=a  bit1=b  bit2=c  bit3=d  bit4=e  bit5=f  bit6=g
;               bit7 = dau cham (dp), luon = 0 o bang nay.
;
;     aaaa        so 0 sang a,b,c,d,e,f  (tat g)   = 0011 1111 = 0x3F
;    f    b       so 1 sang b,c                    = 0000 0110 = 0x06
;    f    b       so 8 sang tat ca 7 doan          = 0111 1111 = 0x7F
;     gggg
;    e    c       ⚠ Neu dung LED COMMON ANODE thi phai DAO nguoc ca bang
;    e    c         (0x3F -> 0xC0 ...), hoac them lenh CPL A truoc khi xuat.
;     dddd  dp
;=====================================================================
bang7doan:
        .db     0x3F            ; 0
        .db     0x06            ; 1
        .db     0x5B            ; 2
        .db     0x4F            ; 3
        .db     0x66            ; 4
        .db     0x6D            ; 5
        .db     0x7D            ; 6
        .db     0x07            ; 7
        .db     0x7F            ; 8
        .db     0x6F            ; 9

;=====================================================================
;  CACH 2 - dung CONG THUC n(n+1)/2 thay cho vong lap
;  (de tra loi cau "con toi uu hon duoc khong?")
;---------------------------------------------------------------------
;        mov   a, r7           ; A = n
;        mov   b, a            ; B = n
;        inc   b               ; B = n+1
;        mul   ab              ; B:A = n x (n+1)      <- 4 chu ky may
;        clr   c
;        rrc   a               ; A = A / 2  (chia 2 = dich phai 1 bit)
;
;  Voi n <= 13 thi n(n+1) <= 182 < 256, nen byte cao B luon bang 0
;  va ket qua nam gon trong A -> khong phai xu ly 16 bit.
;
;  So sanh: vong lap ton ~4 chu ky x n lan (thay doi theo n);
;           cong thuc ton co dinh ~8 chu ky bat ke n bang bao nhieu.
;=====================================================================
