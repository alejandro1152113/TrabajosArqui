#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <cuda_runtime.h>

#define N (1 << 24)
#define NSTREAMS 4
#define CHUNK (N / NSTREAMS)

__global__ void vectorAddChunk(const float *A, const float *B, float *C, int n) {
    int idx=blockIdx.x*blockDim.x+threadIdx.x;
    if(idx<n) C[idx]=A[idx]+B[idx];
}

#define CUDA_CHECK(call)                                                        \
    do {                                                                        \
        cudaError_t e=(call);                                                   \
        if(e!=cudaSuccess) { fprintf(stderr,"CUDA error %s:%d: %s\n",__FILE__,__LINE__,cudaGetErrorString(e)); exit(EXIT_FAILURE); } \
    } while(0)

int main(void) {
    size_t bytes=(size_t)N*sizeof(float), chunkBytes=(size_t)CHUNK*sizeof(float);
    float *h_A,*h_B,*h_C;
    CUDA_CHECK(cudaHostAlloc(&h_A,bytes,cudaHostAllocDefault));
    CUDA_CHECK(cudaHostAlloc(&h_B,bytes,cudaHostAllocDefault));
    CUDA_CHECK(cudaHostAlloc(&h_C,bytes,cudaHostAllocDefault));
    for(int i=0;i<N;i++) { h_A[i]=(float)i*0.5f; h_B[i]=(float)i*1.5f; }
    float *d_A,*d_B,*d_C;
    CUDA_CHECK(cudaMalloc(&d_A,bytes)); CUDA_CHECK(cudaMalloc(&d_B,bytes)); CUDA_CHECK(cudaMalloc(&d_C,bytes));

    cudaEvent_t start,stop;
    CUDA_CHECK(cudaEventCreate(&start)); CUDA_CHECK(cudaEventCreate(&stop));
    int blockSize=256;
    CUDA_CHECK(cudaEventRecord(start));
    CUDA_CHECK(cudaMemcpy(d_A,h_A,bytes,cudaMemcpyHostToDevice));
    CUDA_CHECK(cudaMemcpy(d_B,h_B,bytes,cudaMemcpyHostToDevice));
    vectorAddChunk<<<(N+blockSize-1)/blockSize,blockSize>>>(d_A,d_B,d_C,N);
    CUDA_CHECK(cudaGetLastError());
    CUDA_CHECK(cudaMemcpy(h_C,d_C,bytes,cudaMemcpyDeviceToHost));
    CUDA_CHECK(cudaEventRecord(stop)); CUDA_CHECK(cudaEventSynchronize(stop));
    float syncMs=0.0f; CUDA_CHECK(cudaEventElapsedTime(&syncMs,start,stop));
    printf("Sincrono (H2D + kernel + D2H completos): %.2f ms\n",syncMs);

    cudaStream_t streams[NSTREAMS];
    for(int s=0;s<NSTREAMS;s++) CUDA_CHECK(cudaStreamCreate(&streams[s]));
    CUDA_CHECK(cudaEventRecord(start));
    int chunkGrid=(CHUNK+blockSize-1)/blockSize;
    for(int s=0;s<NSTREAMS;s++) {
        size_t off=(size_t)s*CHUNK;
        CUDA_CHECK(cudaMemcpyAsync(d_A+off,h_A+off,chunkBytes,cudaMemcpyHostToDevice,streams[s]));
        CUDA_CHECK(cudaMemcpyAsync(d_B+off,h_B+off,chunkBytes,cudaMemcpyHostToDevice,streams[s]));
        vectorAddChunk<<<chunkGrid,blockSize,0,streams[s]>>>(d_A+off,d_B+off,d_C+off,CHUNK);
        CUDA_CHECK(cudaGetLastError());
        CUDA_CHECK(cudaMemcpyAsync(h_C+off,d_C+off,chunkBytes,cudaMemcpyDeviceToHost,streams[s]));
    }
    for(int s=0;s<NSTREAMS;s++) CUDA_CHECK(cudaStreamSynchronize(streams[s]));
    CUDA_CHECK(cudaEventRecord(stop)); CUDA_CHECK(cudaEventSynchronize(stop));
    float asyncMs=0.0f; CUDA_CHECK(cudaEventElapsedTime(&asyncMs,start,stop));
    printf("Con streams (%d, solapado): %.2f ms\n",NSTREAMS,asyncMs);
    printf("Reduccion: %.1f%%\n",100.0*(syncMs-asyncMs)/syncMs);
    int errors=0;
    for(int i=0;i<N && errors<100;i++) {
        float expected=h_A[i]+h_B[i];
        if(fabs(h_C[i]-expected)>1e-4f) errors++;
    }
    printf("Errores con streams: %d\n",errors);

    for(int s=0;s<NSTREAMS;s++) CUDA_CHECK(cudaStreamDestroy(streams[s]));
    CUDA_CHECK(cudaEventDestroy(start)); CUDA_CHECK(cudaEventDestroy(stop));
    CUDA_CHECK(cudaFree(d_A)); CUDA_CHECK(cudaFree(d_B)); CUDA_CHECK(cudaFree(d_C));
    CUDA_CHECK(cudaFreeHost(h_A)); CUDA_CHECK(cudaFreeHost(h_B)); CUDA_CHECK(cudaFreeHost(h_C));
    return 0;
}
