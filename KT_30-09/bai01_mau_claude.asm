; ============================================================
;  BAI 01 - 4 NUT BAT/TAT 2 LED + HIEN "97" TREN 2 LED 7 DOAN
;  BAN SO BO CUA CLAUDE (25/09) - DE DOC, KHONG PHAI BAI CUA A
;  LED1 = P2.0, LED2 = P2.1 (xuat 1 = SANG)
;  Nut1..4 = P1.0..P1.3 (nhan = 0)
;  P0 thap -> LED trai, P0 cao -> LED phai  => "97" = 79H
; ============================================================
        ORG   0000H

MAIN:   MOV   P2,#00H         ; ban dau tat het LED
        MOV   P0,#79H         ; trai = 9, phai = 7 (chi can 1 lan)

LOOP:   JB    P1.0,NUT2       ; nut 1 khong nhan (=1) -> hoi nut 2
        SETB  P2.0            ; nut 1 dang nhan -> bat LED1
NUT2:   JB    P1.1,NUT3
        CLR   P2.0            ; nut 2 -> tat LED1
NUT3:   JB    P1.2,NUT4
        SETB  P2.1            ; nut 3 -> bat LED2
NUT4:   JB    P1.3,LOOP
        CLR   P2.1            ; nut 4 -> tat LED2
        SJMP  LOOP

        END
