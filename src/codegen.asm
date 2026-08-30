default rel

; ============================================================
; GLOBALS
; ============================================================

global codegen_set_global
global codegen_set_local

global codegen_load_number
global codegen_load_variable
global codegen_load_array_element
global codegen_load_char
global codegen_load_string

global codegen_declare_variable
global codegen_load_arg_register
global codegen_store_variable
global codegen_save_value
global codegen_dereference

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
global codegen_rep_start_condition
global codegen_rep_condition_check
global codegen_rep_end

global codegen_function_start
global codegen_function_end
global codegen_call_arg
global codegen_call_function
global codegen_return
global codegen_print


; ============================================================
; EXTERNALS
; ============================================================

extern current_number
extern token_value

extern ident_ptr
extern ident_len

extern string_ptr
extern string_len


; ============================================================
; CONSTANTS
; ============================================================

%define SYS_WRITE 1
%define STDOUT    1

%define MAX_IF_DEPTH  256
%define MAX_REP_DEPTH 256


; ============================================================
; DATA
; ============================================================

section .data

header_emitted:
    db 0


; ============================================================
; RODATA
; ============================================================

section .rodata


; ============================================================
; HEADER
; ============================================================

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


; ============================================================
; COMMON
; ============================================================

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


; Вправа: Виправлено розіменування з 64-бітного QWORD на 8-бітний movzx
s_deref:
    db "    movzx rax, byte [rax]", 10
s_deref_len equ $ - s_deref


s_close:
    db "]", 10
s_close_len equ $ - s_close


; ============================================================
; LOCAL SUFFIX
; ============================================================

s_local_suffix:
    db "_f"
s_local_suffix_len equ $ - s_local_suffix


; ============================================================
; ARGUMENT REGISTERS
; ============================================================

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


; ============================================================
; STACK
; ============================================================

s_push:
    db "    push rax", 10
s_push_len equ $ - s_push


; ============================================================
; ARITHMETIC
; ============================================================

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


; ============================================================
; COMPARISONS
; ============================================================

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


; ============================================================
; ARRAY
; ============================================================

s_array_index:
    db "    mov r11, rax", 10
s_array_index_len equ $ - s_array_index


s_array:
    db " + r11 * 8]", 10
s_array_len equ $ - s_array


; ============================================================
; IF
; ============================================================

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


; ============================================================
; REP COUNTER
; ============================================================

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


; ============================================================
; REP CONDITION
; ============================================================

s_rep_cond_test:
    db "    test rax, rax", 10
    db "    jz L_rep_end_"
s_rep_cond_test_len equ $ - s_rep_cond_test


s_rep_cond_jump:
    db "    jmp L_rep_start_"
s_rep_cond_jump_len equ $ - s_rep_cond_jump


; ============================================================
; STRING
; ============================================================

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


; ============================================================
; PRINT
; ============================================================

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


; ============================================================
; VARIABLES
; ============================================================

s_bss_var:
    db "section .bss", 10
s_bss_var_len equ $ - s_bss_var


s_var_resq:
    db ": resq 1", 10
    db "section .text", 10
s_var_resq_len equ $ - s_var_resq


; ============================================================
; BSS
; ============================================================

section .bss

align 8

label_counter:
    resq 1


function_counter:
    resq 1


; 0 = global
; 1 = local

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


; ============================================================
; HEADER
; ============================================================

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


; ============================================================
; GLOBAL / LOCAL
; ============================================================

codegen_set_global:

    mov qword [rel codegen_current_scope], 0

    ret


codegen_set_local:

    mov qword [rel codegen_current_scope], 1

    ret


; ============================================================
; EMIT VARIABLE NAME
; ============================================================

codegen_emit_variable_label:

    push r12
    push r13


    mov r12, rdi
    mov r13, rsi


    cmp qword [rel codegen_current_scope], 0
    je .global


    ; --------------------------------------------------------
    ; LOCAL
    ; --------------------------------------------------------

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


; ============================================================
; FUNCTION START
; ============================================================

codegen_function_start:

    call emit_header


    inc qword [rel function_counter]


    mov byte [rel has_returned], 0


    ; Functions operate in LOCAL scope.
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


