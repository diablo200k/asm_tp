section .bss
    buf resb 3          

section .data
    msg db "1337", 10
    len equ $ - msg

section .text
    global _start

_start:
    ; read(0, buf, 3)
    mov rax, 0          
    mov rdi, 0          
    mov rsi, buf
    mov rdx, 3
    syscall

    ; comparer buf[0] avec '4'
    mov al, byte [buf]
    cmp al, '4'
    jne not_42

    ; comparer buf[1] avec '2'
    mov al, byte [buf+1]
    cmp al, '2'
    jne not_42

    ; si "42", afficher 1337
    mov rax, 1          
    mov rdi, 1          
    mov rsi, msg
    mov rdx, len
    syscall

    ; exit(0)
    mov rax, 60
    xor rdi, rdi
    syscall

not_42:
    ; exit(1)
    mov rax, 60
    mov rdi, 1
    syscall
