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

    mov rax, rbx
    mov rdi, buf+31
    mov rcx, 10
    mov byte [rdi], 10
    dec rdi
.to_ascii:
    xor rdx, rdx
    mov rax, rbx
    div rcx
    add dl, '0'
    mov [rdi], dl
    mov rbx, rax
    test rax, rax
    jnz .cont
    jmp .print
.cont:
    dec rdi
    jmp .to_ascii

.print:
    lea rsi, [rdi]
    mov rdx, buf+32
    sub rdx, rdi
    mov rax, 1
    mov rdi, 1
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall

str_to_int:
    xor rax, rax
.conv_loop:
    mov dl, byte [rsi]
    cmp dl, 0
    je .done
    sub dl, '0'
    imul rax, rax, 10
    add rax, rdx
    inc rsi
    jmp .conv_loop
.done:
    ret

exit_error:
    mov rax, 60
    mov rdi, 1
    syscall
