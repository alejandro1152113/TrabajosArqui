bits 16
org 100h

    mov dx, aviso
    mov ah, 09h
    int 21h

    mov ah, 2Ch
    int 21h
    mov [hora_inicio], ch
    mov [minuto_inicio], cl
    mov [segundo_inicio], dh
    mov [cent_inicio], dl

    mov bx, 1000
bucle:
    mov cx, 1000
bucle_interno:
    inc ax
    loop bucle_interno
    dec bx
    jnz bucle

    mov ah, 2Ch
    int 21h
    mov [hora_fin], ch
    mov [minuto_fin], cl
    mov [segundo_fin], dh
    mov [cent_fin], dl

    mov dx, etiqueta_inicio
    mov ah, 09h
    int 21h
    mov al, [hora_inicio]
    call print_dec2
    mov dx, separador
    mov ah, 09h
    int 21h
    mov al, [minuto_inicio]
    call print_dec2
    mov dx, separador
    mov ah, 09h
    int 21h
    mov al, [segundo_inicio]
    call print_dec2
    mov dx, separador
    mov ah, 09h
    int 21h
    mov al, [cent_inicio]
    call print_dec2

    mov dx, etiqueta_fin
    mov ah, 09h
    int 21h
    mov al, [hora_fin]
    call print_dec2
    mov dx, separador
    mov ah, 09h
    int 21h
    mov al, [minuto_fin]
    call print_dec2
    mov dx, separador
    mov ah, 09h
    int 21h
    mov al, [segundo_fin]
    call print_dec2
    mov dx, separador
    mov ah, 09h
    int 21h
    mov al, [cent_fin]
    call print_dec2

    mov dx, fin
    mov ah, 09h
    int 21h

    mov ax, 4C00h
    int 21h

print_dec2:
    aam
    xchg al, ah
    push ax

    add al, '0'
    mov dl, al
    mov ah, 02h
    int 21h

    pop ax
    mov al, ah
    add al, '0'
    mov dl, al
    mov ah, 02h
    int 21h
    ret

aviso          db 'Midiendo un bucle fijo...', 13, 10, '$'
etiqueta_inicio db 'Inicio (hh:mm:ss:cc): $'
etiqueta_fin    db 13, 10, 'Fin    (hh:mm:ss:cc): $'
separador      db ':$'
fin            db 13, 10, 'Medicion terminada.', 13, 10, '$'

hora_inicio db 0
minuto_inicio db 0
segundo_inicio db 0
cent_inicio db 0
hora_fin db 0
minuto_fin db 0
segundo_fin db 0
cent_fin db 0
