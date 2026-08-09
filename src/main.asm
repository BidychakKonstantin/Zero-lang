%include "src/include/host_sys.inc"
global _start
default rel

section .bss
   file_buffer: resb 65536
   bytes_read: resq 1
section .rodata
   err_no_arg:  db "Error: Please specify .zr file",10
   err_no_arg_len: equ $ - err_no_arg
   err_open: db "Error:Could not open File",10
   err_open_len: equ $ - err_open

section .text
_start:
    ;1.Checking the arguments CLI
    mov rax, [rsp]
    cmp rax, 2
    jl .err_no_arg

    mov rdi, [rsp + 16]
    ;2.We read the raw materials through HOST I/O
    mov eax, HOST_SYS_OPEN
    mov esi,HOST_O_RDONLY
    xor edx, edx
    syscall
 
    test rax, rax
    js .err_open
    mov rbx, rax     ; File Descriptor

    mov rdi, rbx
    mov eax, HOST_SYS_READ
    mov rsi, file_buffer
    mov edx, 65536
    syscall
    mov [bytes_read], rax

    mov rdi,rbx
    mov eax, HOST_SYS_CLOSE
    syscall

    ;Compiler Shutdown
    mov eax, HOST_SYS_EXIT
    xor edi,edi
    syscall
.err_no_arg:
    mov eax, HOST_SYS_WRITE
    mov edi, HOST_STDERR
    mov rsi, err_no_arg
    mov edx, err_no_arg_len
    syscall
    jmp .exit_with_errors

.err_open:
    mov eax, HOST_SYS_WRITE
    mov edi, HOST_STDERR
    mov rsi, err_open
    mov edx, err_open_len
    syscall

.exit_with_errors:
   mov eax, HOST_SYS_EXIT
   mov edi, 1
   syscall