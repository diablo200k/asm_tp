section .data
    listen_msg db 'Listening on port 1337',10
    listen_len equ $-listen_msg
    filename   db 'messages',0
    sockaddr:
        dw 2
        dw 0x3905
        dd 0
        dq 0

section .bss
    buf        resb 1024
    client_addr resb 16
    addr_len   resq 1

section .text
global _start

_start:
    mov rax,41
    mov rdi,2
    mov rsi,2
    xor rdx,rdx
    syscall
    mov r12,rax

    mov rax,49
    mov rdi,r12
    lea rsi,[rel sockaddr]
    mov rdx,16
    syscall

    mov rax,1
    mov rdi,1
    lea rsi,[rel listen_msg]
    mov rdx,listen_len
    syscall

    mov rax,2
    lea rdi,[rel filename]
    mov rsi,0101o
    mov rdx,0644o
    syscall
    mov r13,rax

.loop:
    mov qword [addr_len],16
    mov rax,45
    mov rdi,r12
    lea rsi,[rel buf]
    mov rdx,1024
    xor r10,r10
    lea r8,[rel client_addr]
    lea r9,[rel addr_len]
    syscall
    test rax,rax
    jle .loop
    mov r14,rax

    mov rax,1
    mov rdi,r13
    lea rsi,[rel buf]
    mov rdx,r14
    syscall

    mov rax,1
    mov rdi,r13
    mov byte [buf],10
    lea rsi,[rel buf]
    mov rdx,1
    syscall

    jmp .loop