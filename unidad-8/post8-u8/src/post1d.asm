BITS 16
ORG 100h

start:
    push cs
    pop ds
    push ds
    pop es
    cld

    mov si, cadena1
    mov di, cadena2
    mov cx, longitud
    repe cmpsb
    jne .diferentes_1
    mov dx, msg_iguales
    jmp .imprimir_1
.diferentes_1:
    mov dx, msg_diferentes
.imprimir_1:
    mov ah, 09h
    int 21h
    mov dx, crlf
    mov ah, 09h
    int 21h

    mov si, cadena1
    mov di, cadena3
    mov cx, longitud
    repe cmpsb
    jne .diferentes_2
    mov dx, msg_iguales
    jmp .imprimir_2
.diferentes_2:
    mov dx, msg_diferentes
.imprimir_2:
    mov ah, 09h
    int 21h
    mov dx, crlf
    mov ah, 09h
    int 21h
    mov ax, 4C00h
    int 21h

cadena1 db 'NASM x86'
cadena2 db 'NASM x86'
cadena3 db 'NASM ARM'
longitud equ 8
msg_iguales db 'Iguales.$'
msg_diferentes db 'Diferentes.$'
crlf db 13, 10, '$'
