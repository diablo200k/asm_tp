section .bss
    buf resb 32

section .text
    global _start

_start:
    
    mov rax, 0         
    mov rdi, 0          
    mov rsi, buf
    mov rdx, 32
    syscall            

   
    movzx rbx, byte [buf]
    sub rbx, '0'       

    
    test rbx, 1
    jnz odd

even:
    mov rax, 60        
    xor rdi, rdi       
    syscall

odd:
    mov rax, 60        
    mov rdi, 1         
    syscall
