# Pre-contenido — Emuladores y virtualización

**Arquitectura de Computadores · Unidad 5**  
**Estudiante:** González López  
**Entrega:** Pre5-U5

## Parte 1 — Emulación, simulación y virtualización

### Pregunta 1 — Predicción de consecuencias

Con tablas de páginas en sombra, el hipervisor mantiene una representación que combina las direcciones virtuales del proceso huésped con las direcciones físicas reales del anfitrión. Si un sistema invitado cambia frecuentemente de proceso, cambia también sus tablas y el registro CR3. El hipervisor debe conservar la coherencia de las tablas sombra y de las traducciones almacenadas en el TLB; según la implementación, intercepta operaciones relevantes, valida cambios e invalida traducciones. No significa reconstruir necesariamente toda la tabla en cada cambio: el costo depende de qué páginas cambiaron, de las optimizaciones y de la política de TLB. Sin embargo, muchas conexiones y cambios de contexto elevan la frecuencia de estas tareas y pueden añadir salidas al hipervisor.

EPT de Intel y NPT/RVI de AMD agregan una segunda traducción de direcciones asistida por hardware. El procesador recorre las tablas del huésped y las del hipervisor sin que este tenga que reflejar continuamente cada tabla invitada en una tabla sombra. La traducción anidada aún cuesta accesos y puede fallar en TLB, por lo que no elimina todo el overhead; sí reduce trabajo de software especialmente sensible a memoria virtual. Adams y Agesen (2006) documentan que el efecto de la virtualización asistida varía según la carga, y Bhargava et al. (2008) muestran que optimizar recorridos de páginas de dos dimensiones afecta el rendimiento. Por ello, se espera una diferencia mayor en la base de datos con numerosos procesos que en un único proceso largo. No es responsable asignar un porcentaje universal: habría que medir la misma versión, hardware y carga con y sin EPT/NPT.

### Pregunta 2 — Reflexión crítica

La paravirtualización de CPU conserva valor cuando el huésped conoce que está virtualizado y puede reemplazar operaciones privilegiadas por llamadas explícitas al hipervisor. Xen demostró que esa cooperación permitía virtualizar x86 incluso antes de la asistencia moderna de hardware (Barham et al., 2003). Actualmente, VT-x y AMD-V permiten ejecutar huéspedes sin modificar, por lo que el costo de mantener un kernel especial y la dependencia de interfaces particulares reducen el atractivo de paravirtualizar por completo la CPU. No obstante, las interfaces paravirtuales para temporizadores, almacenamiento y red siguen siendo útiles: reducen emulación de dispositivos, aunque la CPU ya use virtualización asistida.

El caso de AWS debe formularse con precisión. La documentación de AWS describe Nitro como una arquitectura de virtualización rediseñada, con tarjetas que descargan operaciones de entrada/salida y administración, y un hipervisor deliberadamente pequeño (Amazon Web Services, 2024). Eso respalda que la evolución de EC2 no se explica únicamente por activar VT-x/AMD-V ni autoriza a atribuirle una migración simple y universal de “Xen a KVM”. A escala de nube también importan aislamiento, seguridad, operación, costos y velocidad de innovación. En equipos embebidos con CPU sin extensiones, hardware heredado o certificaciones que exigen controlar estrictamente las interfaces, una solución cooperativa todavía podría ser práctica. En cambio, para servidores x86-64 nuevos, un huésped estándar asistido por hardware y controladores paravirtuales de E/S suele equilibrar compatibilidad y rendimiento mejor que exigir un kernel modificado.

### Pregunta 3 — Toma de decisión con justificación

Para estudiar una nueva política de reemplazo de caché L2, el grupo debería elegir gem5 con un modelo que represente la jerarquía de memoria y el nivel de detalle temporal requerido. El experimento no pregunta solo si una aplicación produce la salida correcta: necesita cambiar el algoritmo de reemplazo, observar fallos de caché y comparar el tiempo simulado bajo configuraciones equivalentes. gem5 está diseñado para investigación de arquitectura y permite construir y modificar modelos de CPU y memoria; un simulador detallado puede modelar eventos y latencias que no están expuestos por una VM ordinaria (gem5 Project, s. f.).

