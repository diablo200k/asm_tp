BITS 64
default rel

%define AF_INET 2
%define SOCK_DGRAM 2
%define SOL_SOCKET 1
%define SO_RCVTIMEO 20
%define SYS_write 1
%define SYS_close 3
%define SYS_socket 41
%define SYS_sendto 44
%define SYS_recvfrom 45
%define SYS_setsockopt 54
%define SYS_exit 60
%define STDOUT 1
%define SERVER_PORT 9999
%define RCV_TIMEOUT_S 2
%define IPV4_LOCALHOST 0x0100007F

section .data
sockaddr:
    dw AF_INET
    dw 0x8F27          ; 9999 en big endian = 0x270F mais inversé (NASM little) = 0x0F27 -> pour 9999: 0x270F -> donc dw 0x270F
    dd IPV4_LOCALHOST
    dq 0
timeval:
    dq RCV_TIMEOUT_S
    dq 0
msg_prefix: db 'message: "'
msg_suffix: db '"',10
msg_timeout: db 'Timeout: no response from server',10
ping: db 'ping'

section .bss
buf resb 1024

section .text
global _start

_start:
    mov rax,SYS_socket
    mov rdi,AF_INET
    mov rsi,SOCK_DGRAM
    xor rdx,rdx
    syscall
    mov r12,rax

    mov rax,SYS_setsockopt
    mov rdi,r12
    mov rsi,SOL_SOCKET
    mov rdx,SO_RCVTIMEO
    lea r10,[rel timeval]
    mov r8,16
    syscall

    mov rax,SYS_sendto
    mov rdi,r12
    lea rsi,[rel ping]
    mov rdx,4
    xor r10,r10
    lea r8,[rel sockaddr]
    mov r9,16
    syscall

    mov rax,SYS_recvfrom
    mov rdi,r12
    lea rsi,[rel buf]
    mov rdx,1024
    xor r10,r10
    xor r8,r8
    xor r9,r9
    syscall
    test rax,rax
    js timeout
    mov r13,rax

    mov rax,SYS_write
    mov rdi,STDOUT
    lea rsi,[rel msg_prefix]
    mov rdx,10          ; longueur "message: \""
    syscall

    mov rax,SYS_write
    mov rdi,STDOUT
    lea rsi,[rel buf]
    mov rdx,r13
    syscall

    mov rax,SYS_write
    mov rdi,STDOUT
    lea rsi,[rel msg_suffix]
    mov rdx,2
    syscall

    mov rax,SYS_close
    mov rdi,r12
    syscall
    mov rax,SYS_exit
    xor rdi,rdi
    syscall

timeout:
    neg rax
    cmp rax,11
    jne fatal
    mov rax,SYS_write
    mov rdi,STDOUT
    lea rsi,[rel msg_timeout]
    mov rdx,33
    syscall
    mov rax,SYS_close
    mov rdi,r12
    syscall
    mov rax,SYS_exit
    mov rdi,1
    syscall

fatal:
    mov rax,SYS_exit
    mov rdi,1
    syscall
