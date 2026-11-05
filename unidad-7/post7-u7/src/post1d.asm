bits 16
org 100h

%define TEST_ROW 8
%define TEST_COLUMN 10
%define TEST_CHARACTER "Z"
%define TEST_ATTRIBUTE 2Fh

start:
    ; AH=0Fh devuelve AL=modo, AH=columnas y BH=pagina activa.
    mov ah, 0Fh
    int 10h
    mov [video_mode], al
    mov [video_columns], ah
    mov [active_page], bh

    mov dx, msg_mode
    call print_string
    cmp byte [video_mode], 03h
    jne unexpected_mode
    cmp byte [video_columns], 80
    jne unexpected_mode

    mov dx, msg_mode_ok
    call print_string
    jmp write_test_cell

unexpected_mode:
    mov dx, msg_mode_unexpected
    call print_string

write_test_cell:
    mov ah, 02h
    mov bh, [active_page]
    mov dh, TEST_ROW
    mov dl, TEST_COLUMN
    int 10h

    mov ah, 09h
    mov al, TEST_CHARACTER
    mov bh, [active_page]
    mov bl, TEST_ATTRIBUTE
    mov cx, 1
    int 10h

    ; AH=08h relee el caracter y el atributo en la posicion del cursor.
    mov ah, 02h
    mov bh, [active_page]
    mov dh, TEST_ROW
    mov dl, TEST_COLUMN
    int 10h

    mov ah, 08h
    mov bh, [active_page]
    int 10h
    cmp al, TEST_CHARACTER
    jne cell_mismatch
    cmp ah, TEST_ATTRIBUTE
    jne cell_mismatch

    mov dx, msg_cell_ok
    call print_string
    jmp wait_for_key

cell_mismatch:
    mov dx, msg_cell_error
    call print_string

wait_for_key:
    mov ah, 08h
    int 21h
    mov ax, 4C00h
    int 21h

print_string:
    mov ah, 09h
    int 21h
    ret

msg_mode db "Modo de video: $"
msg_mode_ok db "03h; texto 80x25 confirmado.", 0Dh, 0Ah, "$"
msg_mode_unexpected db "inesperado; se continua con la prueba.", 0Dh, 0Ah, "$"
msg_cell_ok db "Verificacion OK: caracter y atributo coinciden.", "$"
msg_cell_error db "ERROR: la relectura no coincide.", "$"
video_mode db 0
video_columns db 0
active_page db 0
