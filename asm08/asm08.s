section .data
    usage_msg db "Usage: ./asm08 <N> <expected_sum>", 10, 0
    usage_len equ $ - usage_msg - 1
    newline db 10, 0

section .bss
    buffer resb 32

section .text
    global _start

_start:
    pop rax
    cmp rax, 3
    jne usage_error
    pop rdi
    pop rdi
    call atoi
    mov r12, rax
    pop rdi
    call atoi
    mov r13, rax
    xor r14, r14
    mov r15, 1

sum_loop:
    cmp r15, r12
    jge sum_done
    add r14, r15
    inc r15
    jmp sum_loop

sum_done:
    mov rdi, r14
    call print_number
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall
    cmp r14, r13
    je exit_success
    mov rax, 60
    mov rdi, 1
    syscall

exit_success:
    mov rax, 60
    mov rdi, 0
    syscall

usage_error:
    mov rax, 1
    mov rdi, 2
    mov rsi, usage_msg
    mov rdx, usage_len
    syscall
    mov rax, 60
    mov rdi, 1
    syscall

atoi:
    xor rax, rax
    xor rcx, rcx

atoi_loop:
    mov cl, [rdi]
    test cl, cl
    jz atoi_done
    cmp cl, '0'
    jl atoi_done
    cmp cl, '9'
    jg atoi_done
    sub cl, '0'
    imul rax, rax, 10
    add rax, rcx
    inc rdi
    jmp atoi_loop

atoi_done:
    ret

print_number:
    mov rax, rdi
    mov rsi, buffer + 31
    mov byte [rsi], 0
    dec rsi
    test rax, rax
    jnz convert_digits
    mov byte [rsi], '0'
    dec rsi
    jmp print_digits

convert_digits:
    mov rcx, 10

convert_loop:
    test rax, rax
    jz print_digits
    xor rdx, rdx
    div rcx
    add dl, '0'
    mov [rsi], dl
    dec rsi
    jmp convert_loop

print_digits:
    inc rsi
    mov rdx, buffer + 31
    sub rdx, rsi
    mov rax, 1
    mov rdi, 1
    syscall
    ret