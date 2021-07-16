#include <stdio.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <sys/time.h>

uint64_t calculateXZSeed(uint32_t x, uint32_t z) {
    return (x * x * 0x4c1906) + (x * 0x5ac0db) + (z * z) * 0x4307a7 + (z * 0x5f24f);
}

struct seedfinder_struct {
    uint64_t worldPositionSeed;
    uint64_t seedsOffset;
    uint64_t seedsRequested;
    uint64_t index;
}args;

void *runSeedfinder(void *args) {
    struct seedfinder_struct *arguments = (struct seedfinder_struct *)args;
    uint64_t worldPositionSeed = arguments -> worldPositionSeed;
    uint64_t seedsOffset = arguments -> seedsOffset;
    uint64_t seedsRequested = arguments -> seedsRequested;
    uint64_t index = arguments -> index;
    seedsRequested += seedsOffset;
    uint64_t seedsCounted = seedsOffset;
    uint64_t seedsFound = 0;
    struct timeval stop, start;
    gettimeofday(&start, 0);
    /* Optimizations start here */
    while (seedsCounted < seedsRequested) {
        seedsFound += (((((((seedsCounted + worldPositionSeed ^ 0x3ad8025f) ^ 0x5DEECE66D) & 0xffffffffffff) * 0x5DEECE66D + 0xB) & 0xffffffffffff) >> 17) % 10) == 0 ? 1 : 0;
        seedsCounted++;
    }
    gettimeofday(&stop, NULL);
    uint64_t microsTime = (stop.tv_sec - start.tv_sec) * 1000000 + stop.tv_usec - start.tv_usec;
    /* Optimizations end (but don't have to) here */
    printf("Thread %lu finished: %lu million seeds, %lu million matches and took %lu milliseconds\n", index, (seedsCounted - seedsOffset) / 1000000, seedsFound / 1000000, microsTime / 1000);
    pthread_exit(NULL);
}

int main() {
    uint64_t worldPositionSeed = calculateXZSeed(420, 69);
    uint64_t seedsRequested;
    uint64_t threads;
    printf("Enter an amount of Seeds to check\nEnter in billions: ");
    scanf("%lu", &seedsRequested);
    seedsRequested *= 1000000000;
    printf("Enter the amount of Threads to use: ");
    scanf("%lu", &threads);
    printf("\n");
    if (threads < 2) {
        printf("More threads...\n");
        return (-1);
    }
    uint64_t seedsPerThread = seedsRequested / threads;

    pthread_t tlist[threads];
    pthread_t ct;
    for (uint64_t threadIndex = 1; threadIndex < threads; threadIndex++) {
        struct seedfinder_struct* args = (struct seedfinder_struct *)malloc(sizeof(struct seedfinder_struct));
        args->worldPositionSeed = worldPositionSeed;
        args->seedsOffset = threadIndex * seedsPerThread;
        args->seedsRequested = seedsPerThread;
        args->index = threadIndex;
        pthread_create(&ct, NULL, runSeedfinder, (void *)args);
        tlist[threadIndex] = ct;
    }

    if (threads > 1) {
        struct seedfinder_struct* args = (struct seedfinder_struct *)malloc(sizeof(struct seedfinder_struct));
        args->worldPositionSeed = worldPositionSeed;
        args->seedsOffset = 0;
        args->seedsRequested = seedsPerThread;
        args->index = 0;
        runSeedfinder((void*)args);
    }

    for (uint64_t i = 0; i < threads; i++) {
        pthread_join(tlist[i], NULL);
    }
}