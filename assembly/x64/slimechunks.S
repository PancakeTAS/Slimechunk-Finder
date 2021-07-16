.global main
main:
    xor %RDI, %RDI
    # X - Z
    xor %RAX, %RAX
    mov $0x1A4, %RBX
    mov $0x45, %RCX
    # (xPosition * xPosition * 0x4c1906) + (xPosition * 0x5ac0db) + (zPosition * zPosition) * 0x4307a7 + (zPosition * 0x5f24f)
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
    mov %RAX, %RSI
    # Prepare values
loop:
    inc %RDI
    mov %RDI, %RAX
    # Action: worldseed + (xPosition * xPosition * 0x4c1906) + (xPosition * 0x5ac0db) + (zPosition * zPosition) * 0x4307a7 + (zPosition * 0x5f24f) ^ 0x3ad8025f;
    add %RSI, %RAX
    xor $0x3ad8025f, %RAX
    # Action:   (seed ^ multiplier) & mask;
    mov $0x5DEECE66DL, %RCX
    mov $0xffffffffffff, %RBX
    xor %RCX, %RAX
    and %RBX, %RAX
    # Action:   ((scrambled_seed * multiplier + addend) & mask) >>> 17;
    imul %RCX, %RAX
    add $0xBL, %RAX
    and %RBX, %RAX
    shr $0x11, %RAX
    # Action:   EAX % 10
    xor %EDX, %EDX
    xor %RCX, %RCX
    mov $0xA, %ECX
    div %ECX
    jmp loop