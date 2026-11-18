#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <stdbool.h>
#include <cuda_runtime.h>

#define TILE 16

__global__ void matMulNaive(const float *A, const float *B, float *C, int n) {
    int row = blockIdx.y * blockDim.y + threadIdx.y;
    int col = blockIdx.x * blockDim.x + threadIdx.x;
    if (row < n && col < n) {
        float sum = 0.0f;
        for (int k = 0; k < n; k++) sum += A[row*n+k] * B[k*n+col];
        C[row*n+col] = sum;
    }
}

__global__ void matMulTiled(const float *A, const float *B, float *C, int n) {
    __shared__ float sA[TILE][TILE];
    __shared__ float sB[TILE][TILE];
    int row = blockIdx.y * TILE + threadIdx.y;
    int col = blockIdx.x * TILE + threadIdx.x;
    float sum = 0.0f;

    for (int t = 0; t < (n + TILE - 1) / TILE; t++) {
        if (row < n && t*TILE + threadIdx.x < n)
            sA[threadIdx.y][threadIdx.x] = A[row*n+t*TILE+threadIdx.x];
        else
            sA[threadIdx.y][threadIdx.x] = 0.0f;
        if (col < n && t*TILE + threadIdx.y < n)
            sB[threadIdx.y][threadIdx.x] = B[(t*TILE+threadIdx.y)*n+col];
        else
            sB[threadIdx.y][threadIdx.x] = 0.0f;
        __syncthreads();
        for (int k = 0; k < TILE; k++)
            sum += sA[threadIdx.y][k] * sB[k][threadIdx.x];
        __syncthreads();
    }
    if (row < n && col < n) C[row*n+col] = sum;
}

#define CUDA_CHECK(call)                                                        \
    do {                                                                        \
        cudaError_t e = (call);                                                 \
        if (e != cudaSuccess) {                                                 \
            fprintf(stderr, "CUDA error %s:%d: %s\n", __FILE__, __LINE__,      \
                    cudaGetErrorString(e));                                     \
            exit(EXIT_FAILURE);                                                 \
        }                                                                       \
    } while (0)

static float benchKernel(int n, bool tiled) {
    size_t bytes = (size_t)n*n*sizeof(float);
    float *h_A=(float*)malloc(bytes), *h_B=(float*)malloc(bytes), *h_C=(float*)malloc(bytes);
    if (!h_A || !h_B || !h_C) exit(EXIT_FAILURE);
    for (int i=0;i<n*n;i++) { h_A[i]=(float)((i%n)+1); h_B[i]=(float)((i/n)+1); }
    float *d_A,*d_B,*d_C;
    CUDA_CHECK(cudaMalloc(&d_A,bytes)); CUDA_CHECK(cudaMalloc(&d_B,bytes)); CUDA_CHECK(cudaMalloc(&d_C,bytes));
    CUDA_CHECK(cudaMemcpy(d_A,h_A,bytes,cudaMemcpyHostToDevice));
    CUDA_CHECK(cudaMemcpy(d_B,h_B,bytes,cudaMemcpyHostToDevice));
    dim3 block(TILE,TILE), grid((n+TILE-1)/TILE,(n+TILE-1)/TILE);
    cudaEvent_t start,stop;
    CUDA_CHECK(cudaEventCreate(&start)); CUDA_CHECK(cudaEventCreate(&stop));
    CUDA_CHECK(cudaEventRecord(start));
    if (tiled) matMulTiled<<<grid,block>>>(d_A,d_B,d_C,n);
    else matMulNaive<<<grid,block>>>(d_A,d_B,d_C,n);
    CUDA_CHECK(cudaGetLastError());
    CUDA_CHECK(cudaEventRecord(stop)); CUDA_CHECK(cudaEventSynchronize(stop));
    float ms=0.0f; CUDA_CHECK(cudaEventElapsedTime(&ms,start,stop));
    CUDA_CHECK(cudaMemcpy(h_C,d_C,bytes,cudaMemcpyDeviceToHost));
    float cpuZero=0.0f;
    for(int k=0;k<n;k++) cpuZero += h_A[k] * h_B[k*n];
    if(fabs(h_C[0]-cpuZero)>1e-3f)
        fprintf(stderr,"Error de validacion N=%d\n",n);
    CUDA_CHECK(cudaEventDestroy(start)); CUDA_CHECK(cudaEventDestroy(stop));
    CUDA_CHECK(cudaFree(d_A)); CUDA_CHECK(cudaFree(d_B)); CUDA_CHECK(cudaFree(d_C));
    free(h_A); free(h_B); free(h_C);
    return ms;
}

int main(void) {
    for (int n=512;n<=1024;n*=2) {
        float naive=benchKernel(n,false);
        float tiled=benchKernel(n,true);
        printf("N=%d naive=%.3f ms tiled=%.3f ms speedup=%.2fx\n",n,naive,tiled,naive/tiled);
    }
    return 0;
}
