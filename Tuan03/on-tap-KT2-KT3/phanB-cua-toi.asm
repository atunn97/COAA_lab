
; You may customize this and other start-up templates;
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h
nhapso:
    mov ah,01
    int 21h
    sub al, '0'
    mov ah,0
    cmp al, 1
    jb  sai        ; nho hon 1 -> loai
    cmp al, 8
    ja  sai        ; lon hon 8 -> loai
dung:              ; song sot qua ca hai -> chac chan 1..8
    test al,1
    jz so_chan
    jnz so_le
so_chan:
    mov dx,137
    mul dx
    jmp output
so_le:
    mov cx,ax
    mov bx,1
lap:
    mul bx
    sub cx,1
    mov bx,cx
    cmp cx,0
    jnz lap
    jmp output
sai:
    mov ah,09
    mov dx, offset msb
    int 21h
    jmp nhapso
output:
    mov bx, ax

ret
msb db 13,10, 'SAI, nhap lai$'
