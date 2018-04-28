URISC architecture (based on subleq)
====

Instruction
----

[Wikipedia - One instruction set computers](https://en.wikipedia.org/wiki/One_instruction_set_computer#Subtract_and_branch_if_less_than_or_equal_to_zero)

```asm
subleq a, b, c
```

On every cycle following operations are performed:
1. `mem[b] = mem[b] - mem[a]`
2. if `mem[b] <= 0` goto c

Instruction Encoding
----

   0     bbbbb     bbbbb     bbbbb  
   ^       ^         ^         ^  
Unused     a         b         c  

