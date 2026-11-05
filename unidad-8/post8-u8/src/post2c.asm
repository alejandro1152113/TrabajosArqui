BITS 16
ORG 100h

start:
    push cs
    pop ds

    mov dx, prompt_a
    call imprimir
    call leer_digito
    jc .fin
    mov [operando_a], al

    mov dx, prompt_b
    call imprimir
    call leer_digito
    jc .fin
    mov [operando_b], al

    mov dx, prompt_op
    call imprimir
    mov ah, 01h
    int 21h
    mov [operador], al

    cmp al, '*'
    je .multiplicar
    cmp al, '/'
    je .dividir
    mov dx, msg_operador
    call imprimir
    jmp .fin

.multiplicar:
    mov al, [operando_a]
    mul byte [operando_b]
    aam
    mov [decenas], ah
    mov [unidades], al
    mov dx, msg_resultado
    call imprimir
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
    jmp .fin_linea

.dividir:
    cmp byte [operando_b], 0
    je .division_cero
    xor ah, ah
    mov al, [operando_a]
    div byte [operando_b]
    mov [cociente], al
    mov [resto], ah
    mov dx, msg_resultado
    call imprimir
    mov dl, [cociente]
    add dl, '0'
    mov ah, 02h
    int 21h
    mov dx, msg_resto
    call imprimir
    mov dl, [resto]
    add dl, '0'
    mov ah, 02h
    int 21h
    jmp .fin_linea

.division_cero:
    mov dx, msg_div_cero
    call imprimir
    jmp .fin_linea
.fin:
    mov ax, 4C00h
    int 21h
.fin_linea:
    mov dx, crlf
    call imprimir
    mov ax, 4C00h
    int 21h

leer_digito:
    mov ah, 01h
    int 21h
    cmp al, '0'
    jb .invalido
    cmp al, '9'
    ja .invalido
    sub al, '0'
    clc
    ret
.invalido:
    mov dx, msg_digito
    call imprimir
    stc
    ret

imprimir:
    mov ah, 09h
    int 21h
    ret

operando_a db 0
operando_b db 0
operador db 0
decenas db 0
unidades db 0
cociente db 0
resto db 0
prompt_a db 'Primer digito (0-9): $'
prompt_b db 13, 10, 'Segundo digito (0-9): $'
prompt_op db 13, 10, 'Operacion (* o /): $'
msg_resultado db 13, 10, 'Resultado: $'
msg_resto db ' Resto: $'
msg_div_cero db 13, 10, 'Division por cero.$'
msg_digito db 13, 10, 'Entrada invalida; use un digito.$'
msg_operador db 13, 10, 'Operador invalido.$'
crlf db 13, 10, '$'
