section .bss
    buffer resb 1024
    count resb 32

section .text
global _start

_start:
    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 1024
    syscall
    
    mov rcx, rax
    cmp rcx, 0
    jle .exit_success
    
    mov rsi, buffer
    mov rbx, 0

.count_loop:
    cmp rcx, 0
    je .to_ascii_convert
    
    mov al, [rsi]
    
    cmp al, 10 ; Ignore newline read from standard input
    je .next_char

    ; Convert to lowercase if uppercase
    cmp al, 'A'
    jl .check_vowel_only
    cmp al, 'Z'
    jg .check_vowel_only
    
    add al, 32

.check_vowel_only:
    cmp al, 'a'
    je .vowel_found
    cmp al, 'e'
    je .vowel_found
    cmp al, 'i'
    je .vowel_found
    cmp al, 'o'
    je .vowel_found
    cmp al, 'u'
    je .vowel_found
    
    jmp .next_char

.vowel_found:
    inc rbx

.next_char:
    inc rsi
    dec rcx
    jmp .count_loop

.to_ascii_convert:
    mov rax, rbx
    mov rdi, count+31
    mov byte [rdi], 10
    mov rcx, 10

.convert_digit:
    xor rdx, rdx
    div rcx
    
    add dl, '0'
    dec rdi
    mov [rdi], dl
    
    cmp rax, 0
    jnz .convert_digit

    inc rdi
    mov rsi, rdi
    mov rdx, count+32
    sub rdx, rsi
    
    mov rax, 1
    mov rdi, 1
    syscall

.exit_success:
    mov rax, 60
    xor rdi, rdi
    syscall