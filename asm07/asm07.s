section .bss
buf resb 32

section .text
global _start

_start:
    mov rax, 0
    mov rdi, 0
    mov rsi, buf
    mov rdx, 32
    syscall

    xor rbx, rbx
    xor rcx, rcx
    xor r9, r9
    
    mov dl, byte [buf]
    cmp dl, '-'
    jne convert
    mov r9, 1
    inc rcx

convert:
    mov dl, byte [buf+rcx]
    cmp dl, 10
    je done_convert
    cmp dl, 13
    je done_convert
    test dl, dl
    jz done_convert
    cmp dl, '0'
    jb invalid_input
    cmp dl, '9'
    ja invalid_input
    sub dl, '0'
    imul rbx, rbx, 10
    movzx rdx, dl
    add rbx, rdx
    inc rcx
    jmp convert

done_convert:
    test r9, r9
    jz positive
    mov rax, 60
    mov rdi, 1
    syscall

positive:
    mov rax, rbx
    cmp rax, 2
    jl not_prime
    cmp rax, 2
    je is_prime

    test rax, 1
    jz not_prime

    mov rcx, 3
check_loop:
    mov rdx, 0
    mov r8, rax
    div rcx
    cmp rdx, 0
    je not_prime
    add rcx, 2
    mov rax, r8
    mov rdx, rcx
    imul rdx, rdx
    cmp rdx, r8
    jle check_loop

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