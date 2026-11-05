BITS 16
ORG 100h

start:
    push cs
    pop ds

    mov ax, [a_lo]
    mov dx, [a_hi]
    add ax, [b_lo]
    adc dx, [b_hi]
    cmp dx, 3
    jne .error_suma
    cmp ax, 0
    jne .error_suma
    mov dx, msg_suma
    call imprimir

    mov ax, [c_lo]
    mov dx, [c_hi]
    sub ax, [d_lo]
    sbb dx, [d_hi]
    cmp dx, 1
    jne .error_resta
    cmp ax, 0FFFFh
    jne .error_resta
    mov dx, msg_resta
    call imprimir
    jmp .fin

.error_suma:
    mov dx, msg_error_suma
    call imprimir
    jmp .fin
.error_resta:
    mov dx, msg_error_resta
    call imprimir
.fin:
    mov ax, 4C00h
    int 21h

imprimir:
    mov ah, 09h
    int 21h
    ret

a_lo dw 0FFFFh
a_hi dw 0001h
b_lo dw 0001h
b_hi dw 0001h
c_lo dw 0000h
c_hi dw 0003h
d_lo dw 0001h
d_hi dw 0001h
msg_suma db 'Suma OK: DX:AX = 0003:0000', 13, 10, '$'
msg_resta db 'Resta OK: DX:AX = 0001:FFFF', 13, 10, '$'
msg_error_suma db 'Error en suma.', 13, 10, '$'
msg_error_resta db 'Error en resta.', 13, 10, '$'
