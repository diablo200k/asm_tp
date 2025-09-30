section .data
    message db "Hello Universe!", 10
    message_len equ $ - message

section .text
global _start
_start:
    mov rax, [rsp]
    cmp rax, 2
    jl .exit_error
    
    mov rdi, [rsp + 16]
    
    mov rax, 2
    mov rsi, 0101o
    mov rdx, 0644o
    syscall
    
    cmp rax, 0
    jl .exit_error
    
    mov rdi, rax
    
    mov rax, 1
    mov rsi, message
    mov rdx, message_len
    syscall
    
    mov rax, 3
    syscall
    
.exit_success:
    mov rax, 60
    xor rdi, rdi
    syscall
    
.exit_error:
    mov rax, 60
    mov rdi, 1
    syscall