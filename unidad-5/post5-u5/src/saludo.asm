bits 16
org 100h

    mov dx, mensaje
    mov ah, 09h
    int 21h

    mov ax, 4C00h
    int 21h

mensaje db 'Laboratorio DOSBox y NASM', 13, 10
        db 'Estudiante: Gonzalez Lopez', 13, 10
        db 'Unidad 5 - Arquitectura de Computadores', 13, 10, '$'
