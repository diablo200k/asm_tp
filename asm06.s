section .bss
buf resb 20

section .text
global _start

_start:
    mov rbx, [rsp]
    cmp rbx, 3
    jne exit_error

    mov rsi, [rsp+16]
    mov rdi, [rsp+24]

    xor rax, rax
    xor rcx, rcx
atoi1:
    mov dl, byte [rsi+rcx]
    cmp dl, 0
    je atoi1_done
    sub dl, '0'
    imul rax, rax, 10
    add rax, rdx
    inc rcx
    jmp atoi1
atoi1_done:
    mov r8, rax

    xor rax, rax
    xor rcx, rcx
atoi2:
    mov dl, byte [rdi+rcx]
    cmp dl, 0
    je atoi2_done
    sub dl, '0'
    imul rax, rax, 10
    add rax, rdx
    inc rcx
    jmp atoi2
atoi2_done:
    add rax, r8

    mov rbx, rax
    lea rsi, [buf+19]
    mov rcx, 0
itoa:
    xor rdx, rdx
    mov rax, rbx
    mov rdi, 10
    div rdi
    add dl, '0'
    dec rsi
    mov [rsi], dl
    mov rbx, rax
    cmp rbx, 0
    jne itoa

    mov rdx, buf+20
    sub rdx, rsi
    mov rax, 1
    mov rdi, 1
    mov rsi, rsi
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall

exit_error:
    mov rax, 60
    mov rdi, 1
    syscall
