section .bss
    buffer resb 1024

section .text
    global _start

_start:
    pop rdi
    mov rsi, rsp
    cmp rdi, 2
    jl .no_shift_param
    mov rbx, [rsi + 8]
    call atoi
    mov r12, rax
    mov rax, r12
    mov rbx, 26
    cqo
    idiv rbx
    mov r12, rdx
    test r12, r12
    jge .read_input
    add r12, 26

.no_shift_param:
    mov rax, 60
    mov rdi, 1
    syscall

.read_input:
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
    jb .check_upper
    cmp al, 'z'
    ja .check_upper
    sub al, 'a'
    add al, r12b
    xor ah, ah
    mov bl, 26
    div bl
    mov al, ah
    add al, 'a'
    jmp .store

.check_upper:
    cmp al, 'A'
    jb .store
    cmp al, 'Z'
    ja .store
    sub al, 'A'
    add al, r12b
    xor ah, ah
    mov bl, 26
    div bl
    mov al, ah
    add al, 'A'

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

atoi:
    xor rax, rax
    xor rcx, rcx
    mov r8, 1
    movzx rdx, byte [rbx + rcx]
    cmp rdx, '+'
    je .sign_plus
    cmp rdx, '-'
    jne .digits
    mov r8, -1
    inc rcx
    jmp .digits
.sign_plus:
    inc rcx
.digits:
    movzx rdx, byte [rbx + rcx]
    cmp rdx, 0
    je .done_atoi
    cmp rdx, '0'
    jb .done_atoi
    cmp rdx, '9'
    ja .done_atoi
    sub rdx, '0'
    imul rax, rax, 10
    add rax, rdx
    inc rcx
    jmp .digits
.done_atoi:
    cmp r8, 1
    je .ret_atoi
    neg rax
.ret_atoi:
    ret
