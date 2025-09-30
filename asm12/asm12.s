section .bss
    buffer resb 1024

section .text
global _start
_start:
    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 1024
    syscall
    
    mov rcx, rax
    cmp rcx, 0
    jle .exit_success
    
    mov rsi, buffer
    add rsi, rcx
    dec rsi
    
    cmp byte [rsi], 10
    jne .skip_newline
    dec rsi
    dec rcx
    
.skip_newline:
    mov rdi, buffer
    mov rbx, 0
    
.reverse_loop:
    cmp rbx, rcx
    jge .print_result
    
    mov al, [rsi]
    mov [rdi], al
    
    dec rsi
    inc rdi
    inc rbx
    jmp .reverse_loop
    
.print_result:
    mov byte [rdi], 10
    inc rbx
    
    mov rax, 1
    mov rdi, 1
    mov rsi, buffer
    mov rdx, rbx
    syscall
    
.exit_success:
    mov rax, 60
    xor rdi, rdi
    syscall