DEFAULT REL

global codegen_load_number
global codegen_load_variable
global codegen_load_array_element
global codegen_load_char
global codegen_load_string

global codegen_save_value

global codegen_add
global codegen_sub
global codegen_mul

global codegen_cmp_eq
global codegen_cmp_lt
global codegen_cmp_gt
global codegen_cmp_lte
global codegen_cmp_gte

global codegen_if_start
global codegen_if_else
global codegen_if_end

global codegen_rep_start
global codegen_rep_end

extern current_number
extern token_value

extern ident_ptr
extern ident_len

extern string_ptr
extern string_len


section .data

s_mov_rax:
    db "    mov rax, ", 0

s_mov_var:
    db "    mov rax, QWORD [", 0

s_close:
    db "]", 10, 0

s_push_rax:
    db "    push rax", 10, 0

s_add:
    db "    pop rbx", 10
    db "    add rax, rbx", 10, 0

s_sub:
    db "    pop rbx", 10
    db "    mov rcx, rax", 10
    db "    mov rax, rbx", 10
    db "    sub rax, rcx", 10, 0

s_mul:
    db "    pop rbx", 10
    db "    imul rax, rbx", 10, 0

s_cmp_eq:
    db "    pop rbx", 10
    db "    cmp rbx, rax", 10
    db "    sete al", 10
    db "    movzx rax, al", 10, 0

s_cmp_lt:
    db "    pop rbx", 10
    db "    cmp rbx, rax", 10
    db "    setl al", 10
    db "    movzx rax, al", 10, 0

s_cmp_gt:
    db "    pop rbx", 10
    db "    cmp rbx, rax", 10
    db "    setg al", 10
    db "    movzx rax, al", 10, 0

s_cmp_lte:
    db "    pop rbx", 10
    db "    cmp rbx, rax", 10
    db "    setle al", 10
    db "    movzx rax, al", 10, 0

s_cmp_gte:
    db "    pop rbx", 10
    db "    cmp rbx, rax", 10
    db "    setge al", 10
    db "    movzx rax, al", 10, 0

s_if_test:
    db "    test rax, rax", 10
    db "    jz .L_if_else_", 0

s_if_else:
    db "    jmp .L_if_end_", 0

s_if_else_label:
    db ".L_if_else_", 0

s_if_end_label:
    db ".L_if_end_", 0

s_rep_label:
    db ".L_rep_start_", 0

s_rep_test:
    db "    test rax, rax", 10
    db "    jz .L_rep_end_", 0

s_rep_jump:
    db "    jmp .L_rep_start_", 0

s_rep_end:
    db ".L_rep_end_", 0

s_rodata:
    db 10
    db "section .rodata", 10
    db ".str_", 0

s_db:
    db ": db `", 0

s_db_end:
    db "`, 0", 10
    db "section .text", 10
    db "    lea rax, [rel .str_", 0

s_nl:
    db 10


section .bss

label_counter:
    resq 1

if_stack:
    resq 256

if_depth:
    resq 1

rep_counter:
    resq 1

rep_stack:
    resq 256

rep_depth:
    resq 1

string_counter:
    resq 1


section .text


codegen_load_number:
    mov eax, 1
    mov edi, 1
    lea rsi, [s_mov_rax]
    mov edx, 13
    syscall

    mov rax, [current_number]
    call print_uint

    call emit_newline
    ret


codegen_load_char:
    mov eax, 1
    mov edi, 1
    lea rsi, [s_mov_rax]
    mov edx, 13
    syscall

    mov rax, [token_value]
    call print_uint

    call emit_newline
    ret


codegen_load_variable:
    mov eax, 1
    mov edi, 1
    lea rsi, [s_mov_var]
    mov edx, 21
    syscall

    mov eax, 1
    mov edi, 1
    mov rsi, [ident_ptr]
    mov rdx, [ident_len]
    syscall

    mov eax, 1
    mov edi, 1
    lea rsi, [s_close]
    mov edx, 2
    syscall

    ret


codegen_load_array_element:
    mov eax, 1
    mov edi, 1
    lea rsi, [s_mov_var]
    mov edx, 21
    syscall

    mov eax, 1
    mov edi, 1
    mov rsi, [ident_ptr]
    mov rdx, [ident_len]
    syscall

    mov eax, 1
    mov edi, 1
    lea rsi, [array_suffix]
    mov edx, array_suffix_len
    syscall

    ret


section .data

array_suffix:
    db " + r11 * 8]", 10, 0

array_suffix_len equ $ - array_suffix

section .text


codegen_load_string:
    mov r10, [string_counter]
    inc qword [string_counter]

    mov eax, 1
    mov edi, 1
    lea rsi, [s_rodata]
    mov edx, 20
    syscall

    mov rax, r10
    call print_uint

    mov eax, 1
    mov edi, 1
    lea rsi, [s_db]
    mov edx, 8
    syscall

    mov eax, 1
    mov edi, 1
    mov rsi, [string_ptr]
    mov rdx, [string_len]
    syscall

    mov eax, 1
    mov edi, 1
    lea rsi, [s_db_end]
    mov edx, 38
    syscall

    mov rax, r10
    call print_uint

    mov eax, 1
    mov edi, 1
    lea rsi, [s_close]
    mov edx, 2
    syscall

    ret


