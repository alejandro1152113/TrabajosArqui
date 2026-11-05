# Pre-contenido — Manejo de pantalla y teclado

**Arquitectura de Computadores · Unidad 7**  
**Estudiante:** González López  
**Entrega:** Pre7-U7

## Parte 1 — Interrupciones de software y el BIOS

### Pregunta 1 — Predicción de consecuencias

Al instalar el TSR, la nueva rutina queda como destino de INT 09h, la interrupción de hardware asociada con IRQ1. Si la rutina consume la interrupción y retorna sin encadenar el manejador anterior ni enviar su propio EOI, el trabajo normal del BIOS no ocurre: no se lee el código pendiente del puerto 60h para actualizar el buffer circular de teclas y el PIC 8259 conserva IRQ1 en estado de servicio. Mientras esa condición persista, el controlador puede retener o acumular datos y el PIC no volverá a atender IRQ1 de la forma esperada. Por tanto, las aplicaciones que consultan el buffer mediante INT 16h dejarán de recibir nuevas pulsaciones; no necesariamente se detendrán el reloj ni todas las interrupciones del sistema, porque IRQ0 tiene mayor prioridad. La consecuencia observable más probable es un teclado que deja de responder, posiblemente después de una sola pulsación. Si el vector quedó reemplazado por un TSR residente, reiniciar puede ser la única recuperación práctica.

El caso de un hook de INT 21h es distinto: esa es una interrupción de software invocada por una aplicación, no una IRQ del PIC. Omitir el encadenamiento puede dejar sin servicio la función interceptada o alterar su resultado, pero no deja IRQ1 en servicio ni impide por sí mismo que el BIOS procese el teclado. El fallo afecta llamadas DOS que pasan por ese hook, no el mecanismo de interrupción de hardware del teclado. Esta diferencia se desprende de separar la cadena de interrupciones de software de la atención de IRQ1 por el BIOS y el PIC (IBM, 1981; Brown, 2000; Schulman et al., 1990).

### Pregunta 2 — Toma de decisión con justificación

Para registrar escrituras DOS dirigidas a la salida estándar, se elegiría interceptar y encadenar INT 21h/AH=40h. En DOS 2 y posteriores, los procesos reciben handles estándar; el handle 1 representa STDOUT y DOS puede asociarlo con la pantalla o con un archivo redirigido. La función 40h incluye el handle, la dirección del búfer y la longitud, por lo que permite identificar una escritura por handle y conservar los bytes exactos. El mecanismo respeta mejor la redirección: si la salida está dirigida a un archivo, el registro observa la misma operación lógica del proceso, en vez de forzarla a la pantalla. INT 10h, en cambio, observa las operaciones que llegan al BIOS de video, incluso algunas emitidas directamente por una aplicación, pero no las que DOS redirige a un archivo ni las escrituras directas a B800h.

Ninguna ruta cubre todo el software. Una aplicación que escribe a B800h evita ambas interrupciones; una que usa INT 10h evita la intercepción de INT 21h; y una que escribe a un handle distinto de 1 no sería capturada por el filtro propuesto. Aun así, INT 21h/AH=40h es la opción más coherente para aplicaciones DOS que respetan la interfaz del sistema y la redirección. El TSR debe encadenar la llamada original y evitar invocar servicios DOS de archivo mientras DOS ya está ocupado; puede almacenar temporalmente los datos y escribirlos en un momento seguro. La semántica de la función y el soporte de redirección están descritos por la documentación de DOS y la lista técnica de interrupciones (Microsoft, 1986; Brown, 2000; Schulman et al., 1990).

### Pregunta 3 — Síntesis

Una calculadora residente puede combinar los tres mecanismos porque cada uno resuelve una necesidad distinta. El TSR instala un hook de INT 09h para reconocer la combinación de activación mientras otro programa está en primer plano. La rutina debe preservar los registros y el estado que utiliza, actualizar una bandera de activación y mantener el procesamiento normal encadenando el manejador que estaba instalado antes; si no lo hace, puede interrumpir la lectura ordinaria del teclado. La lógica extensa de la calculadora no debería ejecutarse directamente en el contexto de la interrupción.

Cuando llega un momento seguro para mostrar la calculadora, el programa puede guardar las celdas que va a cubrir, dibujar su ventana escribiendo caracteres y atributos directamente en B800h, y restaurar la pantalla al cerrarse. La escritura directa facilita una actualización localizada y rápida, aunque supone modo texto y compatibilidad con el adaptador. Por último, INT 21h/AH=40h escribe los resultados en un handle. Si se usa STDOUT (handle 1), DOS puede redirigirlo; si se abre un archivo de log específico, el handle apunta a ese archivo y la redirección de STDOUT no cambia por sí sola el destino.

Con solo el hook de INT 09h, la utilidad podría detectar la combinación, pero no tendría una interfaz visual ni un mecanismo de persistencia del historial. Los tres recursos, por tanto, no son intercambiables: el hook detecta el evento, B800h dibuja y restaura la ventana, y los handles de DOS gestionan la salida. Esta separación coincide con el modelo documentado de interrupciones, video y archivos en DOS (IBM, 1981; Microsoft, 1986; Schulman et al., 1990).

## Parte 2 — Modo texto y memoria de video

### Pregunta 1 — Análisis comparativo

En un adaptador CGA original, el procesador y el controlador CRT (CRTC) comparten el acceso a la memoria de video durante el barrido de pantalla. Una escritura directa a B800h en el momento de una lectura del CRTC puede producir el efecto visible conocido como *snow*. Para evitarlo, un programa histórico podía sincronizar las escrituras con el período de retrazo consultando el registro de estado en el puerto 3DAh; el bit 0 indica que el despliegue no está activo. Esa espera exige sondeo y añade latencia: cada actualización debe esperar una ventana segura, que no siempre basta para escribir una pantalla completa.

