#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int global_data = 42;
const char *msg = "hola";

int main(void) {
    void *heap = malloc(1024 * 1024);
    if (!heap) return 1;
    printf("PID: %d\n", getpid());
    printf("stack var addr: %p\n", (void *)&heap);
    printf("heap addr:      %p\n", heap);
    printf("global addr:    %p\n", (void *)&global_data);
    printf("Presione Enter para continuar...\n");
    fflush(stdout);
    getchar();
    free(heap);
    return 0;
}
