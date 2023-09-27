;;; Developed by Najam (@najmiter)
;;;;; FREE TO USE ANYWHERE (if it's worth it ofc :D)
;;;;;;; A small credit in the corner would be appreciated though :D

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
;;;;;;;;;;;;;;;;;;;;;;;;; MACROS ;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;; print a const string ;;;;;;;;;;;;;;;;;;

%macro println 1
section .data
    string db %1, 0

section .text
    mov rsi, string
    call std__cout    
%endmacro
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;; push all registers on stack ;;;;;;;;;;;;;;

%macro pushaq 0
    push rax
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi
    push rbp
    push rsp
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    push r14
    push r15
%endmacro
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;; pop all registers from stack ;;;;;;;;;;;;;

%macro popaq 0
    pop r15
    pop r14
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rsp
    pop rbp
    pop rdi
    pop rsi
    pop rdx
    pop rcx
    pop rbx
    pop rax
%endmacro

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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




