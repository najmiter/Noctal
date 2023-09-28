# Noctal - NASM Helper Library
___Noctal___ is a helper library, developed by me, for beginners trying to program in assembly using the __NASM__ assembler and __Linux syscalls__ (64bit)

This is specially useful to those who have been programming in some high level language before and want to get to know the computers at a deeper level. This gives them a friendly handshake with the language one step higher than the binary itself.

Currently, it has the following procedures/functions/subroutines/labels/everything_else. 

| Functions | Inputs | Outputs | Description |
|:----------|:-------|:--------|:------------|
| `std__strlen` | The string (`RSI`) | The length (`RDX`) | Finds the length of a null-terminated string |
| `std__cout` | The string (`RSI`) | `void` | Prints a null-terminated string to the console |
| `std__to_string` | Number (`RAX`),<br>Output string (`RSI`) | Output string (`RSI`),<br>The length (`RDX`) | Converts an integer into a string |
| `std__printa` | The number (`RAX`) | `void` | Prints an integer to the console |
| `std__sort` | The pointer to the array (`RSI`),<br>Size of the array (`RDX`) | Sorted array (`RSI`) | Sorts a 64-bit integer array using the selection sort algorithm |
