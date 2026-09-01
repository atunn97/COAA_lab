org 100h

mov ah, 1
int 21h          ; nhap so thu nhat -> AL
mov bl, al

mov ah, 1
int 21h          ; nhap so thu hai -> AL
mov cl, al

sub bl, 30h      ; ASCII -> gia tri so
sub cl, 30h

mov al, bl
add al, cl       ; <<< AL = TONG, xem thang tren thanh ghi

aam              ; AH = hang chuc, AL = hang don vi
add ax, 3030h    ; -> ASCII

mov bx, ax
mov ah, 2
mov dl, 0Dh
int 21h
mov dl, 0Ah
int 21h          ; xuong dong
mov dl, bh
int 21h          ; in hang chuc
mov dl, bl
int 21h          ; in hang don vi

ret