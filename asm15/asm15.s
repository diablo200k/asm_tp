section .bss
    buffer resb 64

section .text
global _start
_start:
    mov rax, [rsp]
    cmp rax, 2
    jl .exit_error
    
    mov rdi, [rsp + 16]
    
    mov rax, 2
    mov rsi, 0
    syscall
    
    cmp rax, 0
    jl .exit_error
    
    mov rdi, rax
    
    mov rax, 0
    mov rsi, buffer
    mov rdx, 64
    syscall
    
    cmp rax, 64
    jl .close_and_error
    
    mov al, [buffer]
    cmp al, 0x7F
    jne .close_and_error
    
    mov al, [buffer + 1]
    cmp al, 'E'
    jne .close_and_error
    
    mov al, [buffer + 2]
    cmp al, 'L'
    jne .close_and_error
    
    mov al, [buffer + 3]
    cmp al, 'F'
    jne .close_and_error
    
    mov al, [buffer + 4]
    cmp al, 2
    jne .close_and_error
    
    mov rax, 3
    syscall
    
.exit_success:
    mov rax, 60
    xor rdi, rdi
    syscall
    
.close_and_error:
    mov rax, 3
    syscall
    
.exit_error:
    mov rax, 60
    mov rdi, 1
    syscall