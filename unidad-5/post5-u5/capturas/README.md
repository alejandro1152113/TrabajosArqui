# Evidencias del laboratorio — Unidad 5

Estado de evidencia conforme a la auditoría del laboratorio. Se han completado todas las evidencias requeridas para las dos partes del laboratorio:

## Parte 1 — DOSBox

| Checkpoint | Archivo generado | Estado | Observación |
|---|---|---|---|
| P1-1 | [`p1-cp1-estructura.png`](p1-cp1-estructura.png) | **Completado** | Árbol de directorios del proyecto y rama `main` en Git. |
| P1-2 | [`p1-cp2-dosbox-nasm.png`](p1-cp2-dosbox-nasm.png) | **Completado** | DOSBox 0.74-3, prompt `C:\>` y verificación de `nasm -v`. |
| P1-3 | [`p1-cp3-saludo.png`](p1-cp3-saludo.png) | **Completado** | Salida de tres líneas con `saludo.com`. |
| P1-4 | [`p1-cp4-entrada.png`](p1-cp4-entrada.png) | **Completado** | Interacción y código hex (41h) de `entrada.com`. |
| P1-5 | [`p1-cp5-debug.png`](p1-cp5-debug.png) | **Completado** | Trazado con `DEBUG` de `saludo.com` (registros, desensamble con `-u` y paso a paso `-t`). |
| P1-6 | [`p1-cp6-ciclos.png`](p1-cp6-ciclos.png) | **Completado** | Salida de dos lecturas de reloj con `ciclos.com`. |
| P1-7 | [`p1-cp7-comparacion-cycles.png`](p1-cp7-comparacion-cycles.png) | **Completado** | Tres corridas con `cycles` = 8000 (~1.75 s), 1000 (~14.02 s) y 20000 (~0.70 s). |
| P1-8 | [`p1-cp8-decisiones-cycles.png`](p1-cp8-decisiones-cycles.png) | **Completado** | Decisiones técnicas 1 y 2 de cycles y depuración en DOSBox. |

## Parte 2 — VirtualBox / Alpine

| Checkpoint | Archivo generado | Estado | Observación |
|---|---|---|---|
| P2-1 | [`p2-cp1-vm-config.png`](p2-cp1-vm-config.png) | **Completado** | Configuración de VM: Linux 64-bit, 2 vCPU, 2048 MB RAM, disco VDI SATA y NAT. |
| P2-2 | [`p2-cp2-alpine-red.png`](p2-cp2-alpine-red.png) | **Completado** | Alpine instalado, IP asignada `10.0.2.15/24` y conectividad con `ping 8.8.8.8` (0% pérdida). |
| P2-3 | [`p2-cp3-modos-red.png`](p2-cp3-modos-red.png) | **Completado** | Comparativa de modos de red (NAT, Host-Only, Bridge) y tabla de rutas (`route -n`). |
| P2-4 | [`p2-cp4-snapshots.png`](p2-cp4-snapshots.png) | **Completado** | Árbol de instantáneas en PowerShell y restauración de `Base-Install` con `VBoxManage`. |
| P2-5 | [`p2-cp5-recursos.png`](p2-cp5-recursos.png) | **Completado** | Verificación de CPU (`nproc` = 2) y RAM (`free -m` = ~2048 MB) en Alpine. |
| P2-6 | [`p2-cp6-discos.png`](p2-cp6-discos.png) | **Completado** | Benchmarks de disco con `dd` (VDI Fijo 254 MB/s vs VDI Dinámico 179 MB/s). |
| P2-7 | [`p2-cp7-decisiones.png`](p2-cp7-decisiones.png) | **Completado** | Decisiones técnicas 3 y 4 de red y almacenamiento en VirtualBox. |
| P2-8 | [`p2-cp8-exportacion.png`](p2-cp8-exportacion.png) | **Completado** | Exportación de appliance `Lab5-Alpine-export.ova` (368 MB) con manifiesto SHA. |

## Resumen

- Capturas completadas: **16/16 (100% completado)**.
