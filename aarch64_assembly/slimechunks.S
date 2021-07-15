.section .text.boot
.global _start

_start:
    eor x15, x15, x15
    ldr x14, =0xA
    ldr x13, =0x4c1906
    ldr x12, =0x5ac0db
    ldr x11, =0x4307a7
    ldr x10, =0x5f24f
    ldr x9, =0x3ad8025f
loop:
    mov x1, 0x5
    mov x2, 0x6
    mov x3, 0x7
    mov x5, x1
    add x15, x15, 0x1
    bl slime_seed
    bl scramble_seed
    bl next_int
    bl mod_10
    bl loop
    # Uncomment this to exit after finding a chunk
    # cmp 0x00, r4
    # jne loop
    bl end

# In:       x1 = seed
# Out:      x1 = scrambled seed
# Action:   (seed ^ multiplier) & mask;
scramble_seed:
    eor x1, x1, x14
    and x1, x1, 0xffffffffffff
    ret
# return to execution

# ============================

# In:       x1 = scrambled seed
# Out:      x1 = next integer
# Action:   ((scrambled_seed * multiplier + addend) & mask) >>> 16;
next_int:
    mul x1, x1, x14
    add x1, x1, 0xBL
    and x1, x1, 0xffffffffffff
    lsr x1, x1, 0x11
    ret 
# return to execution

# ============================

# In:       x1 = Integer
# Out:      x4 = Integer mod 10
# Action:   x1 % 10
mod_10:
    udiv x1, x1, x14
    msub x4, x2, x14, x1
    ret
# return to execution

# ============================

# In:       x1 = Worldseed
#           x2 = Chunk X
#           x3 = Chunk Z
# Out:      x1 = RNG-Seed
# Action: worldseed + (xPosition * xPosition * 0x4c1906) + (xPosition * 0x5ac0db) + (zPosition * zPosition) * 0x4307a7 + (zPosition * 0x5f24f) ^ 0x3ad8025f;
slime_seed:
    mov x4, x2
    mul x4, x4, x4
    mul x4, x4, x13
    add x1, x4, x1
    mov x4, x2
    mul x4, x4, x12
    add x1, x4, x1
    mov x4, x3
    mul x4, x4, x4
    mul x4, x4, x11
    add x1, x4, x1
    mov x4, x3
    mul x4, x4, x10
    add x1, x4, x1
    eor x1, x1, x9
    ret
# return to execution

# ============================

end:
