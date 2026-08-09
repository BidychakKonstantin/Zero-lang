global _start

section .rodata
    msg db "Zero Language Compiler [v0.1.0-dev]", 10
    msg_len equ $ - msg

section .text
_start:
    ; sys_write(stdout, msg, msg_len)
    mov rax, 1          ; syscall number for sys_write
    mov rdi, 1          ; file descriptor: 1 = stdout
    mov rsi, msg        ; pointer to string
    mov rdx, msg_len    ; string length
    syscall

    ; sys_exit(code=0)
    mov rax, 60         ; syscall number for sys_exit
    xor rdi, rdi        ; status = 0
    syscall