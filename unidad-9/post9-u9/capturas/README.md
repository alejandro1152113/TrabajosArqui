# Evidencias del laboratorio — Unidad 9

Estado de evidencia conforme a la auditoría del laboratorio. Se han completado las capturas individuales para los 8 checkpoints requeridos:

## Parte 1 — Puertos y Polling

| Programa | Checkpoint | Archivo generado | Estado | Comportamiento verificado |
|---|---|---|---|---|
| `TECL.com` | CP01 - Lectura scancode | [`cp01-tecl-scancode.png`](cp01-tecl-scancode.png) | **Completado** | Lectura exitosa de scancode 1Eh (tecla 'A') en puerto 60h y salida limpia al prompt. |
| `POLL_T.com` | CP02 - Polling con timeout | [`cp02-poll-timeout.png`](cp02-poll-timeout.png) | **Completado** | Agotamiento del contador `MAX_RETRY = 50000` y detección de timeout sin colgar la CPU. |
| `LPTTEST.com` | CP03 - Puerto paralelo LPT1 | [`cp03-lpt-port.png`](cp03-lpt-port.png) | **Completado** | Inspección del registro de estado (0379h: 7Fh), escritura de 'A' y pulso STROBE sin bloqueo. |
| `MULTI_ST.com` | CP04 - Banderas combinadas OR | [`cp04-multi-status.png`](cp04-multi-status.png) | **Completado** | Evaluación de teclado y LPT1 mediante operador OR terminando al detectar periférico listo. |

## Parte 2 — PIC 8259A e ISR

| Programa | Checkpoint | Archivo generado | Estado | Comportamiento verificado |
|---|---|---|---|---|
| `ISR_KB.com` | CP05 - Manejador propio IRQ1 | [`cp05-isr-keyboard.png`](cp05-isr-keyboard.png) | **Completado** | Intercepción de 5 pulsaciones por el manejador propio y restauración del vector INT 09h original. |
| `MASK_KB.com` | CP06 - Enmascaramiento IMR | [`cp06-mask-keyboard.png`](cp06-mask-keyboard.png) | **Completado** | Modificación del registro IMR del PIC durante 3 segundos con teclado físicamente inhibido. |
| `ISR_CHAIN.com` | CP07 - Encadenamiento ISR | [`cp07-isr-chain.png`](cp07-isr-chain.png) | **Completado** | Conteo de teclas en rutina propia y salto inmediato hacia el manejador original del BIOS. |
| `ISR_TIME.com` | CP08 - Medición de ticks BIOS | [`cp08-isr-time-ticks.png`](cp08-isr-time-ticks.png) | **Completado** | Lectura del área de datos del BIOS (`0040h:006Ch`) y cálculo de deltas de tiempo (~18.2 Hz). |

## Resumen

- Capturas completadas: **8/8 (100% completado)**.
- `evidencia-dosbox-sesion.png` se conserva como referencia histórica de la sesión inicial.
