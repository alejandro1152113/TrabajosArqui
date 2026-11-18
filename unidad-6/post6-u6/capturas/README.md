# Evidencias del laboratorio — Unidad 6

Estado de evidencia conforme a la auditoría del laboratorio. Se han completado y verificado las 11 capturas individuales correspondientes a cada uno de los checkpoints de DOSBox/DEBUG:

| # | Checkpoint | Archivo generado | Estado | Contenido de la captura |
|---|---|---|---|---|
| 1 | Compilación | [`cp01-compilacion.png`](cp01-compilacion.png) | **Completado** | Ensamblado sin errores de `lab6_instrucciones.asm`, `lab6_modos.asm` y `lab6_factorial.asm`. |
| 2 | Registros y flags | [`cp02-trazado-flags.png`](cp02-trazado-flags.png) | **Completado** | Trazado con DEBUG de `ADD AX, [valor_b]`, actualización de flags (NV, PL, NZ, NC) y volcado. |
| 3 | Suma con LOOP | [`cp03-loop-ax-000f.png`](cp03-loop-ax-000f.png) | **Completado** | Estado de registros con `AX=000Fh` (15 dec) y `CX=0000h` al terminar el bucle `LOOP`. |
| 4 | Rotación de bits | [`cp04-rotacion-bits.png`](cp04-rotacion-bits.png) | **Completado** | Bloque de rotaciones: `BL=02h` (SHL), `CL=03h` (ROL), `DL=40h` (SHR), `BH=C0h` (ROR) y `AL=5Ah` (ROL 4). |
| 5 | Factorial | [`cp05-factorial-120.png`](cp05-factorial-120.png) | **Completado** | Ejecución de `lab6_factorial.com` y verificación con DEBUG de `AX=0078h` (120 dec). |
| 6 | Volcado de array | [`cp06-array-endian.png`](cp06-array-endian.png) | **Completado** | Volcado de memoria con `-d` mostrando disposición little-endian (ej. `0A 00`, `14 00`, `1E 00`). |
| 7 | Direccionamiento SI | [`cp07-indirecto-si.png`](cp07-indirecto-si.png) | **Completado** | Acceso indirecto mediante puntero SI con lectura de `nota1`: `AX=0055h` (85 dec). |
| 8 | Recorrido ascendente | [`cp08-ascendente-ax-0096.png`](cp08-ascendente-ax-0096.png) | **Completado** | Acumulación ascendente del array finalizando en `AX=0096h` (150 dec) con `SI=000Ah`. |
| 9 | Recorrido inverso | [`cp09-inverso-ax-0096.png`](cp09-inverso-ax-0096.png) | **Completado** | Acumulación en sentido descendente con decrementos `SUB SI, 2` finalizando en `AX=0096h`. |
| 10 | Marco BP / Pila | [`cp10-marco-bp.png`](cp10-marco-bp.png) | **Completado** | Marco de activación en pila con variables locales: `[BP-2]=63h`, `[BP-4]=FAh`, `SP` antes/después y `AX=015Dh`. |
| 11 | Matriz bidimensional | [`cp11-matriz-2d.png`](cp11-matriz-2d.png) | **Completado** | Cálculo de offset `SI=000Ah` y lectura del elemento `matriz[1][2]`: `DX=0006h`. |

## Resumen

- Capturas completadas: **11/11 (100% completado)**.
- `evidencia-dosbox-sesion.png` se conserva como referencia histórica.
