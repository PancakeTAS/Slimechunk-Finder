#include "slimechunks.h"

uint64_t calculateXZSeed(uint32_t x, uint32_t z) {
    return (x * x * 0x4c1906) + (x * 0x5ac0db) + (z * z) * 0x4307a7 + (z * 0x5f24f);
}

/*
uint64_t pow(uint64_t e, uint64_t u) {
    uint64_t ret = 1;
    for (int i = 0; i < u; i++) {
        ret *= e;
    }
    return ret;
}

uint64_t readnumber() {
    uint64_t ret;
    uint8_t buf[21] = {0};
    uint8_t buf2[21] = {0};
    uint8_t offset = 0;
    uintn_t index;
    efi_input_key_t key;
    for (int i = 20; i; i--) {
        for (;;) {
            if (ST->ConIn->ReadKeyStroke(ST->ConIn, &key) == EFI_SUCCESS)
                break;
        }
        if (key.UnicodeChar == 0x000D)
            offset = i;
            break;
        if (key.UnicodeChar >= '0' && key.UnicodeChar <= '9')
            ST->ConOut->OutputString(ST->ConOut, &key.UnicodeChar);
            buf[i] = (uint8_t)key.UnicodeChar - '0';
    }
    for (int i = 21; i > offset; i--) {
        uint16_t test;
        test = buf[i] + '0';
        ret += buf[i] * pow(10, i - offset + 1);
        ST->ConOut->OutputString(ST->ConOut, &test);
    }
    return ret;
}
*/

uint64_t pow(uint64_t e, uint64_t u) {
    uint64_t ret = 1;
    for (int i = 0; i < u; i++) {
        ret *= e;
    }
    return ret;
}

uint64_t readnumber() {
    uint64_t ret = 0;
    uint64_t offset = 1000000000;
    efi_input_key_t key;
    for (int i = 10; i; i--) {
        for (;;) {
            if (ST->ConIn->ReadKeyStroke(ST->ConIn, &key) == EFI_SUCCESS)
                break;
        }
        if (key.UnicodeChar == 0x000D) {
            ret /= pow(10, i);
            break;
        } else if (key.UnicodeChar >= '0' && key.UnicodeChar <= '9') {
            uint16_t char_buf[2] = {0};
            char_buf[0] = key.UnicodeChar;
            ST->ConOut->OutputString(ST->ConOut, &char_buf[0]);
            uint8_t in = (uint8_t)key.UnicodeChar - '0';
            ret += (offset * in);
            offset /= 10;
        }
    }
    printf("\nPlease wait..\n");
    return ret;
}

int seedfinder() {
    uint64_t seedsCounted = 0;
    uint64_t seedsFound = 0;
    uint64_t worldPositionSeed = calculateXZSeed(420, 69);
    printf("Enter an amount of Seeds to check\nEnter in millions: ");
    uint64_t seedsRequested = readnumber();
    seedsRequested *= 1000000;
    /* Optimizations start here */
    while (seedsCounted < seedsRequested) {
        uint64_t rngSeed = seedsCounted + worldPositionSeed ^ 0x3ad8025f;
        uint64_t internalSeed = (rngSeed ^ 0x5DEECE66D) & 0xffffffffffff;
        uint64_t nextBoundInt = ((internalSeed * 0x5DEECE66D + 0xB) & 0xffffffffffff) >> 17;
        seedsFound += (nextBoundInt % 10) == 0 ? 1 : 0;
        seedsCounted++;
    }
    /* Optimizations end (but don't have to) here */
    printf("The Program ran through %d seeds, and %d seeds had a slime chunk at X: 420, Z: 69\n", seedsCounted, seedsFound);
}
