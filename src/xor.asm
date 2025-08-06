#include "lib/overture.asm"

mov r4, in
mov r5, in
nand r4, r5, c0
nand c0, r4, r4
nand c0, r5, r5
nand r4, r5, out