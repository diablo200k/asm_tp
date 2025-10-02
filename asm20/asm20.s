section .data
    listen_msg db 'Listening on port 4242',10
    listen_len equ $-listen_msg
    prompt     db 'Type a command: '
    prompt_len equ $-prompt
    pong       db 'PONG',10
    pong_len   equ $-pong
    goodbye    db 'Goodbye!',10
    goodbye_len equ $-goodbye
    sockaddr:
        dw 2
        dw 0x9210
        dd 0
        dq 0
    optval dd 1

section .bss
    buf        resb 1024
    output     resb 1024

section .text
global _start

_start:
    mov rax,41
    mov rdi,2
    mov rsi,1
    xor rdx,rdx
    syscall
    test rax,rax
    js .exit_error
    mov r12,rax

    mov rax,54
    mov rdi,r12
    mov rsi,1
    mov rdx,2
    lea r10,[rel optval]
    mov r8,4
    syscall

    mov rax,49
    mov rdi,r12
    lea rsi,[rel sockaddr]
    mov rdx,16
    syscall
    test rax,rax
    js .exit_error

    mov rax,50
    mov rdi,r12
    mov rsi,5
    syscall
    test rax,rax
    js .exit_error

    mov rax,1
    mov rdi,1
    lea rsi,[rel listen_msg]
    mov rdx,listen_len
    syscall

.accept_loop:
    mov rax,43
    mov rdi,r12
    xor rsi,rsi
    xor rdx,rdx
    syscall
    test rax,rax
    js .accept_loop
    mov r13,rax

    mov rax,57
    syscall
    test rax,rax
    jnz .parent

.cmd_loop:
    mov rax,1
    mov rdi,r13
    lea rsi,[rel prompt]
    mov rdx,prompt_len
    syscall

    xor rbx,rbx
    lea rdi,[rel buf]
.read_loop:
    mov rax,0
    mov rdi,r13
    lea rsi,[rel buf]
    add rsi,rbx
    mov rdx,1
    syscall
    test rax,rax
    jle .close_client
    
    mov al,[rel buf+rbx]
    cmp al,10
    je .process_cmd
    inc rbx
    cmp rbx,1023
    jl .read_loop

.process_cmd:
    mov r14,rbx

    mov al,[rel buf]
    cmp al,'P'
    je .try_ping
    cmp al,'R'
    je .try_reverse
    cmp al,'E'
    je .try_exit
    jmp .cmd_loop

.try_ping:
    cmp r14,4
    jne .cmd_loop
    cmp dword [rel buf],'PING'
    jne .cmd_loop

    mov rax,1
    mov rdi,r13
    lea rsi,[rel pong]
    mov rdx,pong_len
    syscall
    jmp .cmd_loop

.try_reverse:
    cmp r14,8
    jl .cmd_loop
    mov eax,[rel buf]
    cmp eax,'REVE'
    jne .cmd_loop
    mov eax,[rel buf+4]
    cmp eax,'RSE '
    jne .cmd_loop

    lea rsi,[rel buf]
    add rsi,8
    mov rcx,r14
    sub rcx,8
    
    add rsi,rcx
    dec rsi
    lea rdi,[rel output]
    xor rbx,rbx

.rev_loop:
    mov al,[rsi]
    mov [rdi],al
    dec rsi
    inc rdi
    inc rbx
    cmp rbx,rcx
    jl .rev_loop

    mov byte [rdi],10

    mov rax,1
    mov rdi,r13
    lea rsi,[rel output]
    mov rdx,rbx
    inc rdx
    syscall
    jmp .cmd_loop

.try_exit:
    cmp r14,4
    jne .cmd_loop
    cmp dword [rel buf],'EXIT'
    jne .cmd_loop

    mov rax,1
    mov rdi,r13
    lea rsi,[rel goodbye]
    mov rdx,goodbye_len
    syscall

.close_client:
    mov rax,3
    mov rdi,r13
    syscall

    mov rax,60
    xor rdi,rdi
    syscall

.parent:
    mov rax,3
    mov rdi,r13
    syscall
    jmp .accept_loop

.exit_error:
    mov rax,60
    mov rdi,1
    syscall