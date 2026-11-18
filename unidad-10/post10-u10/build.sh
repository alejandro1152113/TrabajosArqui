#!/bin/bash
set -e
mkdir -p bin
gcc -O0 -o bin/cache_bench src/cache_bench.c
gcc -O2 -o bin/mymaps src/mymaps.c
gcc -O0 -o bin/pagefault_demo src/pagefault_demo.c
gcc -O0 -o bin/mmap_fault_cost src/mmap_fault_cost.c
echo "Los cuatro programas se compilaron correctamente."
