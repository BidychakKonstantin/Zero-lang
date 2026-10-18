default rel

global codegen_set_global, codegen_set_local, codegen_set_offset, codegen_alloc_local
global codegen_load_number, codegen_load_variable, codegen_load_array_element
global codegen_load_char, codegen_load_string, codegen_declare_variable
global codegen_declare_array, codegen_store_array_element, codegen_load_address
global codegen_load_arg_register, codegen_store_variable, codegen_save_value
global codegen_dereference, codegen_add, codegen_sub, codegen_mul, codegen_div
global codegen_cmp_eq, codegen_cmp_neq, codegen_cmp_lt, codegen_cmp_gt
global codegen_cmp_lte, codegen_cmp_gte, codegen_and, codegen_or
global codegen_if_start, codegen_if_else, codegen_if_end
global codegen_rep_start, codegen_rep_start_condition
global codegen_rep_condition_check, codegen_rep_end
global codegen_function_start, codegen_function_end, codegen_call_arg
global codegen_call_function, codegen_return, codegen_print
global codegen_truncate_int8, codegen_truncate_nat8, codegen_truncate_int16
global codegen_truncate_nat16, codegen_truncate_int32, codegen_truncate_nat32

extern current_number
extern token_value
extern ident_ptr
extern ident_len
extern string_ptr
extern string_len

%define MAX_DEPTH 256

%macro EMIT 1+
    section .rodata
%%s: db %1
%%e:
    section .text
    mov eax, 1
    mov edi, 1
    lea rsi, [rel %%s]
    mov edx, %%e - %%s
    syscall
%endmacro

%macro NUM 1
    mov rax, %1
    call print_uint
%endmacro

%macro ARGCASE 2+
    cmp rax, %1
    jne %%next
    EMIT %2
    ret
%%next:
%endmacro

section .bss
align 8
header_emitted:   resb 1
has_returned:     resb 1
label_counter:    resq 1
function_counter: resq 1
string_counter:   resq 1
codegen_current_scope:  resq 1
codegen_current_offset: resq 1
frame_size:       resq 1
if_depth:         resq 1
rep_depth:        resq 1
if_stack:         resq MAX_DEPTH
if_has_else:      resb MAX_DEPTH
rep_stack:        resq MAX_DEPTH
rep_mode_stack:   resb MAX_DEPTH

section .text

emit_newline:
    EMIT 10
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
    mov r9, 10
.loop:
    xor edx, edx
    div r9
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

emit_header:
    cmp byte [rel header_emitted], 1
    je .done
    mov byte [rel header_emitted], 1
    EMIT "default rel", 10, 10
    EMIT "extern write_bytes", 10, "extern write_err", 10, "extern syscall2", 10
    EMIT "extern read_file", 10, "extern get_arg", 10, "extern arg_count", 10
    EMIT "extern runtime_init", 10, "extern poke8", 10, 10
    EMIT "global _start", 10, "_start:", 10, "    mov rdi, rsp", 10
    EMIT "    call runtime_init", 10, "    call main", 10
    EMIT "    mov edi, eax", 10, "    mov eax, 60", 10, "    syscall", 10, 10
.done:
    ret

emit_var:
    cmp qword [rel codegen_current_scope], 0
    je .global
    EMIT "rbp - "
    NUM [rel codegen_current_offset]
    ret
.global:
    mov eax, 1
    mov edi, 1
    mov rsi, [rel ident_ptr]
    mov rdx, [rel ident_len]
    syscall
    ret

codegen_set_global:
    mov qword [rel codegen_current_scope], 0
    ret

codegen_set_local:
    mov qword [rel codegen_current_scope], 1
    ret

codegen_set_offset:
    mov [rel codegen_current_offset], rdi
    ret

codegen_alloc_local:
    shl rdi, 3
    mov rax, [rel frame_size]
    add rax, rdi
    mov [rel frame_size], rax
    ret

