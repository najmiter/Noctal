;;; Developed by Najam (@najmiter)
;;;;; FREE TO USE ANYWHERE (if it's worth it ofc :D)
;;;;;;; A small credit in the corner would be appreciated though :D

;;; Standard Macros ;;;

section .text

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
;;;;;;;;;;;;;;;;;; sort an array of size ;;;;;;;;;;;;;;;;

%macro sort 2
    mov rsi, %1
    mov rdx, %2
    call std__sort
%endmacro
