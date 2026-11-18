# Análisis técnico del impacto cuántico en ciberseguridad

**Arquitectura de Computadores · Unidad 12**  
**Autor:** González López

## Introducción

La computación cuántica no rompe todas las criptografías con la misma severidad. El algoritmo de Shor compromete RSA, DSA, ECDSA, ECDH y X25519 al resolver factorización o logaritmo discreto en tiempo polinomial sobre hardware tolerante a fallos. Grover reduce aproximadamente al cuadrado el costo de búsqueda simétrica y de preimagen, pero no elimina por sí solo AES-256 o SHA-384.

## 1. Inventario de vulnerabilidad

| Algoritmo | Tipo | Vulnerabilidad cuántica | Atacante | Remediación |
|---|---|---|---|---|
| RSA-2048/3072/4096 | Asimétrico | Roto por Shor | Shor | ML-KEM |
| ECDSA P-256/P-384 | Firma | Roto por Shor | Shor | ML-DSA o SLH-DSA |
| ECDH/X25519 | Intercambio de clave | Roto por Shor | Shor | ML-KEM |
| AES-128 | Cifrado simétrico | Clave efectiva reducida a 64 bits | Grover | Migrar a AES-256 |
| AES-256 | Cifrado simétrico | Seguridad reducida a 128 bits | Grover | Mantener y auditar |
| SHA-256 | Hash | Resistencia de preimagen reducida | Grover | SHA-384/SHA-512 |
| SHA-3-256 | Hash | Compromiso equivalente a SHA-256 | Grover | SHA-3-384 o mayor |

Un sistema asimétrico debe considerarse confidencialmente comprometido por Shor. La degradación simétrica es significativa, pero no implica ruptura inmediata. AES-256 conserva una reserva suficiente frente a búsquedas cuánticas.

## 2. Estándares NIST 2024

ML-KEM está definido por FIPS 203 y reemplaza a KEM clásicos como RSA-KEM y ECDH. Usa Module-LWE y ofrece ML-KEM-512/768/1024.

ML-DSA está definido por FIPS 204 y reemplaza firmas RSA/ECDSA. Sus parámetros 44, 65 y 87 ofrecen tamaños, seguridad y rendimiento crecientes.

SLH-DSA está definido por FIPS 205 y usa construcciones basadas en hash. Su firma es más grande y lenta que ML-DSA, pero no depende de MLWE. Es apropiada como respaldo o para raíces de confianza.

## 3. Plan de migración por perfil

**Perfil A — Hospital universitario.** Inventariar certificados TLS, HSM, PKI, recetas y archivos cifrados. Los registros médicos con sensibilidad de 50–75 años reciben máxima prioridad por HNDL. Usar ML-KEM híbrido para TLS y ML-DSA-65 para recetas, reservando SLH-DSA para certificados raíz. Hitos: inventario y pruebas en el año 1, piloto híbrido en el año 2 y despliegue completo en los años 3–5.

**Perfil B — Comercio electrónico.** Priorizar un piloto TLS híbrido compatible con navegadores modernos y migrar certificados en etapas. Inventariar pagos, APIs, claves de sesión y sistemas de firma. Hitos: prueba HSM y clientes en 6 meses, región piloto a los 12 meses y retiro gradual clásico entre 2025 y 2033.

**Perfil C — Defensa gubernamental.** Clasificar el tráfico por sensibilidad y crear una PKI conforme a CNSA 2.0. Migrar VPN, cifrado clasificado y firmas oficiales antes del plazo regulatorio. Hitos: inventario inmediato, piloto interagencial y retiro de sistemas heredados.

Cada perfil necesita pruebas de compatibilidad, certificados duplicados durante la transición, pruebas de reversión y auditoría criptográfica.

## 4. Tamaños de claves y firmas e impacto TLS

| Algoritmo | Tipo | Clave pública | Clave privada | Firma/ciphertext | Nivel |
|---|---|---:|---:|---:|---|
| RSA-3072 | Clásico | ~400 B | ~1600 B | 384 B firma | ~128 bits |
| ECDSA P-256 | Clásico | 64 B | 32 B | ~72 B firma | ~128 bits |
| X25519 | Clásico | 32 B | 32 B | N/A | ~128 bits |
| ML-KEM-768 | PQC KEM | 1184 B | 2400 B | 1088 B ciphertext | NIST 3 |
| ML-DSA-65 | PQC firma | 1952 B | 4032 B | 3309 B firma | NIST 3 |
| SLH-DSA-128s | PQC firma | 32 B | 64 B | 7856 B firma | NIST 1 |

ML-KEM-768 tiene una clave pública aproximadamente 37 veces mayor que X25519. ML-DSA-65 firma aproximadamente 46 veces más que ECDSA P-256. En TLS 1.3 X25519+ML-KEM-768, el key_share crece de 32 a aproximadamente 1216 bytes. La respuesta crece de 32 a aproximadamente 1120 bytes. Una cadena firmada con ML-DSA puede agregar varios kilobytes y fragmentar TCP. En redes normales puede caber en una ventana inicial, pero pérdida o latencia alta puede añadir interacciones.

## 5. Decisión técnica: firma para el Perfil A

ML-KEM queda descartado porque encapsula una clave, no firma prescripciones. Para el hospital se prefieren ML-DSA-65 y no SLH-DSA como algoritmo principal: firma 3309 bytes frente a 7856 y opera con menor costo. HNDL amenaza la confidencialidad de registros cifrados, no la autenticidad inmediata de una prescripción. Por ello, 50–75 años de sensibilidad no obliga a usar SLH-DSA para recetas. ML-DSA puede utilizarse como firma principal, con SLH-DSA reservado para raíces o certificados de larga vida.

## 6. Decisión técnica: híbrido para el Perfil B

El modo híbrido clásico+PQC es apropiado desde el inicio para comercio electrónico. El costo de bytes rara vez agrega rondas de red y protege simultáneamente contra la ruptura cuántica de ECC y una posible debilidad clásica de ML-KEM todavía joven. Esta doble protección es valiosa durante el escrutinio público acumulado. El híbrido no debe ser permanente indefinidamente: debe ser una etapa hacia PQC puro cuando exista confianza y compatibilidad suficiente, alineado con los objetivos 2025–2033. Para datos de tarjeta con cinco a siete años de sensibilidad, el híbrido ofrece cobertura sin esperar a una obligación.

## Referencias

NIST. (2024). *FIPS 203: Module-lattice-based key-encapsulation mechanism standard*. https://doi.org/10.6028/NIST.FIPS.203

NIST. (2024). *FIPS 204: Module-lattice-based digital signature standard*. https://doi.org/10.6028/NIST.FIPS.204

NIST. (2024). *FIPS 205: Stateless hash-based digital signature standard*. https://doi.org/10.6028/NIST.FIPS.205

CISA, NSA, &amp; NIST. (2023). *Quantum-readiness: Migration to post-quantum cryptography*.
