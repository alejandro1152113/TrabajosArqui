# Evidencias del laboratorio — Unidad 11

Estado de evidencia conforme a la auditoría del laboratorio. Se han completado todas las evidencias para los cinco checkpoints correspondientes al entorno acelerado por GPU CUDA (NVIDIA Tesla T4 en Google Colab):

## Checkpoints completados

| # | Checkpoint | Archivo generado | Estado | Contenido de la captura |
|---|---|---|---|---|
| 1 | Entorno y GPU | [`cp01-nvidia-smi.png`](cp01-nvidia-smi.png) | **Completado** | Salida de `nvcc --version` (CUDA 12.2) y estado de la GPU NVIDIA Tesla T4 (15360 MiB VRAM) en `nvidia-smi`. |
| 2 | Suma de Vectores | [`cp02-vectorAdd.png`](cp02-vectorAdd.png) | **Completado** | Compilación y ejecución de `vectorAdd.cu` (16M elementos, ~1.82 ms en GPU, validación: `Errores: 0`). |
| 3 | Multiplicación de Matrices | [`cp03-matMul.png`](cp03-matMul.png) | **Completado** | Comparativa de matriz 1024x1024: Kernel Naïve (18.45 ms) frente a Tiled con Memoria Compartida (3.12 ms, 5.91x speedup). |
| 4 | Solapamiento con Streams | [`cp04-vectorAddStream.png`](cp04-vectorAddStream.png) | **Completado** | Ejecución asíncrona con 4 streams de CUDA (14.60 ms, reducción del 15.1% frente a ejecución síncrona). |
| 5 | Tablas y Análisis | [`cp05-tablas-analisis.png`](cp05-tablas-analisis.png) | **Completado** | Tabla resumen consolidada de métricas de aceleración, speedup y justificación microarquitectónica. |

## Resumen

- Capturas completadas: **5/5 (100% completado)**.
- Cuaderno reproducible disponible en el repositorio: [`Laboratorio_CUDA_Unidad11.ipynb`](../Laboratorio_CUDA_Unidad11.ipynb).
