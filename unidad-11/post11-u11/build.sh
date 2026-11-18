#!/bin/bash
set -e
mkdir -p bin
nvcc -O2 -o bin/vectorAdd src/vectorAdd.cu
nvcc -O2 -o bin/matMul src/matMul.cu
nvcc -O2 -o bin/vectorAddStream src/vectorAddStream.cu
echo "Los tres programas CUDA se compilaron correctamente."