codegen_function_start:
    call emit_header
    inc qword [rel function_counter]
    mov byte [rel has_returned], 0
    mov qword [rel frame_size], 0
    mov qword [rel codegen_current_scope], 1
    mov eax, 1
    mov edi, 1
    mov rsi, [rel ident_ptr]
    mov rdx, [rel ident_len]
    syscall
    EMIT ":", 10, "    push rbp", 10, "    mov rbp, rsp", 10
    EMIT "    sub rsp, strict dword FRAME_"
    NUM [rel function_counter]
    call emit_newline
    ret

codegen_function_end:
    cmp byte [rel has_returned], 1
    je .frame
    EMIT "    mov rax, 0", 10, "    leave", 10, "    ret", 10
.frame:
    EMIT "FRAME_"
    NUM [rel function_counter]
    EMIT " equ "
    mov rax, [rel frame_size]
    add rax, 15
    and rax, -16
    call print_uint
    call emit_newline
    ret

codegen_call_arg:
    ret

codegen_call_function:
    EMIT "    call "
    mov eax, 1
    mov edi, 1
    mov rsi, [rel ident_ptr]
    mov rdx, [rel ident_len]
    syscall
    call emit_newline
    ret

codegen_return:
    mov rcx, [rel if_depth]
    add rcx, [rel rep_depth]
    test rcx, rcx
    jnz .emit
    mov byte [rel has_returned], 1
.emit:
    EMIT "    leave", 10, "    ret", 10
    ret

codegen_truncate_int8:
    EMIT "    movsx rax, al", 10
    ret
codegen_truncate_nat8:
    EMIT "    movzx rax, al", 10
    ret
codegen_truncate_int16:
    EMIT "    movsx rax, ax", 10
    ret
codegen_truncate_nat16:
    EMIT "    movzx rax, ax", 10
    ret
codegen_truncate_int32:
    EMIT "    cdqe", 10
    ret
codegen_truncate_nat32:
    EMIT "    mov eax, eax", 10
    ret

codegen_load_number:
    EMIT "    mov rax, "
    NUM [rel current_number]
    call emit_newline
    ret

codegen_load_char:
    EMIT "    mov rax, "
    NUM [rel token_value]
    call emit_newline
    ret

codegen_declare_variable:
    call emit_header
    EMIT "section .bss", 10
    call emit_var
    EMIT ": resq 1", 10, "section .text", 10
    ret

codegen_declare_array:
    push r12
    mov r12, rdi
    call emit_header
    EMIT "section .bss", 10
    call emit_var
    EMIT ": resq "
    NUM r12
    EMIT 10, "section .text", 10
    pop r12
    ret

codegen_load_arg_register:
    ARGCASE 0, "    mov rax, rdi", 10
    ARGCASE 1, "    mov rax, rsi", 10
    ARGCASE 2, "    mov rax, rdx", 10
    ARGCASE 3, "    mov rax, rcx", 10
    ARGCASE 4, "    mov rax, r8", 10
    ARGCASE 5, "    mov rax, r9", 10
    ret

codegen_load_variable:
    EMIT "    mov rax, QWORD ["
    call emit_var
    EMIT "]", 10
    ret

codegen_store_variable:
    EMIT "    mov QWORD ["
    call emit_var
    EMIT "], rax", 10
    ret

codegen_load_array_element:
    EMIT "    mov r11, rax", 10, "    mov rax, QWORD ["
    call emit_var
    EMIT " + r11 * 8]", 10
    ret

codegen_store_array_element:
    EMIT "    mov r12, rax", 10, "    pop r11", 10, "    mov QWORD ["
    call emit_var
    EMIT " + r11 * 8], r12", 10
    ret

codegen_load_address:
    EMIT "    lea rax, ["
    call emit_var
    EMIT "]", 10
    ret

codegen_save_value:
    EMIT "    push rax", 10
    ret

codegen_dereference:
    EMIT "    movzx rax, byte [rax]", 10
    ret

codegen_add:
    EMIT "    pop rbx", 10, "    add rax, rbx", 10
    ret

codegen_sub:
    EMIT "    pop rbx", 10, "    mov rcx, rax", 10, "    mov rax, rbx", 10
    EMIT "    sub rax, rcx", 10
    ret

codegen_mul:
    EMIT "    pop rbx", 10, "    imul rax, rbx", 10
    ret

