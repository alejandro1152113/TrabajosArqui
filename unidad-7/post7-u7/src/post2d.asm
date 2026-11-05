bits 16
org 100h

%define VIDEO_SEGMENT 0B800h
%define EDIT_ROW 12
%define EDIT_ROW_OFFSET (EDIT_ROW * 80 * 2)
%define TEXT_ATTRIBUTE 0Fh
%define ERASE_ATTRIBUTE 07h

start:
    mov ax, VIDEO_SEGMENT
    mov es, ax

    ; Limpiar la linea de edicion antes de comenzar.
    mov di, EDIT_ROW_OFFSET
    mov ax, 0720h
    mov cx, 80
    cld
    rep stosw
    mov byte [cursor_column], 0

read_key:
    mov ah, 00h
    int 16h

    cmp al, 0Dh
    je exit_program
    cmp al, 08h
    je backspace
    or al, al
    jz read_key
    cmp al, 20h
    jb read_key
    cmp al, 7Eh
    ja read_key

    cmp byte [cursor_column], 80
    jae read_key
    mov [current_character], al
    call get_cell_offset
    mov al, [current_character]
    mov ah, TEXT_ATTRIBUTE
    mov [es:di], ax
    inc byte [cursor_column]
    jmp read_key

backspace:
    cmp byte [cursor_column], 0
    je read_key
    dec byte [cursor_column]
    call get_cell_offset
    mov ax, (ERASE_ATTRIBUTE << 8) | 20h
    mov [es:di], ax
    jmp read_key

get_cell_offset:
    xor ax, ax
    mov al, [cursor_column]
    shl ax, 1
    add ax, EDIT_ROW_OFFSET
    mov di, ax
    ret

exit_program:
    mov ax, 4C00h
    int 21h

cursor_column db 0
current_character db 0
