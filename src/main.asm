%include "src/include/host_sys.inc"

default rel

global _start

extern lexer_init
extern lexer_set_source_dir
extern parser_parse

%define FILE_BUFFER_SIZE 65536
%define PATH_BUFFER_SIZE 4096

section .bss

file_buffer:
resb FILE_BUFFER_SIZE

source_dir:
resb PATH_BUFFER_SIZE

section .rodata

err_no_arg:
db "Error: Please specify .zr file", 10
err_no_arg_len equ $ - err_no_arg

err_path:
db "Error: Input path is too long", 10
err_path_len equ $ - err_path

err_open:
db "Error: Could not open file", 10
err_open_len equ $ - err_open

err_read:
db "Error: Could not read file", 10
err_read_len equ $ - err_read

err_dir:
db "Error: Could not set source directory", 10
err_dir_len equ $ - err_dir

section .text

_start:
    mov rax, [rsp]
    cmp rax, 2
    jl .no_arg

    mov r12, [rsp + 16]

    xor rcx, rcx

.path_len:
    cmp byte [r12 + rcx], 0
    je .path_len_done
    inc rcx
    cmp rcx, PATH_BUFFER_SIZE - 1
    jb .path_len
    jmp .path_error

.path_len_done:
    mov r13, rcx

    test r13, r13
    jz .path_error

    lea rdi, [rel source_dir]

    xor r14d, r14d
    mov r14, r13

.find_slash:
    test r14, r14
    jz .no_slash
    dec r14
    cmp byte [r12 + r14], '/'
    jne .find_slash

    test r14, r14
    jnz .copy_dir

    mov byte [rdi], '/'
    mov byte [rdi + 1], 0
    jmp .open_file

.no_slash:
    mov byte [rdi], '.'
    mov byte [rdi + 1], 0
    jmp .open_file

.copy_dir:
    mov rcx, r14
    mov rsi, r12
    rep movsb
    mov byte [rdi], 0

.open_file:
    mov rdi, r12
    mov eax, HOST_SYS_OPEN
    mov esi, HOST_O_RDONLY
    xor edx, edx
    syscall

    test rax, rax
    js .open_error

    mov r15, rax

    mov rdi, r15
    lea rsi, [rel file_buffer]
    mov edx, FILE_BUFFER_SIZE
    mov eax, HOST_SYS_READ
    syscall

    test rax, rax
    js .read_error

    mov r13, rax

    mov rdi, r15
    mov eax, HOST_SYS_CLOSE
    syscall

    lea rdi, [rel file_buffer]
    mov rsi, r13
    call lexer_init

    lea rdi, [rel source_dir]

    xor rcx, rcx

.source_dir_len:
    cmp byte [rdi + rcx], 0
    je .source_dir_len_done
    inc rcx
    jmp .source_dir_len

.source_dir_len_done:
    mov rsi, rcx
    call lexer_set_source_dir

    test rax, rax
    js .dir_error

    call parser_parse

    mov eax, HOST_SYS_EXIT
    xor edi, edi
    syscall

.no_arg:
    mov eax, HOST_SYS_WRITE
    mov edi, HOST_STDERR
    lea rsi, [rel err_no_arg]
    mov edx, err_no_arg_len
    syscall

    mov eax, HOST_SYS_EXIT
    mov edi, 1
    syscall

.path_error:
    mov eax, HOST_SYS_WRITE
    mov edi, HOST_STDERR
    lea rsi, [rel err_path]
    mov edx, err_path_len
    syscall

    mov eax, HOST_SYS_EXIT
    mov edi, 1
    syscall

.open_error:
    mov eax, HOST_SYS_WRITE
    mov edi, HOST_STDERR
    lea rsi, [rel err_open]
    mov edx, err_open_len
    syscall

    mov eax, HOST_SYS_EXIT
    mov edi, 1
    syscall

.read_error:
    mov rdi, r15
    mov eax, HOST_SYS_CLOSE
    syscall

    mov eax, HOST_SYS_WRITE
    mov edi, HOST_STDERR
    lea rsi, [rel err_read]
    mov edx, err_read_len
    syscall

    mov eax, HOST_SYS_EXIT
    mov edi, 1
    syscall

.dir_error:
    mov eax, HOST_SYS_WRITE
    mov edi, HOST_STDERR
    lea rsi, [rel err_dir]
    mov edx, err_dir_len
    syscall

    mov eax, HOST_SYS_EXIT
    mov edi, 1
    syscall