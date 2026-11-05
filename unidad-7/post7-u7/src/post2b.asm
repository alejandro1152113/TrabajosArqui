bits 16
org 100h

%define VIDEO_SEGMENT 0B800h
%define START_ROW 10
%define START_COLUMN 38

start:
    mov ax, VIDEO_SEGMENT
    mov es, ax

    ; El offset de una celda es (fila*80 + columna)*2.
    mov ax, START_ROW
    mov bx, 80
    mul bx
    add ax, START_COLUMN
    shl ax, 1
    mov di, ax

    mov al, "H"
    mov ah, 0Ch
    stosw
    add di, 158
    mov al, "O"
    mov ah, 0Ah
    stosw
    add di, 158
    mov al, "L"
    mov ah, 0Bh
    stosw
    add di, 158
    mov al, "A"
    mov ah, 0Eh
    stosw

    mov ah, 08h
    int 21h
    mov ax, 4C00h
    int 21h
