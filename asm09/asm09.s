section .data
    usage_msg db "Usage: ./asm09 [-b] <number> <expected>", 10, 0
    usage_len equ $ - usage_msg - 1
    newline db 10, 0
    hex_digits db "0123456789ABCDEF"

section .bss
    buffer resb 64

section .text
    global _start

_start:
    pop rax
    cmp rax, 3
    je check_normal
    cmp rax, 4
    je check_binary_flag
    jmp usage_error

check_binary_flag:
    pop rdi
    pop rdi
    mov rsi, rdi
    mov al, [rsi]
    cmp al, '-'
    jne usage_error
    mov al, [rsi+1]
    cmp al, 'b'
    jne usage_error
    mov al, [rsi+2]
    test al, al
    jnz usage_error
    mov r11, 1
    pop rdi
    call atoi
    mov r12, rax
    pop rdi
    mov r13, rdi
    jmp convert_binary

check_normal:
    pop rdi
    mov r11, 0
    pop rdi
    call atoi
    mov r12, rax
    pop rdi
    mov r13, rdi
    jmp convert_hex

convert_hex:
    mov rdi, r12
    call to_hex
    mov rdi, buffer
    mov rsi, r13
    call compare_strings
    test rax, rax
    jz exit_success
    jmp exit_fail

convert_binary:
    mov rdi, r12
    call to_binary
    mov rdi, buffer
    mov rsi, r13
    call compare_strings
    test rax, rax
    jz exit_success
    jmp exit_fail

to_hex:
    mov rax, rdi
    mov rsi, buffer + 63
    mov byte [rsi], 0
    dec rsi
    test rax, rax
    jnz hex_loop
    mov byte [rsi], '0'
    dec rsi
    jmp hex_done

hex_loop:
    test rax, rax
    jz hex_done
    mov rdx, rax
    and rdx, 15
    mov cl, [hex_digits + rdx]
    mov [rsi], cl
    dec rsi
    shr rax, 4
    jmp hex_loop

hex_done:
    inc rsi
    mov rdi, buffer
    mov rcx, buffer + 64
    sub rcx, rsi

copy_hex:
    test rcx, rcx
    jz copy_hex_done
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp copy_hex

copy_hex_done:
    mov byte [rdi], 0
    ret

to_binary:
    mov rax, rdi
    mov rsi, buffer + 63
    mov byte [rsi], 0
    dec rsi
    test rax, rax
    jnz binary_loop
    mov byte [rsi], '0'
    dec rsi
    jmp binary_done

binary_loop:
    test rax, rax
    jz binary_done
    mov rdx, rax
    and rdx, 1
    add dl, '0'
    mov [rsi], dl
    dec rsi
    shr rax, 1
    jmp binary_loop

binary_done:
    inc rsi
    mov rdi, buffer
    mov rcx, buffer + 64
    sub rcx, rsi

copy_binary:
    test rcx, rcx
    jz copy_binary_done
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp copy_binary

copy_binary_done:
    mov byte [rdi], 0
    ret

compare_strings:
    mov al, [rdi]
    mov bl, [rsi]
    cmp al, bl
    jne strings_different
    test al, al
    jz strings_equal
    inc rdi
    inc rsi
    jmp compare_strings

strings_equal:
    mov rax, 0
    ret

strings_different:
    mov rax, 1
    ret

exit_success:
    mov rdi, buffer
    call print_string
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall
    mov rax, 60
    mov rdi, 0
    syscall

exit_fail:
    mov rdi, buffer
    call print_string
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall
    mov rax, 60
    mov rdi, 1
    syscall

usage_error:
    mov rax, 1
    mov rdi, 2
    mov rsi, usage_msg
    mov rdx, usage_len
    syscall
    mov rax, 60
    mov rdi, 1
    syscall

print_string:
    mov rsi, rdi
    xor rdx, rdx

strlen_loop:
    mov al, [rsi + rdx]
    test al, al
    jz strlen_done
    inc rdx
    jmp strlen_loop

strlen_done:
    mov rax, 1
    mov rdi, 1
    syscall
    ret

atoi:
    xor rax, rax
    xor rcx, rcx

atoi_loop:
    mov cl, [rdi]
    test cl, cl
    jz atoi_done
    cmp cl, '0'
    jl atoi_done
    cmp cl, '9'
    jg atoi_done
    sub cl, '0'
    imul rax, rax, 10
    add rax, rcx
    inc rdi
    jmp atoi_loop

atoi_done:
    ret