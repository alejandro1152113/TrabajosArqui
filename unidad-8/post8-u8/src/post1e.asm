BITS 16
ORG 100h

start:
    push cs
    pop ds
    push ds
    pop es
    cld
    mov si, origen
    mov di, destino
    mov cx, longitud

.bucle:
    lodsb
    cmp al, 'a'
    jb .guardar
    cmp al, 'z'
    ja .guardar
    sub al, 20h
.guardar:
    stosb
    loop .bucle

    mov dx, msg
    mov ah, 09h
    int 21h
    mov si, destino
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

origen db 'hola, mundo!', 0
longitud equ $ - origen
destino times longitud db 0
msg db 'Transformado: $'
crlf db 13, 10, '$'
