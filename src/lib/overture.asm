#subruledef reg {
    r0 => 0
    sc => 0
    ja => 0

    r1 => 1
    c0 => 1

    r2 => 2
    c1 => 2

    r3 => 3
    co => 3
    jc => 3

    r4 => 4
    r5 => 5

    in => 6
    out => 6
}

#subruledef movSrc {
    {reg: reg} => {
        assert(reg == 0)
        0`0
    }
    {reg: reg} => {
        assert(reg != 0)
        asm { mov {reg}, r0 }
    }
}

#subruledef mathop {
    nand => 0
    or => 1
    and => 2
    nor => 3
    add => 4
    sub => 5
}

#subruledef mathsrc {
    {imm: i6} => imm
    {reg: reg} => reg
}

#subruledef mathsrcA {
    {imm: i6} => asm { mov c0, {imm} }
    {reg: reg} => {
        assert(reg == 1)
        0`0
    }
    {reg: reg} => {
        assert(reg != 1)
        asm { mov c0, {reg} }
    }
}

#subruledef mathsrcB {
    {imm: i6} => asm { mov c1, {imm} }
    {reg: reg} => {
        assert(reg == 2)
        0`0
    }
    {reg: reg} => {
        assert(reg != 2)
        asm { mov c1, {reg} }
    }
}

#subruledef mathsrcC {
    {reg: reg} => {
        assert(reg == 3)
        0`0
    }
    {reg: reg} => {
        assert(reg != 3)
        asm { mov {reg}, co }
    }
}

#subruledef jumps {
    jmp => 1
    jz => 2
    jnz => 3
    jlt => 4
    jge => 5
    jle => 6
    jgt => 7
}

#subruledef jumpSrc {
    {reg: reg} => {
        assert(reg == 3)
        0`0
    }
    {reg: reg} => {
        assert(reg != 3)
        asm { mov jc, {reg} }
    }
}

#ruledef {
    mov {dst: movSrc}, {imm: i6} => 0b00 @ imm @ dst
    mov {dst: reg}, {src: reg} => 0b10 @ src`3 @ dst`3

    {op: mathop} {a: mathsrcA}, {b: mathsrcB}, {dst: mathsrcC} => a @ b @ 1`2 @ op`6 @ dst
    {op: mathop} {a: mathsrcA}, {b: mathsrcB} => a @ b @ 1`2 @ op`6

    nop => 0b11 @ 0`6

    {op: jumps} {reg: jumpSrc}, {addr: i6} => reg @ asm { mov ja, {addr} } @ 0b11000 @ op`3
    {op: jumps} {addr: i6} => asm { mov ja, {addr} } @ 0b11000 @ op`3
}