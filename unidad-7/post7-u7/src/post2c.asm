bits 16
org 100h

%define VIDEO_SEGMENT 0B800h
%define SCREEN_CELLS 2000
%define BACKGROUND_WORD 1720h
%define MESSAGE_ATTRIBUTE 0Fh
%define MESSAGE_OFFSET 1980

start:
    mov ax, VIDEO_SEGMENT
    mov es, ax

    ; Rellenar 80x25 celdas con espacios sobre fondo azul.
    mov ax, BACKGROUND_WORD
    xor di, di
    mov cx, SCREEN_CELLS
    cld
    rep stosw

    ; Escribir directamente una cadena centrada en la fila 12.
    mov di, MESSAGE_OFFSET
    mov si, message
write_message:
    lodsb
    or al, al
    jz wait_for_key
    mov ah, MESSAGE_ATTRIBUTE
    stosw
    jmp write_message

wait_for_key:
    mov ah, 08h
    int 21h
    mov ax, 4C00h
    int 21h

message db "HOLA DESDE B800h", 0
