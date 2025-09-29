section .bss
buf resb 10

section .text
global _start

_start:
    mov rax, 0
    mov rdi, 0
    mov rsi, buf
    mov rdx, 10
    syscall

    xor rbx, rbx
    xor rcx, rcx
convert:
    mov dl, byte [buf+rcx]
    cmp dl, 10
    je done_convert
    cmp dl, '0'
    jb invalid_input
    cmp dl, '9'
    ja invalid_input
    sub dl, '0'
    imul rbx, rbx, 10
    add rbx, rdx
    inc rcx
    jmp convert
done_convert:
    mov rax, rbx
    cmp rax, 2
    jl not_prime
    cmp rax, 2
    je is_prime

    mov rcx, 2
check_loop:
    mov rdx, 0
    mov r8, rax
    div rcx
    cmp rdx, 0
    je not_prime
    inc rcx
    mov rax, r8
    cmp rcx, r8
    jl check_loop

is_prime:
    mov rax, 60
    xor rdi, rdi
    syscall

not_prime:
    mov rax, 60
    mov rdi, 1
    syscall

invalid_input:
    mov rax, 60
    mov rdi, 2
    syscall