Los adaptadores EGA/VGA implementaron un acceso a memoria de video que evita el artefacto CGA, mediante mecanismos internos de almacenamiento y arbitraje; no es correcto concluir que el antiguo problema se resolvía solo haciendo el código más rápido. En el VGA emulado por DOSBox, el programa de laboratorio puede escribir directamente en B800h sin implementar la espera de CGA. Si el mismo código sin sincronización se ejecutara hipotéticamente en un CGA, las escrituras coincidentes con el barrido podrían producir nieve; la frecuencia y visibilidad dependerían del momento y del hardware, no significan que cada escritura necesariamente falle.

La comparación muestra que una dirección de memoria mapeada no describe por sí sola el comportamiento temporal del periférico. El diseño del adaptador, la contención del bus y la temporización de la pantalla también importan. La documentación técnica de IBM para CGA y la literatura de arquitectura de PC describen esta limitación y la evolución posterior del subsistema de video (IBM, 1983; IBM, 1987; Mueller, 2002).

### Pregunta 2 — Investigación de casos

El *page flipping* separa la página visible de la página en la que se dibuja el siguiente cuadro. En modo texto color, cada celda ocupa dos bytes y una pantalla de 80×25 usa 4000 bytes. Una página de 4 KiB comienza cada 1000h bytes dentro de B800h. Mientras la página 0 continúa visible, el programa puede preparar la página 1 y luego seleccionar esta última con INT 10h/AH=05h. El BIOS actualiza la página activa y el punto de inicio de lectura del CRTC; así, la presentación cambia sin copiar las 4000 celdas. La dirección del CRTC se expresa en unidades de celda/palabra en modo texto: el inicio de la segunda página corresponde a 0800h unidades de palabra, aunque su desplazamiento de bytes en B800h sea 1000h.

La función BIOS es simple y portable dentro de los modos compatibles, pero puede introducir latencia. Un programa que programa directamente los registros de índice/datos 0Ch/0Dh del CRTC en 3D4h/3D5h evita esa llamada y puede sincronizar el cambio con el retrazo vertical leyendo el bit 3 de 3DAh. A cambio, asume el adaptador, sus registros y su modo de video, y debe gestionar la sincronización correctamente. En 32 KiB de memoria de video, ocho páginas de 4 KiB consumen toda la región; no queda espacio para una novena página ni para una segunda copia completa de cada una.

Microsoft QuickBASIC documenta el principio en software DOS: su instrucción `SCREEN` permite fijar página activa y visible para dibujar fuera de pantalla y luego mostrar la imagen, evitando parpadeo. El ejemplo corresponde a modos gráficos, no prueba que una aplicación almacenara dos pantallas de texto en B800h. La distinción evita confundir el cambio de página general con el formato del modo texto (Microsoft, 1990; IBM, 1987; Brown, 2000).

### Pregunta 3 — Reflexión crítica

La analogía entre el registro de dirección de inicio del CRTC y el *page flip* moderno es válida en el principio, no en todos los detalles. En ambos casos se dibuja en un recurso que no se está mostrando y se cambia qué recurso consume el dispositivo de salida. Si el cambio ocurre en el momento apropiado del refresco, se evita mostrar una imagen compuesta por partes de dos cuadros. El inicio de página del CRTC permite hacer ese cambio en una pantalla de texto con una actualización pequeña del estado del adaptador, sin copiar carácter por carácter el contenido preparado.

La escala moderna es muy distinta: un búfer gráfico puede contener millones de píxeles y varios formatos; una cadena de presentación administra varios buffers, sincronización entre CPU y GPU, colas, fences y la composición del escritorio. APIs como Vulkan hacen explícita la adquisición y presentación de imágenes de una swapchain, mientras que B800h ofrece páginas de memoria de tamaño fijo y un mecanismo de hardware mucho más sencillo. Además, un cambio de puntero no garantiza por sí solo baja latencia: importan el instante de presentación y la cola de cuadros pendientes.

Estudiar B800h sí aporta una base conceptual útil. Permite distinguir dibujar del presentar, comprender por qué copiar no es siempre necesario y razonar sobre *tearing* cuando la pantalla lee un buffer durante una actualización. La analogía también enseña sus límites: sincronizar el cambio con el retrazo no equivale a controlar todas las colas de una GPU moderna. La documentación de IBM, Microsoft y Khronos permite comparar el mecanismo histórico con las interfaces actuales (IBM, 1987; Microsoft, 2024; Khronos Group, 2024).

## Referencias

Brown, R. (2000). *Ralf Brown's Interrupt List* (Release 61). https://fd.lod.bz/rbil/

IBM. (1981). *IBM Personal Computer technical reference*. IBM.

IBM. (1983). *Color/Graphics Monitor Adapter technical reference*. IBM.

IBM. (1987). *Video Graphics Array technical reference*. IBM.

Khronos Group. (2024). *Vulkan 1.3 specification: Window system integration*. https://registry.khronos.org/vulkan/specs/1.3-extensions/html/chap34.html

Microsoft. (1986). *MS-DOS programmer's reference*. Microsoft Press.

Microsoft. (1990). *Microsoft QuickBASIC 4.5: Basic language reference*. Microsoft Corporation.

Microsoft. (2024). *Flip model*. Microsoft Learn. https://learn.microsoft.com/en-us/windows/win32/direct3ddxgi/dxgi-flip-model

Mueller, S. (2002). *Upgrading and repairing PCs* (14th ed.). Que.

Schulman, A., Brown, R., Maxey, D., Michels, R. J., & Kyle, J. C. (1990). *Undocumented DOS: A programmer's guide to reserved MS-DOS functions and data structures*. Addison-Wesley.
