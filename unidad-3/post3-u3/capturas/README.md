# Capturas — Post-contenido Unidad 3

Las imágenes de esta carpeta se capturaron directamente desde las ventanas de DOSBox 0.74-3 mientras se ejecutaba FreeDOS DEBUG. Para que las trazas extensas sigan siendo legibles dentro de la pantalla de 25 filas, algunas secciones se documentan en varias imágenes consecutivas.

| Parte | Checkpoint | Archivo | Evidencia |
|---|---|---|---|
| 1 | 1 | `CP1_registros.png` | Estado inicial real (segmento `0724`) y cambio de AX a `1234`. |
| 1 | 2 | `CP2_volcado_memoria.png` | Relleno y volcado de 64 bytes con el patrón `AB CD EF`. |
| 1 | 3 | `CP3_ensamblado_desensamblado.png` | Ensamblado y desensamblado del programa de cuatro instrucciones. |
| 1 | 4 | `CP4_memoria_direccionamiento.png` | Memoria antes/después de `E`, instrucción `A1 00 03` y ejecución con AX=`5678`. |
| 2 | 1 | `CP1_traza_suma_inicio.png` | Inicio de la traza de suma, con registros e instrucciones siguientes. |
| 2 | 1 | `CP1_traza_suma.png` | Traza completa visible y resultado AX=`0012`. |
| 2 | 2 | `CP2_traza_loop_inicio.png` | Ensamblado y primeras iteraciones del bucle `LOOP`. |
| 2 | 2 | `CP2_traza_loop.png` | Iteraciones finales, CX=`0000` y AX=`0008`. |
| 2 | 3 | `CP3_traza_dec_jnz_inicio.png` | Ensamblado y primeras instrucciones de `DEC/JNZ`. |
| 2 | 3 | `CP3_traza_dec_jnz_medio.png` | Iteraciones intermedias de la traza. |
| 2 | 3 | `CP3_traza_dec_jnz.png` | Iteración final, CX=`0000`, AX=`0008` y terminación. |
| 2 | 3 | `CP3_verificacion_G.png` | Verificación adicional con `G 20C` y consulta de AX. |

La guía lista siete nombres de captura principales, aunque pide documentar trazas completas que exceden el alto de una pantalla de DEBUG. Los nombres adicionales conservan la secuencia completa sin montar ni editar salidas. El checkpoint 4 de la Parte 2 es el cierre del repositorio y no requiere una captura de DOSBox.

**Estado:** las capturas requeridas ya están realizadas. En esta máquina `DEBUG.COM` se obtuvo del paquete oficial [FreeDOS DEBUG 1.3](https://www.ibiblio.org/pub/micro/pc-stuff/freedos/files/repositories/1.3/base/debug.zip) y se copió en las carpetas DOSBox `C:\DOSWork\L3P1` y `C:\DOSWork\L3P2`.