codegen_save_value:
    mov eax, 1
    mov edi, 1
    lea rsi, [s_push_rax]
    mov edx, 14
    syscall
    ret


codegen_add:
    mov eax, 1
    mov edi, 1
    lea rsi, [s_add]
    mov edx, 35
    syscall
    ret


codegen_sub:
    mov eax, 1
    mov edi, 1
    lea rsi, [s_sub]
    mov edx, 72
    syscall
    ret


codegen_mul:
    mov eax, 1
    mov edi, 1
    lea rsi, [s_mul]
    mov edx, 36
    syscall
    ret


codegen_cmp_eq:
    mov eax, 1
    mov edi, 1
    lea rsi, [s_cmp_eq]
    mov edx, 76
    syscall
    ret


codegen_cmp_lt:
    mov eax, 1
    mov edi, 1
    lea rsi, [s_cmp_lt]
    mov edx, 76
    syscall
    ret


codegen_cmp_gt:
    mov eax, 1
    mov edi, 1
    lea rsi, [s_cmp_gt]
    mov edx, 76
    syscall
    ret


codegen_cmp_lte:
    mov eax, 1
    mov edi, 1
    lea rsi, [s_cmp_lte]
    mov edx, 77
    syscall
    ret


codegen_cmp_gte:
    mov eax, 1
    mov edi, 1
    lea rsi, [s_cmp_gte]
    mov edx, 77
    syscall
    ret


codegen_if_start:
    mov rcx, [if_depth]

    cmp rcx, 256
    jae .return

    mov r10, [label_counter]
    inc qword [label_counter]

    mov [if_stack + rcx * 8], r10
    inc qword [if_depth]

    mov eax, 1
    mov edi, 1
    lea rsi, [s_if_test]
    mov edx, 34
    syscall

    mov rax, r10
    call print_uint

    call emit_newline

.return:
    ret


codegen_if_else:
    mov rcx, [if_depth]

    test rcx, rcx
    jz .return

    dec rcx

    mov r10, [if_stack + rcx * 8]

    mov eax, 1
    mov edi, 1
    lea rsi, [s_if_else]
    mov edx, 27
    syscall

    mov rax, r10
    call print_uint

    call emit_newline

    mov eax, 1
    mov edi, 1
    lea rsi, [s_if_else_label]
    mov edx, 12
    syscall

    mov rax, r10
    call print_uint

    mov eax, 1
    mov edi, 1
    lea rsi, [colon_nl]
    mov edx, 2
    syscall

.return:
    ret


codegen_if_end:
    mov rcx, [if_depth]

    test rcx, rcx
    jz .return

    dec rcx

    mov r10, [if_stack + rcx * 8]

    mov eax, 1
    mov edi, 1
    lea rsi, [s_if_end_label]
    mov edx, 11
    syscall

    mov rax, r10
    call print_uint

    mov eax, 1
    mov edi, 1
    lea rsi, [colon_nl]
    mov edx, 2
    syscall

.return:
    ret


codegen_rep_start:
    mov rcx, [rep_depth]

    cmp rcx, 256
    jae .return

    mov r10, [rep_counter]
    inc qword [rep_counter]

    mov [rep_stack + rcx * 8], r10
    inc qword [rep_depth]

    mov eax, 1
    mov edi, 1
    lea rsi, [s_rep_label]
    mov edx, 15
    syscall

    mov rax, r10
    call print_uint

    mov eax, 1
    mov edi, 1
    lea rsi, [colon_nl]
    mov edx, 2
    syscall

    mov eax, 1
    mov edi, 1
    lea rsi, [s_rep_test]
    mov edx, 34
    syscall

    mov rax, r10
    call print_uint

    call emit_newline

.return:
    ret


codegen_rep_end:
    mov rcx, [rep_depth]

    test rcx, rcx
    jz .return

    dec rcx

    mov r10, [rep_stack + rcx * 8]

    mov eax, 1
    mov edi, 1
    lea rsi, [s_rep_jump]
    mov edx, 28
    syscall

    mov rax, r10
    call print_uint

    call emit_newline

    mov eax, 1
    mov edi, 1
    lea rsi, [s_rep_end]
    mov edx, 13
    syscall

    mov rax, r10
    call print_uint

    mov eax, 1
    mov edi, 1
    lea rsi, [colon_nl]
    mov edx, 2
    syscall

.return:
    ret


emit_newline:
    mov eax, 1
    mov edi, 1
    lea rsi, [s_nl]
    mov edx, 1
    syscall
    ret


print_uint:
    push rbp
    mov rbp, rsp
    sub rsp, 32

    test rax, rax
    jnz .convert

    mov byte [rbp - 1], '0'

    mov eax, 1
    mov edi, 1
    lea rsi, [rbp - 1]
    mov edx, 1
    syscall

    leave
    ret


.convert:
    lea r8, [rbp - 2]
    mov ecx, 10

.loop:
    xor edx, edx
    div rcx

    add dl, '0'
    mov [r8], dl
    dec r8

    test rax, rax
    jnz .loop

    inc r8
    mov rsi, r8

    lea rdx, [rbp - 1]
    sub rdx, rsi

    mov eax, 1
    mov edi, 1
    syscall

    leave
    ret


section .data

colon_nl:
    db ":", 10