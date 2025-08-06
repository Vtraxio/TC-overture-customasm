; Unfinished since the in game assembler for symphony is actually nice to use.

#subruledef reg {
    zr => 0
    r1 => 1
    r2 => 2
    r3 => 3
    r4 => 4
    r5 => 5
    r6 => 6
    r7 => 7
    r8 => 8
    r9 => 9
    r10 => 10
    r11 => 11
    r12 => 12
    r13 => 13
    sp => 14
    flags => 15
}

#subruledef mathOp {
    nand => 0
    or => 1
    and => 2
    nor => 3
    add => 4
    sub => 5
    xor => 6
    lsl => 7
    lsr => 8
    mul => 10
}

#subruledef jumpOp {
    jmp => 0

    je => 1
    jne => 9

    jl => 4
    jge => 12
    jle => 5
    jg => 13

    jb => 2
    jae => 10
    jbe => 3
    ja => 11
}

#subruledef ramLoadOp {
    load_8    => 0b0000
    load_16   => 0b0010
    pload_8   => 0b0100
    pload_16  => 0b0110
}

#subruledef ramStoreOp {
    store_8   => 0b0001
    store_16  => 0b0011   
    pstore_8  => 0b0101
    pstore_16 => 0b0111
}

#ruledef {
    nop => 0`1 @ 0`2 @ 0`1 @ 0`4 @ 0`4 @ 0`4 @ 0`4 @ 0`4 @ 0`8

    in {dst: reg} =>       0`1 @ 0`2 @ 0`1 @ 1`4 @ dst`4 @ 0`4 @ 0`4 @ 0`4 @ 0`8
    out {a: reg} =>        0`1 @ 0`2 @ 0`1 @ 2`4 @ 0`4   @ 0`4 @ 0`4 @ a`4 @ 0`8
    out {a: i16} =>        0`1 @ 0`2 @ 1`1 @ 2`4 @ 0`4   @ 0`4 @ a`16
    console {a: reg} =>    0`1 @ 0`2 @ 0`1 @ 3`4 @ 0`4   @ 0`4 @ 0`4 @ a`4 @ 0`8
    console {a: i16} =>    0`1 @ 0`2 @ 1`1 @ 3`4 @ 0`4   @ 0`4 @ a`16
    time_0 {dst: reg} =>   0`1 @ 0`2 @ 0`1 @ 4`4 @ dst`4 @ 0`4 @ 0`4 @ 0`4 @ 0`8
    time_1 {dst: reg} =>   0`1 @ 0`2 @ 0`1 @ 5`4 @ dst`4 @ 0`4 @ 0`4 @ 0`4 @ 0`8
    time_2 {dst: reg} =>   0`1 @ 0`2 @ 0`1 @ 6`4 @ dst`4 @ 0`4 @ 0`4 @ 0`4 @ 0`8
    time_3 {dst: reg} =>   0`1 @ 0`2 @ 0`1 @ 7`4 @ dst`4 @ 0`4 @ 0`4 @ 0`4 @ 0`8
    counter {dst: reg} =>  0`1 @ 0`2 @ 0`1 @ 8`4 @ dst`4 @ 0`4 @ 0`4 @ 0`4 @ 0`8
    keyboard {dst: reg} => 0`1 @ 0`2 @ 0`1 @ 9`4 @ dst`4 @ 0`4 @ 0`4 @ 0`4 @ 0`8

    {o: mathOp} {dst: reg}, {a: reg}, {b: reg} => 0`1 @ 1`2 @ 0`1 @ o`4 @ dst`4 @ a`4 @ 0`4 @ b`4 @ 0`8
    {o: mathOp} {dst: reg}, {a: reg}, {b: i16} => 0`1 @ 1`2 @ 1`1 @ o`4 @ dst`4 @ a`4 @ b`16
    cmp {a: reg}, {b: reg}                     => 0`1 @ 1`2 @ 0`1 @ 9`4 @ 15`4  @ a`4 @ 0`4 @ b`4 @ 0`8
    cmp {a: reg}, {b: i16}                     => 0`1 @ 1`2 @ 1`1 @ 9`4 @ 15`4  @ a`4 @ b`16

    jmp {addr: reg}         => 0`1 @ 2`2 @ 0`1 @ o`4 @ 0`4 @ 15`4 @ 0`4 @ addr`4 @ 0`8
    {o: jumpOp} {addr: i16} => 0`1 @ 2`2 @ 1`1 @ o`4 @ 0`4 @ 15`4 @ addr`16

    {o: ramLoadOp} {dst: reg}, [{adr: reg}]  => 0`1 @ 3`2 @ 0`1 @ o`4 @ dst`4 @ 0`4   @ 0`4 @ adr`4 @ 0`8
    {o: ramLoadOp} {dst: reg}, [{imm: i16}]  => 0`1 @ 3`2 @ 1`1 @ o`4 @ dst`4 @ 0`4   @ imm`16   
    {o: ramStoreOp} [{adr: reg}], {src: reg} => 0`1 @ 3`2 @ 0`1 @ o`4 @ 0`4   @ src`4 @ 0`4 @ adr`4 @ 0`8
    {o: ramStoreOp} [{imm: i16}], {src: reg} => 0`1 @ 3`2 @ 1`1 @ o`4 @ 0`4   @ src`4 @ imm`16

    mov {dst: reg}, {src: reg} => asm { or {dst}, {src}, zr }
    mov {dst: reg}, {imm: i16} => asm { or {dst}, zr, {imm} }
    neg {dst: reg}, {src: reg} => asm { sub {dst}, zr, {src} }
    neg {dst: reg}, {imm: i16} => asm { sub {dst}, zr, {imm} }
    not {dst: reg}, {src: reg} => asm { nor {dst}, zr, {src} }
    not {dst: reg}, {imm: i16} => asm { nor {dst}, zr, {imm} }
}