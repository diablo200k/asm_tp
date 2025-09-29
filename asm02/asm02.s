section .bss
    buf resb 4

section .data
    msg db "1337", 10
    len equ $ - msg

section .text
    global _start

_start:
    mov rax, 0
    mov rdi, 0
    mov rsi, buf
    mov rdx, 4
    syscall

    cmp rax, 3
    jne not_42

    mov al, byte [buf]
    cmp al, '4'
    jne not_42

    mov al, byte [buf+1]
    cmp al, '2'
    jne not_42

    mov al, byte [buf+2]
    cmp al, 10
    jne not_42

    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, len
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall

not_42:
    mov rax, 60
    mov rdi, 1
    syscall