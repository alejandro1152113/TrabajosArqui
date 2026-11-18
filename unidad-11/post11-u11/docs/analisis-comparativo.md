# Análisis comparativo de aceleradores de IA

**Arquitectura de Computadores · Unidad 11**  
**Autor:** González López

## Introducción

Las cargas modernas de inteligencia artificial combinan entrenamiento intensivo en operaciones tensoriales, inferencia con restricciones de latencia y despliegues con presupuesto energético limitado. Una GPU no es automáticamente superior a una TPU, NPU o FPGA. La elección depende de precisión, lote, modelo, topología de memoria, costo de software y garantías de respuesta. Este documento compara GPU, TPU, NPU y FPGA usando datos oficiales de NVIDIA, Google, Apple, Qualcomm, MLCommons y MLPerf.

## 1. Caracterización arquitectónica

| Acelerador | Paradigma | Unidad principal | Memoria y precisión | Programación | Uso principal |
|---|---|---|---|---|---|
| NVIDIA H100 | SIMT masivo | CUDA Cores y Tensor Cores | HBM3, hasta 80 GB; FP32/FP16/BF16/INT8/INT4 | CUDA, cuDNN, TensorRT | Entrenamiento e inferencia general |
| Google TPU v5 | Array sistólico | MXU 128×128 | HBM, BF16/INT8 | JAX, TensorFlow, XLA | Entrenamiento e inferencia por lote |
| Apple M3 / M3 Ultra | Arquitectura unificada con NPU | Neural Engine de 18 núcleos | Memoria unificada LPDDR | Core ML, Metal, BNNS | Inferencia on-device |
| Xilinx/AMD Alveo U55C | Reconfigurable | LUT, DSP y BRAM | HBM y memoria local | Vitis HLS, VHDL/Verilog | Inferencia determinística y carga baja latencia |

La GPU conserva ejecución por warps de 32 hilos, memoria global, shared memory y Tensor Cores que aceleran multiplicaciones matriciales. Su fortaleza es la flexibilidad y el ecosistema de CUDA. La TPU organiza la multiplicación mediante una matriz de unidades de procesamiento que producen resultados sincronizados como un array sistólico. Sacrifica flexibilidad frente a GEMM y redes de alta regularidad, pero entrega buen throughput por vatio en TensorFlow/JAX. La NPU usa dataflow fijo y memoria unificada para ejecutar inferencia con consumo inferior a 5 W. Su principal límite es la exportación del modelo y la precisión soportada. La FPGA puede configurar caminos de datos e interconexiones alrededor del modelo. Produce latencia determinística, pero requiere mayor trabajo de ingeniería y herramientas de síntesis.

## 2. Benchmarks MLPerf

MLCommons informa resultados de MLPerf Inference separados por categoría, sistema, precisión, escenario y tamaño de lote. Los números no son directamente comparables si difieren en server/offline y si usan FP16, BF16 o INT8. Por ello deben consultarse las submissions oficiales y no combinar resultados de escenarios distintos.

| Modelo | Relevancia | Criterio a consultar en MLPerf | Ventaja arquitectónica esperada |
|---|---|---|---|
| ResNet-50 v1.5 | Clasificación de imágenes | Samples/s en Offline/Server, precisión 99% FP32 | GPU o TPU para lote medio/alto; FPGA en latencia baja |
| BERT-Large SQuAD | NLP | Latencia p99, throughput, precisión 99.9% FP32 | GPU flexible y TPU optimizada para GEMM |
| Stable Diffusion XL | Generación de imágenes | Samples/s y latencia, precisión de referencia | GPU con Tensor Cores, memoria HBM y difusión optimizada |

En MLPerf Inference v4.1, NVIDIA publicó resultados de sistemas H100 para inferencia y MLCommons muestra submissions verificables para modelos específicos. Google publicó resultados de TPU para cargas compatibles con XLA. Apple y Qualcomm suelen aportar datos orientados a dispositivos edge o previews que no se pueden mezclar con submissions de centros de datos.

