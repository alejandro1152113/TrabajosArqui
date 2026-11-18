# Post-contenido - Computación cuántica y ciberseguridad

**Arquitectura de Computadores · Unidad 12**  
**Estudiante:** González López  
**Repositorio:** [TrabajosArqui - post12-u12](https://github.com/alejandro1152113/TrabajosArqui/tree/main/unidad-12/post12-u12)  
**PDF:** [Gonzalez Lopez_Post12_U12.pdf](https://github.com/alejandro1152113/TrabajosArqui/blob/main/unidad-12/post12-u12/Gonzalez%20Lopez_Post12_U12.pdf)

## Requisitos

- Python 3.9 o superior
- Qiskit 1.x o 2.x
- qiskit-aer
- matplotlib

```bash
py -3.12 -m pip install qiskit qiskit-aer matplotlib
cd unidad-12/post12-u12
py -3.12 src/bell_state.py
py -3.12 src/deutsch_jozsa.py
py -3.12 src/grover.py
py -3.12 src/grover_noise.py
```

Los histogramas se guardan en `capturas/`.

## Parte 1 - Qiskit

| Programa | Experimento | Resultado esperado |
|---|---|---|
| `bell_state.py` | Estado Phi+ | Solo |00> y |11> |
| `deutsch_jozsa.py` | Constante y balanceada | Constante devuelve |00>; balanceada no |
| `grover.py` | Cuatro objetivos en 2 qubits | Probabilidad sobre el 90% |
| `grover_noise.py` | Modelo despolarizante | Éxito menor que ideal |

## Resultados reales obtenidos

Se ejecutó con Qiskit 2.6.2 y Aer 0.18.4:

- Bell: 489 muestras |00> y 535 muestras |11>.
- Deutsch-Jozsa: constante 1024×|00>; balanceada 1024×|11>.
- Grover: los cuatro objetivos encontraron su estado objetivo con probabilidad 100% en esta ejecución.
- Grover con ruido: éxito ideal 100% y éxito ruidoso 98.4%, degradación de 1.6 puntos porcentuales.

Los valores exactos pueden variar por aleatoriedad y semilla.

## Decisión técnica 1 - Utilidad de Grover con ruido

El circuito de dos qubits sigue identificando claramente el estado objetivo con 1024 shots. Ese resultado es útil como demostración NISQ pequeña y poco profunda. Si se amplía a diez o veinte qubits y mayor profundidad, el error acumulado por puertas de dos qubits puede reducir la señal hasta hacerla estadísticamente indistinguible. Para Shor o simulaciones profundas se requieren qubits lógicos con corrección de errores.

## Decisión técnica 2 - Modelo despolarizante

El modelo uniforme no representa tiempos T1/T2 ni el error específico por qubit o readout. Sigue siendo apropiado para enseñar que el ruido degrada fidelidad de forma controlada y reproducible. Un modelo desde un backend real sería necesario para predecir un dispositivo concreto.

## Parte 2 - Impacto PQC

El análisis completo está en [`docs/analisis-pqc.md`](docs/analisis-pqc.md). Incluye inventario criptográfico, estándares NIST, tamaños oficiales, handshakes híbridos, migración por perfil y decisiones sobre ML-DSA e híbrido.
