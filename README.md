# Trabajos de Arquitectura de Computadores

Repositorio de actividades organizadas por unidad:

- [Unidad 3 — Post-contenido](unidad-3/post3-u3/README.md): laboratorio DEBUG/DOSBox, tablas de traza y capturas reales.
- [Unidad 5 — Pre-contenido](<unidad-5/pre5-u5/Gonzalez Lopez_Pre5_U5.pdf>): respuestas teóricas en PDF.
- [Unidad 5 — Post-contenido](unidad-5/post5-u5/README.md): laboratorio DOSBox/NASM y VirtualBox/Alpine, con su [documentación PDF](<unidad-5/post5-u5/Gonzalez Lopez_Post5_U5.pdf>).
- [Unidad 6 — Post-contenido](unidad-6/post6-u6/README.md): laboratorio NASM/DOSBox y [PDF](<unidad-6/post6-u6/Gonzalez Lopez_Post6_U6.pdf>).
- [Unidad 7 — Pre-contenido](<unidad-7/pre7-u7/Gonzalez Lopez_Pre7_U7.pdf>): respuestas teóricas desarrolladas en PDF.
- [Unidad 7 — Post-contenido](unidad-7/post7-u7/README.md): fuentes NASM, guía del laboratorio y [PDF](<unidad-7/post7-u7/Gonzalez Lopez_Post7_U7.pdf>).
- [Unidad 8 — Pre-contenido](<unidad-8/pre8-u8/Gonzalez Lopez_Pre8_U8.pdf>): respuestas teóricas desarrolladas en PDF.
- [Unidad 8 — Post-contenido](unidad-8/post8-u8/README.md): fuentes NASM, programas DOSBox y [PDF](<unidad-8/post8-u8/Gonzalez Lopez_Post8_U8.pdf>).
- [Unidad 9 — Pre-contenido](<unidad-9/pre9-u9/Gonzalez Lopez_Pre9_U9.pdf>): reflexiones teóricas sobre polling, interrupciones y DMA.
- [Unidad 9 — Post-contenido](unidad-9/post9-u9/README.md): laboratorio de puertos, polling, PIC 8259A e ISR en NASM/DOSBox y [PDF](<unidad-9/post9-u9/Gonzalez Lopez_Post9_U9.pdf>).
- [Unidad 10 — Pre-contenido](<unidad-10/pre10-u10/Gonzalez Lopez_Pre10_U10.pdf>): tecnologías de memoria y memoria virtual.
- [Unidad 10 — Post-contenido](unidad-10/post10-u10/README.md): benchmark de caché y memoria virtual en C sobre Linux y [PDF](<unidad-10/post10-u10/Gonzalez Lopez_Post10_U10.pdf>).
- [Unidad 11 — Pre-contenido](<unidad-11/pre11-u11/Gonzalez Lopez_Pre11_U11.pdf>): CPU frente a GPU, CUDA y GPGPU.
- [Unidad 11 — Post-contenido](unidad-11/post11-u11/README.md): benchmark CUDA y análisis comparativo de aceleradores y [PDF](<unidad-11/post11-u11/Gonzalez Lopez_Post11_U11.pdf>).
- [Unidad 12 — Pre-contenido](<unidad-12/pre12-u12/Gonzalez Lopez_Pre12_U12.pdf>): computación cuántica y paradigmas emergentes.
- [Unidad 12 — Post-contenido](unidad-12/post12-u12/README.md): laboratorio Qiskit y análisis PQC y [PDF](<unidad-12/post12-u12/Gonzalez Lopez_Post12_U12.pdf>).

---

## Estado General de Auditoría de Evidencias

Todas las evidencias requeridas por las guías del curso se encuentran completamente integradas, verificadas y documentadas en sus respectivas carpetas:

| Unidad | Estado | Evidencias generadas y verificadas |
|---|---|---|
| **[Unidad 3](unidad-3/post3-u3/capturas/README.md)** | **100% Completo** | Trazas de DEBUG, suma, volcado de memoria, saltos condicionales y direccionamiento. |
| **[Unidad 5](unidad-5/post5-u5/capturas/README.md)** | **100% Completo** | 16/16 capturas: DOSBox (P1-1 a P1-8) y VirtualBox/Alpine (P2-1 a P2-8: red, snapshots, recursos, disco `dd` y exportación OVA). |
| **[Unidad 6](unidad-6/post6-u6/capturas/README.md)** | **100% Completo** | 11/11 capturas: Compilación, flags, bucle LOOP (AX=000Fh), rotaciones, factorial 120, little-endian, puntero SI, recorridos ascendente/inverso, marco BP y matriz bidimensional. |
| **[Unidad 7](unidad-7/post7-u7/capturas/README.md)** | **100% Completo** | 12/12 capturas: Pantalla (INT 21h, INT 10h), teclado (INT 16h, B800h, editor, modifiers) y decisiones documentadas (P1-5, P2-6, P2-7). |
| **[Unidad 8](unidad-8/post8-u8/capturas/README.md)** | **100% Completo** | 26/26 capturas (variantes `-a` y `-b`): Cadenas (MOVSB/W, longitud impar, SCASB, CMPSB, mayúsculas), aritmética de 32 bits (suma y resta real corregida), BCD (DAA, DAS, AAA, AAS), calculadora interactiva (multiplicación, división y división por cero) y decisiones documentadas. |
| **[Unidad 9](unidad-9/post9-u9/capturas/README.md)** | **100% Completo** | 8/8 capturas: Lectura de scancode en `TECL.com` sin bucle infinito, polling con timeout, puerto LPT1, banderas OR, manejador IRQ1 propio, enmascaramiento del PIC, encadenamiento e ISR con ticks del BIOS. |
| **[Unidad 10](unidad-10/post10-u10/capturas/README.md)** | **100% Completo** | 5/5 capturas individuales en WSL/Ubuntu: Topología/acceso secuencial, acceso aleatorio Fisher-Yates, strides de asociatividad de 8 vías, segmentación `/proc/PID/maps` y costo de demand paging / page faults. |
| **[Unidad 11](unidad-11/post11-u11/capturas/README.md)** | **100% Completo** | 5/5 capturas de entorno GPU CUDA (NVIDIA Tesla T4): `nvcc`/`nvidia-smi`, `vectorAdd` (16M), `matMul` (Naïve vs Tiled Shared Memory), solapamiento con 4 streams y tabla consolidada. Incluye notebook `Laboratorio_CUDA_Unidad11.ipynb`. |
| **[Unidad 12](unidad-12/post12-u12/capturas/README.md)** | **100% Completo** | Circuitos cuánticos, estados de Bell, algoritmo de Deutsch-Jozsa, búsqueda de Grover con ruido y análisis PQC. |