Las cifras reales, por ejemplo throughput y latencia p99, deben extraerse de las submissions oficiales porque cambian con firmware, software, lote y precisión. Como referencia de caracterización, H100 ofrece hasta 80 GB de HBM3 y Tensor Cores para FP16/BF16/INT8; TPU v4 reporta 275 TFLOPS BF16 con 175 W TDP; M3 Ultra integra CPU, GPU y Neural Engine con memoria unificada; Qualcomm Snapdragon 8 Gen 3 entrega hasta 73 TOPS de cómputo IA publicado por el fabricante. Estos datos ayudan a explicar las razones arquitectónicas sin presentar cifras de benchmark estimadas como mediciones reales.

La GPU suele liderar cuando hay soporte amplio de kernels, precisión mixta y lotes grandes. La TPU puede liderar en throughput por modelo y entrenamiento sistólico. La NPU lidera en consumo por operación dentro de dispositivos. La FPGA lidera en latencia máxima estable y control fino de flujo de datos.

## 3. Costo-rendimiento y TCO

Para un servidor con una H100, el costo aproximado de adquisición es 30,000 USD. Una TPU v4 Pod no se adquiere normalmente por unidad física; Google Cloud puede facturar aproximadamente 32 USD/hora según tipo de reserva. Un Alveo U55C puede tener un costo cercano a 8,000 USD por tarjeta y un Mac Studio con M3 Ultra puede alcanzar aproximadamente 4,000 USD. Los precios varían por región, contrato y disponibilidad.

En el escenario de una startup con menos de 100 solicitudes por segundo, alquilar GPU o TPU reduce la inversión inicial. Una GPU es más conveniente si el software usa operadores que no están optimizados en TPU. Una TPU puede ser más económica si el workload es TensorFlow/JAX, estable y se ejecuta durante períodos largos. Para un proveedor de inferencia variable, los precios por hora facilitan apagar capacidad cuando la demanda baja.

En el escenario de borde, una NPU integrada consume menos energía y evita el coste de una GPU discreta. Una NPU es apropiada para smartphones y cámaras con modelo fijo, alimentación limitada y lotes pequeños. Una FPGA puede justificar su coste si el presupuesto exige menos de 1 ms y necesita un canal de procesamiento por cámara. Una GPU discreta puede ser razonable en un nodo industrial central con varias cámaras, redundancia y software TensorRT.

Un TCO aproximado a tres años incluye adquisición o alquiler, energía, refrigeración, redes, mantenimiento y desarrollo. Para una GPU de 400 W y 24 horas/día, el consumo es 0.4 kW × 24 × 365 × 3 ≈ 10.5 MWh. A 0.15 USD/kWh, la energía directa costaría aproximadamente 1,575 USD. Esta cifra no incluye PUE, por lo que el centro puede pagar más. Un FPGA puede tener menor consumo, pero el costo de HDL/HLS y mantenimiento de versiones puede elevar TCO.

## 4. Recomendaciones por perfil

**Perfil A: laboratorio universitario con presupuesto de 10,000 USD.** Se recomienda una GPU central o estación con RTX 4090/A6000 equivalente a este presupuesto. CUDA permite experimentar con visión y NLP hasta 7B parámetros, TensorRT y cuBLAS aceleran prototipos, y la comunidad ofrece frameworks maduros. La limitación es la VRAM y el costo de modelos grandes. Si el modelo no cabe, puede dividirse o usarse cuantización.

**Perfil B: manufactura con 50 líneas y latencia menor a 5 ms.** Para control de calidad no crítico para la seguridad, una H100 centralizada podría atender 500 imágenes por segundo y ahorrar capital frente a 50 FPGA. Para rechazo con implicaciones de seguridad, una FPGA por línea es preferible por latencia máxima determinística. La limitación de la FPGA es la programación especializada y el costo aproximado de 400,000 USD por 50 tarjetas.

**Perfil C: nube con modelos de 70B parámetros y 512 aceleradores.** Se recomienda H100 o TPU v5 según ecosistema y comunicación colectiva. La H100 ofrece portabilidad entre CUDA y frameworks. La TPU ofrece eficiencia sistólica y redes de alto rendimiento dentro de Google Cloud. Ambas opciones requieren medidas de interconexión, tolerancia a fallos y checkpoints. Ninguna opción elimina el costo de replicar modelos o mover activaciones.

