default rel

global codegen_set_global
global codegen_set_local

global codegen_load_number
global codegen_load_variable
global codegen_load_array_element
global codegen_load_char
global codegen_load_string

global codegen_declare_variable
global codegen_declare_array
global codegen_store_array_element
global codegen_load_address
global codegen_load_arg_register
global codegen_store_variable
global codegen_save_value
global codegen_dereference

global codegen_add
global codegen_sub
global codegen_mul

global codegen_cmp_eq
global codegen_cmp_neq
global codegen_cmp_lt
global codegen_cmp_gt
global codegen_cmp_lte
global codegen_cmp_gte

global codegen_and
global codegen_or

global codegen_if_start
global codegen_if_else
global codegen_if_end

global codegen_rep_start
global codegen_rep_start_condition
global codegen_rep_condition_check
global codegen_rep_end

global codegen_function_start
global codegen_function_end
global codegen_call_arg
global codegen_call_function
global codegen_return
global codegen_print

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

section .data

header_emitted:
    db 0

section .rodata

s_header:
    db "default rel", 10
    db 10
    db "global _start", 10
    db "_start:", 10
    db "    call main", 10
    db "    mov edi, eax", 10
    db "    mov eax, 60", 10
    db "    syscall", 10
    db 10
s_header_len equ $ - s_header

s_colon:
    db ":", 10
s_colon_len equ $ - s_colon

s_newline:
    db 10

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

s_deref:
    db "    movzx rax, byte [rax]", 10
s_deref_len equ $ - s_deref

s_close:
    db "]", 10
s_close_len equ $ - s_close

s_local_suffix:
    db "_f"
s_local_suffix_len equ $ - s_local_suffix

s_arg_reg0:
    db "    mov rax, rdi", 10
s_arg_reg0_len equ $ - s_arg_reg0

s_arg_reg1:
    db "    mov rax, rsi", 10
s_arg_reg1_len equ $ - s_arg_reg1

s_arg_reg2:
    db "    mov rax, rdx", 10
s_arg_reg2_len equ $ - s_arg_reg2

s_arg_reg3:
    db "    mov rax, rcx", 10
s_arg_reg3_len equ $ - s_arg_reg3

s_arg_reg4:
    db "    mov rax, r8", 10
s_arg_reg4_len equ $ - s_arg_reg4

s_arg_reg5:
    db "    mov rax, r9", 10
s_arg_reg5_len equ $ - s_arg_reg5

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

s_cmp_neq:
    db "    pop rbx", 10
    db "    cmp rbx, rax", 10
    db "    setne al", 10
    db "    movzx rax, al", 10
s_cmp_neq_len equ $ - s_cmp_neq

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

s_and:
    db "    pop rbx", 10
    db "    test rax, rax", 10
    db "    setne al", 10
    db "    test rbx, rbx", 10
    db "    setne bl", 10
    db "    and al, bl", 10
    db "    movzx rax, al", 10
s_and_len equ $ - s_and

s_or:
    db "    pop rbx", 10
    db "    or rax, rbx", 10
    db "    test rax, rax", 10
    db "    setne al", 10
    db "    movzx rax, al", 10
s_or_len equ $ - s_or

s_array_index:
    db "    mov r11, rax", 10
s_array_index_len equ $ - s_array_index

s_array:
    db " + r11 * 8]", 10
s_array_len equ $ - s_array

s_if_test:
    db "    test rax, rax", 10
    db "    jz L_if_else_"
s_if_test_len equ $ - s_if_test

s_if_jump_end:
    db "    jmp L_if_end_"
s_if_jump_end_len equ $ - s_if_jump_end

s_if_else:
    db "L_if_else_"
s_if_else_len equ $ - s_if_else

s_if_end:
    db "L_if_end_"
s_if_end_len equ $ - s_if_end

s_rep_start:
    db "L_rep_start_"
s_rep_start_len equ $ - s_rep_start

s_rep_check:
    db ":", 10
    db "    cmp qword [rsp], 0", 10
    db "    jle L_rep_end_"
s_rep_check_len equ $ - s_rep_check

s_rep_dec_jump:
    db "    dec qword [rsp]", 10
    db "    jmp L_rep_start_"
s_rep_dec_jump_len equ $ - s_rep_dec_jump

s_rep_end_label:
    db "L_rep_end_"
s_rep_end_label_len equ $ - s_rep_end_label

