#include <stdio.h>
#include <stdint.h>
#include <stdio.h>
#include <sys/time.h>

uint64_t calculateXZSeed(uint32_t x, uint32_t z) {
    return (x * x * 0x4c1906) + (x * 0x5ac0db) + (z * z) * 0x4307a7 + (z * 0x5f24f);
}

int main() {
    uint64_t seedsCounted = 0;
    uint64_t seedsFound = 0;
    uint64_t worldPositionSeed = calculateXZSeed(420, 69);
    uint64_t seedsRequested;
    printf("Enter an amount of Seeds to check\nEnter in millions: ");
    scanf("%lu", &seedsRequested);
    seedsRequested *= 1000000;
    struct timeval stop, start;
    gettimeofday(&start, 0);
    /* Optimizations start here */
    while (seedsCounted < seedsRequested) {
        uint64_t rngSeed = seedsCounted + worldPositionSeed ^ 0x3ad8025f;
        uint64_t internalSeed = (rngSeed ^ 0x5DEECE66D) & 0xffffffffffff;
        uint64_t nextBoundInt = ((internalSeed * 0x5DEECE66D + 0xB) & 0xffffffffffff) >> 17;
        seedsFound += (nextBoundInt % 10) == 0 ? 1 : 0;
        seedsCounted++;
    }
    /* Optimizations end (but don't have to) here */
    gettimeofday(&stop, NULL);
    uint64_t microsTime = (stop.tv_sec - start.tv_sec) * 1000000 + stop.tv_usec - start.tv_usec;
    printf("The Program ran through %lu seeds, and %lu seeds had a slime chunk at X: 420, Z: 69\n", seedsCounted, seedsFound);
    printf("The program ran for %lu microseconds or %lu milliseconds.\n", microsTime, microsTime / 1000);
}
