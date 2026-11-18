; ISR_KB.ASM - ISR propio para IRQ1
[BITS 16]
[ORG 0x100]

contador DW 0
MAX_KEYS EQU 5
old_isr  DD 0
msg_tecla DB 0Dh, 0Ah, "Tecla detectada por ISR propio$"
msg_fin   DB 0Dh, 0Ah, "ISR restaurado. Fin del programa.$"

start:
    MOV AX, 3509h
    INT 21h
    MOV [old_isr], BX
    MOV [old_isr+2], ES

    PUSH DS
    MOV AX, CS
    MOV DS, AX
    MOV DX, mi_isr
    MOV AX, 2509h
    INT 21h
    POP DS

    STI
.esperar:
    MOV AX, [contador]
    CMP AX, MAX_KEYS
    JL .esperar

    CLI
    LDS DX, [old_isr]
    MOV AX, 2509h
    INT 21h
    STI

    MOV AH, 09h
    MOV DX, msg_fin
    INT 21h
    MOV AH, 4Ch
    INT 21h

mi_isr:
    PUSH AX
    PUSH DX
    PUSH DS

    MOV AX, CS
    MOV DS, AX
    IN AL, 60h

    MOV AH, 09h
    MOV DX, msg_tecla
    INT 21h

    INC WORD [contador]

    MOV AL, 20h
    OUT 20h, AL

    POP DS
    POP DX
    POP AX
    IRET
