default rel

%include "src/include/tokens.inc"

global _start

extern lexer_init
extern lexer_set_source_dir
extern parser_parse


%define SYS_READ       0
%define SYS_WRITE      1
%define SYS_OPENAT     257
%define SYS_CLOSE      3
%define SYS_EXIT       60

%define AT_FDCWD       -100
%define O_RDONLY       0

%define SOURCE_BUFFER_SIZE (4 * 1024 * 1024)


section .rodata

msg_no_file:
    db "Usage: zero <source.zr>", 10
msg_no_file_len equ $ - msg_no_file

msg_open_error:
    db "Error: cannot open source file", 10
msg_open_error_len equ $ - msg_open_error

msg_read_error:
    db "Error: cannot read source file", 10
msg_read_error_len equ $ - msg_read_error


section .bss

align 16

source_buffer:
    resb SOURCE_BUFFER_SIZE


section .text

_start:

    ; argc
    mov rax, [rsp]

    ; Need argv[1]
    cmp rax, 2
    jb .no_file


    ; argv[1]
    mov r12, [rsp + 16]


    ; ========================================================
    ; OPEN
    ; ========================================================

    mov eax, SYS_OPENAT
    mov edi, AT_FDCWD
    mov rsi, r12
    mov edx, O_RDONLY
    xor r10d, r10d
    syscall

    test rax, rax
    js .open_error

    mov r13, rax


    ; ========================================================
    ; READ
    ; ========================================================

    mov eax, SYS_READ
    mov rdi, r13
    lea rsi, [rel source_buffer]
    mov edx, SOURCE_BUFFER_SIZE
    syscall

    test rax, rax
    js .read_error

    mov r14, rax


    ; ========================================================
    ; CLOSE
    ; ========================================================

    mov eax, SYS_CLOSE
    mov rdi, r13
    syscall


    ; ========================================================
    ; FIND DIRECTORY LENGTH
    ;
    ; Walk the path and remember the index right AFTER the
    ; last '/' found. That is the length of the directory
    ; part (including trailing slash). If no '/' is found,
    ; r15 stays 0, meaning "no directory" (use cwd).
    ; ========================================================

    mov rsi, r12
    xor rcx, rcx
    xor r15, r15

.find_path_end:

    cmp byte [rsi + rcx], 0
    je .path_end

    cmp byte [rsi + rcx], '/'
    jne .find_path_next

    lea r8, [rcx + 1]
    mov r15, r8

.find_path_next:

    inc rcx
    jmp .find_path_end


.path_end:

    ; ========================================================
    ; SET CURRENT SOURCE DIRECTORY
    ;
    ; RDI = path
    ; RSI = directory length (excludes filename)
    ; ========================================================

    mov rdi, r12
    mov rsi, r15

    call lexer_set_source_dir


    ; ========================================================
    ; INIT LEXER
    ;
    ; RDI = source buffer
    ; RSI = source length
    ; ========================================================

    lea rdi, [rel source_buffer]
    mov rsi, r14

    call lexer_init


    ; ========================================================
    ; PARSE
    ; ========================================================

    call parser_parse


    ; ========================================================
    ; EXIT 0
    ; ========================================================

    mov eax, SYS_EXIT
    xor edi, edi
    syscall


.no_file:

    mov eax, SYS_WRITE
    mov edi, 2
    lea rsi, [rel msg_no_file]
    mov edx, msg_no_file_len
    syscall

    mov eax, SYS_EXIT
    mov edi, 1
    syscall


.open_error:

    mov eax, SYS_WRITE
    mov edi, 2
    lea rsi, [rel msg_open_error]
    mov edx, msg_open_error_len
    syscall

    mov eax, SYS_EXIT
    mov edi, 1
    syscall


.read_error:

    mov eax, SYS_CLOSE
    mov rdi, r13
    syscall

    mov eax, SYS_WRITE
    mov edi, 2
    lea rsi, [rel msg_read_error]
    mov edx, msg_read_error_len
    syscall

    mov eax, SYS_EXIT
    mov edi, 1
    syscall