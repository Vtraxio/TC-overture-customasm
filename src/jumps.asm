#include "lib/overture.asm"

loop:
    add r4, 1, r4
    sub in, 37
    jz end
    jmp loop

end:
    mov out, r4
