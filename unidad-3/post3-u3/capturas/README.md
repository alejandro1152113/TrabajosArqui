# Capturas — Post-contenido Unidad 3

Las capturas deben ser imágenes reales de la sesión de DOSBox con DEBUG; no se sustituyen con salidas recreadas o ilustrativas. En este espacio se deben guardar los siguientes siete archivos con los nombres indicados por la guía:

| Parte | Checkpoint | Archivo esperado | Debe mostrar |
|---|---|---|---|
| 1 | 1 | `CP1_registros.png` | `R`, estado de registros y modificación/verificación de AX. |
| 1 | 2 | `CP2_volcado_memoria.png` | `D 200 L40` con el patrón `AB CD EF` en cuatro filas. |
| 1 | 3 | `CP3_ensamblado_desensamblado.png` | Comandos `A` y `U`, con las cuatro instrucciones y sus bytes. |
| 1 | 4 | `CP4_memoria_direccionamiento.png` | Inicialización con `F`, volcados antes/después de `E`, desensamblado y `T` con AX=`5678`. |
| 2 | 1 | `CP1_traza_suma.png` | Programa de suma trazado y resultado AX=`0012`. |
| 2 | 2 | `CP2_traza_loop.png` | Traza completa de `LOOP`, con AX=`0008` y CX=`0000`. |
| 2 | 3 | `CP3_traza_dec_jnz.png` | Traza `DEC/JNZ` y verificación con `G 20C`, AX=`0008`. |

La guía denomina ocho checkpoints al incluir el checkpoint 4 de cierre del repositorio, pero enumera siete archivos de captura. El cierre del repositorio no requiere una captura adicional en la lista de nombres proporcionada.

**Estado actual:** las siete capturas están pendientes de obtener en una sesión real de DOSBox/DEBUG. DOSBox está instalado, pero DEBUG no está incluido con esa instalación.
