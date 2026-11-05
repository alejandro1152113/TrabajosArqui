bits 16
org 100h

start:
    mov dx, prompt
    call print_string

read_key:
    mov ah, 00h
    int 16h
    mov [scan_code], ah
    mov [ascii_code], al

    cmp byte [scan_code], 01h
    je exit_program

    mov dx, scan_label
    call print_string
    mov al, [scan_code]
    call print_hex_byte

    mov dx, ascii_label
    call print_string
    mov al, [ascii_code]
    call print_hex_byte

    mov dx, line_end
    call print_string
    jmp read_key

exit_program:
    mov ax, 4C00h
    int 21h

print_hex_byte:
    mov [hex_value], al
    mov al, [hex_value]
    shr al, 4
    call print_hex_nibble
    mov al, [hex_value]
    and al, 0Fh
    call print_hex_nibble
    ret

print_hex_nibble:
    cmp al, 9
    jbe numeric_nibble
    add al, "A" - 10
    jmp write_nibble
numeric_nibble:
    add al, "0"
write_nibble:
    mov dl, al
    mov ah, 02h
    int 21h
    ret

print_string:
    mov ah, 09h
    int 21h
    ret

prompt db "Pulse una tecla (ESC para salir):", 0Dh, 0Ah, "$"
scan_label db "  Scan: $"
ascii_label db "  ASCII: $"
line_end db 0Dh, 0Ah, "$"
scan_code db 0
ascii_code db 0
hex_value db 0
