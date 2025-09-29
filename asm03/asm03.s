section .data
    msg db "1337", 10
    len equ $ - msg

section .text
    global _start

_start:
   
    mov rbx, [rsp]          
    cmp rbx, 2              
    jne not_42

   
    mov rsi, [rsp+16]      

   
    mov al, byte [rsi]
    cmp al, '4'
    jne not_42

    
    mov al, byte [rsi+1]
    cmp al, '2'
    jne not_42

   
    mov al, byte [rsi+2]
    cmp al, 0
    jne not_42

    
    mov rax, 1              ; write
    mov rdi, 1              ; stdout
    mov rsi, msg
    mov rdx, len
    syscall

    
    mov rax, 60
    xor rdi, rdi
    syscall

not_42:
   
    mov rax, 60
    mov rdi, 1
    syscall
