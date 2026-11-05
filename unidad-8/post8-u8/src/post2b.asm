BITS 16
ORG 100h

start:
    push cs
    pop ds

    mov al, [bcd_a]
    add al, [bcd_b]
    daa
    mov [resultado], al
    pushf
    pop bx
    and bl, 1
    mov [acarreo], bl
    mov dx, msg_suma
    call imprimir
    mov al, [resultado]
    call imprimir_bcd
    cmp byte [acarreo], 0
    jz .sin_acarreo
    mov dx, msg_acarreo
    call imprimir
.sin_acarreo:
    mov dx, crlf
    call imprimir

    mov al, [bcd_c]
    sub al, [bcd_d]
    das
    mov [resultado], al
    mov dx, msg_resta
    call imprimir
    mov al, [resultado]
    call imprimir_bcd
    mov dx, crlf
    call imprimir

    mov al, 99h
    add al, 01h
    daa
    mov [resultado], al
    pushf
    pop bx
    and bl, 1
    mov [acarreo], bl
    mov dx, msg_carry
    call imprimir
    mov al, [resultado]
    call imprimir_bcd
    cmp byte [acarreo], 0
    jz .fin
    mov dx, msg_acarreo
    call imprimir
.fin:
    mov dx, crlf
    call imprimir
    mov ax, 4C00h
    int 21h

imprimir:
    mov ah, 09h
    int 21h
    ret

imprimir_bcd:
    push ax
    mov ah, al
    shr al, 4
    add al, '0'
    mov dl, al
    mov ah, 02h
    int 21h
    pop ax
    and al, 0Fh
    add al, '0'
    mov dl, al
    mov ah, 02h
    int 21h
    ret

bcd_a db 47h
bcd_b db 38h
bcd_c db 73h
bcd_d db 28h
resultado db 0
acarreo db 0
msg_suma db 'DAA 47 + 38 = $'
msg_resta db 'DAS 73 - 28 = $'
msg_carry db 'DAA 99 + 01 = $'
msg_acarreo db ' (CF=1)$'
crlf db 13, 10, '$'
