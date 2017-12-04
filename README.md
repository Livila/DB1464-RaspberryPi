# DB1464-RaspberryPi
Coding with Raspberry Pi.

## gdb
Some info on how to use gdb.

`gdb file` - Start debugging.

`break code filename:line number` - (b) Set a breakpoint in a specific file at a line number.

`break function name` - (b) Set a breakpoint on a specific function.

`info registers` - (i) View all current registers.

`info break` - (i) View a list of current breakpoints.

`disable id` - Disable a breakpoint.

`enable id` - Enable a breakpoint.

`delete id` - (del) (clear) Delete a breakpoint.

`run` - Run the file and start debugging.

`next` - (n) Go forward.

`step` - (s) Step forward.

`continue` - (c) Continue running the program until the next breakpoint.

## Links with more info

- https://sourceware.org/gdb/onlinedocs/gdb/

- https://cs.brown.edu/courses/cs033/docs/guides/x64_cheatsheet.pdf

## Older info

as -o main.o main.s && gcc -g -o main main.o && gdb main

Use: gcc -g -o main main.s && gdb main

http://cessa.khu.ac.ir/wp-content/uploads/2015/12/Computer-Organization-and-Design-5th-Edition-Patterson-Hennessy.pdf

Machine instructions
   http://flint.cs.yale.edu/cs421/papers/x86-asm/asm.html

Book about assembly
   https://en.wikibooks.org/wiki/X86_Assembly
   https://en.wikibooks.org/wiki/X86_Assembly/GAS_Syntax

Introduction to x64 Assembly
   https://software.intel.com/en-us/articles/introduction-to-x64-assembly
