# Noctal - NASM Helper Library
___Noctal___ is a helper library, for beginners trying to program in assembly using the __NASM__ assembler and __Linux syscalls__ (64bit)

This is specially useful to those who have been programming in some high level language before and want to get to know the computers at a deeper level. This gives them a friendly handshake with the language one step higher than the binary itself.

## How to assemble using NASM
To use ___Noctal___ in your code, you will have to download the [`std_notcal.asm`](https://github.com/najmiter/Noctal/blob/main/src/std_noctal.asm) and [`std_noctalm.asm`](https://github.com/najmiter/Noctal/blob/main/src/std_noctalm.asm) files into your wokring directory as well. Then include `std_noctal.asm` in your `main.asm`. Then, considering, your `asm` file name is `main`, you can use the following commands from your working directory:

`nasm -felf64 main.asm -o main && ld main -o a.out && ./a.out`

## Functions
Currently, it has the following procedures/functions/subroutines/labels/everything_else. 

| Functions | Inputs | Outputs | Description |
|:----------|:-------|:--------|:------------|
| `std__strlen` | The string (`RSI`) | The length (`RDX`) | Finds the length of a null-terminated string |
| `std__cout` | The string (`RSI`) | `void` | Prints a null-terminated string to the console |
| `std__to_string` | Number (`RAX`),<br>Output string (`RSI`) | Output string (`RSI`),<br>The length (`RDX`) | Converts an integer into a string |
| `std__printa` | The number (`RAX`) | `void` | Prints an integer to the console |
| `std__sort` | The pointer to the array (`RSI`),<br>Size of the array (`RDX`) | Sorted array (`RSI`) | Sorts a 64-bit integer array using the selection sort algorithm |

