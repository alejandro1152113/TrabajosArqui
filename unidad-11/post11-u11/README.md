# Post-contenido - Procesadores gráficos GPU

**Arquitectura de Computadores · Unidad 11**  
**Estudiante:** González López  
**Repositorio:** [TrabajosArqui - post11-u11](https://github.com/alejandro1152113/TrabajosArqui/tree/main/unidad-11/post11-u11)  
**PDF:** [Gonzalez Lopez_Post11_U11.pdf](https://github.com/alejandro1152113/TrabajosArqui/blob/main/unidad-11/post11-u11/Gonzalez%20Lopez_Post11_U11.pdf)

## Entorno requerido

Se requiere Ubuntu 20.04/22.04 o WSL2, CUDA Toolkit 12.x, nvcc, nvidia-smi y una GPU compatible con compute capability 5.0 o superior. Sin GPU local se puede usar Google Colab con runtime GPU T4.

```bash
nvcc --version
nvidia-smi
./build.sh
```

Los fuentes están en `src/`, los ejecutables se generan en `bin/` y las capturas deben guardarse en `capturas/`.

## Parte 1 - CUDA

| Fuente | Objetivo |
|---|---|
| `src/vectorAdd.cu` | Suma de vectores en CPU y GPU con cudaEvent |
| `src/matMul.cu` | Multiplicación naïve y con tiling/shared memory |
| `src/vectorAddStream.cu` | H2D, kernel y D2H solapados con cuatro streams |

Resultados esperados: vectorAdd muestra `Errores: 0`; matMul debe verificar error menor que 1e-3; vectorAddStream debe reportar reducción medible frente a la versión síncrona.

## Decisión técnica 1 - Streams para vectorAdd

Para 16M elementos, los arreglos suman 192 MB: dos entradas de 64 MB y una salida de 64 MB. Sobre PCIe 4.0 x16 efectivo a 10–12 GB/s, la transferencia tarda aproximadamente 16–19 ms. El kernel medido en el laboratorio de referencia tarda 1.8 ms, por lo que vectorAdd es claramente memory-bound. Con streams perfecto, el cómputo máximo ocultable es aproximadamente 1.8 ms dentro de la transferencia, no la transferencia completa. El beneficio práctico en este caso es modesto y explica reducciones cercanas al 10%. En matMul, el cómputo por chunk puede superar o acercarse a la transferencia, por lo que el solapamiento tiene mayor impacto.

## Decisión técnica 2 - Número de streams

Cuatro streams son suficientes para iniciar varios chunks sin saturar los recursos físicos. Más streams no crean más ancho de banda ni copy engines: estos suelen ser uno o dos motores DMA capaces de H2D/D2H. Al aumentar de 4 a 16, se fragmenta el mismo volumen con más lanzamientos y context switches, produciendo rendimientos decrecientes. El ancho de banda PCIe permanece compartido. Dividir en streams reorganiza cuándo se mueve cada porción, pero no reduce el volumen ni elimina el límite físico del bus.

## Parte 2 - Análisis comparativo

La caracterización completa se encuentra en [`docs/analisis-comparativo.md`](docs/analisis-comparativo.md). Incluye GPU, TPU, NPU y FPGA, resultados de MLPerf, costo-rendimiento, TCO, perfiles de recomendación y cuantización INT8.

## Decisiones técnicas 3 y 4

El documento comparativo contiene las decisiones sobre GPU centralizada frente a FPGA distribuida para el Perfil B y sobre cuantización INT8 según el riesgo de falsos negativos.

## Evidencia pendiente

Como esta máquina no dispone de CUDA o GPU NVIDIA, no se deben presentar valores inventados. Las imágenes reales deben obtenerse con `nvidia-smi`, `nvcc`, `vectorAdd`, `matMul` y `vectorAddStream`, y colocarse en `capturas/`.