s_rep_cleanup:
    db ":", 10
    db "    add rsp, 8", 10
s_rep_cleanup_len equ $ - s_rep_cleanup

s_rep_cond_test:
    db "    test rax, rax", 10
    db "    jz L_rep_end_"
s_rep_cond_test_len equ $ - s_rep_cond_test

s_rep_cond_jump:
    db "    jmp L_rep_start_"
s_rep_cond_jump_len equ $ - s_rep_cond_jump

s_string_header:
    db "section .rodata", 10
    db "str_"
s_string_header_len equ $ - s_string_header

s_string_mid:
    db ": db "
s_string_mid_len equ $ - s_string_mid

s_string_tail:
    db ", 0", 10
    db "section .text", 10
    db "    lea rax, [rel str_"
s_string_tail_len equ $ - s_string_tail

s_string_close:
    db "]", 10
s_string_close_len equ $ - s_string_close

s_print_sub:
    db "    sub rsp, 32", 10
    db "    mov r8, rsp", 10
    db "    add r8, 31", 10
    db "    mov byte [r8], 10", 10
    db "    mov r9, r8", 10
    db "    test rax, rax", 10
    db "    jnz L_pr_c_"
s_print_sub_len equ $ - s_print_sub

s_print_zero:
    db 10
    db "    dec r8", 10
    db "    mov byte [r8], '0'", 10
    db "    jmp L_pr_o_"
s_print_zero_len equ $ - s_print_zero

s_print_lbl_c:
    db 10
    db "L_pr_c_"
s_print_lbl_c_len equ $ - s_print_lbl_c

s_print_loop_head:
    db ":", 10
    db "    mov r10, 10", 10
    db "L_pr_l_"
s_print_loop_head_len equ $ - s_print_loop_head

s_print_loop_body:
    db ":", 10
    db "    test rax, rax", 10
    db "    jz L_pr_o_"
s_print_loop_body_len equ $ - s_print_loop_body

s_print_loop_foot:
    db 10
    db "    xor rdx, rdx", 10
    db "    div r10", 10
    db "    add dl, '0'", 10
    db "    dec r8", 10
    db "    mov [r8], dl", 10
    db "    jmp L_pr_l_"
s_print_loop_foot_len equ $ - s_print_loop_foot

s_print_lbl_o:
    db 10
    db "L_pr_o_"
s_print_lbl_o_len equ $ - s_print_lbl_o

s_print_syscall:
    db ":", 10
    db "    mov eax, 1", 10
    db "    mov edi, 1", 10
    db "    mov rsi, r8", 10
    db "    mov rdx, r9", 10
    db "    inc rdx", 10
    db "    sub rdx, r8", 10
    db "    syscall", 10
    db "    add rsp, 32", 10
s_print_syscall_len equ $ - s_print_syscall

s_bss_var:
    db "section .bss", 10
s_bss_var_len equ $ - s_bss_var

s_var_resq:
    db ": resq 1", 10
    db "section .text", 10
s_var_resq_len equ $ - s_var_resq

s_resq_space:
    db ": resq "
s_resq_space_len equ $ - s_resq_space

s_section_text:
    db 10, "section .text", 10
s_section_text_len equ $ - s_section_text

s_store_arr_pop:
    db "    mov r12, rax", 10
    db "    pop r11", 10
    db "    mov QWORD ["
s_store_arr_pop_len equ $ - s_store_arr_pop

s_array_close_store:
    db " + r11 * 8], r12", 10
s_array_close_store_len equ $ - s_array_close_store

s_lea_rax:
    db "    lea rax, ["
s_lea_rax_len equ $ - s_lea_rax

section .bss

align 8

label_counter:
    resq 1

function_counter:
    resq 1

codegen_current_scope:
    resq 1

if_stack:
    resq MAX_IF_DEPTH

if_has_else:
    resb MAX_IF_DEPTH

if_depth:
    resq 1

rep_stack:
    resq MAX_REP_DEPTH

rep_depth:
    resq 1

rep_mode_stack:
    resb MAX_REP_DEPTH

rep_condition:
    resq 1

string_counter:
    resq 1

call_arg_index:
    resq 1

has_returned:
    resb 1

section .text

emit_header:

    cmp byte [rel header_emitted], 1
    je .done

    mov byte [rel header_emitted], 1

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_header]
    mov edx, s_header_len

    syscall

