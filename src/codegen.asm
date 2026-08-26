default rel

global codegen_load_number
global codegen_load_variable
global codegen_load_array_element
global codegen_load_char
global codegen_load_string

global codegen_store_variable
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

global codegen_function_start
global codegen_function_end
global codegen_call_arg
global codegen_call_function
global codegen_return

extern current_number
extern token_value

extern ident_ptr
extern ident_len

extern string_ptr
extern string_len


%define SYS_WRITE 1
%define STDOUT    1

%define MAX_IF_DEPTH  256
%define MAX_REP_DEPTH 256

%define MAX_CALL_ARGS 64


section .rodata

s_colon:
db ":", 10
s_colon_len equ $ - s_colon

s_ret:
db "    ret", 10
s_ret_len equ $ - s_ret

s_call:
db "    call "
s_call_len equ $ - s_call

s_mov_rax:
db "    mov rax, "
s_mov_rax_len equ $ - s_mov_rax

s_mov_var:
db "    mov rax, QWORD ["
s_mov_var_len equ $ - s_mov_var

s_store_var:
db "    mov QWORD ["
s_store_var_len equ $ - s_store_var

s_store_rax:
db "], rax", 10
s_store_rax_len equ $ - s_store_rax

s_close:
db "]", 10
s_close_len equ $ - s_close

s_push:
db "    push rax", 10
s_push_len equ $ - s_push

s_add:
db "    pop rbx", 10
db "    add rax, rbx", 10
s_add_len equ $ - s_add

s_sub:
db "    pop rbx", 10
db "    mov rcx, rax", 10
db "    mov rax, rbx", 10
db "    sub rax, rcx", 10
s_sub_len equ $ - s_sub

s_mul:
db "    pop rbx", 10
db "    imul rax, rbx", 10
s_mul_len equ $ - s_mul

s_cmp_eq:
db "    pop rbx", 10
db "    cmp rbx, rax", 10
db "    sete al", 10
db "    movzx rax, al", 10
s_cmp_eq_len equ $ - s_cmp_eq

s_cmp_lt:
db "    pop rbx", 10
db "    cmp rbx, rax", 10
db "    setl al", 10
db "    movzx rax, al", 10
s_cmp_lt_len equ $ - s_cmp_lt

s_cmp_gt:
db "    pop rbx", 10
db "    cmp rbx, rax", 10
db "    setg al", 10
db "    movzx rax, al", 10
s_cmp_gt_len equ $ - s_cmp_gt

s_cmp_lte:
db "    pop rbx", 10
db "    cmp rbx, rax", 10
db "    setle al", 10
db "    movzx rax, al", 10
s_cmp_lte_len equ $ - s_cmp_lte

s_cmp_gte:
db "    pop rbx", 10
db "    cmp rbx, rax", 10
db "    setge al", 10
db "    movzx rax, al", 10
s_cmp_gte_len equ $ - s_cmp_gte

s_array:
db " + r11 * 8]", 10
s_array_len equ $ - s_array

s_newline:
db 10

s_if_test:
db "    test rax, rax", 10
db "    jz .L_if_else_"
s_if_test_len equ $ - s_if_test

s_if_jump_end:
db "    jmp .L_if_end_"
s_if_jump_end_len equ $ - s_if_jump_end

s_if_else:
db ".L_if_else_"
s_if_else_len equ $ - s_if_else

s_if_end:
db ".L_if_end_"
s_if_end_len equ $ - s_if_end

s_rep_start:
db ".L_rep_start_"
s_rep_start_len equ $ - s_rep_start

s_rep_jump:
db "    jmp .L_rep_start_"
s_rep_jump_len equ $ - s_rep_jump

s_rep_end:
db ".L_rep_end_"
s_rep_end_len equ $ - s_rep_end

s_string_header:
db "section .rodata", 10
db ".str_"
s_string_header_len equ $ - s_string_header

s_string_mid:
db ": db "
s_string_mid_len equ $ - s_string_mid

s_string_tail:
db ", 0", 10
db "section .text", 10
db "    lea rax, [rel .str_"
s_string_tail_len equ $ - s_string_tail

s_string_close:
db "]", 10
s_string_close_len equ $ - s_string_close


s_call_arg0:
db "    mov rdi, rax", 10
s_call_arg0_len equ $ - s_call_arg0

s_call_arg1:
db "    mov rsi, rax", 10
s_call_arg1_len equ $ - s_call_arg1

s_call_arg2:
db "    mov rdx, rax", 10
s_call_arg2_len equ $ - s_call_arg2

