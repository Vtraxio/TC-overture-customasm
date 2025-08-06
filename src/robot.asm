#include "lib/overture.asm"

#const left = 0
#const forward = 1
#const right = 2

loop:
    mov out, forward
    mov out, left
    ; turn right as long as there is a wall ahead
    .turnLoop:
        mov jc, in
        jz loop
        ; there is a wall, we turn
        mov out, right
        jmp loop.turnLoop

        
