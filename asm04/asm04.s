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

    test rax, rax
    jz invalid_input
    
    mov rsi, buf
    xor rcx, rcx
    xor r8, r8
    xor r9, r9
    
    movzx rax, byte [rsi]
    cmp al, '-'
    jne .check_plus
    mov r8, 1
    inc rsi
    jmp .parse_loop
    
.check_plus:
    cmp al, '+'
    jne .parse_loop
    inc rsi

.parse_loop:
    movzx rax, byte [rsi]
    
    cmp al, 10
    je .done
    cmp al, 13
    je .done
    test al, al
    jz .done
    
    cmp al, '0'
    jb invalid_input
    cmp al, '9'
    ja invalid_input
    
    sub al, '0'
    
    mov rdx, rcx
    imul rdx, 10
    jo overflow_detected
    
    movzx rbx, al
    add rdx, rbx
    jo overflow_detected
    
    cmp rdx, 2147483647
    ja overflow_detected
    
    mov rcx, rdx
    inc r9
    inc rsi
    jmp .parse_loop

.done:
    test r9, r9
    jz invalid_input
    
    test r8, r8
    jz .check_parity
    neg rcx

.check_parity:
    test rcx, 1
    jnz odd

even:
    mov rax, 60
    xor rdi, rdi
    syscall

odd:
    mov rax, 60
    mov rdi, 1
    syscall

invalid_input:
    mov rax, 60
    mov rdi, 2
    syscall

overflow_detected:
    mov rax, 60
    mov rdi, 2
    syscall