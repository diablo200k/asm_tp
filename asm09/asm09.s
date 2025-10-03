section .data
    usage_msg db "Usage: ./asm09 [-b] <number>", 10, 0
    usage_len equ $ - usage_msg - 1
    newline db 10, 0
    hex_digits db "0123456789ABCDEF"

section .bss
    buffer resb 64

section .text
    global _start

_start:
    pop rax
    cmp rax, 2
    je check_normal
    cmp rax, 3
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
    pop rdi
    call atoi
    cmp r10, 1
    je usage_error
    mov rdi, rax
    call to_binary
    jmp print_result

check_normal:
    pop rdi
    pop rdi
    call atoi
    cmp r10, 1
    je usage_error
    mov rdi, rax
    call to_hex
    jmp print_result

print_result:
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
    xor r10, r10
    xor r11, r11

    mov cl, [rdi]
    cmp cl, '-'
    jne atoi_loop
    mov r10, 1
    inc rdi

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
    inc r11
    jmp atoi_loop

atoi_done:
    test r11, r11
    jz atoi_invalid
    ret

atoi_invalid:
    mov r10, 1
    ret