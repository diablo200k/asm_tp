section .bss
    buffer resb 1024

section .text
    global _start

_start:
    pop rdi
    mov rsi, rsp
    cmp rdi, 2
    jl exit_error
    mov rbx, [rsi + 8]
    call atoi
    mov r12, rax
    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 1024
    syscall
    mov r13, rax
    xor rcx, rcx
.loop:
    cmp rcx, r13
    jge .done
    mov al, [buffer + rcx]
    cmp al, 'a'
    jb .store
    cmp al, 'z'
    ja .store
    sub al, 'a'
    add al, r12b
    mov bl, 26
    xor ah, ah
    div bl
    mov al, ah
    add al, 'a'
.store:
    mov [buffer + rcx], al
    inc rcx
    jmp .loop
.done:
    mov rax, 1
    mov rdi, 1
    mov rsi, buffer
    mov rdx, r13
    syscall
    mov rax, 60
    xor rdi, rdi
    syscall

exit_error:
    mov rax, 60
    mov rdi, 1
    syscall

atoi:
    xor rax, rax
    xor rcx, rcx
.next_digit:
    movzx rdx, byte [rbx + rcx]
    cmp rdx, 0
    je .done
    sub rdx, '0'
    imul rax, rax, 10
    add rax, rdx
    inc rcx
    jmp .next_digit
.done:
    ret
