; TECL.ASM - Lectura del scancode por polling sobre el puerto 64h
[BITS 16]
[ORG 0x100]

start:
.poll:
    IN AL, 64h
    TEST AL, 01h
    JZ .poll

    IN AL, 60h
    MOV BL, AL

    MOV AH, 02h
    MOV DL, BL
    SHR DL, 4
    ADD DL, 30h
    CMP DL, 3Ah
    JL .printH
    ADD DL, 07h
.printH:
    INT 21h

    MOV DL, BL
    AND DL, 0Fh
    ADD DL, 30h
    CMP DL, 3Ah
    JL .printL
    ADD DL, 07h
.printL:
    INT 21h

    MOV AH, 02h
    MOV DL, 0Dh
    INT 21h
    MOV DL, 0Ah
    INT 21h

    MOV AH, 4Ch
    INT 21h
