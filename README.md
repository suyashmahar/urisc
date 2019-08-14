![build-status](https://travis-ci.com/suyashmahar/urisc.svg?token=JoPidbExBPkazChjCZLp&branch=master)  
Ultra Reduced Instruction Set Computer (URISC)
====

Ultra Reduced Instruction Set Computers use extremely limited set of instructions, in this case just a single instruction, `subleq`.   More details on this is available in [docs/architecture/architecture.md](architecture/architecture.md)

Overview
----

This project contains:  
#### Hardware  
1. **[URISC core](src/urisc.sv)**. Implements the essential cpu stuff to execute instructions when supplied. URISC uses three clock cycles to execute an instruction (pos-edge).  
2. **[IO arbiter](src/ioArbiter.sv)**. Arbitrates the memory among the IO devices. Allows the VGA controller to read from the memory and the PS2 controller to write to the memory. Memory access is granted on a round-robin manner to all the registered IO devices (synthesis-time).
3. **VGA controller**. Standard VGA controller stuff, sync generator, frame buffer... . Currently non-functional 😢.  
4. **PS2 controller**. Standard PS2 controller to read the key-codes, convert them to ASCII and write to the key buffer.

#### Toolchain  
1. **Assembler**. The assembler is a [collection of python scripts](toolchain/python-based) that can take a program written in a custom assembly language and converts it to memory coefficient file (\*.coe) for the processor.  
The assembler provides complete support for recursive macro substitution, constant declaration, labels and importing other *.asm files.  
*Note: An experimental and incomplete [Haskell based assembler](toolchain/assembler.hs) also dwells in the toolchain directory.*  
2. **Tests and Examples**. The examples are limited at this stage, an attempt to implement the MIPS ISA with limited instruction support is available [here](tests/toolchain/mips.asm). This can be used to compile the infinite loop example available [here](tests/toolchain/sample.asm).  

 
Execution
----
Here is a (potato quality) video showing the execution of URISC core, the 8 LEDs from the right shows the PC in base 2.  
<img src="https://i.imgur.com/4b6M29h.jpg"/>


Contributor
----

[Suyash Mahar](https://suyashmahar.github.io)

