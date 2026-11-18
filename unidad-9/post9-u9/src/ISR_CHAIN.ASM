; ISR_CHAIN.ASM - ISR propio para IRQ1 encadenado con el original
[BITS 16]
[ORG 0x100]

contador DW 0
old_isr DD 0
MAX_KEYS EQU 5
msg_fin DB 0Dh, 0Ah, "ISR encadenado restaurado. Fin del programa.$"

start:
    MOV AX, 3509h
    INT 21h
    MOV [old_isr], BX
    MOV [old_isr+2], ES

    PUSH DS
    MOV AX, CS
    MOV DS, AX
    MOV DX, mi_isr_chain
    MOV AX, 2509h
    INT 21h
    POP DS

    STI
.esperar:
    CMP WORD [contador], MAX_KEYS
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

mi_isr_chain:
    PUSH AX
    PUSH DX
    PUSH DS

    MOV AX, CS
    MOV DS, AX
    IN AL, 60h
    INC WORD [contador]

    POP DS
    POP DX
    POP AX

    PUSHF
    CALL FAR [old_isr]
    IRET
