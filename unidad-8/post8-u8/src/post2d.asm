BITS 16
ORG 100h

start:
    push cs
    pop ds

    mov dx, msg_suma
    mov ah, 09h
    int 21h
    xor ah, ah
    mov al, 07h
    add al, 08h
    aaa
    mov [decenas], ah
    mov [unidades], al
    cmp byte [decenas], 0
    je .imprimir_unidades
    mov dl, [decenas]
    add dl, '0'
    mov ah, 02h
    int 21h
.imprimir_unidades:
    mov dl, [unidades]
    add dl, '0'
    mov ah, 02h
    int 21h

    mov dx, msg_resta
    mov ah, 09h
    int 21h
    mov ah, 1
    mov al, 03h
    sub al, 08h
    aas
    mov [decenas], ah
    mov [unidades], al
    cmp byte [decenas], 0
    je .imprimir_unidades_resta
    mov dl, [decenas]
    add dl, '0'
    mov ah, 02h
    int 21h
.imprimir_unidades_resta:
    mov dl, [unidades]
    add dl, '0'
    mov ah, 02h
    int 21h

    mov dx, crlf
    mov ah, 09h
    int 21h
    mov ax, 4C00h
    int 21h

decenas db 0
unidades db 0
msg_suma db 'AAA: 7 + 8 = $'
msg_resta db 13, 10, 'AAS: 13 - 8 = $'
crlf db 13, 10, '$'
