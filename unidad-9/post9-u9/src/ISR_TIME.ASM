; ISR_TIME.ASM - Intervalo de IRQ1 usando el tick BIOS
[BITS 16]
[ORG 0x100]

old_isr   DD 0
ticks_prev DW 0
contador DW 0
MAX_KEYS EQU 5
msg_ticks DB 0Dh, 0Ah, "Ticks desde la interrupcion anterior: $"
msg_fin   DB 0Dh, 0Ah, "ISR_TIME restaurado. Fin del programa.$"

start:
    MOV AX, 3509h
    INT 21h
    MOV [old_isr], BX
    MOV [old_isr+2], ES

    PUSH ES
    MOV AX, 40h
    MOV ES, AX
    MOV AX, [ES:6Ch]
    MOV [ticks_prev], AX
    POP ES

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
    PUSH BX
    PUSH DX
    PUSH DS
    PUSH ES

    MOV AX, CS
    MOV DS, AX
    IN AL, 60h

    MOV AX, 40h
    MOV ES, AX
    MOV AX, [ES:6Ch]
    MOV BX, AX
    SUB BX, [ticks_prev]
    MOV [ticks_prev], AX

    MOV AL, 20h
    OUT 20h, AL

    MOV AH, 09h
    MOV DX, msg_ticks
    INT 21h

    MOV AX, BX
    CALL imprimir_decimal
    INC WORD [contador]

    POP ES
    POP DS
    POP DX
    POP BX
    POP AX
    IRET

imprimir_decimal:
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    MOV BX, 10
    XOR CX, CX
.divide:
    XOR DX, DX
    DIV BX
    PUSH DX
    INC CX
    TEST AX, AX
    JNZ .divide
.imprimir:
    POP DX
    ADD DL, 30h
    MOV AH, 02h
    INT 21h
    LOOP .imprimir
    POP DX
    POP CX
    POP BX
    POP AX
    RET
