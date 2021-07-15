from numba import njit
import time

@njit
def seed(worldseed: int, xPosition: int, zPosition: int):
    return (((((worldseed + (xPosition * xPosition * 0x4c1906) + (xPosition * 0x5ac0db) + (zPosition * zPosition) * 0x4307a7 + (zPosition * 0x5f24f) ^ 0x3ad8025f) ^ 0x5DEECE66D) & 0xffffffffffff) * 0x5DEECE66D + 0xB & 0xffffffffffff) >> 17) % 10

@njit
def save(f: int):
    for i in range(f):
        seed(i, 420, 69)
    return f

save(1)

start = time.time()
r = save(1000000000)
end = time.time()
print(round(r/round(end - start, 2))), "seeds per second") 
