section .data
    old_str db "1337", 10
    old_len equ 5
    new_str db "H4CK", 10
    new_len equ 5

section .bss
    buffer resb 65536

section .text
global _start
_start:
    mov rax, [rsp]
    cmp rax, 2
    jl .exit_error
    
    mov rdi, [rsp + 16]
    
    mov rax, 2
    mov rsi, 2
    syscall
    
    cmp rax, 0
    jl .exit_error
    
    mov r12, rax
    
    mov rax, 0
    mov rdi, r12
    mov rsi, buffer
    mov rdx, 65536
    syscall
    
    cmp rax, 0
    jle .close_and_error
    
    mov r13, rax
    
    mov rsi, buffer
    mov rcx, r13
    sub rcx, old_len
    inc rcx
    
.search_loop:
    cmp rcx, 0
    jle .close_and_error
    
    mov al, [rsi]
    cmp al, '1'
    jne .next_byte
    
    mov rdi, rsi
    mov rbx, 0
    
.compare_loop:
    cmp rbx, old_len
    jge .found_match
    
    mov al, [rdi]
    mov dl, [old_str + rbx]
    cmp al, dl
    jne .next_byte
    
    inc rdi
    inc rbx
    jmp .compare_loop
    
.found_match:
    mov rdi, rsi
    mov rbx, 0
    
.patch_loop:
    cmp rbx, new_len
    jge .write_file
    
    mov al, [new_str + rbx]
    mov [rdi], al
    
    inc rdi
    inc rbx
    jmp .patch_loop
    
.write_file:
    mov rax, 8
    mov rdi, r12
    xor rsi, rsi
    xor rdx, rdx
    syscall
    
    mov rax, 1
    mov rdi, r12
    mov rsi, buffer
    mov rdx, r13
    syscall
    
    mov rax, 3
    mov rdi, r12
    syscall
    
    jmp .exit_success
    
.next_byte:
    inc rsi
    dec rcx
    jmp .search_loop
    
.close_and_error:
    mov rax, 3
    mov rdi, r12
    syscall
    
.exit_error:
    mov rax, 60
    mov rdi, 1
    syscall
    
.exit_success:
    mov rax, 60
    xor rdi, rdi
    syscall