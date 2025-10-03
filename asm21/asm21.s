BITS 64
GLOBAL _start

SECTION .text

strlen:
    push rdi
    xor eax, eax
    mov rcx, -1
    repne scasb
    not rcx
    dec rcx
    mov rax, rcx
    pop rdi
    ret

hexval:
    cmp al, '0'
    jb .bad
    cmp al, '9'
    jbe .num
    cmp al, 'A'
    jb .chk_a
    cmp al, 'F'
    jbe .AtoF
.chk_a:
    cmp al, 'a'
    jb .bad
    cmp al, 'f'
    ja .bad
    sub al, 'a' - 10
    clc
    ret
.AtoF:
    sub al, 'A' - 10
    clc
    ret
.num:
    sub al, '0'
    clc
    ret
.bad:
    stc
    ret

_start:
    mov rbx, [rsp]
    cmp rbx, 2
    je .have_arg
    mov edi, 1
    mov eax, 60
    syscall

.have_arg:
    mov rsi, [rsp+16]
    test rsi, rsi
    jz .bad_exit
    mov rdi, rsi
    call strlen
    test rax, rax
    jz .bad_exit
    mov r14, rsi
    add r14, rax

    mov rdx, 4096
    xor edi, edi
    mov rsi, rdx
    mov edx, 7
    mov r10d, 0x22
    mov r8d, -1
    xor r9d, r9d
    mov eax, 9
    syscall
    cmp rax, -4095
    jae .bad_exit
    mov r12, rax
    mov rdi, rax
    mov rsi, [rsp+16]
    xor r13, r13

.parse_loop:
    cmp rsi, r14
    jae .parse_done
    mov al, [rsi]
    cmp al, ' '
    je .skip
    cmp al, 9
    je .skip
    cmp al, 10
    je .skip
    cmp al, 13
    je .skip
    cmp al, ','
    je .skip
    cmp al, '\'
    jne .bad_exit

    mov rbx, r14
    sub rbx, rsi
    cmp rbx, 4
    jb .bad_exit

    mov al, [rsi+1]
    cmp al, 'x'
    je .have_x
    cmp al, 'X'
    jne .bad_exit

.have_x:
    mov al, [rsi+2]
    call hexval
    jc .bad_exit
    shl al, 4
    mov bl, al
    mov al, [rsi+3]
    call hexval
    jc .bad_exit
    or al, bl
    mov [rdi], al
    add rsi, 4
    inc rdi
    inc r13
    jmp .parse_loop

.skip:
    inc rsi
    jmp .parse_loop

.parse_done:
    test r13, r13
    jz .bad_exit
    mov rdi, r12
    mov rsi, 4096
    mov edx, 5
    mov eax, 10
    syscall
    call r12
    xor edi, edi
    mov eax, 60
    syscall

.bad_exit:
    mov eax, 60
    mov edi, 1
    syscall