.done:
    ret

codegen_set_global:

    mov qword [rel codegen_current_scope], 0

    ret

codegen_set_local:

    mov qword [rel codegen_current_scope], 1

    ret

codegen_emit_variable_label:

    push r12
    push r13

    mov r12, rdi
    mov r13, rsi

    cmp qword [rel codegen_current_scope], 0
    je .global

    mov eax, SYS_WRITE
    mov edi, STDOUT

    mov rsi, r12
    mov rdx, r13

    syscall

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_local_suffix]
    mov edx, s_local_suffix_len

    syscall

    mov rax, [rel function_counter]

    call print_uint

    jmp .done

.global:

    mov eax, SYS_WRITE
    mov edi, STDOUT

    mov rsi, r12
    mov rdx, r13

    syscall

.done:

    pop r13
    pop r12

    ret

codegen_function_start:

    call emit_header

    inc qword [rel function_counter]

    mov byte [rel has_returned], 0

    mov qword [rel codegen_current_scope], 1

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

    cmp byte [rel has_returned], 1
    je .done

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_ret]
    mov edx, s_ret_len

    syscall

.done:
    ret

codegen_call_arg:
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

global codegen_truncate_int8
global codegen_truncate_nat8
global codegen_truncate_int16
global codegen_truncate_nat16
global codegen_truncate_int32
global codegen_truncate_nat32

s_trunc_int8:
    db "    movsx rax, al", 10
s_trunc_int8_len equ $ - s_trunc_int8

s_trunc_nat8:
    db "    movzx rax, al", 10
s_trunc_nat8_len equ $ - s_trunc_nat8

s_trunc_int16:
    db "    movsx rax, ax", 10
s_trunc_int16_len equ $ - s_trunc_int16

s_trunc_nat16:
    db "    movzx rax, ax", 10
s_trunc_nat16_len equ $ - s_trunc_nat16

s_trunc_int32:
    db "    cdqe", 10
s_trunc_int32_len equ $ - s_trunc_int32

s_trunc_nat32:
    db "    mov eax, eax", 10
s_trunc_nat32_len equ $ - s_trunc_nat32

codegen_truncate_int8:

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_trunc_int8]
    mov edx, s_trunc_int8_len

    syscall

    ret

codegen_truncate_nat8:

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_trunc_nat8]
    mov edx, s_trunc_nat8_len

    syscall

    ret

codegen_truncate_int16:

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_trunc_int16]
    mov edx, s_trunc_int16_len

    syscall

    ret

codegen_truncate_nat16:

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_trunc_nat16]
    mov edx, s_trunc_nat16_len

    syscall

    ret

codegen_truncate_int32:

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_trunc_int32]
    mov edx, s_trunc_int32_len

    syscall

    ret

codegen_truncate_nat32:

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_trunc_nat32]
    mov edx, s_trunc_nat32_len

    syscall

    ret

codegen_return:

    mov rcx, [rel if_depth]
    add rcx, [rel rep_depth]
    test rcx, rcx
    jnz .emit_ret

    mov byte [rel has_returned], 1

.emit_ret:
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

codegen_declare_variable:

    call emit_header

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_bss_var]
    mov edx, s_bss_var_len

    syscall

    mov rdi, [rel ident_ptr]
    mov rsi, [rel ident_len]

    call codegen_emit_variable_label

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_var_resq]
    mov edx, s_var_resq_len

    syscall

    ret

codegen_declare_array:

    push rdi

    call emit_header

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_bss_var]
    mov edx, s_bss_var_len

    syscall

    mov rdi, [rel ident_ptr]
    mov rsi, [rel ident_len]

    call codegen_emit_variable_label

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_resq_space]
    mov edx, s_resq_space_len

    syscall

    pop rax

    call print_uint

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_section_text]
    mov edx, s_section_text_len

    syscall

    ret

codegen_store_array_element:

    mov eax, SYS_WRITE
    mov edi, STDOUT
    lea rsi, [rel s_store_arr_pop]
    mov edx, s_store_arr_pop_len
    syscall

    mov rdi, [rel ident_ptr]
    mov rsi, [rel ident_len]
    call codegen_emit_variable_label

    mov eax, SYS_WRITE
    mov edi, STDOUT
    lea rsi, [rel s_array_close_store]
    mov edx, s_array_close_store_len
    syscall

    ret

