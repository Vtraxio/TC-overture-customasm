# Turing Complete with customasm

This repo contains the [customasm](https://github.com/hlorenzi/customasm) definition and solutions for the *overture*
architecture in [Turing Complete](https://store.steampowered.com/app/1444480/Turing_Complete/) ***in the alpha branch***.

I did not find the experience of writing overture assembly pleasant so i decided to spend a couple hours of my life
writing the definition file.

## Assembling
Since customasm doesn't support the format required by the alpha branch of TC i have made a simple script to convert it to such format.
`.\build.ps1 .\src\add5.asm` will assemble the file and put the result in the dist directory, which you can then copy into the TC assembler.

## Quick explanation of the definitions

If you look in [./src/lib/overture.asm](./src/lib/overture.asm) you'll see that it's way more complex than it should be for such a simple cpu,
this is because in game if you want to add 2 numbers for example you have to explicitly move them into register 1 and 2, and only then perform the operation,
using these definitions you can do something like:
```
add in, 5, out
```
<sub>(which is the solution to the add 5 level as you can probably tell)</sub>
<br>and it will automatically expand into the 5 instruction required.

### However
```
add c0, 5, out
```
This will expand to just 4 instructions.
```
add c0, c1, co
```
And this will just become a single add instruction.

So the complexity comes from the fact that the assembler will automatically detect if a specified value needs to be moved to a specific register.

---
Tbh i don't even know why i'm sharing this or even made it in the first place, i guess i just love waisting my time :)