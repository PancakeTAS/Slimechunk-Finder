#include "uefi/uefi.h"

#ifndef SLIMECHUNKS_H_
#define SLIMECHUNKS_H_

uint64_t calculateXZSeed(uint32_t x, uint32_t z);
efi_time_t get_time();
uint64_t readnumber();
int seedfinder();

#endif