codegen_load_address:

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_lea_rax]
    mov edx, s_lea_rax_len

    syscall

    mov rdi, [rel ident_ptr]
    mov rsi, [rel ident_len]

    call codegen_emit_variable_label

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_close]
    mov edx, s_close_len

    syscall

    ret

codegen_load_arg_register:

    cmp rax, 0
    je .reg0

    cmp rax, 1
    je .reg1

    cmp rax, 2
    je .reg2

    cmp rax, 3
    je .reg3

    cmp rax, 4
    je .reg4

    cmp rax, 5
    je .reg5

    ret

.reg0:
    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_arg_reg0]
    mov edx, s_arg_reg0_len

    syscall

    ret

.reg1:
    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_arg_reg1]
    mov edx, s_arg_reg1_len

    syscall

    ret

.reg2:
    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_arg_reg2]
    mov edx, s_arg_reg2_len

    syscall

    ret

.reg3:
    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_arg_reg3]
    mov edx, s_arg_reg3_len

    syscall

    ret

.reg4:
    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_arg_reg4]
    mov edx, s_arg_reg4_len

    syscall

    ret

.reg5:
    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_arg_reg5]
    mov edx, s_arg_reg5_len

    syscall

    ret

codegen_load_variable:

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_mov_var]
    mov edx, s_mov_var_len

    syscall

    mov rdi, [rel ident_ptr]
    mov rsi, [rel ident_len]

    call codegen_emit_variable_label

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_close]
    mov edx, s_close_len

    syscall

    ret

codegen_load_array_element:

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_array_index]
    mov edx, s_array_index_len

    syscall

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_mov_var]
    mov edx, s_mov_var_len

    syscall

    mov rdi, [rel ident_ptr]
    mov rsi, [rel ident_len]

    call codegen_emit_variable_label

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

    mov rdi, [rel ident_ptr]
    mov rsi, [rel ident_len]

    call codegen_emit_variable_label

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

codegen_dereference:

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_deref]
    mov edx, s_deref_len

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

codegen_cmp_neq:

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_cmp_neq]
    mov edx, s_cmp_neq_len

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

codegen_and:

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_and]
    mov edx, s_and_len

    syscall

    ret

codegen_or:

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_or]
    mov edx, s_or_len

    syscall

    ret

codegen_if_start:

    mov rcx, [rel if_depth]

    cmp rcx, MAX_IF_DEPTH
    jae .done

    mov r10, [rel label_counter]

    inc qword [rel label_counter]

    lea r11, [rel if_stack]

    mov [r11 + rcx * 8], r10

    lea r11, [rel if_has_else]

    mov byte [r11 + rcx], 0

    inc qword [rel if_depth]

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_if_test]
    mov edx, s_if_test_len

    syscall

    mov rax, r10

    call print_uint

    call emit_newline

.done:
    ret

codegen_if_else:

    mov rcx, [rel if_depth]

    test rcx, rcx
    jz .done

    dec rcx

    lea r11, [rel if_stack]

    mov r10, [r11 + rcx * 8]

    lea r11, [rel if_has_else]

    mov byte [r11 + rcx], 1

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

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_colon]
    mov edx, s_colon_len

    syscall

.done:
    ret

codegen_if_end:

    mov rcx, [rel if_depth]

    test rcx, rcx
    jz .done

    dec rcx

    mov [rel if_depth], rcx

    lea r11, [rel if_stack]

    mov r10, [r11 + rcx * 8]

    lea r11, [rel if_has_else]

    cmp byte [r11 + rcx], 1
    je .emit_end

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_if_else]
    mov edx, s_if_else_len

    syscall

    mov rax, r10

    call print_uint

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_colon]
    mov edx, s_colon_len

    syscall

.emit_end:

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_if_end]
    mov edx, s_if_end_len

    syscall

    mov rax, r10

    call print_uint

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_colon]
    mov edx, s_colon_len

    syscall

.done:
    ret

