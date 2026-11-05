bits 16
org 100h

%define VIDEO_PAGE 0
%define COLOR_YELLOW_BLUE 1Eh
%define COLOR_LIGHT_RED 0Ch

start:
    ; Limpiar las 25 filas por medio de INT 10h/AH=06h.
    mov ax, 0600h
    mov bh, 07h
    xor cx, cx
    mov dx, 184Fh
    int 10h

    ; Escribir A en fila 2, columna 10: amarillo sobre azul.
    mov ah, 02h
    mov bh, VIDEO_PAGE
    mov dh, 2
    mov dl, 10
    int 10h

    mov ah, 09h
    mov al, "A"
    mov bh, VIDEO_PAGE
    mov bl, COLOR_YELLOW_BLUE
    mov cx, 1
    int 10h

    ; Escribir U7 en fila 3, columna 10.
    mov ah, 02h
    mov bh, VIDEO_PAGE
    mov dh, 3
    mov dl, 10
    int 10h

    mov ah, 09h
    mov al, "U"
    mov bh, VIDEO_PAGE
    mov bl, COLOR_LIGHT_RED
    mov cx, 1
    int 10h

    mov ah, 02h
    mov bh, VIDEO_PAGE
    mov dh, 3
    mov dl, 11
    int 10h

    mov ah, 09h
    mov al, "7"
    mov bh, VIDEO_PAGE
    mov bl, COLOR_LIGHT_RED
    mov cx, 1
    int 10h

    mov ah, 08h
    int 21h
    mov ax, 4C00h
    int 21h
