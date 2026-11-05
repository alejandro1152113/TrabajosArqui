BITS 16
ORG 100h

start:
    push cs
    pop ds
    push ds
    pop es
    cld

    mov si, origen
    mov di, destino_byte
    mov cx, longitud
    rep movsb

    mov si, origen
    mov di, destino_word
    mov cx, longitud
    mov bx, cx
    shr cx, 1
    rep movsw
    test bx, 1
    jz .comparar
    movsb

.comparar:
    mov si, destino_byte
    mov di, destino_word
    mov cx, longitud
    repe cmpsb
    jne .error
    mov dx, msg_iguales
    jmp .imprimir_estado
.error:
    mov dx, msg_diferentes
.imprimir_estado:
    mov ah, 09h
    int 21h
    mov dx, crlf
    mov ah, 09h
    int 21h
    mov dx, msg_byte
    mov ah, 09h
    int 21h
    mov si, destino_byte
    call imprimir_cadena
    mov dx, crlf
    mov ah, 09h
    int 21h
    mov dx, msg_word
    mov ah, 09h
    int 21h
    mov si, destino_word
    call imprimir_cadena
    mov dx, crlf
    mov ah, 09h
    int 21h
    mov ax, 4C00h
    int 21h

imprimir_cadena:
.siguiente:
    lodsb
    test al, al
    jz .fin
    mov dl, al
    push si
    mov ah, 02h
    int 21h
    pop si
    jmp .siguiente
.fin:
    ret

origen db 'HOLA, MUNDO!', 0
longitud equ $ - origen
destino_byte times longitud db 0
destino_word times longitud db 0
msg_iguales db 'Buffers MOVSB/MOVSW iguales.$'
msg_diferentes db 'Error: buffers diferentes.$'
msg_byte db 'MOVSB: $'
msg_word db 'MOVSW: $'
crlf db 13, 10, '$'