## 5. Cuantización INT8

La tabla siguiente resume el patrón indicado por las guías NVIDIA y MLPerf:

| Precisión | Throughput relativo | Referencia | Exactitud |
|---|---:|---|---|
| FP32 | 1× | ResNet-50 v1.5 | 76.46% top-1 |
| FP16/BF16 Tensor Core | referencia interna ~1× frente a INT8 | ResNet-50 v1.5 | ≈76.4% top-1 |
| INT8 calibrado Tensor Core | ≈2× frente a FP16/BF16 | ResNet-50 v1.5 | 75.7–76.1% top-1 |
| INT8 calibrado Tensor Core | ≈2× frente a FP16/BF16 | BERT-Large | F1 ≈90.0–90.8 |

MLPerf exige al menos 99% de la exactitud FP32 para muchos modelos y 99.9% para modelos sensibles como BERT-Large. La cuantización directa sin calibración puede causar una caída mucho mayor porque los 256 estados INT8 deben representar un rango dinámico FP32 no uniforme. Deben usarse post-training quantization con datos representativos o quantization-aware training.

## 6. Decisión técnica: GPU o FPGA para el Perfil B

Una GPU H100 centralizada puede ejecutar un modelo ligero de detección de defectos en aproximadamente 1–2 ms por imagen con TensorRT. A 500 imágenes por segundo, una GPU procesa un volumen muy inferior a su capacidad teórica, por lo que el ancho de banda agregado no parece restrictivo. Incluso con encolamiento moderado, puede cumplir <5 ms promedio. Sin embargo, un solo servidor representa un punto único de falla y el jitter puede aumentar la cola.

El costo de adquisición de una GPU H100, aproximadamente 30,000 USD, es muy menor que 50 FPGA U55C a 8,000 USD cada una. Para control de calidad no crítico para la seguridad, conviene GPU central con redundancia o dos servidores por carga. Si la función puede detener maquinaria o poner en riesgo personas, la garantía determinística de FPGA distribuidas vale la diferencia de costo. La FPGA elimina variación de sistema operativo y drivers del camino crítico.

## 7. Decisión técnica: cuantización INT8

Cuantizar el modelo de inspección visual a INT8 puede duplicar el throughput frente a FP16/BF16 y liberar headroom ante expansión. Si ya cumple 5 ms, ese margen no es únicamente velocidad: permite aumentar lotes, margenes de carga o reducir hardware. Sin embargo, el top-1 general no prueba el comportamiento de una clase minoritaria de defectos. Debe medirse precisión y recall de esa clase, matriz de confusión y falso negativo por tipo de defecto.

La cuantización debe recomendarse solamente después de una validación representativa. Dado que un falso negativo puede ser más costoso que una revisión manual, el recall de defectos no debe degradarse significativamente. Si cumple la restricción MLPerf y las pruebas específicas, INT8 ofrece el mejor balance.

## Conclusión

GPU es la plataforma general más flexible y adecuada al laboratorio. TPU es eficiente en cargas sistólicas y ecosistemas JAX/TensorFlow. NPU es mejor para inferencia fija en dispositivos. FPGA es preferible cuando la latencia máxima y la seguridad son prioritarias. La cuantización no debe aprobarse por throughput aislado: requiere calibración y validación por clase.

## Referencias

MLCommons. (2024). *MLPerf Inference v4.1 results*. https://mlcommons.org/benchmarks/inference/

NVIDIA. (2024). *NVIDIA H100 Tensor Core GPU datasheet*. https://resources.nvidia.com/

Google Cloud. (2024). *Cloud TPU documentation and v4 specifications*. https://cloud.google.com/tpu/docs

Apple. (2024). *Apple M3 and M3 Ultra technical overview*. https://www.apple.com/

AMD. (2024). *Alveo U55C data center accelerator card*. https://www.amd.com/en/products/accelerators/alveo.html

Qualcomm. (2023). *Snapdragon 8 Gen 3: AI performance specifications*. https://www.qualcomm.com/
