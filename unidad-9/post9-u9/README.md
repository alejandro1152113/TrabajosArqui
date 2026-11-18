# Post-contenido — Entrada y salida avanzados

**Arquitectura de Computadores · Unidad 9**  
**Estudiante:** González López  
**Repositorio:** [TrabajosArqui — post9-u9](https://github.com/alejandro1152113/TrabajosArqui/tree/main/unidad-9/post9-u9)  
**PDF:** [Gonzalez Lopez_Post9_U9.pdf](https://github.com/alejandro1152113/TrabajosArqui/blob/main/unidad-9/post9-u9/Gonzalez%20Lopez_Post9_U9.pdf)

## Entorno y compilacion

Se requieren DOSBox 0.74 o superior y NASM 2.x. Cada programa usa modo real y formato binario `.COM`.

Desde PowerShell, en esta carpeta:

```powershell
.\build.bat
```

Dentro de DOSBox:

```text
nasm -f bin TECL.ASM -o TECL.COM
TECL
```

Los archivos fuente estan en [`src/`](src/) y los ejecutables generados en [`bin/`](bin/).
El fuente `LPT1_PORT.ASM` genera `LPTTEST.com`; `LPT1` es un nombre de dispositivo reservado en Windows.

## Parte 1 - Puertos y polling

| Programa | Funcion | Resultado esperado |
|---|---|---|
| [`TECL.ASM`](src/TECL.ASM) | Lee el puerto 64h hasta que OBF sea uno y muestra el scancode. | Una pulsacion produce su valor hexadecimal. |
| [`POLL_T.ASM`](src/POLL_T.ASM) | Usa un contador fijo de reintentos sobre el puerto 64h. | Muestra timeout si no llega una pulsacion. |
| [`LPT1_PORT.ASM`](src/LPT1_PORT.ASM) | Espera el estado LPT1, escribe `A` y genera STROBE. | Compila y termina sin bloquear si BUSY esta siempre activo. |
| [`MULTI_ST.ASM`](src/MULTI_ST.ASM) | Combina con OR las banderas del teclado y LPT1. | Sale al activarse uno o ambos dispositivos. |

## Parte 2 - PIC 8259A e ISR

| Programa | Funcion | Resultado esperado |
|---|---|---|
| [`ISR_KB.ASM`](src/ISR_KB.ASM) | Instala un ISR propio para IRQ1 y lo restaura tras cinco pulsaciones. | Muestra cinco mensajes y luego restaura el handler. |
| [`MASK_KB.ASM`](src/MASK_KB.ASM) | Modifica el IMR para enmascarar IRQ1 aproximadamente tres segundos. | Las teclas no generan eventos visibles durante el intervalo. |
| [`ISR_CHAIN.ASM`](src/ISR_CHAIN.ASM) | Cuenta teclas y encadena con el handler original de INT 09h. | El sistema conserva el procesamiento normal del teclado. |
| [`ISR_TIME.ASM`](src/ISR_TIME.ASM) | Lee los ticks BIOS en 0040h:006Ch desde IRQ1 y los imprime. | Muestra ticks proporcionales al intervalo real entre pulsaciones. |

## Decision tecnica 1 - Polling sin limite o con timeout

Un bucle sin limite como el de `TECL.ASM` es aceptable solamente cuando existe la garantia operativa de que el dispositivo producira el evento esperado. Es util en una demostracion controlada en la que el usuario presiona una tecla poco despues de iniciar el programa o cuando la tarea no puede continuar sin una respuesta y el bloqueo es una forma valida de falla. En cambio, `POLL_T.ASM` resulta preferible en servicios, utilidades o programas que puedan operar sin el periférico, porque convierte una falla indefinida en un mensaje y permite ejecutar una ruta alternativa. Si `MAX_RETRY` se reduce demasiado, por ejemplo a cinco iteraciones, aparece el riesgo de falso timeout: el dispositivo puede estar sano, pero responder despues de que el contador haya llegado a cero. Ademas, un contador de iteraciones no mide tiempo real. Cada repeticion consume una cantidad de ciclos que depende de la velocidad de la CPU, de las instrucciones y del comportamiento del emulador. Por ello, esperar un segundo puede requerir numeros de vueltas muy distintos en dos equipos. En contraste, el contador de ticks almacenado por el BIOS permite calcular intervalos con un reloj independiente de cuantas instrucciones ejecuta el bucle, aunque su resolucion sea la del timer instalado.

## Decision tecnica 2 - OR frente a AND en banderas combinadas

`MULTI_ST.ASM` usa OR porque pretende salir ante el primer dispositivo listo. Si LPT1 informa el bit de listo en uno permanentemente, como puede ocurrir en DOSBox sin una impresora real, el bucle de OR se detiene en la primera iteracion sin esperar al teclado. La consecuencia practica es que la espera pierde su utilidad: el programa siempre considera satisfecho el evento sin representar la disponibilidad real del periférico. Por eso, despues de salir del bucle es necesario comprobar por separado las banderas `BL` y `BH`. El OR ya elimino informacion sobre cual condicion produjo el valor distinto de cero y solo conserva el hecho de que alguna fue verdadera. Una implementacion que usara AND esperaria que las dos banderas fueran simultaneamente uno. Esa estrategia seria apropiada como sincronizacion de encuentro, por ejemplo para no enviar un dato a una impresora hasta que el usuario haya elegido una accion y el periferico este listo. AND exige el cumplimiento simultaneo de ambas condiciones, mientras que OR selecciona el primer evento disponible.

## Decision tecnica 3 - Ubicacion del EOI en el ISR

El EOI debe enviarse al puerto `20h` despues de liberar y reconocer el hardware que originó la interrupcion y antes de un trabajo largo como imprimir texto. Si `ISR_KB.ASM` retrasa el EOI hasta despues de una impresion por INT 21h, el PIC mantiene la linea de fin de interrupcion sin indicar que el ISR anterior termino. Durante ese lapso, otras IRQ de igual o menor prioridad no pueden ser despachadas. En este laboratorio no se ejecuta `STI`; por tanto las interrupciones globales siguen deshabilitadas hasta `IRET`. Enviar el EOI temprano no evita por si solo la reentrada de IRQ1, porque IF sigue en cero, pero si reduce la latencia con que el PIC puede pasar a otra IRQ pendiente una vez que termine el reconocimento del hardware. Enviar el EOI demasiado tarde incrementa la latencia de otras interrupciones; enviarlo antes de procesar datos puede permitir que el PIC despache otro evento mientras el ISR aun usa el dispositivo, aunque aqui IF impide la ejecucion inmediata. `ISR_TIME.ASM` envia el EOI despues de leer el scancode, leer ticks y calcular el intervalo, justo antes de imprimir. Es el orden recomendado para minimizar la latencia de otras IRQ.

## Decision tecnica 4 - Polling frente a interrupcion

El polling de `TECL.ASM` ocupa el CPU al 100% mientras espera, por lo que resulta inaceptable en aplicaciones que deban animar una pantalla, procesar datos o atender otro periférico. El ISR de `ISR_KB.ASM` permite que el programa principal siga ejecutando instrucciones y se interrumpe solamente cuando IRQ1 se activa. En cuanto a latencia, el ISR responde en cuanto el hardware levanta la señal y entra en el manejador, salvo por la prioridad y el estado actual de las interrupciones; el polling solo observa una tecla cuando el programa vuelve a ejecutar el lazo, por lo que puede pasar mas tiempo entre la llegada del dato y su lectura. En un dispositivo lento y esporadico como el teclado, mantener el CPU en un lazo activo desperdicia ciclos aun si pasan minutos entre pulsaciones. Una interrupcion evita ese busy-wait y reserva el polling para esperas cortas en las que instalar y retirar un ISR no sea apropiado.

## Validacion

- Las capturas reales se registraran en [`capturas/`](capturas/).
- Antes de ejecutar un ISR, guardar el trabajo de DOSBox porque el handler puede quedar activo si se interrumpe de forma incorrecta.
- Siempre restaurar el vector original y enviar EOI antes de IRET.