codegen_rep_start:

    mov rcx, [rel rep_depth]

    cmp rcx, MAX_REP_DEPTH
    jae .done

    mov r10, [rel label_counter]

    inc qword [rel label_counter]

    lea r11, [rel rep_stack]

    mov [r11 + rcx * 8], r10

    lea r11, [rel rep_mode_stack]

    mov byte [r11 + rcx], 0

    inc qword [rel rep_depth]

    mov [rel rep_condition], rdi

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_mov_rax]
    mov edx, s_mov_rax_len

    syscall

    mov rax, [rel rep_condition]

    call print_uint

    call emit_newline

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_push]
    mov edx, s_push_len

    syscall

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_rep_start]
    mov edx, s_rep_start_len

    syscall

    mov rax, r10

    call print_uint

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_rep_check]
    mov edx, s_rep_check_len

    syscall

    mov rax, r10

    call print_uint

    call emit_newline

.done:
    ret

codegen_rep_start_condition:

    mov rcx, [rel rep_depth]

    cmp rcx, MAX_REP_DEPTH
    jae .done

    mov r10, [rel label_counter]

    inc qword [rel label_counter]

    lea r11, [rel rep_stack]

    mov [r11 + rcx * 8], r10

    lea r11, [rel rep_mode_stack]

    mov byte [r11 + rcx], 1

    inc qword [rel rep_depth]

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_rep_start]
    mov edx, s_rep_start_len

    syscall

    mov rax, r10

    call print_uint

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_colon]
    mov edx, s_colon_len

    syscall

.done:
    ret

codegen_rep_condition_check:

    mov rcx, [rel rep_depth]

    test rcx, rcx
    jz .done

    dec rcx

    lea r11, [rel rep_stack]

    mov r10, [r11 + rcx * 8]

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_rep_cond_test]
    mov edx, s_rep_cond_test_len

    syscall

    mov rax, r10

    call print_uint

    call emit_newline

.done:
    ret

codegen_rep_end:

    mov rcx, [rel rep_depth]

    test rcx, rcx
    jz .done

    dec rcx

    mov [rel rep_depth], rcx

    lea r11, [rel rep_stack]

    mov r10, [r11 + rcx * 8]

    lea r11, [rel rep_mode_stack]

    movzx eax, byte [r11 + rcx]

    test eax, eax
    jnz .condition_end

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_rep_dec_jump]
    mov edx, s_rep_dec_jump_len

    syscall

    mov rax, r10

    call print_uint

    call emit_newline

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_rep_end_label]
    mov edx, s_rep_end_label_len

    syscall

    mov rax, r10

    call print_uint

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_rep_cleanup]
    mov edx, s_rep_cleanup_len

    syscall

    ret

.condition_end:

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_rep_cond_jump]
    mov edx, s_rep_cond_jump_len

    syscall

    mov rax, r10

    call print_uint

    call emit_newline

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_rep_end_label]
    mov edx, s_rep_end_label_len

    syscall

    mov rax, r10

    call print_uint

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_colon]
    mov edx, s_colon_len

    syscall

.done:
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

codegen_print:

    mov r10, [rel label_counter]

    inc qword [rel label_counter]

    push r10

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_print_sub]
    mov edx, s_print_sub_len

    syscall

    mov rax, [rsp]

    call print_uint

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_print_zero]
    mov edx, s_print_zero_len

    syscall

    mov rax, [rsp]

    call print_uint

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_print_lbl_c]
    mov edx, s_print_lbl_c_len

    syscall

    mov rax, [rsp]

    call print_uint

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_print_loop_head]
    mov edx, s_print_loop_head_len

    syscall

    mov rax, [rsp]

    call print_uint

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_print_loop_body]
    mov edx, s_print_loop_body_len

    syscall

    mov rax, [rsp]

    call print_uint

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_print_loop_foot]
    mov edx, s_print_loop_foot_len

    syscall

    mov rax, [rsp]

    call print_uint

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_print_lbl_o]
    mov edx, s_print_lbl_o_len

    syscall

    mov rax, [rsp]

    call print_uint

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_print_syscall]
    mov edx, s_print_syscall_len

    syscall

    pop r10

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

    jnz .convert

    mov byte [rbp - 1], '0'

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rbp - 1]

    mov edx, 1

    syscall

    leave

    ret

.convert:

    lea r8, [rbp - 2]

    mov r9, 10

.convert_loop:

    xor edx, edx

    div r9

    add dl, '0'

    mov [r8], dl

    dec r8

    test rax, rax

    jnz .convert_loop

    inc r8

    mov rsi, r8

    lea rdx, [rbp - 1]

    sub rdx, rsi

    mov eax, SYS_WRITE
    mov edi, STDOUT

    syscall

    leave

    ret