import time

def seed(worldseed: int, wp: int):
    return ((((((worldseed + wp) ^ 0x3ad8025f) ^ 0x5DEECE66D) & 0xffffffffffff) * 0x5DEECE66D + 0xB & 0xffffffffffff) >> 17) % 10

def save(f: int):
    num = 0
    xPosition = 420;
    zPosition = 69;
    wp = (xPosition * xPosition * 0x4c1906) + (xPosition * 0x5ac0db) + (zPosition * zPosition) * 0x4307a7 + (zPosition * 0x5f24f);
    for i in range(f):
        num += 1 if seed(i, wp) == 0 else 0
    return num, f

start = time.time()
r = save(100000000)
end = time.time()
print(r)
print(round(end - start, 2))