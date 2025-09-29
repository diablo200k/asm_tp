section .bss
buf resb 20

section .text
global _start

_start:
    mov rax, [rsp]
    cmp rax, 3
    jne exit_error

    mov rsi, [rsp+16]
    mov rdi, [rsp+24]

    xor rax, rax
    xor rcx, rcx
    mov r8, 1
atoi1:
    mov dl, byte [rsi+rcx]
    cmp dl, 0
    je atoi1_done
    cmp dl, '-'
    jne atoi1_digit
    mov r8, -1
    inc rcx
    jmp atoi1
atoi1_digit:
    sub dl, '0'
    mov rdx, rax
    imul rax, rdx, 10
    add rax, rdx
    add rax, rdx
    add rax, rdx
    add rax, rdx
    add rax, rdx
    add rax, rdx
    add rax, rdx
    add rax, rdx
    add rax, rdx
    add rax, rdx
    inc rcx
    jmp atoi1
atoi1_done:
    imul rax, r8
    mov r8, rax

    xor rax, rax
    xor rcx, rcx
    mov r9, 1
atoi2:
    mov dl, byte [rdi+rcx]
    cmp dl, 0
    je atoi2_done
    cmp dl, '-'
    jne atoi2_digit
    mov r9, -1
    inc rcx
    jmp atoi2
atoi2_digit:
    sub dl, '0'
    mov rdx, rax
    imul rax, rdx, 10
    add rax, rdx
    add rax, rdx
    add rax, rdx
    add rax, rdx
    add rax, rdx
    add rax, rdx
    add rax, rdx
    add rax, rdx
    add rax, rdx
    add rax, rdx
    inc rcx
    jmp atoi2
atoi2_done:
    imul rax, r9
    add rax, r8
    mov rbx, rax

    lea rsi, [buf+19]
    mov r8, rbx
    cmp rbx, 0
    jge itoa_positive
    neg rbx
    mov byte [buf], '-'
itoa_positive:
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

    cmp r8, 0
    jge print
    lea rsi, [buf]
print:
    mov rdx, buf+20
    sub rdx, rsi
    mov rax, 1
    mov rdi, 1
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall

exit_error:
    mov rax, 60
    mov rdi, 1
    syscall
