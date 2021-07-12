.global main
main:
    xor %RDI, %RDI
loop:
    inc %RDI
    # mov %0x10, %RAX | Use leftover RAX
    mov $0x1A4, %RBX
    mov $0x45, %RCX

# ============================

# In:       RAX = Worldseed
#           RBX = Chunk X
#           RCX = Chunk Z
# Out:      RAX = RNG-Seed
# Action: worldseed + (xPosition * xPosition * 0x4c1906) + (xPosition * 0x5ac0db) + (zPosition * zPosition) * 0x4307a7 + (zPosition * 0x5f24f) ^ 0x3ad8025f;
slime_seed:
    mov %RBX, %RDX
    imul %RDX, %RDX
    imul $0x4c1906, %RDX
    add %RDX, %RAX
    mov %RBX, %RDX
    imul $0x5ac0db, %RDX
    add %RDX, %RAX
    mov %RCX, %RDX
    imul %RDX, %RDX
    imul $0x4307a7, %RDX
    add %RDX, %RAX
    mov %RCX, %RDX
    imul $0x5f24f, %RDX
    add %RDX, %RAX
    xor $0x3ad8025f, %RAX

# In:       RAX = seed
# Out:      RAX = scrambled seed
# Action:   (seed ^ multiplier) & mask;
scramble_seed:
    mov $0x5DEECE66DL, %RBX
    xor %RBX, %RAX
    mov $0xffffffffffff, %RBX
    and %RBX, %RAX

# In:       RAX = scrambled seed
# Out:      EAX = next integer
# Action:   ((scrambled_seed * multiplier + addend) & mask) >>> 16;
next_int:
    mov $0x5DEECE66DL, %RBX
    imul %RBX, %RAX
    add $0xBL, %RAX
    mov $0xffffffffffff, %RBX
    and %RBX, %RAX
    shr $0x11, %RAX 

# In:       EAX = Integer
# Out:      EDX = Integer mod 10
# Action:   EAX % 10
mod_10:
    xor %EDX, %EDX
    xor %RCX, %RCX
    mov $0xA, %ECX
    div %ECX
    jmp loop