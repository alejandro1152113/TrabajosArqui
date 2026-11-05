bits 16
org 100h

%define VIDEO_PAGE 0
%define TEXT_ATTRIBUTE 0Ah

start:
    ; Limpiar la pantalla en modo texto.
    mov ax, 0600h
    mov bh, 07h
    xor cx, cx
    mov dx, 184Fh
    int 10h

    mov si, title
    mov byte [column], 25

next_character:
    lodsb
    or al, al
    jz wait_for_key

    ; Guardar el caracter mientras se posiciona el cursor.
    mov [current_character], al
    push si
    mov ah, 02h
    mov bh, VIDEO_PAGE
    mov dh, 5
    mov dl, [column]
    int 10h

    mov ah, 09h
    mov al, [current_character]
    mov bh, VIDEO_PAGE
    mov bl, TEXT_ATTRIBUTE
    mov cx, 1
    int 10h
    pop si

    inc byte [column]
    jmp next_character

wait_for_key:
    mov ah, 08h
    int 21h
    mov ax, 4C00h
    int 21h

title db "UNIDAD 7 - PANTALLA Y TECLADO", 0
column db 0
current_character db 0
