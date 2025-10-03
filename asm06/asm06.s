section .bss
    outbuf  resb 32

section .data
    nl db 10
    minus db '-'

section .text
global _start

atoi_signed:
    xor     rax, rax
    xor     r8,  r8
    xor     r9, r9
    mov     dl, [rdi]
    cmp     dl, '+'
    jne     .chkminus
    inc     rdi
    jmp     .loop
.chkminus:
    cmp     dl, '-'
    jne     .loop
    inc     rdi
    mov     r8, 1
.loop:
    mov     dl, [rdi]
    test    dl, dl
    jz      .done
    cmp     dl, 10
    je      .done
    cmp     dl, '0'
    jb      .invalid
    cmp     dl, '9'
    ja      .invalid
    imul    rax, rax, 10
    sub     dl, '0'
    movzx   rdx, dl
    add     rax, rdx
    inc     rdi
    inc     r9
    jmp     .loop
.done:
    test    r9, r9
    jz      .invalid
    test    r8, r8
    jz      .ret
    neg     rax
.ret:
    clc
    ret
.invalid:
    stc
    ret

print_i64:
    mov     rbx, rax
    test    rbx, rbx
    jns     .pos
    mov     rax, 1
    mov     rdi, 1
    lea     rsi, [rel minus]
    mov     rdx, 1
    syscall
    mov     rax, rbx
    neg     rax
.pos:
    lea     rsi, [outbuf+32]
    test    rax, rax
    jne     .conv
    mov     byte [outbuf+31], '0'
    lea     rsi, [outbuf+31]
    jmp     .write
.conv:
    .loop:
        xor     rdx, rdx
        mov     rcx, 10
        div     rcx
        add     dl, '0'
        dec     rsi
        mov     [rsi], dl
        test    rax, rax
        jne     .loop
.write:
    mov     rdx, outbuf+32
    sub     rdx, rsi
    mov     rax, 1
    mov     rdi, 1
    syscall
    mov     rax, 1
    mov     rdi, 1
    lea     rsi, [rel nl]
    mov     rdx, 1
    syscall
    ret

_start:
    mov     rsi, rsp
    mov     rdi, [rsi]
    cmp     rdi, 3
    jne     .error

    mov     rdi, [rsi+16]
    call    atoi_signed
    jc      .error
    mov     r12, rax

    mov     rdi, [rsi+24]
    call    atoi_signed
    jc      .error
    add     rax, r12

    call    print_i64
    mov     rax, 60
    xor     rdi, rdi
    syscall

.error:
    mov     rax, 60
    mov     rdi, 1
    syscall