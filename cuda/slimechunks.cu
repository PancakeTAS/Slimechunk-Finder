#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/time.h>
#define WPS 0xD24932BDC6
#define OPTIMIZE_SPEED true

#if OPTIMIZE_SPEED
__global__ void find8seeds(uint64_t *hack) {
    long int i = blockIdx.x * 1024 + threadIdx.x;
    *hack = ((((((i + WPS ^ 0x3ad8025f) ^ 0x5DEECE66D) & 0xffffffffffff) * 0x5DEECE66D + 0xB) & 0xffffffffffff) >> 17) % 10;
    *hack += ((((((i+1 + WPS ^ 0x3ad8025f) ^ 0x5DEECE66D) & 0xffffffffffff) * 0x5DEECE66D + 0xB) & 0xffffffffffff) >> 17) % 10;
    *hack += ((((((i+2 + WPS ^ 0x3ad8025f) ^ 0x5DEECE66D) & 0xffffffffffff) * 0x5DEECE66D + 0xB) & 0xffffffffffff) >> 17) % 10;
    *hack += ((((((i+3 + WPS ^ 0x3ad8025f) ^ 0x5DEECE66D) & 0xffffffffffff) * 0x5DEECE66D + 0xB) & 0xffffffffffff) >> 17) % 10;
    *hack += ((((((i+4 + WPS ^ 0x3ad8025f) ^ 0x5DEECE66D) & 0xffffffffffff) * 0x5DEECE66D + 0xB) & 0xffffffffffff) >> 17) % 10;
    *hack += ((((((i+5 + WPS ^ 0x3ad8025f) ^ 0x5DEECE66D) & 0xffffffffffff) * 0x5DEECE66D + 0xB) & 0xffffffffffff) >> 17) % 10;
    *hack += ((((((i+6 + WPS ^ 0x3ad8025f) ^ 0x5DEECE66D) & 0xffffffffffff) * 0x5DEECE66D + 0xB) & 0xffffffffffff) >> 17) % 10;
    *hack += ((((((i+7 + WPS ^ 0x3ad8025f) ^ 0x5DEECE66D) & 0xffffffffffff) * 0x5DEECE66D + 0xB) & 0xffffffffffff) >> 17) % 10;
}
#else
__global__ void find8seeds(uint8_t *cuda_results) {
    long int i = blockIdx.x * 1024 + threadIdx.x;
    uint8_t result = 0x00;
    result |= ((uint8_t) (((((((i + WPS ^ 0x3ad8025f) ^ 0x5DEECE66D) & 0xffffffffffff) * 0x5DEECE66D + 0xB) & 0xffffffffffff) >> 17) % 10)) == 0 ? 0x01 : 0x00;
    result |= ((uint8_t) (((((((i+1 + WPS ^ 0x3ad8025f) ^ 0x5DEECE66D) & 0xffffffffffff) * 0x5DEECE66D + 0xB) & 0xffffffffffff) >> 17) % 10)) == 0 ? 0x02 : 0x00;
    result |= ((uint8_t) (((((((i+2 + WPS ^ 0x3ad8025f) ^ 0x5DEECE66D) & 0xffffffffffff) * 0x5DEECE66D + 0xB) & 0xffffffffffff) >> 17) % 10)) == 0 ? 0x04 : 0x00;
    result |= ((uint8_t) (((((((i+3 + WPS ^ 0x3ad8025f) ^ 0x5DEECE66D) & 0xffffffffffff) * 0x5DEECE66D + 0xB) & 0xffffffffffff) >> 17) % 10)) == 0 ? 0x08 : 0x00;
    result |= ((uint8_t) (((((((i+4 + WPS ^ 0x3ad8025f) ^ 0x5DEECE66D) & 0xffffffffffff) * 0x5DEECE66D + 0xB) & 0xffffffffffff) >> 17) % 10)) == 0 ? 0x10 : 0x00;
    result |= ((uint8_t) (((((((i+5 + WPS ^ 0x3ad8025f) ^ 0x5DEECE66D) & 0xffffffffffff) * 0x5DEECE66D + 0xB) & 0xffffffffffff) >> 17) % 10)) == 0 ? 0x20 : 0x00;
    result |= ((uint8_t) (((((((i+6 + WPS ^ 0x3ad8025f) ^ 0x5DEECE66D) & 0xffffffffffff) * 0x5DEECE66D + 0xB) & 0xffffffffffff) >> 17) % 10)) == 0 ? 0x40 : 0x00;
    result |= ((uint8_t) (((((((i+7 + WPS ^ 0x3ad8025f) ^ 0x5DEECE66D) & 0xffffffffffff) * 0x5DEECE66D + 0xB) & 0xffffffffffff) >> 17) % 10)) == 0 ? 0x80 : 0x00;
    cuda_results[i] = result;
}
#endif

int main() {
    uint64_t N;
    printf("Enter an amount of Seeds to check\nEnter in billions: ");
    scanf("%lu", &N);
    N *= 1000000000;
    N /= 8; // We calculate 8 bits instead of 1 bit as 1 byte
    #if !OPTIMIZE_SPEED
    printf("This action will take up %lu MB of ram.\n", (long) ((float) N / 1e+6));
    printf("If the program exceeds maximum gpu ram, it will return with incorrect results.\n");
    #endif
    struct timeval stop, start;
    printf("\nStarting..\n");
    #if OPTIMIZE_SPEED
    uint64_t *useless;
    cudaMalloc((void**)&useless, sizeof(uint64_t));
    find8seeds<<<(long) ((float) N / 1024),1024>>>(useless);
    #else
    uint8_t *cuda_results;
    uint8_t *results = (uint8_t*) malloc(sizeof(uint8_t) * N);
    cudaMalloc((void**)&cuda_results, sizeof(uint8_t) * N);
    find8seeds<<<(long) ((float) N / 1024),1024>>>(cuda_results);
    #endif
    gettimeofday(&start, 0);
    cudaDeviceSynchronize();
    gettimeofday(&stop, 0);
    printf("Program finished in %lu microseconds or %lu milliseconds\n", microsTime, (long)((float) microsTime / 1000));
    uint64_t microsTime = (stop.tv_sec - start.tv_sec) * 1000000 + stop.tv_usec - start.tv_usec;
    #if !OPTIMIZE_SPEED
    cudaMemcpy(results, cuda_results, sizeof(uint8_t) * N, cudaMemcpyDeviceToHost);
    cudaFree(cuda_results);
    uint64_t founds;
    for (uint64_t i = 0; i < N; i++) {
        founds += (results[i] & 0x01) == 1 ? 1 : 0;
        founds += (results[i] & 0x02) == 1 ? 1 : 0;
        founds += (results[i] & 0x04) == 1 ? 1 : 0;
        founds += (results[i] & 0x08) == 1 ? 1 : 0;
        founds += (results[i] & 0x10) == 1 ? 1 : 0;
        founds += (results[i] & 0x20) == 1 ? 1 : 0;
        founds += (results[i] & 0x40) == 1 ? 1 : 0;
        founds += (results[i] & 0x80) == 1 ? 1 : 0;
    }
    free(results * 8);
    printf("%d Seeds found.\n", founds);
    #endif
    return 0;
}