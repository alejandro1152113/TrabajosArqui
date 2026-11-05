bits 16
org 100h

%define VIDEO_SEGMENT 0B800h
%define SHIFT_CELL_OFFSET 12
%define CTRL_CELL_OFFSET 26
%define SHIFT_MASK 03h
%define CTRL_MASK 04h
%define SHIFT_ATTRIBUTE 0Ah
%define CTRL_ATTRIBUTE 0Ch

start:
    mov ax, VIDEO_SEGMENT
    mov es, ax

    mov di, 0
    mov si, shift_label
    mov cx, 6
    mov ah, 0Fh
    call write_label

    mov di, 16
    mov si, ctrl_label
    mov cx, 5
    mov ah, 0Fh
    call write_label

poll_status:
    ; AH=02h entrega el estado actual sin esperar una pulsacion.
    mov ah, 02h
    int 16h
    mov [keyboard_flags], al

    mov al, [keyboard_flags]
    and al, SHIFT_MASK
    mov cl, "0"
    jz write_shift
    mov cl, "1"
write_shift:
    mov di, SHIFT_CELL_OFFSET
    mov byte [es:di], cl
    mov byte [es:di+1], SHIFT_ATTRIBUTE

    mov al, [keyboard_flags]
    and al, CTRL_MASK
    mov cl, "0"
    jz write_ctrl
    mov cl, "1"
write_ctrl:
    mov di, CTRL_CELL_OFFSET
    mov byte [es:di], cl
    mov byte [es:di+1], CTRL_ATTRIBUTE

    ; La consulta no bloqueante detecta ESC para terminar.
    mov ah, 01h
    int 16h
    jz poll_status
    mov ah, 00h
    int 16h
    cmp ah, 01h
    jne poll_status

    mov ax, 4C00h
    int 21h

write_label:
    lodsb
    stosw
    loop write_label
    ret

shift_label db "SHIFT:"
ctrl_label db "CTRL:"
keyboard_flags db 0