codegen_div:
    EMIT "    pop rbx", 10, "    xchg rax, rbx", 10, "    xor rdx, rdx", 10
    EMIT "    div rbx", 10
    ret

%macro CMPGEN 2
%1:
    EMIT "    pop rbx", 10, "    cmp rbx, rax", 10, %2, 10
    EMIT "    movzx rax, al", 10
    ret
%endmacro

CMPGEN codegen_cmp_eq,  "    sete al"
CMPGEN codegen_cmp_neq, "    setne al"
CMPGEN codegen_cmp_lt,  "    setl al"
CMPGEN codegen_cmp_gt,  "    setg al"
CMPGEN codegen_cmp_lte, "    setle al"
CMPGEN codegen_cmp_gte, "    setge al"

codegen_and:
    EMIT "    pop rbx", 10, "    test rax, rax", 10, "    setne al", 10
    EMIT "    test rbx, rbx", 10, "    setne bl", 10, "    and al, bl", 10
    EMIT "    movzx rax, al", 10
    ret

codegen_or:
    EMIT "    pop rbx", 10, "    or rax, rbx", 10, "    test rax, rax", 10
    EMIT "    setne al", 10, "    movzx rax, al", 10
    ret

codegen_if_start:
    push r12
    mov rcx, [rel if_depth]
    cmp rcx, MAX_DEPTH
    jae .done
    mov r12, [rel label_counter]
    inc qword [rel label_counter]
    lea r11, [rel if_stack]
    mov [r11 + rcx * 8], r12
    lea r11, [rel if_has_else]
    mov byte [r11 + rcx], 0
    inc qword [rel if_depth]
    EMIT "    test rax, rax", 10, "    jz L_if_else_"
    NUM r12
    call emit_newline
.done:
    pop r12
    ret

codegen_if_else:
    push r12
    mov rcx, [rel if_depth]
    test rcx, rcx
    jz .done
    dec rcx
    lea r11, [rel if_stack]
    mov r12, [r11 + rcx * 8]
    lea r11, [rel if_has_else]
    mov byte [r11 + rcx], 1
    EMIT "    jmp L_if_end_"
    NUM r12
    call emit_newline
    EMIT "L_if_else_"
    NUM r12
    EMIT ":", 10
.done:
    pop r12
    ret

codegen_if_end:
    push r12
    push r13
    mov rcx, [rel if_depth]
    test rcx, rcx
    jz .done
    dec rcx
    mov [rel if_depth], rcx
    lea r11, [rel if_stack]
    mov r12, [r11 + rcx * 8]
    lea r11, [rel if_has_else]
    movzx r13d, byte [r11 + rcx]
    cmp r13d, 1
    je .end
    EMIT "L_if_else_"
    NUM r12
    EMIT ":", 10
.end:
    EMIT "L_if_end_"
    NUM r12
    EMIT ":", 10
.done:
    pop r13
    pop r12
    ret

codegen_rep_start:
    push r12
    push r13
    mov r13, rdi
    mov rcx, [rel rep_depth]
    cmp rcx, MAX_DEPTH
    jae .done
    mov r12, [rel label_counter]
    inc qword [rel label_counter]
    lea r11, [rel rep_stack]
    mov [r11 + rcx * 8], r12
    lea r11, [rel rep_mode_stack]
    mov byte [r11 + rcx], 0
    inc qword [rel rep_depth]
    EMIT "    mov rax, "
    NUM r13
    EMIT 10, "    push rax", 10, "L_rep_start_"
    NUM r12
    EMIT ":", 10, "    cmp qword [rsp], 0", 10, "    jle L_rep_end_"
    NUM r12
    call emit_newline
.done:
    pop r13
    pop r12
    ret

codegen_rep_start_condition:
    push r12
    mov rcx, [rel rep_depth]
    cmp rcx, MAX_DEPTH
    jae .done
    mov r12, [rel label_counter]
    inc qword [rel label_counter]
    lea r11, [rel rep_stack]
    mov [r11 + rcx * 8], r12
    lea r11, [rel rep_mode_stack]
    mov byte [r11 + rcx], 1
    inc qword [rel rep_depth]
    EMIT "L_rep_start_"
    NUM r12
    EMIT ":", 10
