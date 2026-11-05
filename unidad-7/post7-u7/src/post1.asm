bits 16
org 100h

start:
    mov dx, msg1
    call print_string
    mov dx, msg2
    call print_string
    mov dx, msg3
    call print_string

    mov ax, 4C00h
    int 21h

print_string:
    mov ah, 09h
    int 21h
    ret

msg1 db "Arquitectura de Computadores", 0Dh, 0Ah, "$"
msg2 db "Unidad 7: Pantalla y Teclado", 0Dh, 0Ah, "$"
msg3 db "Laboratorio POST-1", 0Dh, 0Ah, "$"
