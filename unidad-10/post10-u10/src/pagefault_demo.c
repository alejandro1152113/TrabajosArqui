#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

static void print_memory_status(const char *label) {
    FILE *status = fopen("/proc/self/status", "r");
    char line[256];
    if (!status) {
        perror("fopen /proc/self/status");
        return;
    }
    printf("%s:\n", label);
    while (fgets(line, sizeof(line), status)) {
        if (strncmp(line, "VmRSS:", 6) == 0 ||
            strncmp(line, "VmPeak:", 7) == 0 ||
            strncmp(line, "VmSize:", 7) == 0) {
            fputs(line, stdout);
        }
    }
    fclose(status);
}

int main(void) {
    size_t N = 100 * 1024 * 1024;
    char *buf = (char *)malloc(N);
    if (!buf) return 1;
    print_memory_status("Antes de tocar la memoria");
    memset(buf, 0xAA, N);
    print_memory_status("Despues de escribir 100 MB");
    free(buf);
    return 0;
}
