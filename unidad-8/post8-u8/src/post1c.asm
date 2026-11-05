BITS 16
ORG 100h

start:
    push cs
    pop ds
    push ds
    pop es
    cld

    mov di, cadena
    mov al, 'd'
    mov cx, longitud
    repne scasb
    jne .no_encontrado

    mov bx, di
    sub bx, cadena
    dec bx
    mov dx, msg_hallado
    mov ah, 09h
    int 21h
    mov ax, bx
    call imprimir_decimal
    mov dx, crlf
    mov ah, 09h
    int 21h

    mov di, cadena
    mov al, 'z'
    mov cx, longitud
    repne scasb
    jne .z_no_encontrado
    mov dx, msg_z_hallado
    jmp .imprimir_z
.z_no_encontrado:
    mov dx, msg_z_no
.imprimir_z:
    mov ah, 09h
    int 21h
    jmp .fin

.no_encontrado:
    mov dx, msg_no
    mov ah, 09h
    int 21h
.fin:
    mov dx, crlf
    mov ah, 09h
    int 21h
    mov ax, 4C00h
    int 21h

imprimir_decimal:
    xor cx, cx
    mov bx, 10
.dividir:
    xor dx, dx
    div bx
    push dx
    inc cx
    test ax, ax
    jnz .dividir
.imprimir:
    pop dx
    add dl, '0'
    mov ah, 02h
    int 21h
    loop .imprimir
    ret

cadena db 'Arquitectura de Computadores', 0
longitud equ $ - cadena - 1
msg_hallado db 'Caracter d en indice: $'
msg_no db 'No encontrado.$'
msg_z_hallado db 'z encontrado.$'
msg_z_no db 'z no encontrado.$'
crlf db 13, 10, '$'
