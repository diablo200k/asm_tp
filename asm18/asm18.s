section .data
hdr        db 'message: "',0
hdr_len    equ $-hdr
tail       db '"',10
to_msg     db 'Timeout: no response from server',10
to_len     equ $-to_msg
timeval    dq 2,0
sockaddr:
    dw 2
    dw 0x3905
    dd 0x0100007F
    dq 0

section .bss
buf  resb 1024

section .text
global _start

_start:
    mov rax,41
    mov rdi,2
    mov rsi,2
    xor rdx,rdx
    syscall
    mov r12,rax

    mov rax,42
    mov rdi,r12
    lea rsi,[rel sockaddr]
    mov rdx,16
    syscall

    mov rax,54
    mov rdi,r12
    mov rsi,1
    mov rdx,20
    lea r10,[rel timeval]
    mov r8,16
    syscall

    mov byte [buf],'X'
    mov rax,44
    mov rdi,r12
    lea rsi,[rel buf]
    mov rdx,1
    xor r10,r10
    xor r8,r8
    xor r9,r9
    syscall

    mov rax,45
    mov rdi,r12
    lea rsi,[rel buf]
    mov rdx,1024
    xor r10,r10
    xor r8,r8
    syscall
    test rax,rax
    jle .timeout
    mov r13,rax

    mov rax,1
    mov rdi,1
    lea rsi,[rel hdr]
    mov rdx,hdr_len
    syscall

    mov rax,1
    mov rdi,1
    lea rsi,[rel buf]
    mov rdx,r13
    syscall

    mov rax,1
    mov rdi,1
    lea rsi,[rel tail]
    mov rdx,2
    syscall

    mov rax,60
    xor rdi,rdi
    syscall

.timeout:
    mov rax,1
    mov rdi,1
    lea rsi,[rel to_msg]
    mov rdx,to_len
    syscall
    mov rax,60
    mov rdi,1
    syscall