s_call_arg3:
db "    mov rcx, rax", 10
s_call_arg3_len equ $ - s_call_arg3

s_call_arg4:
db "    mov r8, rax", 10
s_call_arg4_len equ $ - s_call_arg4

s_call_arg5:
db "    mov r9, rax", 10
s_call_arg5_len equ $ - s_call_arg5


section .bss

label_counter:
resq 1

if_stack:
resq MAX_IF_DEPTH

if_depth:
resq 1

rep_stack:
resq MAX_REP_DEPTH

rep_depth:
resq 1

string_counter:
resq 1

call_arg_index:
resq 1

; Прапорець для відстеження, чи було вже згенеровано ret
has_returned:
resb 1


section .text


codegen_function_start:
    ; Скидаємо прапорець на початку кожної функції
    mov byte [rel has_returned], 0

    mov eax, SYS_WRITE
    mov edi, STDOUT

    mov rsi, [rel ident_ptr]
    mov rdx, [rel ident_len]

    syscall

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_colon]
    mov edx, s_colon_len

    syscall

    ret


codegen_function_end:
    ; Перевіряємо, чи вже був згенерований ret через явний return
    cmp byte [rel has_returned], 1
    je .skip_epilogue_ret

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_ret]
    mov edx, s_ret_len

    syscall

.skip_epilogue_ret:
    ret


codegen_call_arg:
    mov rcx, [rel call_arg_index]

    cmp rcx, 0
    je .arg0

    cmp rcx, 1
    je .arg1

    cmp rcx, 2
    je .arg2

    cmp rcx, 3
    je .arg3

    cmp rcx, 4
    je .arg4

    cmp rcx, 5
    je .arg5

    ret

.arg0:
    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_call_arg0]
    mov edx, s_call_arg0_len

    syscall

    ret

.arg1:
    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_call_arg1]
    mov edx, s_call_arg1_len

    syscall

    ret

.arg2:
    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_call_arg2]
    mov edx, s_call_arg2_len

    syscall

    ret

.arg3:
    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_call_arg3]
    mov edx, s_call_arg3_len

    syscall

    ret

.arg4:
    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_call_arg4]
    mov edx, s_call_arg4_len

    syscall

    ret

.arg5:
    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_call_arg5]
    mov edx, s_call_arg5_len

    syscall

    ret


codegen_call_function:
    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_call]
    mov edx, s_call_len

    syscall

    mov eax, SYS_WRITE
    mov edi, STDOUT

    mov rsi, [rel ident_ptr]
    mov rdx, [rel ident_len]

    syscall

    call emit_newline

    ret


codegen_return:
    ; Встановлюємо прапорець, що ret уже згенеровано
    mov byte [rel has_returned], 1

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_ret]
    mov edx, s_ret_len

    syscall

    ret


codegen_load_number:
    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_mov_rax]
    mov edx, s_mov_rax_len

    syscall

    mov rax, [rel current_number]

    call print_uint
    call emit_newline

    ret


codegen_load_char:
    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_mov_rax]
    mov edx, s_mov_rax_len

    syscall

    mov rax, [rel token_value]

    call print_uint
    call emit_newline

    ret


codegen_load_variable:
    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_mov_var]
    mov edx, s_mov_var_len

    syscall

    mov eax, SYS_WRITE
    mov edi, STDOUT

    mov rsi, [rel ident_ptr]
    mov rdx, [rel ident_len]

    syscall

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_close]
    mov edx, s_close_len

    syscall

    ret


codegen_load_array_element:
    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_mov_var]
    mov edx, s_mov_var_len

    syscall

    mov eax, SYS_WRITE
    mov edi, STDOUT

    mov rsi, [rel ident_ptr]
    mov rdx, [rel ident_len]

    syscall

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_array]
    mov edx, s_array_len

    syscall

    ret


codegen_store_variable:
    mov r10, rax

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_store_var]
    mov edx, s_store_var_len

    syscall

    mov eax, SYS_WRITE
    mov edi, STDOUT

    mov rsi, [rel ident_ptr]
    mov rdx, [rel ident_len]

    syscall

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_store_rax]
    mov edx, s_store_rax_len

    syscall

    mov rax, r10

    ret


codegen_save_value:
    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_push]
    mov edx, s_push_len

    syscall

    ret


codegen_add:
    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_add]
    mov edx, s_add_len

    syscall

    ret


codegen_sub:
    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_sub]
    mov edx, s_sub_len

    syscall

    ret


codegen_mul:
    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_mul]
    mov edx, s_mul_len

    syscall

    ret


