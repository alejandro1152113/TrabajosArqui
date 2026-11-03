bits 16
org 100h

    jmp inicio

valor_a        dw 45
valor_b        dw 12
resultado_add  dw 0
resultado_sub  dw 0
resultado_mul  dw 0
cociente_div   db 0
resto_div      db 0
resultado_and  db 0
resultado_or   db 0
resultado_xor  db 0
resultado_test db 0
resultado_suma dw 0
resultado_dec  dw 0
resultado_rol_1 db 0
resultado_rol_4 db 0
resultado_shl  db 0
resultado_ror  db 0
resultado_shr  db 0
flags_add      dw 0
flags_sub      dw 0
flags_and      dw 0
flags_test     dw 0
flags_cmp      dw 0
comparacion    db 0
terminado      db 'Parte 1 ejecutada; revise las variables y flags con DEBUG.', 13, 10, '$'

inicio:
    mov ax, [valor_a]
    mov bx, [valor_b]
    mov cx, ax
    mov dx, bx
    lea si, [valor_a]
    mov ax, [si]
    xchg cx, dx
    xchg cx, dx
    push ax
    mov ax, 0FFFFh
    pop ax

    mov ax, [valor_a]
    add ax, [valor_b]
    pushf
    pop dx
    mov [flags_add], dx
    mov [resultado_add], ax

    mov ax, [valor_b]
    sub ax, [valor_a]
    pushf
    pop dx
    mov [flags_sub], dx
    mov [resultado_sub], ax

    mov ax, [valor_a]
    inc ax
    dec ax

    mov al, 10
    mov bl, 7
    mul bl
    mov [resultado_mul], ax

    mov ax, 100
    mov bl, 7
    div bl
    mov [cociente_div], al
    mov [resto_div], ah

    mov al, 0B7h
    and al, 0Fh
    pushf
    pop dx
    mov [flags_and], dx
    mov [resultado_and], al

    mov al, 0B7h
    or al, 0F0h
    mov [resultado_or], al

    mov al, 0AAh
    xor al, 0FFh
    mov [resultado_xor], al
    xor bx, bx

    mov al, 0B7h
    test al, 1
    pushf
    pop dx
    mov [flags_test], dx
    mov [resultado_test], al

    mov ax, [valor_a]
    cmp ax, [valor_b]
    pushf
    pop dx
    mov [flags_cmp], dx
    jg .mayor
    je .igual
    mov byte [comparacion], 0
    jmp .fin_cmp
.mayor:
    mov byte [comparacion], 1
    jmp .fin_cmp
.igual:
    mov byte [comparacion], 2
.fin_cmp:

    xor ax, ax
    mov cx, 5
    mov bx, 1
.bucle_suma:
    add ax, bx
    inc bx
    loop .bucle_suma
    mov [resultado_suma], ax

    xor ax, ax
    mov cx, 5
    mov bx, 1
.bucle_dec_jnz:
    add ax, bx
    inc bx
    dec cx
    jnz .bucle_dec_jnz
    mov [resultado_dec], ax

    mov al, 81h
    mov bl, al
    shl bl, 1
    mov [resultado_shl], bl
    mov cl, al
    rol cl, 1
    mov [resultado_rol_1], cl
    mov dl, al
    shr dl, 1
    mov [resultado_shr], dl
    mov bh, al
    ror bh, 1
    mov [resultado_ror], bh

    mov al, 0A5h
    rol al, 4
    mov [resultado_rol_4], al

    mov dx, terminado
    mov ah, 09h
    int 21h
    int 20h
