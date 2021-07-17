#include <uefi.h>
#include "slimechunks.h"

int main(int argc, char **argv) {
    ST->ConOut->Reset(ST->ConOut, 0);
    while (1 == 1) {
        seedfinder();
    }
    return 0;
}