codegen_cmp_eq:
    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_cmp_eq]
    mov edx, s_cmp_eq_len

    syscall

    ret


codegen_cmp_lt:
    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_cmp_lt]
    mov edx, s_cmp_lt_len

    syscall

    ret


codegen_cmp_gt:
    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_cmp_gt]
    mov edx, s_cmp_gt_len

    syscall

    ret


codegen_cmp_lte:
    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_cmp_lte]
    mov edx, s_cmp_lte_len

    syscall

    ret


codegen_cmp_gte:
    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_cmp_gte]
    mov edx, s_cmp_gte_len

    syscall

    ret


codegen_if_start:
    mov rcx, [rel if_depth]

    cmp rcx, MAX_IF_DEPTH
    jae .if_start_return

    mov r10, [rel label_counter]

    inc qword [rel label_counter]

    lea r11, [rel if_stack]
    mov [r11 + rcx * 8], r10

    inc qword [rel if_depth]

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_if_test]
    mov edx, s_if_test_len

    syscall

    mov rax, r10

    call print_uint
    call emit_newline

.if_start_return:
    ret


codegen_if_else:
    mov rcx, [rel if_depth]

    test rcx, rcx
    jz .if_else_return

    dec rcx

    lea r11, [rel if_stack]
    mov r10, [r11 + rcx * 8]

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_if_jump_end]
    mov edx, s_if_jump_end_len

    syscall

    mov rax, r10

    call print_uint
    call emit_newline

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_if_else]
    mov edx, s_if_else_len

    syscall

    mov rax, r10

    call print_uint
    call emit_newline

.if_else_return:
    ret


codegen_if_end:
    mov rcx, [rel if_depth]

    test rcx, rcx
    jz .if_end_return

    dec rcx

    lea r11, [rel if_stack]
    mov r10, [r11 + rcx * 8]

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_if_end]
    mov edx, s_if_end_len

    syscall

    mov rax, r10

    call print_uint
    call emit_newline

    mov [rel if_depth], rcx

.if_end_return:
    ret


codegen_rep_start:
    mov rcx, [rel rep_depth]

    cmp rcx, MAX_REP_DEPTH
    jae .rep_start_return

    mov r10, [rel label_counter]

    inc qword [rel label_counter]

    lea r11, [rel rep_stack]
    mov [r11 + rcx * 8], r10

    inc qword [rel rep_depth]

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_rep_start]
    mov edx, s_rep_start_len

    syscall

    mov rax, r10

    call print_uint
    call emit_newline

.rep_start_return:
    ret


codegen_rep_end:
    mov rcx, [rel rep_depth]

    test rcx, rcx
    jz .rep_end_return

    dec rcx

    lea r11, [rel rep_stack]
    mov r10, [r11 + rcx * 8]

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_rep_jump]
    mov edx, s_rep_jump_len

    syscall

    mov rax, r10

    call print_uint
    call emit_newline

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_rep_end]
    mov edx, s_rep_end_len

    syscall

    mov rax, r10

    call print_uint
    call emit_newline

    mov [rel rep_depth], rcx

.rep_end_return:
    ret


codegen_load_string:
    mov r10, [rel string_counter]

    inc qword [rel string_counter]

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_string_header]
    mov edx, s_string_header_len

    syscall

    mov rax, r10

    call print_uint

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_string_mid]
    mov edx, s_string_mid_len

    syscall

    mov eax, SYS_WRITE
    mov edi, STDOUT

    mov rsi, [rel string_ptr]
    mov rdx, [rel string_len]

    syscall

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_string_tail]
    mov edx, s_string_tail_len

    syscall

    mov rax, r10

    call print_uint

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_string_close]
    mov edx, s_string_close_len

    syscall

    ret


emit_newline:
    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_newline]
    mov edx, 1

    syscall

    ret


print_uint:
    push rbp
    mov rbp, rsp

    sub rsp, 32

    test rax, rax
    jnz .print_convert

    mov byte [rbp - 1], '0'

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rbp - 1]
    mov edx, 1

    syscall

    leave
    ret

.print_convert:
    lea r8, [rbp - 2]
    mov r9, 10

.print_convert_loop:
    xor edx, edx
    div r9
    add dl, '0'
    mov [r8], dl
    dec r8
    test rax, rax
    jnz .print_convert_loop

    inc r8
    mov rsi, r8

    lea rdx, [rbp - 1]
    sub rdx, rsi

    mov eax, SYS_WRITE
    mov edi, STDOUT

    syscall

    leave
    ret