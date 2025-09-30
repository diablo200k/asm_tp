section .bss
    buffer resb 1024

section .text
    global _start

_start:
    pop rdi
    mov rsi, rsp
    cmp rdi, 2
    jl .no_shift
    mov rbx, [rsi + 8]
    call atoi
    mov r12, rax
    jmp .read_input

.no_shift:
    xor r12, r12

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
.next_digit:
    movzx rdx, byte [rbx + rcx]
    cmp rdx, 0
    je .done_atoi
    sub rdx, '0'
    imul rax, rax, 10
    add rax, rdx
    inc rcx
    jmp .next_digit
.done_atoi:
    ret
