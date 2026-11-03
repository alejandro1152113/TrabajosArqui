bits 16
org 100h

    mov dx, prompt
    mov ah, 09h
    int 21h

    mov ah, 07h
    int 21h
    mov [caracter], al

    mov dx, recibido
    mov ah, 09h
    int 21h

    mov dl, [caracter]
    mov ah, 02h
    int 21h

    mov dx, codigo
    mov ah, 09h
    int 21h

    mov al, [caracter]
    shr al, 4
    call print_hex_nibble

    mov al, [caracter]
    and al, 0Fh
    call print_hex_nibble

    mov dx, nueva_linea
    mov ah, 09h
    int 21h

    mov ax, 4C00h
    int 21h

print_hex_nibble:
    cmp al, 9
    jbe .digit
    add al, 7
.digit:
    add al, '0'
    mov dl, al
    mov ah, 02h
    int 21h
    ret

prompt      db 'Ingrese una tecla: $'
recibido    db 13, 10, 'Caracter recibido: $'
codigo      db 13, 10, 'Codigo ASCII (hex): $'
nueva_linea db 13, 10, '$'
caracter    db 0
