; PHAN B - ban mau cua Claude, de doi chieu
; Chi dung INT 21h voi AH = 1, 2, 9. File .COM.

org 100h

; ================= BUOC 1: NHAP + KIEM TRA HOP LE =================
nhapso:
    xor si,si              ; <-- TONG CHU SO VE 0 CHO MOI LUOT (xem giai thich)
    mov ah,09
    mov dx,offset mnhap
    int 21h
    mov ah,01
    int 21h
    sub al,'0'
    mov ah,0               ; tu day AX = N, sach ca hai byte
    cmp al,1
    jb  sai
    cmp al,8
    ja  sai

; ================= BUOC 2: RE NHANH CHAN / LE =================
dung:
    test al,1
    jz  so_chan
so_le:
    mov cx,ax              ; CX = N
    mov bx,1               ; BX = 1
lap:
    mul bx                 ; AX = AX * BX
    sub cx,1               ; da dat co ZF san
    mov bx,cx              ; MOV khong dung toi co
    jnz lap
    jmp output
so_chan:
    mov dx,137
    mul dx                 ; roi thang xuong output

; ================= BUOC 3 + 4: IN K, ROI IN TONG CHU SO =================
output:                    ; vao day: AX = K
    call xuongdong
    call in_so             ; in K, dong thoi cong don chu so vao SI
    call xuongdong         ; de dong thu hai
    mov  ax,si             ; AX = tong chu so
    call in_so             ; in tong (co the 2 chu so)

; ================= BUOC 5: HOI LAM LAI =================
hoi_lai:
    mov ah,09
    mov dx,offset mlam
    int 21h
    mov ah,01
    int 21h
    cmp al,'y'
    je  nhapso
    cmp al,'Y'
    je  nhapso
    ret                    ; thoat sach: SP dang can bang

sai:
    mov ah,09
    mov dx,offset msb
    int 21h
    jmp nhapso

; ================= THU TUC: IN AX HE 10, CONG CHU SO VAO SI =================
in_so:
    mov bx,10
    xor cx,cx              ; <-- DEM CHU SO VE 0 MOI LAN GOI
chia:
    xor dx,dx              ; <-- BAT BUOC truoc MOI lan div
    div bx                 ; DX = du (chu so), AX = thuong
    add si,dx              ; cong don chu so vao tong
    push dx
    inc cx
    cmp ax,0               ; DUNG THEO THUONG, khong phai theo du
    jnz chia
in_lai:
    pop dx
    add dl,'0'
    mov ah,02
    int 21h
    loop in_lai            ; pop dung bang so lan da push -> SP can bang
    ret

xuongdong:
    mov ah,09
    mov dx,offset mxd
    int 21h
    ret

; ================= DU LIEU - dat sau code =================
mnhap db 13,10,'Nhap N (1-8): $'
msb   db 13,10,'SAI, NHAP LAI: $'
mlam  db 13,10,'LAM LAI? (y/n) $'
mxd   db 13,10,'$'
