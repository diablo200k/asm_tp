section .data
    newline db 10

section .text
    global _start

_start:
    mov rbx, [rsp]         
    cmp rbx, 2            
    jne exit_error         

    mov rsi, [rsp+16]
    test rsi, rsi
    jz exit_error
   
    xor rcx, rcx           
.len_loop:
    mov al, byte [rsi+rcx]
    cmp al, 0
    je .len_done
    inc rcx
    jmp .len_loop
.len_done:

    mov rax, 1             
    mov rdi, 1            
    mov rdx, rcx           
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall

exit_error:
    mov rax, 60
    mov rdi, 1
    syscall