El costo es velocidad. El simulador ejecuta el modelo de hardware en software y debe actualizar eventos, colas y estados de microarquitectura; por eso normalmente es mucho más lento que ejecutar código directamente en el anfitrión. QEMU con TCG, por su parte, traduce bloques de instrucciones para ejecutar sistemas de otra arquitectura, pero su objetivo principal es emular el comportamiento funcional de la máquina y sus dispositivos, no reproducir fielmente la caché L2 del procesador real (QEMU Project, s. f.). Una VM acelerada por VT-x/AMD-V sería más veloz aún, pero las cachés pertenecen al hardware anfitrión y no constituyen una arquitectura modificable ni observada con fidelidad de ciclo. Si la pregunta alternativa fuera comprobar si un binario ARM arranca en una estación x86, QEMU sería la elección apropiada; para comparar políticas de caché, no sustituye al modelo microarquitectónico de gem5.

## Parte 2 — Plataformas de virtualización

### Pregunta 1 — Síntesis

En un laboratorio universitario con varios servidores de prácticas, cada mecanismo resuelve un problema diferente. La interfaz de paravirtualización KVM que VirtualBox presenta a un huésped Linux puede mejorar ciertas operaciones de temporizador y comunicación con el hipervisor; virtio-net ofrece además un dispositivo de red diseñado para huéspedes con controlador compatible, en vez de emular una tarjeta antigua (Oracle, s. f.). Ninguna de esas interfaces decide cuántas máquinas pueden caber en la RAM del host ni endurece por sí sola el arranque.

Para consolidar más escritorios de baja carga, Hyper-V Dynamic Memory ajusta la memoria asignada dentro de límites configurados; VMware ofrece mecanismos de reclamación de memoria como ballooning. Eso puede mejorar la densidad cuando las VMs no usan simultáneamente su máximo, pero no crea RAM física ni garantiza rendimiento bajo presión. Microsoft advierte que la configuración del huésped y la demanda importan (Microsoft, 2025). Finalmente, elegir UEFI y Secure Boot en una VM Hyper-V de Generación 2 reduce la dependencia del firmware heredado y permite validar componentes de arranque firmados; debe comprobarse que el sistema invitado sea compatible con ese modo (Microsoft, s. f.).

Así, la paravirtualización busca reducir costo de comunicación y mejorar rendimiento; el ballooning redistribuye memoria para consolidación; y UEFI/Secure Boot establece propiedades de arranque. Un controlador rápido no libera RAM, Dynamic Memory no corrige un firmware inseguro y Secure Boot no reduce los VM exits ni acelera la red. Una plataforma de laboratorio debe configurarlos como controles complementarios, validar la carga máxima y conservar una plantilla de VM compatible para que las prácticas sean reproducibles.

### Pregunta 2 — Análisis comparativo

VirtualBox de escritorio es un hipervisor alojado: se instala como aplicación sobre Windows, Linux o macOS y comparte recursos y administración con el anfitrión. VMware no es una sola categoría: Workstation y Fusion son productos de escritorio alojados, mientras que ESXi es un hipervisor de Tipo 1 instalado directamente sobre el hardware del servidor (VMware, s. f.). Hyper-V también es Tipo 1 aunque se habilite desde Windows: el hipervisor controla la virtualización y Windows corre en una partición raíz con acceso de administración (Microsoft, s. f.). Esta arquitectura puede confundir porque la interfaz cotidiana sigue siendo Windows.

Para una carga empresarial sostenida, ESXi suele ofrecer administración centralizada de clúster, alta disponibilidad, migración en vivo y controles de operación que no son el foco de VirtualBox. Un Tipo 1 evita depender de un sistema operativo anfitrión general para planificar las VMs, aunque el rendimiento final también depende de hardware, controladores, almacenamiento y configuración; el rótulo de tipo no garantiza por sí solo mayor velocidad. VirtualBox resulta apropiado para desarrollo, demostraciones y laboratorios individuales, con una instalación sencilla y amplia portabilidad. Oracle describe sus herramientas de red y VBoxManage como funciones para controlar VMs desde el anfitrión (Oracle, s. f.). En producción, el problema de VirtualBox no es que no pueda arrancar servidores, sino la menor superficie de operación empresarial integrada: clúster, políticas, soporte y mantenimiento a escala. Por ello, los centros de datos tienden a usar ESXi, Hyper-V o KVM en vez de una aplicación de escritorio. La elección se justifica por gestión y continuidad operativa, no por una promesa absoluta de rendimiento.

