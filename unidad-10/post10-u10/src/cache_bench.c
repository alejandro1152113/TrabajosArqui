#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#define REPEAT 100

double bench_seq(size_t n_bytes) {
    volatile char *arr = malloc(n_bytes);
    if (!arr) return -1.0;
    memset((void *)arr, 1, n_bytes);
    struct timespec t0, t1;
    clock_gettime(CLOCK_MONOTONIC, &t0);
    for (int r = 0; r < REPEAT; r++)
        for (size_t i = 0; i < n_bytes; i++) (void)arr[i];
    clock_gettime(CLOCK_MONOTONIC, &t1);
    double ns = (t1.tv_sec-t0.tv_sec)*1e9+(t1.tv_nsec-t0.tv_nsec);
    free((void *)arr);
    return ns/(REPEAT*(double)n_bytes);
}

double bench_rand(size_t n_bytes) {
    size_t n = n_bytes/sizeof(int);
    int *arr = malloc(n*sizeof(int));
    size_t *idx = malloc(n*sizeof(size_t));
    if (!arr || !idx) return -1.0;
    for (size_t i=0;i<n;i++) { arr[i]=(int)i; idx[i]=i; }
    srand((unsigned)n_bytes);
    for (size_t i=n-1;i>0;i--) {
        size_t j=(size_t)(rand()%(i+1));
        size_t tmp=idx[i]; idx[i]=idx[j]; idx[j]=tmp;
    }
    struct timespec t0,t1;
    volatile long sum=0;
    clock_gettime(CLOCK_MONOTONIC,&t0);
    for(int r=0;r<REPEAT;r++)
        for(size_t i=0;i<n;i++) sum += arr[idx[i]];
    clock_gettime(CLOCK_MONOTONIC,&t1);
    free(arr); free(idx);
    double ns=(t1.tv_sec-t0.tv_sec)*1e9+(t1.tv_nsec-t0.tv_nsec);
    return ns/(REPEAT*(double)n);
}

double bench_stride(size_t n_bytes,size_t stride) {
    volatile char *arr=malloc(n_bytes);
    if(!arr) return -1.0;
    memset((void *)arr,1,n_bytes);
    size_t steps=n_bytes/stride;
    struct timespec t0,t1;
    clock_gettime(CLOCK_MONOTONIC,&t0);
    for(int r=0;r<REPEAT;r++)
        for(size_t i=0;i<steps;i++) (void)arr[(i*stride)%n_bytes];
    clock_gettime(CLOCK_MONOTONIC,&t1);
    free((void *)arr);
    double ns=(t1.tv_sec-t0.tv_sec)*1e9+(t1.tv_nsec-t0.tv_nsec);
    return ns/(REPEAT*(double)steps);
}

int main(void) {
    size_t sizes[]={4*1024,8*1024,16*1024,32*1024,64*1024,128*1024,256*1024,512*1024,1024*1024,4*1024*1024,16*1024*1024,64*1024*1024};
    printf("%-12s %12s %12s\n","Array KiB","Sec ns/byte","Rand ns/acceso");
    for(size_t i=0;i<sizeof(sizes)/sizeof(sizes[0]);i++) {
        double seq=bench_seq(sizes[i]);
        double ran=bench_rand(sizes[i]);
        printf("%-12zu %12.3f %12.3f\n",sizes[i]/1024,seq,ran);
    }
    printf("\n%-12s %12s\n","Stride","ns/acceso");
    printf("%-12s %12.3f\n","64 B",bench_stride(1024*1024,64));
    printf("%-12s %12.3f\n","4096 B",bench_stride(1024*1024,4096));
    return 0;
}
