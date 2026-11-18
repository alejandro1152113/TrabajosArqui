# Post-contenido - Memorias del computador

**Arquitectura de Computadores · Unidad 10**  
**Estudiante:** González López  
**Repositorio:** [TrabajosArqui - post10-u10](https://github.com/alejandro1152113/TrabajosArqui/tree/main/unidad-10/post10-u10)  
**PDF:** [Gonzalez Lopez_Post10_U10.pdf](https://github.com/alejandro1152113/TrabajosArqui/blob/main/unidad-10/post10-u10/Gonzalez%20Lopez_Post10_U10.pdf)

## Entorno

El laboratorio requiere Linux, gcc 9 o superior y acceso a `/sys/devices/system/cpu`, `/proc` y herramientas como `perf`, `time`, `pmap`, `vmstat` y `free`.

```bash
chmod +x build.sh
./build.sh
```

Los programas fuente están en `src/` y los ejecutables en `bin/`.

## Resultado real de validación

La sesión de Ubuntu mostró L1d = 32 KB, L2 = 512 KB y L3 = 4096 KB. El benchmark produjo:

| Array | Secuencial ns/byte | Aleatorio ns/acceso |
|---:|---:|---:|
| 4 KiB | 1.558 | 2.358 |
| 32 KiB | 1.851 | 2.091 |
| 256 KiB | 1.653 | 2.525 |
| 512 KiB | 1.601 | 3.780 |
| 1024 KiB | 2.143 | 3.994 |
| 4096 KiB | 1.498 | 21.166 |
| 65536 KiB | 1.417 | 30.331 |

La comparativa de stride fue 4.354 ns/acceso para 64 B y 6.863 ns/acceso para 4096 B. El patrón aleatorio creció notablemente al superar las cachés. La medición de un fault individual produjo 3344.1 ns en el primer toque, 32.9 ns en el segundo toque y 3311.2 ns de overhead. La prueba agregada pasó de 1760 KB a 104160 KB de VmRSS y reportó 25676 minor faults.

## Parte 1 - Benchmark de caché

| Programa | Experimento | Resultado esperado |
|---|---|---|
| `cache_bench.c` | Acceso secuencial por tamaños de array | Saltos al superar L1, L2, L3 y RAM |
| `cache_bench.c` | Acceso aleatorio con Fisher-Yates | Penalización mayor por caché y posible presión sobre TLB |
| `cache_bench.c` | Strides de 64 B y 4096 B | Los 4096 B generan más conflictos de asociatividad |

La topología se consulta con:

```bash
for i in 0 1 2 3; do
  cat /sys/devices/system/cpu/cpu0/cache/index$i/size 2>/dev/null
done
```

## Parte 2 - Memoria virtual

| Programa | Experimento | Resultado esperado |
|---|---|---|
| `mymaps.c` | Inspección de `/proc/PID/maps` | Texto, datos, heap, libc, stack y vDSO |
| `pagefault_demo.c` | Crecimiento agregado de RSS | VmRSS crece hasta aproximadamente 100 MB |
| `mmap_fault_cost.c` | Costo de primer y segundo toque | El primer toque presenta overhead de minor fault |

## Decisión técnica 1 - Stride de asociatividad

Para una L1 de 32 KB con 8 vías y líneas de 64 B existen 64 sets. El stride que maximiza los conflictos es el tamaño total dividido entre el número de vías: 32 KB/8 = 4096 B. Coincide con una página, pero su importancia viene de que el set queda determinado por unos bits específicos de la dirección y el stride fija esos bits. Un stride de 2048 B recorrería dos sets alternados. Las páginas de 1 MB producirían muchas direcciones que compiten por cada set. Desde el noveno acceso dentro de un mismo set, una línea nueva debe reemplazar una existente si se alcanzó la asociatividad. El rendimiento se acerca a niveles superiores a L1, mientras que el stride de 64 B conserva localidad secuencial y visita líneas distintas.

## Decisión técnica 2 - Prefetch por software

El flag `-fno-prefetch-loop-arrays` solamente impide que gcc inserte instrucciones de prefetch por software. No modifica el prefetcher de hardware. El patrón secuencial sería el más sensible a comparar `-fprefetch-loop-arrays` contra `-fno-prefetch-loop-arrays`, porque el compilador puede anticipar líneas futuras. El patrón aleatorio es insensible, pues Fisher-Yates no permite anticipar direcciones. El stride de 4096 B también sería insensible a insertar prefetch útil porque está diseñado para causar conflictos. Comparar ambos flags solo mide prefetch por software. Deshabilitar el prefetch de hardware requiere MSR, BIOS o herramientas específicas.

## Decisión técnica 3 - smaps frente a pmap

`pmap -x` sí reporta el RSS por región y ofrece una vista práctica para terminal. Sin embargo, no separa claramente las clasificaciones Private_Dirty y Shared_Clean ni muestra Referenced con el detalle de smaps. Leer smaps completo tiene más costo por su volumen de campos. En monitoreo periódico de alta frecuencia conviene usar pmap o resúmenes agregados. En una inspección rápida, pmap ofrece una tabla legible sin filtrar manualmente. Smaps es preferible cuando se requiere distinguir qué páginas son privadas, compartidas, limpias o modificadas región por región.

## Decisión técnica 4 - MAP_POPULATE frente a demand paging

Con `MAP_POPULATE`, el kernel prepara todas las páginas físicas durante la llamada a mmap. Los primeros toques medirían tiempos cercanos al segundo toque, porque ya no existiría minor fault. Esta opción conviene a servidores que requieren latencia baja y predecible por petición, o cargas que usarán todo el rango inmediatamente. Demand paging no gasta marcos físicos ni tiempo en páginas no utilizadas. Si se reserva 100 MB y solo se toca 10 MB, el kernel evita asignar los otros 90 MB; MAP_POPULATE sí los asignaría por adelantado y podría desperdiciar RAM.

## Capturas y validación

Las capturas auténticas se deben colocar en `capturas/`. Los resultados deben obtenerse en Linux y no pueden reemplazarse con valores sintéticos.
