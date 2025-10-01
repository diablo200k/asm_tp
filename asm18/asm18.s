section .data
    server_addr:
        dw 2
        dw 0x3930
        dd 0x0100007F
        times 8 db 0
    
    send_msg db "PING", 0
    send_len equ 4
    
    timeout_msg db "Timeout: no response from server", 10
    timeout_len equ 33
    
    recv_prefix db "message: ", 34
    prefix_len equ 10
    
    quote db 34, 10
    quote_len equ 2

section .bss
    buffer resb 1024
    sockfd resq 1
    timeval:
        tv_sec resq 1
        tv_usec resq 1

section .text
global _start
_start:
    mov rax, 41
    mov rdi, 2
    mov rsi, 2
    xor rdx, rdx
    syscall
    
    cmp rax, 0
    jl .exit_error
    
    mov [sockfd], rax
    
    mov qword [tv_sec], 2
    mov qword [tv_usec], 0
    
    mov rax, 54
    mov rdi, [sockfd]
    mov rsi, 1
    mov rdx, 20
    mov r10, timeval
    mov r8, 16
    syscall
    
    mov rax, 44
    mov rdi, [sockfd]
    mov rsi, send_msg
    mov rdx, send_len
    xor r10, r10
    mov r8, server_addr
    mov r9, 16
    syscall
    
    mov rax, 45
    mov rdi, [sockfd]
    mov rsi, buffer
    mov rdx, 1024
    xor r10, r10
    xor r8, r8
    xor r9, r9
    syscall
    
    cmp rax, 0
    jle .timeout_error
    
    mov r12, rax
    
    mov rax, 1
    mov rdi, 1
    mov rsi, recv_prefix
    mov rdx, prefix_len
    syscall
    
    mov rax, 1
    mov rdi, 1
    mov rsi, buffer
    mov rdx, r12
    syscall
    
    mov rax, 1
    mov rdi, 1
    mov rsi, quote
    mov rdx, quote_len
    syscall
    
    mov rax, 3
    mov rdi, [sockfd]
    syscall
    
.exit_success:
    mov rax, 60
    xor rdi, rdi
    syscall
    
.timeout_error:
    mov rax, 1
    mov rdi, 1
    mov rsi, timeout_msg
    mov rdx, timeout_len
    syscall
    
    mov rax, 3
    mov rdi, [sockfd]
    syscall
    
.exit_error:
    mov rax, 60
    mov rdi, 1
    syscall