.done:
    pop r12
    ret

codegen_rep_condition_check:
    push r12
    mov rcx, [rel rep_depth]
    test rcx, rcx
    jz .done
    dec rcx
    lea r11, [rel rep_stack]
    mov r12, [r11 + rcx * 8]
    EMIT "    test rax, rax", 10, "    jz L_rep_end_"
    NUM r12
    call emit_newline
.done:
    pop r12
    ret

codegen_rep_end:
    push r12
    push r13
    mov rcx, [rel rep_depth]
    test rcx, rcx
    jz .done
    dec rcx
    mov [rel rep_depth], rcx
    lea r11, [rel rep_stack]
    mov r12, [r11 + rcx * 8]
    lea r11, [rel rep_mode_stack]
    movzx r13d, byte [r11 + rcx]
    test r13d, r13d
    jnz .cond
    EMIT "    dec qword [rsp]", 10, "    jmp L_rep_start_"
    NUM r12
    call emit_newline
    EMIT "L_rep_end_"
    NUM r12
    EMIT ":", 10, "    add rsp, 8", 10
    jmp .done
.cond:
    EMIT "    jmp L_rep_start_"
    NUM r12
    call emit_newline
    EMIT "L_rep_end_"
    NUM r12
    EMIT ":", 10
.done:
    pop r13
    pop r12
    ret

codegen_load_string:
    push r12
    push r13
    push r14
    mov r12, [rel string_counter]
    inc qword [rel string_counter]
    EMIT "section .rodata", 10, "str_"
    NUM r12
    EMIT ": db "
    mov r13, [rel string_ptr]
    mov r14, [rel string_len]
.loop:
    test r14, r14
    jz .done
    movzx eax, byte [r13]
    inc r13
    dec r14
    cmp eax, 92
    jne .emit
    test r14, r14
    jz .emit
    movzx eax, byte [r13]
    inc r13
    dec r14
    cmp eax, 'n'
    jne .not_n
    mov eax, 10
    jmp .emit
.not_n:
    cmp eax, 't'
    jne .not_t
    mov eax, 9
    jmp .emit
.not_t:
    cmp eax, 'r'
    jne .not_r
    mov eax, 13
    jmp .emit
.not_r:
    cmp eax, '0'
    jne .emit
    xor eax, eax
.emit:
    call print_uint
    EMIT ", "
    jmp .loop
.done:
    EMIT "0", 10, "section .text", 10, "    lea rax, [rel str_"
    NUM r12
    EMIT "]", 10
    pop r14
    pop r13
    pop r12
    ret

codegen_print:
    push r12
    mov r12, [rel label_counter]
    inc qword [rel label_counter]
    EMIT "    sub rsp, 32", 10, "    mov r8, rsp", 10, "    add r8, 31", 10
    EMIT "    mov byte [r8], 10", 10, "    mov r9, r8", 10
    EMIT "    test rax, rax", 10, "    jnz L_pr_c_"
    NUM r12
    EMIT 10, "    dec r8", 10, "    mov byte [r8], '0'", 10, "    jmp L_pr_o_"
    NUM r12
    EMIT 10, "L_pr_c_"
    NUM r12
    EMIT ":", 10, "    mov r10, 10", 10, "L_pr_l_"
    NUM r12
    EMIT ":", 10, "    test rax, rax", 10, "    jz L_pr_o_"
    NUM r12
    EMIT 10, "    xor rdx, rdx", 10, "    div r10", 10, "    add dl, '0'", 10
    EMIT "    dec r8", 10, "    mov [r8], dl", 10, "    jmp L_pr_l_"
    NUM r12
    EMIT 10, "L_pr_o_"
    NUM r12
    EMIT ":", 10, "    mov eax, 1", 10, "    mov edi, 1", 10, "    mov rsi, r8", 10
    EMIT "    mov rdx, r9", 10, "    inc rdx", 10, "    sub rdx, r8", 10
    EMIT "    syscall", 10, "    add rsp, 32", 10
    pop r12
    ret