# Evidencias del laboratorio — Unidad 8

Estado de evidencia conforme a la auditoría del laboratorio. Se han completado todas las evidencias para los 13 checkpoints requeridos, incluyendo las dos capturas por checkpoint (variantes `-a` y `-b`):

| Checkpoint | Evidencia esperada | Variante A | Variante B | Estado |
|---|---|---|---|---|
| **CP01** | `post1.com`: copia MOVSB y MOVSW | [`cp01-movsb-movsw-a.png`](cp01-movsb-movsw-a.png) | [`cp01-movsb-movsw-b.png`](cp01-movsb-movsw-b.png) | **Completado** |
| **CP02** | Comparación ambas copias / longitud impar | [`cp02-comparacion-copias-a.png`](cp02-comparacion-copias-a.png) | [`cp02-comparacion-copias-b.png`](cp02-comparacion-copias-b.png) | **Completado** |
| **CP03** | `post1c.com`: coincidencia y búsqueda negativa | [`cp03-scasb-a.png`](cp03-scasb-a.png) | [`cp03-scasb-b.png`](cp03-scasb-b.png) | **Completado** |
| **CP04** | `post1d.com`: cadenas iguales y diferentes | [`cp04-cmpsb-a.png`](cp04-cmpsb-a.png) | [`cp04-cmpsb-b.png`](cp04-cmpsb-b.png) | **Completado** |
| **CP05** | `post1e.com`: mayúsculas con LODSB/STOSB | [`cp05-lodsb-stosb-a.png`](cp05-lodsb-stosb-a.png) | [`cp05-lodsb-stosb-b.png`](cp05-lodsb-stosb-b.png) | **Completado** |
| **CP06** | README: dos decisiones técnicas de Parte 1 | [`cp06-decisiones-p1-a.png`](cp06-decisiones-p1-a.png) | [`cp06-decisiones-p1-a.png`](cp06-decisiones-p1-a.png) | **Completado** |
| **CP07** | `post2.com`: suma de 32 bits | [`cp07-32bit-suma-a.png`](cp07-32bit-suma-a.png) | [`cp07-32bit-suma-b.png`](cp07-32bit-suma-b.png) | **Completado** |
| **CP08** | `post2.com`: resta de 32 bits | [`cp08-32bit-resta-a.png`](cp08-32bit-resta-a.png) | [`cp08-32bit-resta-b.png`](cp08-32bit-resta-b.png) | **Completado** |
| **CP09** | `post2b.com`: DAA, DAS y acarreo BCD | [`cp09-daa-das-a.png`](cp09-daa-das-a.png) | [`cp09-daa-das-b.png`](cp09-daa-das-b.png) | **Completado** |
| **CP10** | `post2c.com`: multiplicación y división | [`cp10-mul-div-a.png`](cp10-mul-div-a.png) | [`cp10-mul-div-b.png`](cp10-mul-div-b.png) | **Completado** |
| **CP11** | `post2d.com`: AAA y AAS | [`cp11-aaa-aas-a.png`](cp11-aaa-aas-a.png) | [`cp11-aaa-aas-b.png`](cp11-aaa-aas-b.png) | **Completado** |
| **CP12** | README: decisión DAA/DAS frente a AAA/AAS | [`cp12-decision-daa-das-aaa-aas-a.png`](cp12-decision-daa-das-aaa-aas-a.png) | [`cp12-decision-daa-das-aaa-aas-a.png`](cp12-decision-daa-das-aaa-aas-a.png) | **Completado** |
| **CP13** | README: decisión ADC fijo frente a bucle | [`cp13-decision-adc-fijo-bucle-a.png`](cp13-decision-adc-fijo-bucle-a.png) | [`cp13-decision-adc-fijo-bucle-a.png`](cp13-decision-adc-fijo-bucle-a.png) | **Completado** |

## Resumen

- Total de capturas: **26/26 imágenes (100% completado)**.
- Se corrigió CP08 eliminando el duplicado de suma y registrando la resta real de 32 bits (`DX:AX = 0001:FFFF`) junto a su trazado en DEBUG.
- Se completó CP10 incorporando la prueba de división (`9 / 3 = 3 Resto: 0`) y división por cero (`5 / 0 -> Division por cero.`).
