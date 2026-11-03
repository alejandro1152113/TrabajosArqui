bits 16
org 100h

    jmp inicio

array          dw 10, 20, 30, 40, 50
nota1          dw 85
nota2          dw 73
promedio       dw 0
var_x          dw 0FFFFh
matriz         dw 1, 2, 3
               dw 4, 5, 6
               dw 7, 8, 9

inmediato_ax   dw 0
directo_ax     dw 0
directo_bx     dw 0
directo_cx     dw 0
indirecto_ax   dw 0
indirecto_bx   dw 0
indexado_ax    dw 0
suma_array     dw 0
suma_inversa   dw 0
bp_suma        dw 0
bp_original    dw 0
sp_antes_local dw 0
sp_despues_sub dw 0
matriz_offset  dw 0
matriz_valor   dw 0
matriz_directa dw 0
terminado      db 'Parte 2 ejecutada; revise registros, datos y segmentos con DEBUG.', 13, 10, '$'

inicio:
    mov ax, 100
    mov [inmediato_ax], ax

    mov ax, [var_x]
    mov [directo_ax], ax
    mov bx, [array]
    mov [directo_bx], bx
    mov cx, [nota1]
    mov [directo_cx], cx
    mov word [var_x], 0

    mov si, nota1
    mov ax, [si]
    mov [indirecto_ax], ax
    mov si, nota2
    mov bx, [si]
    mov [indirecto_bx], bx
    add ax, bx
    shr ax, 1
    mov si, promedio
    mov [si], ax

    mov bx, array
    mov si, 4
    mov ax, [bx + si]
    mov [indexado_ax], ax

    xor ax, ax
    mov bx, array
    mov cx, 5
    xor si, si
.suma_directa:
    add ax, [bx + si]
    add si, 2
    loop .suma_directa
    mov [suma_array], ax

    xor ax, ax
    mov bx, array
    mov cx, 5
    mov si, 8
.suma_inversa:
    add ax, [bx + si]
    sub si, 2
    loop .suma_inversa
    mov [suma_inversa], ax

    mov [bp_original], bp
    mov [sp_antes_local], sp
    push bp
    mov bp, sp
    sub sp, 4
    mov [sp_despues_sub], sp
    mov word [bp - 2], 99
    mov word [bp - 4], 250
    mov ax, [bp - 2]
    add ax, [bp - 4]
    mov [bp_suma], ax
    mov sp, bp
    pop bp

    mov ax, 1
    mov bx, 3
    mul bx
    shl ax, 1
    mov si, ax
    mov cx, 2
    shl cx, 1
    add si, cx
    mov [matriz_offset], si
    mov bx, matriz
    mov dx, [bx + si]
    mov [matriz_valor], dx
    mov ax, [matriz + 10]
    mov [matriz_directa], ax

    mov dx, terminado
    mov ah, 09h
    int 21h
    int 20h
