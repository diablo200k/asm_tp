section .bss
    buffer resb 65536
    count  resb 64

section .text
global _start
_start:
    xor rbx, rbx
.read_loop:
    mov rax, 0
    mov rdi, 0
    lea rsi, [buffer + rbx]
    mov rdx, 4096
    syscall
    cmp rax, 0
    jle .done_reading
    add rbx, rax
    cmp rbx, 65536
    jl .read_loop
.done_reading:
    mov rcx, rbx
    cmp rcx, 0
    jle .zero_vowels
    mov rsi, buffer
    mov rbx, 0
.count_loop:
    cmp rcx, 0
    je .to_ascii_convert
    movzx rax, byte [rsi]
    cmp al, 10
    je .next_char
    cmp al, 13
    je .next_char
    cmp al, 0xC3
    jne .check_ascii
    cmp rcx, 1
    jle .next_char
    movzx rdx, byte [rsi+1]
    cmp dl, 0x80
    je .vowel_found
    cmp dl, 0x81
    je .vowel_found
    cmp dl, 0x82
    je .vowel_found
    cmp dl, 0x83
    je .vowel_found
    cmp dl, 0x84
    je .vowel_found
    cmp dl, 0xA0
    je .vowel_found
    cmp dl, 0xA1
    je .vowel_found
    cmp dl, 0xA2
    je .vowel_found
    cmp dl, 0xA3
    je .vowel_found
    cmp dl, 0xA4
    je .vowel_found
    cmp dl, 0xA8
    je .vowel_found
    cmp dl, 0xA9
    je .vowel_found
    cmp dl, 0xAA
    je .vowel_found
    cmp dl, 0xAB
    je .vowel_found
    cmp dl, 0xAC
    je .vowel_found
    cmp dl, 0xB9
    je .vowel_found
    inc rsi
    dec rcx
    jmp .next_char
.check_ascii:
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
    cmp al, 'y'
    je .vowel_found
    jmp .next_char
.vowel_found:
    inc rbx
.next_char:
    inc rsi
    dec rcx
    jmp .count_loop
.zero_vowels:
    mov byte [count], '0'
    mov byte [count+1], 10
    mov rsi, count
    mov rdx, 2
    jmp .print_result
.to_ascii_convert:
    cmp rbx, 0
    je .zero_vowels
    mov rax, rbx
    mov r8, count+64
    mov rdi, r8
    dec rdi
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
    mov rsi, rdi
    mov rdx, r8
    sub rdx, rsi
.print_result:
    mov rax, 1
    mov rdi, 1
    syscall
.exit_success:
    mov rax, 60
    xor rdi, rdi
    syscall
