bits 16
org 100h

    jmp inicio

resultado dw 0
terminado db 'Factorial de 5 calculado; resultado esperado: 120.', 13, 10, '$'

inicio:
    mov ax, 1
    mov bx, 1
    mov cx, 5
.factorial:
    mul bx
    inc bx
    loop .factorial
    mov [resultado], ax

    mov dx, terminado
    mov ah, 09h
    int 21h
    int 20h
