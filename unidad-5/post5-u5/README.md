# Post-contenido — DOSBox y VirtualBox

**Arquitectura de Computadores · Unidad 5**  
**Estudiante:** González López  
**Repositorio:** [TrabajosArqui](https://github.com/alejandro1152113/TrabajosArqui/tree/main/unidad-5/post5-u5)

> **Estado:** se prepararon el código NASM y la guía de ejecución. No se han inventado resultados, capturas, versiones de software ni una instalación de Alpine. Los resultados del host y las 16 capturas deben añadirse después de realizar los pasos marcados como pendientes.

## Contenido

- [`src/`](src/): programas NASM de 16 bits para DOSBox.
- `bin/`: ejecutables `.COM` de DOS generados con NASM.
- [`dosbox.conf`](dosbox.conf): configuración base; revisar la ruta de montaje en cada equipo.
- [`VBoxManage_commands.ps1`](VBoxManage_commands.ps1): comandos PowerShell de apoyo para el host Windows.
- [`capturas/`](capturas/README.md): nombres y ubicación de las 16 evidencias requeridas.
- [Gonzalez Lopez_Post5_U5.pdf](https://github.com/alejandro1152113/TrabajosArqui/blob/main/unidad-5/post5-u5/Gonzalez%20Lopez_Post5_U5.pdf): copia PDF de esta bitácora.

Los ejecutables `.COM`, ISO de Alpine, discos virtuales y exportaciones OVA se generan localmente y no se versionan.

## Requisitos

- Windows 10/11 de 64 bits, virtualización de CPU habilitada en BIOS/UEFI, al menos 4 GB de RAM disponible y 15 GB libres para realizar la actividad completa.
- DOSBox 0.74-3 o posterior.
- NASM 2.x que pueda ejecutarse **dentro de DOSBox**. El NASM de Windows no sustituye al ejecutable DOS que pide la guía.
- `DEBUG.EXE` de DOS o FreeDOS, colocado en una carpeta montada en DOSBox. DOSBox no garantiza que `DEBUG` venga incluido.
- Oracle VirtualBox 7.x, `VBoxManage` y la ISO `alpine-standard-3.19.0-x86_64.iso` indicada por la actividad.
- Editor de texto plano y Git.

La actividad exige Alpine 3.19. Debe usarse solo en el laboratorio aislado: es una versión antigua y no se recomienda publicar en Internet servicios instalados en ella.

## Parte 1 — NASM y DOSBox

### 1. Preparar y montar la carpeta

Abrir PowerShell en la raíz de este repositorio y comprobar que existen `src`, `bin` y `capturas`. Crear `bin` si aún no existe. Editar en `dosbox.conf` la ruta absoluta de `mount c` para que apunte a esta carpeta `post5-u5`; la ruta de ejemplo corresponde al equipo donde se preparó la estructura. La sintaxis de DOSBox no acepta comentarios al final de una asignación, por eso los comentarios se dejan en líneas separadas.

Iniciar DOSBox con el archivo de configuración. Si `-conf` recibe una ruta relativa, ejecutar primero `dosbox.exe -conf "RUTA\A\post5-u5\dosbox.conf"` desde el host. En el prompt `C:\>` comprobar con `dir`, y ejecutar `nasm -v`. Si no se reconoce `nasm`, copiar el ejecutable DOS NASM provisto por el curso a esta carpeta y comprobar que esté en el PATH de DOSBox.

### 2. Ensamblar y ejecutar los programas

En el prompt de DOSBox:

```text
C:\> mkdir bin
C:\> nasm -f bin src\saludo.asm -o bin\saludo.com
C:\> bin\saludo
C:\> nasm -f bin src\entrada.asm -o bin\entrada.com
C:\> bin\entrada
C:\> nasm -f bin src\ciclos.asm -o bin\ciclos.com
C:\> bin\ciclos
```

`saludo.com` imprime tres líneas. `entrada.com` espera una tecla y muestra el carácter y su código ASCII hexadecimal. `ciclos.com` muestra dos lecturas del reloj DOS (`INT 21h`, función `2Ch`) antes y después de un bucle fijo de 1.000.000 de iteraciones. La duración real depende de la configuración de emulación y del equipo; se debe comprobar en DOSBox, no inferirla de antemano.

Los fuentes usan `bits 16` y `org 100h`, no usan `@data` ni `section .data/.text`. Esas construcciones suelen asociarse a ejecutables objeto o a otros ensambladores y no son necesarias en un `.COM` de NASM: DOS carga código y datos en un segmento y deja el PSP en los primeros 256 bytes. Las cadenas de `INT 21h/AH=09h` terminan en `$`.

### 3. Depurar saludo.com con DEBUG

Con `DEBUG.EXE` accesible desde la unidad montada:

```text
C:\> debug bin\saludo.com
-r
-u 100 10f
-t
-t
-t
-g
-q
```

Registrar la salida real de los registros y del desensamblado. Los valores de segmentos dependen de la sesión, por lo que no se deben copiar valores de ejemplo como si fueran mediciones propias. Si DEBUG no está instalado, se debe documentar su procedencia y añadir su carpeta al montaje; el depurador integrado de otra versión de DOSBox no es automáticamente el mismo programa.

### 4. Comparar cycles

Ejecutar `ciclos.com` tres veces, cambiando **solo** `cycles` en `[cpu]` a `8000`, `1000` y `20000`; reiniciar DOSBox después de cada cambio. Calcular cada duración con las cuatro marcas `hh:mm:ss:cc`, teniendo en cuenta el cambio de segundo/minuto. Completar la tabla con observaciones reales:

| Corrida | cycles | Hora inicial | Hora final | Duración observada |
|---|---:|---|---|---|
| 1 | 8000 | 13:36:50:07 | 13:36:50:29 | 22 cs |
| 2 | 1000 | Pendiente | Pendiente | Pendiente |
| 3 | 20000 | Pendiente | Pendiente | Pendiente |

El dato de 8000 corresponde a una ejecución de verificación local en DOSBox 0.74-3 con esta fuente; las dos corridas restantes deben realizarse y registrarse antes de entregar. Durante esta verificación el bucle de un millón de iteraciones tardó 22 centésimas. Las pruebas preliminares con 1000 y 20000 no completaron dentro del límite de 90 segundos usado para la automatización y, por ello, no se presentan resultados inventados. Si esas corridas también tardan demasiado en el equipo, reducir el total de iteraciones manteniendo el mismo número para las tres configuraciones y anotar el cambio.

El parámetro `cycles` es la velocidad de CPU emulada que DOSBox intenta mantener, no la frecuencia física del procesador anfitrión. Un valor fijo ayuda a controlar el experimento, pero no garantiza igual tiempo de pared entre equipos: si el host no alcanza la velocidad solicitada, puede ralentizarse. `max` ejecuta la emulación tan rápido como pueda el host y vuelve poco comparable el bucle; `auto` ajusta la velocidad según el programa. Fuera de una prueba de tiempos puede convenir `auto` o `max` en software que no depende de la temporización original.

Para estimar el costo en el host, se deben usar herramientas del sistema operativo como el Monitor de rendimiento o Windows Performance Recorder/Analyzer; el número de `cycles` de DOSBox no expresa ciclos de reloj físicos consumidos.

## Parte 2 — VirtualBox y Alpine

### 1. Crear la VM

Verificar primero que VirtualBox esté instalado y que la virtualización de hardware esté habilitada. Desde VirtualBox Manager o `VBoxManage`, crear `Lab5-Alpine` con Linux de 64 bits, 1024 MB de RAM, 1 CPU, un VDI dinámico de 10 GB, red NAT y la ISO de Alpine conectada. La guía incluye un script PowerShell para crear la VM; editar la ruta de la ISO antes de ejecutarlo.

Desde PowerShell, ubicado en esta carpeta:

```powershell
.\VBoxManage_commands.ps1 -Action create -IsoPath "C:\ruta\alpine-standard-3.19.0-x86_64.iso"
```

El script no elimina VMs o discos existentes. Los modos de red se pueden cambiar con `-Action nat`, `-Action host-only -AdapterName "NOMBRE EXACTO"` o `-Action bridged -AdapterName "NOMBRE DEL ADAPTADOR"`. Para encontrar los adaptadores Host-Only disponibles, usar `VBoxManage list hostonlyifs`.

### 2. Instalar Alpine

Arrancar desde la ISO y ejecutar `setup-alpine`. Seguir la configuración indicada en la actividad: hostname `lab5-vm`, interfaz `eth0` por DHCP, zona horaria `America/Bogota`, SSH opcional, disco de sistema `sda` y modo `sys`. Usar una contraseña local segura y no guardarla en el repositorio. Apagar Alpine al terminar y retirar la ISO para comprobar que la VM arranque desde el VDI.

Validar desde la consola del huésped:

```sh
ip addr show eth0
ping -c 3 8.8.8.8
```

NAT suele permitir conexiones iniciadas desde el huésped hacia fuera y bloquea conexiones entrantes no solicitadas salvo reglas de reenvío. Que `ping` falle no demuestra por sí solo que NAT esté mal: una red puede filtrar ICMP.

### 3. Probar modos de red

Registrar el modo y la IP real que obtiene Alpine para NAT y para al menos uno de Host-Only o Bridge. En Windows, el adaptador Host-Only no se llama necesariamente `vboxnet0`: consultar `VBoxManage list hostonlyifs` o VirtualBox Network Manager y usar el nombre exacto de esta máquina. Host-Only requiere que exista un adaptador y, para DHCP, un servidor configurado. Bridge conecta la VM a la LAN física; debe evitarse en redes públicas o no confiables y no se debe exponer SSH sin autorización y controles de acceso.

| Modo | IP de `eth0` observada | Acceso probado | Evidencia |
|---|---|---|---|
| NAT | Pendiente | Pendiente | `capturas/p2-cp3-modos-red.png` |
| Host-Only o Bridge | Pendiente | Pendiente | `capturas/p2-cp3-modos-red.png` |

### 4. Crear y restaurar snapshots

Crear `snap_base` después de la instalación y `snap_con_herramientas` después de instalar `curl`, `wget`, `nano` y `htop`. Si el snapshot debe incluir el estado de memoria de una VM encendida, emplear la opción `--live` admitida por la versión instalada; en caso contrario, apagar ordenadamente y crear un snapshot coherente del disco. Verificar con `VBoxManage snapshot "Lab5-Alpine" list`; restaurar el snapshot base y confirmar que las herramientas añadidas ya no están instaladas.

El script ofrece `-Action snapshot-base` y `-Action snapshot-tools`; ejecutar cada acción mientras la VM está encendida en el estado que se desea guardar. Para restaurar, apagar Alpine desde el huésped y usar `-Action restore-base`.

### 5. Cambiar recursos

Con la VM apagada, cambiar a dos CPU virtuales y 2048 MB de memoria, luego arrancar y verificar:

```sh
nproc
free -m
```

El cambio puede hacerse con `.\VBoxManage_commands.ps1 -Action resources` mientras la VM esté apagada.

No asignar todos los procesadores ni casi toda la RAM del host; el sistema anfitrión debe conservar recursos suficientes para operar con estabilidad.

### 6. Comparar disco fijo y dinámico

Con la VM apagada, crear y adjuntar un VDI fijo de 4 GB en el segundo puerto SATA. Dentro de Alpine, particionar `/dev/sdb`, crear ext4 y montarlo. Comparar escritura secuencial de 200 MiB en el disco fijo y en el dinámico con el mismo comando, sistema de archivos comparable, cargas y condiciones. Ejecutar varias repeticiones, anotar el tiempo informado por `time` y describir cachés y variación entre corridas; no presentar una diferencia de una sola medición como ley universal.

Crear y conectar el disco con `.\VBoxManage_commands.ps1 -Action fixed-disk` antes de particionarlo.

```sh
apk add e2fsprogs
fdisk /dev/sdb
mkfs.ext4 /dev/sdb1
mkdir -p /mnt/fijo /mnt/dinamico
mount /dev/sdb1 /mnt/fijo
mkdir -p /root/dinamico
time sh -c 'dd if=/dev/zero of=/mnt/fijo/test.img bs=1M count=200; sync'
time sh -c 'dd if=/dev/zero of=/root/dinamico/test.img bs=1M count=200; sync'
rm -f /mnt/fijo/test.img /root/dinamico/test.img
```

El archivo de un VDI dinámico crece según se escriben bloques; el VDI fijo reserva espacio desde la creación. El host podría tener otras cargas y cachés, y las particiones usadas arriba no son idénticas. Registrar esa limitación o repetir ambas mediciones en discos de datos formateados de la misma manera para una comparación más controlada.

| Tipo de VDI | Repetición 1 | Repetición 2 | Repetición 3 | Promedio |
|---|---:|---:|---:|---:|
| Fijo | Pendiente | Pendiente | Pendiente | Pendiente |
| Dinámico | Pendiente | Pendiente | Pendiente | Pendiente |

### 7. Decisiones técnicas

#### Decisión 1 — Valor de cycles (más de 100 palabras)

Para este laboratorio conviene mantener un valor fijo de `cycles`, como 8000, durante cada corrida y cambiarlo solo en el experimento comparativo. Un límite fijo hace que DOSBox intente suministrar una tasa de CPU emulada definida y permite que distintos estudiantes describan la misma condición experimental. No significa que todos los equipos midan el mismo tiempo de pared: un anfitrión lento puede no alcanzar el objetivo y la implementación o la versión de DOSBox también puede influir. Con `cycles=max`, el bucle ejecutaría instrucciones a la velocidad que permita cada host y su duración dependería mucho del equipo, por lo que se pierde comparabilidad. `cycles=auto` puede reajustar la tasa durante la ejecución, lo que tampoco es apropiado si la variable que se quiere estudiar debe permanecer controlada. En programas modernos de DOS que no usan bucles de espera ni temporización dependiente del procesador original, `auto` o `max` pueden resultar adecuados para obtener más fluidez. La tabla final debe reportar las tres duraciones medidas y su equipo; no se deben completar con cifras estimadas.

#### Decisión 2 — cycles frente a ciclos físicos del anfitrión (más de 100 palabras)

El número configurado en `cycles` no equivale a hercios del procesador real. Describe una tasa objetivo de ejecución emulada que DOSBox usa para aproximar una CPU invitada; no es una lectura de los ciclos de reloj que transcurren en el silicio del anfitrión. Para emular una instrucción x86 de 16 bits, el proceso DOSBox ejecuta instrucciones nativas, calcula estados y atiende dispositivos, por lo que el trabajo físico del host depende de la implementación, la carga, la CPU y la tasa alcanzada. En consecuencia, `cycles=8000` no indica que el proceso consuma solamente 8000 ciclos reales por segundo ni predice su porcentaje de CPU. Para medir consumo se observan contadores del proceso con el Monitor de rendimiento, Windows Performance Recorder/Analyzer o un perfilador de CPU; para contar ciclos físicos con precisión se requiere además soporte de contadores de rendimiento de hardware y una herramienta compatible. Los resultados deben indicar cuál fue la métrica, su intervalo y el proceso observado, sin confundirla con la velocidad emulada mostrada por el archivo de configuración.

#### Decisión 3 — Modo de red (más de 100 palabras)

Para una VM de práctica personal, NAT es el modo inicial recomendado: permite que Alpine inicie conexiones hacia servicios externos —por ejemplo, descargar paquetes— y, por defecto, no publica directamente la VM como otro equipo accesible desde toda la red local. El host y los dispositivos de la LAN no pueden iniciar libremente conexiones entrantes salvo que se configuren redirecciones de puertos; esto reduce exposición, pero no convierte a la VM en un entorno seguro frente a software malicioso ni sustituye actualizaciones y firewall. Host-Only es apropiado para estudiar DHCP, SSH entre anfitrión e invitado o servicios de laboratorio sin acceso directo a la LAN ni salida a Internet; pierde la conectividad externa salvo que se agregue explícitamente enrutamiento. Bridge resulta útil si se necesita probar cómo otra máquina de la red se conecta al huésped, pero la VM recibe presencia de red local y sus servicios quedan potencialmente alcanzables por otros dispositivos. Para Alpine 3.19 y un ejercicio sin necesidad de acceso de terceros, Bridge agrega superficie de ataque sin beneficio; NAT debe conservarse, SSH mantenerse restringido y las pruebas documentarse.

#### Decisión 4 — Disco fijo/dinámico y recursos de VM (más de 100 palabras)

La medición debe decidir cuál disco fue más rápido en este equipo a partir de las repeticiones de `dd`, no de asumir por adelantado que el fijo siempre gana. Un VDI fijo reserva en el anfitrión su capacidad completa al crearse, evitando que el archivo tenga que aumentar mientras se asignan bloques nuevos; eso puede reducir trabajo de crecimiento o fragmentación en ciertas escrituras. Un VDI dinámico ocupa menos mientras no se escriban todos los bloques asignados, una ventaja importante en un curso con decenas de VMs y almacenamiento anfitrión limitado. El tipo de disco no es el único factor: caché, filesystem, controlador y carga alteran los tiempos; se anotará el promedio y las condiciones. Asignar dos vCPU y 2048 MB a Alpine es razonable en un host típico con 4–8 CPU y 8–16 GB de RAM: entrega recursos suficientes sin dejar al anfitrión sin memoria. Asignar todos los vCPU o la mayor parte de la RAM podría causar contención, paginación y lentitud tanto en la VM como en Windows. Los límites deben ajustarse a los recursos reales del equipo, que se registrarán en el informe.

### 8. Exportar y cerrar

Con la VM apagada:

```powershell
VBoxManage export "Lab5-Alpine" --output "Lab5-Alpine-export.ova" --manifest
Get-Item .\Lab5-Alpine-export.ova | Select-Object Name,Length
```

No subir `.ova`, `.vdi` ni la ISO al repositorio. Guardar evidencia del tamaño exportado en una captura. Completar las cuatro decisiones con las observaciones reales, registrar versiones y entorno del host, agregar las capturas requeridas y actualizar el PDF desde este README antes de la entrega.

## Checkpoints y estado de evidencia

| # | Evidencia requerida | Estado |
|---:|---|---|
| P1-1 | Árbol de directorios y rama Git | Estructura creada; captura pendiente |
| P1-2 | DOSBox, prompt y `nasm -v` | DOSBox verificado; NASM DOS y captura pendientes |
| P1-3 | Salida de `saludo.com` | Programa verificado en DOSBox; captura pendiente |
| P1-4 | Interacción y hex de `entrada.com` | Programa verificado en DOSBox; captura pendiente |
| P1-5 | `DEBUG`: desensamble y pasos | Pendiente |
| P1-6 | Salida de `ciclos.com` | Programa verificado en DOSBox; captura pendiente |
| P1-7 | Tres corridas de `cycles` | Pendiente |
| P1-8 | Decisiones de cycles | Pendiente |
| P2-1 | Configuración de la VM | Pendiente |
| P2-2 | Alpine instalado, IP y conectividad | Pendiente |
| P2-3 | Modos e IPs de red | Pendiente |
| P2-4 | Lista de snapshots y restauración | Pendiente |
| P2-5 | `nproc` y `free -m` | Pendiente |
| P2-6 | Benchmarks de discos | Pendiente |
| P2-7 | Decisiones de red y almacenamiento | Pendiente |
| P2-8 | Exportación OVA y tamaño | Pendiente |

## Conclusión

DOSBox emula por software una plataforma DOS/x86 histórica y requiere interpretar o traducir las instrucciones; `cycles` regula la velocidad objetivo de esa CPU emulada. VirtualBox presenta hardware virtual a un sistema operativo invitado y aprovecha las extensiones del procesador anfitrión cuando están disponibles. El primero permite experimentar con código real de 16 bits y sus servicios DOS; el segundo permite gestionar una máquina Linux completa, sus interfaces de red, almacenamiento y snapshots. Las conclusiones cuantitativas de este laboratorio se completarán cuando las ejecuciones y mediciones reales estén disponibles.

## Referencias técnicas

- Oracle. (s. f.). *Oracle VM VirtualBox User Manual: Virtual networking*. https://www.virtualbox.org/manual/ch06.html
- Oracle. (s. f.). *Oracle VM VirtualBox User Manual: VBoxManage*. https://www.virtualbox.org/manual/ch08.html
- Alpine Linux. (s. f.). *Alpine setup scripts*. https://wiki.alpinelinux.org/wiki/Alpine_setup_scripts
- DOSBox. (s. f.). *DOSBox configuration*. https://www.dosbox.com/wiki/Dosbox.conf
- Microsoft. (s. f.). *Hyper-V architecture*. https://learn.microsoft.com/en-us/windows-server/virtualization/hyper-v/architecture
