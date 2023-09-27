;;; Developed by Najam (@najmiter)
;;;;; FREE TO USE ANYWHERE (if it's worth it ofc :D)
;;;;;;; A small credit in the corner would be appreciated though :D

%include "stdm.asm"

section .data
    size_64t     equ 8
    EXIT         equ 60
    EXIT_SUCCESS equ 0

section .text
    global std__strlen          ; return the length of a string in RDX
    global std__cout            ; print a null terminated string to the console
    global std__to_string       ; convert an integer into a string pointed to by RSI
    global printa               ; print the value of RAX to the console


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;; std::strlen ;;;;;;;;;;;;;;;;;;;;;;
std__strlen:
    ; ----------------------------------------------------------------------
    ;    TAKES
    ;        ||------> 1. RSI => The string
    ;
    ;    GIVES
    ;        ||------> 1. RDX => The length of the string
    ;
    ; ----------------------------------------------------------------------

    push rsi
    xor rdx, rdx
    strlen:
        mov al, [rsi]
        inc rdx
        inc rsi

        cmp al, 0
        jne strlen

    pop rsi
    ret
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;; printf (std::cout) ;;;;;;;;;;;;;;;;;;;
std__cout:
    ; ----------------------------------------------------------------------
    ;    TAKES
    ;        ||------> 1. RSI => The string
    ;
    ;    GIVES (void)
    ;
    ; ----------------------------------------------------------------------

    
    ; rsi is holding the pointer to the string
    ; Save rsi's value for later
    call std__strlen

    ; Find the length of the string (null terminated)
    ; rdx will hold the length
    
    ; Get ready to make a system call
    mov rax, 1
    mov rdi, 1
    syscall

    ret
    

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;; to_string ;;;;;;;;;;;;;;;;;;;;;;;
std__to_string:
    ; ----------------------------------------------------------------------
    ;    TAKES
    ;        ||------> 1. RAX => Number
    ;                  2. RSI => Output string
    ;
    ;    GIVES
    ;        ||------> 1. RSI = Number as a string
    ;                  2. RDX = Length of the string (number of digits)
    ;
    ; ----------------------------------------------------------------------

    push rsi              ; Keep the output string pointer on the stack for later
    push rax              ; Keep the value of RAX on the stack because the next loop will change its value

    mov rdi, 1            ; For keeping the number of digits in the original number
    mov rcx, 1            ; For keeping the divisor
    mov rbx, 10           ; For dividing the number by ten in each iteration 
    get_divisor:
        xor rdx, rdx
        div rbx           ; Reduce the RAX by one digit
        
        cmp rax, 0        ; Compare RAX with zero
        je _after         ; Break the loop if equal
        imul rcx, 10      ; Otherwise increase the divisor (RCX) ten times
        inc rdi           ; Increment number of digits as well (RDI)
        jmp get_divisor   ; Unconditional jump to the first instruction of the 'loop'


    _after:
        pop rax           ; Get back the value of RAX from the stack
        push rdi          ; Put the number of digits on the stack for later

    to_string:
        xor rdx, rdx
        div rcx           ; Divide the number (RAX) by the divisor to get the first digit from the left

        add al, '0'       ; Add the base (48) to the digit because we want to store an ASCII string
        mov [rsi], al     ; Move the value into the string
        inc rsi           ; Increment the pointer to the next byte

        push rdx          ; Push the remaining part of the number onto the stack
        xor rdx, rdx      
        mov rax, rcx     
        mov rbx, 10       
        div rbx           ; Reduce the divisor (RCX) ten times
        mov rcx, rax      ; Put the new divisor back into (RCX)

        pop rax           ; Pop the top the stack into (RAX). It's the remaining part of the number
        
        cmp rcx, 0        ; See if the divisor has become zero
        jg to_string      ; If not, repeat the same process

    pop rdx               ; Pop the top of the stack into (RDX). It's the value of (RDI): the number of digits in the original number
    pop rsi               ; Bring (RSI) to the beginning of the string before returning as well
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;; print_RAX ;;;;;;;;;;;;;;;;;;;;;;;

printa:
section .bss 
    _char resb 2

section .text
%macro writechr 1
    mov rax, 1
    mov rdi, 1
    mov rsi, %1
    mov rdx, 1
    syscall
%endmacro
    pushaq
    push rax      

    mov rcx, 1            
    mov r10, 10           
    get_divisor:
        xor rdx, rdx
        div r10           
        
        cmp rax, 0        
        je _after         
        imul rcx, 10      
        jmp get_divisor   

    _after:
        pop rax           

    to_string:
        xor rdx, rdx
        div rcx           
        
        push rdx      
        push rcx

        add al, '0'       
        mov [_char], al    

        writechr _char

        pop rcx
        xor rdx, rdx      
        mov rax, rcx     
        div r10
        mov rcx, rax     

        pop rax           
        
        cmp rcx, 0        
        jg to_string      

    mov byte [_char], 10
    writechr _char

    popaq
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;; sort_64array ;;;;;;;;;;;;;;;;;;;;;;

std__sort:
section .data
    elem_size      dq 8
    
    array_ptr      dq 0
    min_p          dq 0  ; to store the index of next minimum value in the array
    outer_boundary dq 0  ; outer loop boundary
    inner_boundary dq 0  ; inner loop boundary
    
section .text
    pushaq
    mov [array_ptr],  rsi
    
    ;; for (i < size - 1)
    mov [outer_boundary], rdx
    sub [outer_boundary], rcx

    ;; for (j < size)
    mov [inner_boundary], rdx

    ;; r8 will be used as 'i'
    xor r8, r8 
    outer_loop:
        mov rsi, [array_ptr]
        add rsi, r8      
        mov rdx, rsi
        
        ;; r9 will be used as 'j'
        mov r9, r8
        add r9, [elem_size]
        
        ;; rdi is pointer at 'j'
        inner_loop:
            mov rdi, [array_ptr]
            add rdi, r9     ; (array + j)

            mov rax, [rdi]  ; array[j]
            mov rbx, [rdx]  ; array[min_p]

            cmp rax, rbx
            jl if_less
            jmp cont
            
            if_less:
                mov rdx, rdi
            cont:
                add r9, [elem_size]
                cmp r9, [inner_boundary]
        jl inner_loop

        
        mov r10, [rsi]
        mov r11, [rdx]
        
        mov [rsi], r11
        mov [rdx], r10

        add r8, [elem_size]
        cmp r8, [outer_boundary]
    jl outer_loop
    
    popaq
ret


