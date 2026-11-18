; LPT1_PORT.ASM - Escritura de un caracter al puerto paralelo
[BITS 16]
[ORG 0x100]

DATA_PORT   EQU 0378h
STATUS_PORT EQU 0379h
CTRL_PORT   EQU 037Ah

start:
.wait_ready:
    MOV DX, STATUS_PORT
    IN AL, DX
    TEST AL, 80h
    JZ .wait_ready

    MOV AL, 41h
    MOV DX, DATA_PORT
    OUT DX, AL

    MOV DX, CTRL_PORT
    IN AL, DX
    AND AL, 0FEh
    OUT DX, AL

    MOV CX, 0Fh
.delay:
    LOOP .delay

    OR AL, 01h
    OUT DX, AL

    MOV AH, 4Ch
    INT 21h
