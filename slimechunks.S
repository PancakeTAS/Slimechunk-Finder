.global main
main:
    xor %RDI, %RDI
loop:
    # mov $0x5, %RAX | Use leftover RAX :)
    mov $0x6, %RBX
    mov $0x7, %RCX
    mov %RAX, %RSI
    inc %RDI
    call slime_seed
    call scramble_seed
    call next_int
    call mod_10
    jmp loop
    # Uncomment this to exit after finding a chunk
    # cmp $0x00, %EDX
    # jne main
    jmp end

# ============================

# In:       RAX = seed
# Out:      RAX = scrambled seed
# Action:   (seed ^ multiplier) & mask;
scramble_seed:
    mov $0x5DEECE66DL, %RBX
    mov $0xffffffffffff, %RCX
    xor %RBX, %RAX
    and %RCX, %RAX
    ret
# return to execution

# ============================

# In:       RAX = scrambled seed
# Out:      EAX = next integer
# Action:   ((scrambled_seed * multiplier + addend) & mask) >>> 16;
next_int:
    mov $0x5DEECE66DL, %RBX
    mov $0xBL, %RCX
    mov $0xffffffffffff, %RDX
    imul %RBX, %RAX
    add %RCX, %RAX
    and %RDX, %RAX
    shr $0x11, %RAX 
    ret 
# return to execution

# ============================

# In:       EAX = Integer
# Out:      EDX = Integer mod 10
# Action:   EAX % 10
mod_10:
    xor %EDX, %EDX
    xor %RCX, %RCX
    mov $0xA, %ECX
    div %ECX
    ret
# return to execution

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
    ret
# return to execution

# ============================

end: