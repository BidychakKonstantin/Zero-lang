default rel

global write_bytes
global write_err
global syscall2
global read_file
global get_arg
global arg_count
global runtime_init
global poke8

section .bss

runtime_sp:
    resq 1

section .text

runtime_init:
    mov [rel runtime_sp], rdi
    ret

write_bytes:
    mov rdx, rsi
    mov rsi, rdi
    mov edi, 1
    mov eax, 1
    syscall
    ret

write_err:
    mov rdx, rsi
    mov rsi, rdi
    mov edi, 2
    mov eax, 1
    syscall
    ret

syscall2:
    mov rax, rdi
    mov rdi, rsi
    syscall
    ret

poke8:
    mov [rdi], sil
    xor eax, eax
    ret

arg_count:
    mov rax, [rel runtime_sp]
    mov rax, [rax]
    ret

get_arg:
    mov rax, [rel runtime_sp]
    mov rax, [rax + rdi * 8 + 8]
    ret

read_file:
    push r12
    mov r8, rsi
    mov r9, rdx
    mov rsi, rdi
    mov edi, -100
    xor edx, edx
    xor r10d, r10d
    mov eax, 257
    syscall
    test rax, rax
    js .err
    mov r12, rax
    xor eax, eax
    mov rdi, r12
    mov rsi, r8
    mov rdx, r9
    syscall
    push rax
    mov eax, 3
    mov rdi, r12
    syscall
    pop rax
    pop r12
    ret
.err:
    mov rax, -1
    pop r12
    ret