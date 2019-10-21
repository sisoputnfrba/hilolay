# Hilolay

Hilolay (se pronuncia "Hilo Light") es una pequeña biblioteca de ULTs con fines académicos.

Con ese objetivo en mente, Hilolay posee una interfaz interna bien definida que permite la implementación de múltiples metodologías de planificación de esos ULTs.

# Instalación

`make && sudo make install` 

# Interfaz de Hilolay
- `void hilolay_init(void)`
- `hilolay_create(hilolay_t *, const hilolay_attr_t *, void *(*start_routine)(void *), void *arg)`
- `hilolay_yield(void)`
- `hilolay_join(hilolay_t *)`
- `hilolay_get_tid(void)`
- `hilolay_wait(char *)`
- `hilolay_signal(char *)`
- `hilolay_return(int)`

# Interfaz Interna de Planificación

## Inicialización
A diferencia de la interfaz de funcionamiento y finalización, `hilolay_init` mantiene una dinámica de inversión de control. Es decir, toda implementación de `hilolay_init` deberá llamar a `init_internal` definido por Hilolay al terminar su ejecución.

Esto es así debido a que la tarea de inicialización de la biblioteca requiere conocer las _funciones de Funcionamiento_, dado que el programa principal debe convertirse, **en el primer ULT**. Eso implica que se debe llamar a `suse_create`, que hasta ese momento, no se encontraba definida por el programador que encuentre extendiendo la biblioteca.

Toda precondición necesaria para ejecutar correctamente esta extensión de planificación, debera ser inicializada en esta función.

## Funcionamiento
De forma análoga a otras bibliotecas de hilos, la interfaz plantea implementar las siguientes funciones a modo de que cada programador controle su propios metadatos de planificación y ejecución `suse_create`, `suse_wait` y `suse_signal`, debiendo responder de forma similar a sus implementaciones no-académicas.

Finalmente, también se deberá implementar `suse_schedule_next` quien determinará el próximo ULT que deberá ejecutarse, dado el contexto en el que se llame la misma.

## Finalización
Como mencionamos antes, las bibliotecas de hilos suelen implementar un _join_, el cual será realizado con `suse_join` para interactuar con la metadata. El mismo deberá marcar el thread como bloqueado hasta que termine.

Por otro lado, hilolay luego de cada finalización de un hilo, invocará a `suse_close` para asegurarse que la extensión de planificación pueda liberar los recursos que hayan sido tomados. Tener en cuenta que si luego de un `suse_close` no se posee ningún hilo activo, se deberá a proceder a liberar todos los recursos en uso para metadatos (conexiones, etc).

# Ejemplos de uso
Ver https://github.com/sisoputnfrba/hilolay-example

# SO Soportados
- macOS Mojave
- Ubuntu 16.04 LTS