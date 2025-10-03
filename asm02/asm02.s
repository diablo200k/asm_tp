section .bss
    buf resb 64

section .data
    msg db "1337", 10
    len equ $ - msg

section .text
    global _start

_start:
    ; Lire l'entrée (jusqu'à 64 octets)
    mov rax, 0
    mov rdi, 0
    mov rsi, buf
    mov rdx, 64
    syscall

    ; Vérifier si on a lu au moins 3 octets
    cmp rax, 3
    jl not_42
    
    ; Vérifier si c'est "42\n" ou "42\r\n"
    mov al, byte [buf]
    cmp al, '4'
    jne not_42

    mov al, byte [buf+1]
    cmp al, '2'
    jne not_42

    mov al, byte [buf+2]
    cmp al, 10          ; '\n'
    je is_42
    
    cmp al, 13          ; '\r'
    jne not_42
    
    ; Vérifier si c'est '\r\n'
    mov al, byte [buf+3]
    cmp al, 10
    jne not_42

is_42:
    ; Afficher "1337\n"
    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, len
    syscall

    ; Exit 0
    mov rax, 60
    xor rdi, rdi
    syscall

not_42:
    ; Exit 1
    mov rax, 60
    mov rdi, 1
    syscall