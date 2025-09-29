section .bss
buf resb 32

section .text
global _start

_start:
    mov rax, [rsp]
    cmp rax, 4
    jne exit_error

    mov rsi, [rsp+16]
    call str_to_int
    mov rbx, rax

    mov rsi, [rsp+24]
    call str_to_int
    cmp rax, rbx
    jle .skip2
    mov rbx, rax
.skip2:

    mov rsi, [rsp+32]
    call str_to_int
    cmp rax, rbx
    jle .skip3
    mov rbx, rax
.skip3:

    mov rdi, buf+31
    mov rcx, 10
    mov byte [rdi], 10
    dec rdi

    mov r8, rbx
    cmp rbx, 0
    jge .positive_val
    neg rbx
.positive_val:

.to_ascii:
    xor rdx, rdx
    mov rax, rbx
    div rcx
    add dl, '0'
    mov [rdi], dl
    mov rbx, rax
    dec rdi
    test rax, rax
    jnz .to_ascii
    
    cmp r8, 0
    jge .print
    mov byte [rdi], '-'
    dec rdi

.print:
    lea rsi, [rdi+1]
    mov rdx, buf+32
    sub rdx, rsi

    mov rax, 1
    mov rdi, 1
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall

str_to_int:
    mov r10, 0
    xor rax, rax
    
    mov dl, byte [rsi]
    cmp dl, '-'
    jne .conv_start
    mov r10, 1
    inc rsi

.conv_start:
.conv_loop:
    mov dl, byte [rsi]
    cmp dl, 0
    je .done_apply_sign
    
    cmp dl, '0'
    jl .done_apply_sign
    cmp dl, '9'
    jg .done_apply_sign
    
    sub dl, '0'
    imul rax, rax, 10
    add rax, rdx
    inc rsi
    jmp .conv_loop

.done_apply_sign:
    cmp r10, 1
    jne .done_ret
    neg rax
.done_ret:
    ret

exit_error:
    mov rax, 60
    mov rdi, 1
    syscall