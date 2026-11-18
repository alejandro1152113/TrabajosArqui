; MASK_KB.ASM - Enmascarar y desenmascarar IRQ1
[BITS 16]
[ORG 0x100]

msg_mask   DB "IRQ1 enmascarado (teclado deshabilitado)...$"
msg_unmask DB 0Dh, 0Ah, "IRQ1 restaurado.$"

start:
    IN AL, 21h
    PUSH AX
    OR AL, 02h
    OUT 21h, AL

    MOV AH, 09h
    MOV DX, msg_mask
    INT 21h

    MOV AH, 00h
    INT 1Ah
    MOV BX, DX
    ADD BX, 55
.wait:
    MOV AH, 00h
    INT 1Ah
    CMP DX, BX
    JL .wait

    POP AX
    OUT 21h, AL

    MOV AH, 09h
    MOV DX, msg_unmask
    INT 21h
    MOV AH, 4Ch
    INT 21h