### Pregunta 3 — Investigación de casos

Impacto TIC reportó que, durante el evento *The Next Move*, Eduardo Espinel, director de Data Center de Ilkari Colombia, presentó la migración de 700 máquinas virtuales desde VMware a Proxmox para un cliente que desarrolla aplicaciones digitales de consumo masivo (Diaz, 2026). Según el artículo, el costo de licenciamiento presionaba la viabilidad financiera del servicio. El equipo hizo un piloto para revisar rendimiento, latencia y conectividad; luego trasladó las máquinas por etapas, automatizando trabajos nocturnos para reducir el impacto operativo. Espinel informó un ahorro del 60 % en licencias. El artículo no revela el nombre del cliente y esa cifra corresponde al licenciamiento, no al costo total de tecnología ni a un resultado auditado de todos los gastos.

El caso muestra que el reto no es solo convertir discos: hay que validar cada arquitectura de VM, sus aplicaciones, redes y rendimiento, y coordinar el cambio para mantener los servicios disponibles. La fuente indica que hubo tropiezos, pero no publica cuáles fueron ni detalla tiempos de indisponibilidad; no se deben completar esos vacíos con suposiciones. Como análisis, la escala de 700 VM hace razonable usar inventario, piloto, lotes pequeños, respaldos verificados y un plan de reversión antes de mover cargas críticas. El 60 % informado es una referencia del caso, no una promesa transferible a otra empresa: el ahorro neto también depende de soporte, personal, operación y mantenimiento. Aunque el cliente permanece anónimo, el reportaje identifica al proveedor que presentó el caso y ofrece una escala y un resultado financiero concretos.

## Referencias

Adams, K., & Agesen, O. (2006). A comparison of software and hardware techniques for x86 virtualization. *Proceedings of the 12th International Conference on Architectural Support for Programming Languages and Operating Systems*, 2–13. https://doi.org/10.1145/1168857.1168860

Amazon Web Services. (2024). *The security design of the AWS Nitro System*. https://docs.aws.amazon.com/whitepapers/latest/security-design-of-aws-nitro-system/security-design-of-aws-nitro-system.html

Barham, P., Dragovic, B., Fraser, K., Hand, S., Harris, T., Ho, A., Neugebauer, R., Pratt, I., & Warfield, A. (2003). Xen and the art of virtualization. *Proceedings of the 19th ACM Symposium on Operating Systems Principles*, 164–177. https://doi.org/10.1145/945445.945462

Bhargava, R., Serebrin, B., Spadini, F., & Manne, S. (2008). Accelerating two-dimensional page walks for virtualized systems. *Proceedings of the 13th International Conference on Architectural Support for Programming Languages and Operating Systems*, 26–35. https://doi.org/10.1145/1346281.1346285

Broadcom. (2023, November 22). *Broadcom Inc. completes acquisition of VMware*. https://news.broadcom.com/2023-11-22-Broadcom-Inc-Completes-Acquisition-of-VMware

Diaz, E. (2026, 28 de octubre). *Migración de VMware: el 86 % busca alternativas*. Impacto TIC. https://impactotic.co/formatos/noticias-tic/migracion-de-vmware-alternativas-proxmox/

gem5 Project. (s. f.). *gem5 documentation*. https://www.gem5.org/documentation/

Microsoft. (2025). *Dynamic Memory for Hyper-V virtual machines*. Microsoft Learn. https://learn.microsoft.com/en-us/windows-server/virtualization/hyper-v/dynamic-memory

Microsoft. (s. f.). *Hyper-V architecture*. Microsoft Learn. https://learn.microsoft.com/en-us/windows-server/virtualization/hyper-v/architecture

Oracle. (s. f.). *Oracle VM VirtualBox User Manual: Virtual networking and VBoxManage*. https://www.virtualbox.org/manual/ch06.html

Proxmox Server Solutions. (s. f.). *Migrate to Proxmox VE*. https://pve.proxmox.com/wiki/Migrate_to_Proxmox_VE

QEMU Project. (s. f.). *System emulation*. https://www.qemu.org/docs/master/system/introduction.html

VMware. (s. f.). *VMware vSphere*. https://www.vmware.com/products/cloud-infrastructure/vsphere
