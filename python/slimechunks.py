import concurrent.futures
import time
from os import cpu_count

def seed(worldseed: int, seedpart: int):
    return ((((((worldseed + seedpart) ^ 0x3ad8025f) ^ 0x5DEECE66D) & 0xffffffffffff) * 0x5DEECE66D + 0xB & 0xffffffffffff) >> 17) % 10

xPosition = 420
zPosition = 69
seedpart = (xPosition * xPosition * 0x4c1906) + (xPosition * 0x5ac0db) + (zPosition * zPosition) * 0x4307a7 + (zPosition * 0x5f24f)

def save(g: int, f: int):
    num = 0    
    for i in range(g, f):
        num += 1 if seed(i, seedpart) == 0 else 0
    return f - g, num

result = []

start = time.time()

with concurrent.futures.ProcessPoolExecutor() as executor:
    for i in range(1, cpu_count() + 1):
        result.append(executor.submit(save, 1_000_000_000 // cpu_count() * (i - 1), 1_000_000_000 // cpu_count() * i))

end = time.time()

r = [0, 0]

for i in result:
    print(i.result())
    r[0] += i.result()[0]
    r[1] += i.result()[1]

print("Seeds found:", r[1])
print("Seeds checked:", r[0])
print("Seconds ran:", round(nd - start, 2))
print(round(r[0]/(end-start)), "seeds per second")
