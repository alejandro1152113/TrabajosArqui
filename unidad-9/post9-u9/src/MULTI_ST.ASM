; MULTI_ST.ASM - Polling combinado de teclado y puerto paralelo
[BITS 16]
[ORG 0x100]

STATUS_PORT EQU 0379h

start:
.poll:
    IN AL, 64h
    AND AL, 01h
    MOV BL, AL

    MOV DX, STATUS_PORT
    IN AL, DX
    AND AL, 80h
    SHR AL, 7
    MOV BH, AL

    MOV AL, BL
    OR AL, BH
    JZ .poll

    TEST BL, BL
    JZ .solo_lpt1
    MOV AH, 09h
    MOV DX, msg_tecl
    INT 21h
.solo_lpt1:
    TEST BH, BH
    JZ .fin
    MOV AH, 09h
    MOV DX, msg_lpt1
    INT 21h
.fin:
    MOV AH, 4Ch
    INT 21h

msg_tecl DB "Teclado listo (OBF=1).", 0Dh, 0Ah, "$"
msg_lpt1 DB "LPT1 listo (BUSY#=1).", 0Dh, 0Ah, "$"
