# Evidencias del laboratorio — Unidad 10

Estado de evidencia conforme a la auditoría del laboratorio. Se han generado y validado las capturas individuales para cada uno de los cinco checkpoints con base en la ejecución real en Ubuntu/WSL2:

## Checkpoints completados

| # | Checkpoint | Archivo generado | Estado | Contenido de la captura |
|---|---|---|---|---|
| 1 | Topología y Acceso Secuencial | [`cp01-cache-secuencial.png`](cp01-cache-secuencial.png) | **Completado** | Topología L1/L2/L3 y tabla secuencial de `cache_bench` (4 KiB a 64 MiB, ~1.5 ns/B). |
| 2 | Acceso Aleatorio | [`cp02-cache-aleatorio.png`](cp02-cache-aleatorio.png) | **Completado** | Columna aleatoria con Fisher-Yates evidenciando saltos de latencia de L1 (~2 ns) a RAM (~30 ns). |
| 3 | Strides de Asociatividad | [`cp03-cache-strides.png`](cp03-cache-strides.png) | **Completado** | Comparativa de accesos stride 64 B vs 4096 B (conflicto de líneas de caché de 8 vías: +57.6% tiempo). |
| 4 | Mapas de Memoria Virtual | [`cp04-mymaps-proc.png`](cp04-mymaps-proc.png) | **Completado** | Ejecución de `mymaps` e inspección de segmentos (código, heap, stack, libc, vdso) en `/proc/PID/maps`. |
| 5 | Page Faults y Costo mmap | [`cp05-pagefault-cost.png`](cp05-pagefault-cost.png) | **Completado** | Demostración de demanda de páginas (100 MB RSS, 25676 faults) y costo de overhead (3311.2 ns por fault). |

## Resumen

- Capturas individuales completadas: 5/5.
- Captura de sesión acumulada: `evidencia-linux.png` (respaldo).