; ============================================================
; FUNCTION END
; ============================================================

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


; ============================================================
; CALL ARG
; ============================================================

codegen_call_arg:
    ret


; ============================================================
; CALL FUNCTION
; ============================================================

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


; ============================================================
; RETURN
; ============================================================

codegen_return:

    ; has_returned виставляється лише при поверненні на верхньому рівні функції (не у вкладених блоках)
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


; ============================================================
; NUMBER
; ============================================================

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


; ============================================================
; CHAR
; ============================================================

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


; ============================================================
; DECLARE VARIABLE
; ============================================================

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


; ============================================================
; LOAD ARG REGISTER
; ============================================================

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


; ============================================================
; LOAD VARIABLE
; ============================================================

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


; ============================================================
; ARRAY ELEMENT
; ============================================================

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


; ============================================================
; STORE VARIABLE
; ============================================================

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


; ============================================================
; SAVE
; ============================================================

codegen_save_value:

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_push]
    mov edx, s_push_len

    syscall

    ret


; ============================================================
; DEREFERENCE
; ============================================================

codegen_dereference:

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_deref]
    mov edx, s_deref_len

    syscall

    ret


; ============================================================
; ADD
; ============================================================

codegen_add:

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_add]
    mov edx, s_add_len

    syscall

    ret


; ============================================================
; SUB
; ============================================================

codegen_sub:

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_sub]
    mov edx, s_sub_len

    syscall

    ret


; ============================================================
; MUL
; ============================================================

codegen_mul:

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_mul]
    mov edx, s_mul_len

    syscall

    ret


; ============================================================
; CMP EQ
; ============================================================

codegen_cmp_eq:

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_cmp_eq]
    mov edx, s_cmp_eq_len

    syscall

    ret


; ============================================================
; CMP LT
; ============================================================

codegen_cmp_lt:

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_cmp_lt]
    mov edx, s_cmp_lt_len

    syscall

    ret


; ============================================================
; CMP GT
; ============================================================

codegen_cmp_gt:

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_cmp_gt]
    mov edx, s_cmp_gt_len

    syscall

    ret


; ============================================================
; CMP LTE
; ============================================================

codegen_cmp_lte:

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_cmp_lte]
    mov edx, s_cmp_lte_len

    syscall

    ret


; ============================================================
; CMP GTE
; ============================================================

codegen_cmp_gte:

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_cmp_gte]
    mov edx, s_cmp_gte_len

    syscall

    ret


; ============================================================
; IF START
; ============================================================

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


; ============================================================
; IF ELSE
; ============================================================

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


; ============================================================
; IF END
; ============================================================

codegen_if_end:

    mov rcx, [rel if_depth]

    test rcx, rcx
    jz .done


    dec rcx

    ; Store the new depth right away: every syscall below
    ; (SYS_WRITE, and the ones inside print_uint) clobbers
    ; RCX per the Linux x86-64 syscall ABI, so RCX can't be
    ; trusted after this point.
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


; ============================================================
; REP COUNTER
; ============================================================

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


; ============================================================
; REP CONDITION START
; ============================================================

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


; ============================================================
; REP CONDITION CHECK
; ============================================================

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


; ============================================================
; REP END
; ============================================================

codegen_rep_end:

    mov rcx, [rel rep_depth]

    test rcx, rcx
    jz .done


    dec rcx

    ; Store the new depth right away: syscall clobbers RCX,
    ; see the note in codegen_if_end above.
    mov [rel rep_depth], rcx


    lea r11, [rel rep_stack]

    mov r10, [r11 + rcx * 8]


    lea r11, [rel rep_mode_stack]

    movzx eax, byte [r11 + rcx]


    test eax, eax
    jnz .condition_end


    ; COUNTER REP

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


; ============================================================
; STRING
; ============================================================

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


; ============================================================
; PRINT
; ============================================================

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


; ============================================================
; NEWLINE
; ============================================================

emit_newline:

    mov eax, SYS_WRITE
    mov edi, STDOUT

    lea rsi, [rel s_newline]

    mov edx, 1

    syscall

    ret


; ============================================================
; PRINT UINT
; ============================================================

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