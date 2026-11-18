# Evidencias del laboratorio — Unidad 7

Estado de evidencia conforme a la auditoría del laboratorio. Se han integrado y verificado todas las capturas tanto de la ejecución de programas en DOSBox como de las decisiones técnicas documentadas:

## Parte 1 — INT 21h e INT 10h

| Checkpoint | Archivo | Estado | Descripción |
|---|---|---|---|
| P1-1 | [`p1-cp1-salida-int21.png`](p1-cp1-salida-int21.png) | **Completado** | Salida de encabezado con INT 21h / AH=09h (`post1.com`) |
| P1-2 | [`p1-cp2-cursor-color.png`](p1-cp2-cursor-color.png) | **Completado** | Salida con atributos de color y cursor en INT 10h (`post1b.com`) |
| P1-3 | [`p1-cp3-cadena-posicionada.png`](p1-cp3-cadena-posicionada.png) | **Completado** | Cadena centrada con INT 10h / AH=02h y 09h (`post1c.com`) |
| P1-4 | [`p1-cp4-modo-y-relectura.png`](p1-cp4-modo-y-relectura.png) | **Completado** | Consulta de modo de video (AH=0Fh) y relectura (AH=08h) (`post1d.com`) |
| P1-5 | [`p1-cp5-decision-int21-int10.png`](p1-cp5-decision-int21-int10.png) | **Completado** | Decisión técnica: ¿Por qué no usar siempre INT 21h/AH=09h? |

## Parte 2 — INT 16h y memoria de video B800h

| Checkpoint | Archivo | Estado | Descripción |
|---|---|---|---|
| P2-1 | [`p2-cp1-scan-ascii.png`](p2-cp1-scan-ascii.png) | **Completado** | Lectura de teclado con scan codes y ASCII (`post2a.com`) |
| P2-2 | [`p2-cp2-escritura-b800.png`](p2-cp2-escritura-b800.png) | **Completado** | Escritura directa en memoria de video `ES:B800h` (`post2b.com`) |
| P2-3 | [`p2-cp3-rep-stosw.png`](p2-cp3-rep-stosw.png) | **Completado** | Llenado de pantalla mediante `REP STOSW` (`post2c.com`) |
| P2-4 | [`p2-cp4-mini-editor.png`](p2-cp4-mini-editor.png) | **Completado** | Mini-editor interactivo en pantalla (`post2d.com`) |
| P2-5 | [`p2-cp5-shift-ctrl.png`](p2-cp5-shift-ctrl.png) | **Completado** | Detección continua de Shift y Ctrl con AH=02h (`post2e.com`) |
| P2-6 | [`p2-cp6-decision-int16-puerto60.png`](p2-cp6-decision-int16-puerto60.png) | **Completado** | Decisión técnica: INT 16h bloqueante frente a lectura directa del puerto 60h |
| P2-7 | [`p2-cp7-decision-estado-scan-codes.png`](p2-cp7-decision-estado-scan-codes.png) | **Completado** | Decisión técnica: Consulta de estado (AH=02h) frente a rastreo make/break |

## Resumen

- Capturas de ejecución en DOSBox: 9/9 completadas.
- Capturas de decisiones técnicas: 3/3 completadas.
- Estado general Unidad 7: **12/12 (100% completo)**.
