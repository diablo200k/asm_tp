section .bss
    buffer resb 65536

section .text
global _start
_start:
    mov     rbx, 0
.read_loop:
    mov     rax, 0
    mov     rdi, 0
    lea     rsi, [buffer+rbx]
    mov     rdx, 4096
    syscall
    cmp     rax, 0
    jle     .done_reading
    add     rbx, rax
    cmp     rbx, 65536
    jl      .read_loop
.done_reading:
    mov     rcx, rbx
    cmp     rcx, 0
    jle     .palindrome

    mov     rsi, buffer
    add     rsi, rcx
    dec     rsi

    cmp     byte [rsi], 10
    jne     .skip_nl
    dec     rsi
    dec     rcx
.skip_nl:

    mov     rdi, buffer
    mov     r8, rsi

.check_loop:
    cmp     rdi, r8
    jge     .palindrome

    mov     al, [rdi]
    mov     bl, [r8]
    cmp     al, bl
    jne     .not_palindrome

    inc     rdi
    dec     r8
    jmp     .check_loop

.palindrome:
    mov     rax, 60
    xor     rdi, rdi
    syscall

.not_palindrome:
    mov     rax, 60
    mov     rdi, 1
    syscall
