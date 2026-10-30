default rel

extern write_bytes
extern write_err
extern syscall2
extern read_file
extern get_arg
extern arg_count
extern runtime_init
extern poke8

global _start
_start:
    mov rdi, rsp
    call runtime_init
    call main
    mov edi, eax
    mov eax, 60
    syscall

section .bss
pu_buf: resq 4
section .text
section .bss
token_value: resq 1
section .text
section .bss
token_ptr: resq 1
section .text
section .bss
token_len: resq 1
section .text
section .bss
lx_cur: resq 1
section .text
section .bss
lx_end: resq 1
section .text
section .bss
lx_slot: resq 1
section .text
section .bss
lx_depth: resq 1
section .text
section .bss
lx_file_count: resq 1
section .text
section .bss
lx_used_count: resq 1
section .text
section .bss
lx_pool: resq 262144
section .text
section .bss
lx_dirs: resq 16384
section .text
section .bss
lx_dirlen: resq 32
section .text
section .bss
lx_used: resq 16384
section .text
section .bss
lx_usedlen: resq 32
section .text
section .bss
lx_stack_cur: resq 32
section .text
section .bss
lx_stack_end: resq 32
section .text
section .bss
lx_stack_slot: resq 32
section .text
section .bss
lx_path: resq 512
section .text
section .bss
ast_kind: resq 65536
section .text
section .bss
ast_a: resq 65536
section .text
section .bss
ast_b: resq 65536
section .text
section .bss
ast_c: resq 65536
section .text
section .bss
ast_d: resq 65536
section .text
section .bss
ast_name_ptr: resq 65536
section .text
section .bss
ast_name_len: resq 65536
section .text
section .bss
ast_next: resq 65536
section .text
section .bss
ast_count: resq 1
section .text
section .bss
cur_tok: resq 1
section .text
section .bss
cur_ptr: resq 1
section .text
section .bss
cur_len: resq 1
section .text
section .bss
cur_val: resq 1
section .text
section .bss
pstk: resq 1024
section .text
section .bss
psp: resq 1
section .text
section .bss
loc_name_ptr: resq 1024
section .text
section .bss
loc_name_len: resq 1024
section .text
section .bss
loc_off: resq 1024
section .text
section .bss
loc_count: resq 1
section .text
section .bss
con_name_ptr: resq 1024
section .text
section .bss
con_name_len: resq 1024
section .text
section .bss
con_value: resq 1024
section .text
section .bss
con_count: resq 1
section .text
section .bss
cg_label: resq 1
section .text
section .bss
cg_fn: resq 1
section .text
section .bss
cg_frame: resq 1
section .text
section .bss
cg_nest: resq 1
section .text
section .bss
cg_has_ret: resq 1
section .text
section .bss
cg_str: resq 1
section .text
section .bss
cg_ret_type: resq 1
section .text
section .bss
cg_ret_ptr: resq 1
section .text
str_len:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_1
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    mov rax, 0
    mov QWORD [rbp - 16], rax
L_rep_start_0:
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, QWORD [rbp - 16]
    pop rbx
    add rax, rbx
    movzx rax, byte [rax]
    push rax
    mov rax, 0
    pop rbx
    cmp rbx, rax
    setne al
    movzx rax, al
    test rax, rax
    jz L_rep_end_0
    mov rax, QWORD [rbp - 16]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    mov QWORD [rbp - 16], rax
    jmp L_rep_start_0
L_rep_end_0:
    mov rax, QWORD [rbp - 16]
    leave
    ret
FRAME_1 equ 16
write_str:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_2
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, QWORD [rbp - 8]
    push rax
    pop rax
    mov rdi, rax
    call str_len
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call write_bytes
    leave
    ret
FRAME_2 equ 16
err_str:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_3
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, QWORD [rbp - 8]
    push rax
    pop rax
    mov rdi, rax
    call str_len
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call write_err
    leave
    ret
FRAME_3 equ 16
emit_nl:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_4
    mov rax, 10
    mov QWORD [rbp - 8], rax
    lea rax, [rbp - 8]
    push rax
    mov rax, 1
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call write_bytes
    leave
    ret
FRAME_4 equ 16
print_uint:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_5
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    mov rax, 32
    mov QWORD [rbp - 16], rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 0
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_1
    mov rax, QWORD [rbp - 16]
    push rax
    mov rax, 1
    pop rbx
    mov rcx, rax
    mov rax, rbx
    sub rax, rcx
    mov QWORD [rbp - 16], rax
    lea rax, [pu_buf]
    push rax
    mov rax, QWORD [rbp - 16]
    pop rbx
    add rax, rbx
    push rax
    mov rax, 48
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call poke8
L_if_else_1:
L_if_end_1:
L_rep_start_2:
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 0
    pop rbx
    cmp rbx, rax
    setne al
    movzx rax, al
    test rax, rax
    jz L_rep_end_2
    mov rax, QWORD [rbp - 16]
    push rax
    mov rax, 1
    pop rbx
    mov rcx, rax
    mov rax, rbx
    sub rax, rcx
    mov QWORD [rbp - 16], rax
    lea rax, [pu_buf]
    push rax
    mov rax, QWORD [rbp - 16]
    pop rbx
    add rax, rbx
    push rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 10
    pop rbx
    xchg rax, rbx
    xor rdx, rdx
    div rbx
    push rax
    mov rax, 10
    pop rbx
    imul rax, rbx
    pop rbx
    mov rcx, rax
    mov rax, rbx
    sub rax, rcx
    push rax
    mov rax, 48
    pop rbx
    add rax, rbx
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call poke8
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 10
    pop rbx
    xchg rax, rbx
    xor rdx, rdx
    div rbx
    mov QWORD [rbp - 8], rax
    jmp L_rep_start_2
L_rep_end_2:
    lea rax, [pu_buf]
    push rax
    mov rax, QWORD [rbp - 16]
    pop rbx
    add rax, rbx
    push rax
    mov rax, 32
    push rax
    mov rax, QWORD [rbp - 16]
    pop rbx
    mov rcx, rax
    mov rax, rbx
    sub rax, rcx
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call write_bytes
    leave
    ret
FRAME_5 equ 16
exit_program:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_6
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    mov rax, 60
    push rax
    mov rax, QWORD [rbp - 8]
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call syscall2
    leave
    ret
FRAME_6 equ 16
lx_fail:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_7
    mov rax, rdi
    mov QWORD [rbp - 8], rax
section .rodata
str_0: db 69, 114, 114, 111, 114, 58, 32, 0
section .text
    lea rax, [rel str_0]
    push rax
    pop rax
    mov rdi, rax
    call err_str
    mov rax, QWORD [rbp - 8]
    push rax
    pop rax
    mov rdi, rax
    call err_str
section .rodata
str_1: db 10, 0
section .text
    lea rax, [rel str_1]
    push rax
    pop rax
    mov rdi, rax
    call err_str
    mov rax, 1
    push rax
    pop rax
    mov rdi, rax
    call exit_program
    leave
    ret
FRAME_7 equ 16
lx_peek:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_8
    mov rax, QWORD [lx_cur]
    push rax
    mov rax, QWORD [lx_end]
    pop rbx
    cmp rbx, rax
    setge al
    movzx rax, al
    test rax, rax
    jz L_if_else_3
    mov rax, 0
    leave
    ret
L_if_else_3:
L_if_end_3:
    mov rax, QWORD [lx_cur]
    movzx rax, byte [rax]
    leave
    ret
FRAME_8 equ 0
lx_peek_at:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_9
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    mov rax, QWORD [lx_cur]
    push rax
    mov rax, QWORD [rbp - 8]
    pop rbx
    add rax, rbx
    mov QWORD [rbp - 16], rax
    mov rax, QWORD [rbp - 16]
    push rax
    mov rax, QWORD [lx_end]
    pop rbx
    cmp rbx, rax
    setge al
    movzx rax, al
    test rax, rax
    jz L_if_else_4
    mov rax, 0
    leave
    ret
L_if_else_4:
L_if_end_4:
    mov rax, QWORD [rbp - 16]
    movzx rax, byte [rax]
    leave
    ret
FRAME_9 equ 16
lx_adv:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_10
    call lx_peek
    mov QWORD [rbp - 8], rax
    mov rax, QWORD [lx_cur]
    push rax
    mov rax, QWORD [lx_end]
    pop rbx
    cmp rbx, rax
    setl al
    movzx rax, al
    test rax, rax
    jz L_if_else_5
    mov rax, QWORD [lx_cur]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    mov QWORD [lx_cur], rax
L_if_else_5:
L_if_end_5:
    mov rax, QWORD [rbp - 8]
    leave
    ret
FRAME_10 equ 16
lx_is_digit:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_11
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 48
    pop rbx
    cmp rbx, rax
    setge al
    movzx rax, al
    push rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 57
    pop rbx
    cmp rbx, rax
    setle al
    movzx rax, al
    pop rbx
    test rax, rax
    setne al
    test rbx, rbx
    setne bl
    and al, bl
    movzx rax, al
    leave
    ret
FRAME_11 equ 16
lx_is_alpha:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_12
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 97
    pop rbx
    cmp rbx, rax
    setge al
    movzx rax, al
    push rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 122
    pop rbx
    cmp rbx, rax
    setle al
    movzx rax, al
    pop rbx
    test rax, rax
    setne al
    test rbx, rbx
    setne bl
    and al, bl
    movzx rax, al
    push rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 65
    pop rbx
    cmp rbx, rax
    setge al
    movzx rax, al
    push rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 90
    pop rbx
    cmp rbx, rax
    setle al
    movzx rax, al
    pop rbx
    test rax, rax
    setne al
    test rbx, rbx
    setne bl
    and al, bl
    movzx rax, al
    pop rbx
    or rax, rbx
    test rax, rax
    setne al
    movzx rax, al
    push rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 95
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    pop rbx
    or rax, rbx
    test rax, rax
    setne al
    movzx rax, al
    leave
    ret
FRAME_12 equ 16
lx_is_alnum:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_13
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    mov rax, QWORD [rbp - 8]
    push rax
    pop rax
    mov rdi, rax
    call lx_is_alpha
    push rax
    mov rax, 1
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    push rax
    mov rax, QWORD [rbp - 8]
    push rax
    pop rax
    mov rdi, rax
    call lx_is_digit
    push rax
    mov rax, 1
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    pop rbx
    or rax, rbx
    test rax, rax
    setne al
    movzx rax, al
    leave
    ret
FRAME_13 equ 16
lx_skip:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_14
L_rep_start_6:
    mov rax, 1
    test rax, rax
    jz L_rep_end_6
    call lx_peek
    mov QWORD [rbp - 8], rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 32
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    push rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 9
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    pop rbx
    or rax, rbx
    test rax, rax
    setne al
    movzx rax, al
    push rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 13
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    pop rbx
    or rax, rbx
    test rax, rax
    setne al
    movzx rax, al
    test rax, rax
    jz L_if_else_7
    call lx_adv
    jmp L_if_end_7
L_if_else_7:
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 47
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    push rax
    mov rax, 1
    push rax
    pop rax
    mov rdi, rax
    call lx_peek_at
    push rax
    mov rax, 47
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    pop rbx
    test rax, rax
    setne al
    test rbx, rbx
    setne bl
    and al, bl
    movzx rax, al
    test rax, rax
    jz L_if_else_8
L_rep_start_9:
    call lx_peek
    push rax
    mov rax, 10
    pop rbx
    cmp rbx, rax
    setne al
    movzx rax, al
    push rax
    call lx_peek
    push rax
    mov rax, 0
    pop rbx
    cmp rbx, rax
    setne al
    movzx rax, al
    pop rbx
    test rax, rax
    setne al
    test rbx, rbx
    setne bl
    and al, bl
    movzx rax, al
    test rax, rax
    jz L_rep_end_9
    call lx_adv
    jmp L_rep_start_9
L_rep_end_9:
    jmp L_if_end_8
L_if_else_8:
    mov rax, 0
    leave
    ret
L_if_end_8:
L_if_end_7:
    jmp L_rep_start_6
L_rep_end_6:
    mov rax, 0
    leave
    ret
FRAME_14 equ 16
lx_tok:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_15
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    mov rax, rsi
    mov QWORD [rbp - 16], rax
    mov rax, rdx
    mov QWORD [rbp - 24], rax
    mov rax, QWORD [rbp - 16]
    mov QWORD [token_ptr], rax
    mov rax, QWORD [rbp - 24]
    mov QWORD [token_len], rax
    mov rax, QWORD [rbp - 8]
    leave
    ret
FRAME_15 equ 32
lx_kw:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_16
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    mov rax, rsi
    mov QWORD [rbp - 16], rax
    mov rax, rdx
    mov QWORD [rbp - 24], rax
    mov rax, rcx
    mov QWORD [rbp - 32], rax
    mov rax, QWORD [rbp - 16]
    push rax
    mov rax, QWORD [rbp - 32]
    pop rbx
    cmp rbx, rax
    setne al
    movzx rax, al
    test rax, rax
    jz L_if_else_10
    mov rax, 0
    leave
    ret
L_if_else_10:
L_if_end_10:
    mov rax, 0
    mov QWORD [rbp - 40], rax
L_rep_start_11:
    mov rax, QWORD [rbp - 40]
    push rax
    mov rax, QWORD [rbp - 16]
    pop rbx
    cmp rbx, rax
    setne al
    movzx rax, al
    test rax, rax
    jz L_rep_end_11
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, QWORD [rbp - 40]
    pop rbx
    add rax, rbx
    movzx rax, byte [rax]
    push rax
    mov rax, QWORD [rbp - 24]
    push rax
    mov rax, QWORD [rbp - 40]
    pop rbx
    add rax, rbx
    movzx rax, byte [rax]
    pop rbx
    cmp rbx, rax
    setne al
    movzx rax, al
    test rax, rax
    jz L_if_else_12
    mov rax, 0
    leave
    ret
L_if_else_12:
L_if_end_12:
    mov rax, QWORD [rbp - 40]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    mov QWORD [rbp - 40], rax
    jmp L_rep_start_11
L_rep_end_11:
    mov rax, 1
    leave
    ret
FRAME_16 equ 48
lx_keyword:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_17
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    mov rax, rsi
    mov QWORD [rbp - 16], rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, QWORD [rbp - 16]
    push rax
section .rodata
str_2: db 105, 102, 0
section .text
    lea rax, [rel str_2]
    push rax
    mov rax, 2
    push rax
    pop rax
    mov rcx, rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call lx_kw
    push rax
    mov rax, 1
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_13
    mov rax, 25
    leave
    ret
L_if_else_13:
L_if_end_13:
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, QWORD [rbp - 16]
    push rax
section .rodata
str_3: db 101, 108, 115, 101, 0
section .text
    lea rax, [rel str_3]
    push rax
    mov rax, 4
    push rax
    pop rax
    mov rcx, rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call lx_kw
    push rax
    mov rax, 1
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_14
    mov rax, 26
    leave
    ret
L_if_else_14:
L_if_end_14:
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, QWORD [rbp - 16]
    push rax
section .rodata
str_4: db 114, 101, 112, 0
section .text
    lea rax, [rel str_4]
    push rax
    mov rax, 3
    push rax
    pop rax
    mov rcx, rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call lx_kw
    push rax
    mov rax, 1
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_15
    mov rax, 27
    leave
    ret
L_if_else_15:
L_if_end_15:
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, QWORD [rbp - 16]
    push rax
section .rodata
str_5: db 114, 101, 116, 0
section .text
    lea rax, [rel str_5]
    push rax
    mov rax, 3
    push rax
    pop rax
    mov rcx, rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call lx_kw
    push rax
    mov rax, 1
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_16
    mov rax, 28
    leave
    ret
L_if_else_16:
L_if_end_16:
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, QWORD [rbp - 16]
    push rax
section .rodata
str_6: db 117, 115, 101, 0
section .text
    lea rax, [rel str_6]
    push rax
    mov rax, 3
    push rax
    pop rax
    mov rcx, rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call lx_kw
    push rax
    mov rax, 1
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_17
    mov rax, 42
    leave
    ret
L_if_else_17:
L_if_end_17:
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, QWORD [rbp - 16]
    push rax
section .rodata
str_7: db 99, 104, 114, 0
section .text
    lea rax, [rel str_7]
    push rax
    mov rax, 3
    push rax
    pop rax
    mov rcx, rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call lx_kw
    push rax
    mov rax, 1
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_18
    mov rax, 5
    leave
    ret
L_if_else_18:
L_if_end_18:
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, QWORD [rbp - 16]
    push rax
section .rodata
str_8: db 98, 111, 111, 108, 0
section .text
    lea rax, [rel str_8]
    push rax
    mov rax, 4
    push rax
    pop rax
    mov rcx, rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call lx_kw
    push rax
    mov rax, 1
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_19
    mov rax, 37
    leave
    ret
L_if_else_19:
L_if_end_19:
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, QWORD [rbp - 16]
    push rax
section .rodata
str_9: db 78, 85, 76, 76, 0
section .text
    lea rax, [rel str_9]
    push rax
    mov rax, 4
    push rax
    pop rax
    mov rcx, rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call lx_kw
    push rax
    mov rax, 1
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_20
    mov rax, 0
    leave
    ret
L_if_else_20:
L_if_end_20:
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, QWORD [rbp - 16]
    push rax
section .rodata
str_10: db 105, 110, 116, 56, 0
section .text
    lea rax, [rel str_10]
    push rax
    mov rax, 4
    push rax
    pop rax
    mov rcx, rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call lx_kw
    push rax
    mov rax, 1
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_21
    mov rax, 29
    leave
    ret
L_if_else_21:
L_if_end_21:
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, QWORD [rbp - 16]
    push rax
section .rodata
str_11: db 110, 97, 116, 56, 0
section .text
    lea rax, [rel str_11]
    push rax
    mov rax, 4
    push rax
    pop rax
    mov rcx, rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call lx_kw
    push rax
    mov rax, 1
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_22
    mov rax, 30
    leave
    ret
L_if_else_22:
L_if_end_22:
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, QWORD [rbp - 16]
    push rax
section .rodata
str_12: db 105, 110, 116, 49, 54, 0
section .text
    lea rax, [rel str_12]
    push rax
    mov rax, 5
    push rax
    pop rax
    mov rcx, rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call lx_kw
    push rax
    mov rax, 1
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_23
    mov rax, 31
    leave
    ret
L_if_else_23:
L_if_end_23:
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, QWORD [rbp - 16]
    push rax
section .rodata
str_13: db 110, 97, 116, 49, 54, 0
section .text
    lea rax, [rel str_13]
    push rax
    mov rax, 5
    push rax
    pop rax
    mov rcx, rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call lx_kw
    push rax
    mov rax, 1
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_24
    mov rax, 32
    leave
    ret
L_if_else_24:
L_if_end_24:
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, QWORD [rbp - 16]
    push rax
section .rodata
str_14: db 105, 110, 116, 51, 50, 0
section .text
    lea rax, [rel str_14]
    push rax
    mov rax, 5
    push rax
    pop rax
    mov rcx, rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call lx_kw
    push rax
    mov rax, 1
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_25
    mov rax, 33
    leave
    ret
L_if_else_25:
L_if_end_25:
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, QWORD [rbp - 16]
    push rax
section .rodata
str_15: db 110, 97, 116, 51, 50, 0
section .text
    lea rax, [rel str_15]
    push rax
    mov rax, 5
    push rax
    pop rax
    mov rcx, rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call lx_kw
    push rax
    mov rax, 1
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_26
    mov rax, 34
    leave
    ret
L_if_else_26:
L_if_end_26:
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, QWORD [rbp - 16]
    push rax
section .rodata
str_16: db 105, 110, 116, 54, 52, 0
section .text
    lea rax, [rel str_16]
    push rax
    mov rax, 5
    push rax
    pop rax
    mov rcx, rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call lx_kw
    push rax
    mov rax, 1
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_27
    mov rax, 35
    leave
    ret
L_if_else_27:
L_if_end_27:
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, QWORD [rbp - 16]
    push rax
section .rodata
str_17: db 110, 97, 116, 54, 52, 0
section .text
    lea rax, [rel str_17]
    push rax
    mov rax, 5
    push rax
    pop rax
    mov rcx, rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call lx_kw
    push rax
    mov rax, 1
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_28
    mov rax, 36
    leave
    ret
L_if_else_28:
L_if_end_28:
    mov rax, 3
    leave
    ret
FRAME_17 equ 16
lx_single:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_18
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 10
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_29
    mov rax, 2
    leave
    ret
L_if_else_29:
L_if_end_29:
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 123
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_30
    mov rax, 7
    leave
    ret
L_if_else_30:
L_if_end_30:
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 125
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_31
    mov rax, 8
    leave
    ret
L_if_else_31:
L_if_end_31:
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 40
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_32
    mov rax, 9
    leave
    ret
L_if_else_32:
L_if_end_32:
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 41
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_33
    mov rax, 10
    leave
    ret
L_if_else_33:
L_if_end_33:
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 91
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_34
    mov rax, 11
    leave
    ret
L_if_else_34:
L_if_end_34:
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 93
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_35
    mov rax, 12
    leave
    ret
L_if_else_35:
L_if_end_35:
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 44
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_36
    mov rax, 13
    leave
    ret
L_if_else_36:
L_if_end_36:
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 43
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_37
    mov rax, 16
    leave
    ret
L_if_else_37:
L_if_end_37:
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 42
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_38
    mov rax, 18
    leave
    ret
L_if_else_38:
L_if_end_38:
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 47
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_39
    mov rax, 19
    leave
    ret
L_if_else_39:
L_if_end_39:
    mov rax, 0
    leave
    ret
FRAME_18 equ 16
lx_pop:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_19
    mov rax, QWORD [lx_depth]
    push rax
    mov rax, 1
    pop rbx
    mov rcx, rax
    mov rax, rbx
    sub rax, rcx
    mov QWORD [lx_depth], rax
    mov rax, QWORD [lx_depth]
    mov r11, rax
    mov rax, QWORD [lx_stack_cur + r11 * 8]
    mov QWORD [lx_cur], rax
    mov rax, QWORD [lx_depth]
    mov r11, rax
    mov rax, QWORD [lx_stack_end + r11 * 8]
    mov QWORD [lx_end], rax
    mov rax, QWORD [lx_depth]
    mov r11, rax
    mov rax, QWORD [lx_stack_slot + r11 * 8]
    mov QWORD [lx_slot], rax
    mov rax, 0
    leave
    ret
FRAME_19 equ 0
lexer_next_token:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_20
    call lx_skip
    mov rax, QWORD [lx_cur]
    push rax
    mov rax, QWORD [lx_end]
    pop rbx
    cmp rbx, rax
    setge al
    movzx rax, al
    test rax, rax
    jz L_if_else_40
    mov rax, QWORD [lx_depth]
    push rax
    mov rax, 0
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_41
    mov rax, 0
    leave
    ret
L_if_else_41:
L_if_end_41:
    call lx_pop
    call lexer_next_token
    leave
    ret
L_if_else_40:
L_if_end_40:
    mov rax, QWORD [lx_cur]
    mov QWORD [rbp - 8], rax
    call lx_adv
    mov QWORD [rbp - 16], rax
    mov rax, QWORD [rbp - 16]
    push rax
    pop rax
    mov rdi, rax
    call lx_single
    mov QWORD [rbp - 24], rax
    mov rax, QWORD [rbp - 24]
    push rax
    mov rax, 0
    pop rbx
    cmp rbx, rax
    setne al
    movzx rax, al
    test rax, rax
    jz L_if_else_42
    mov rax, QWORD [rbp - 24]
    push rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 1
    push rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call lx_tok
    leave
    ret
L_if_else_42:
L_if_end_42:
    mov rax, QWORD [rbp - 16]
    push rax
    mov rax, 61
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_43
    call lx_peek
    push rax
    mov rax, 61
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_44
    call lx_adv
    mov rax, 15
    push rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 2
    push rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call lx_tok
    leave
    ret
L_if_else_44:
L_if_end_44:
    mov rax, 14
    push rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 1
    push rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call lx_tok
    leave
    ret
L_if_else_43:
L_if_end_43:
    mov rax, QWORD [rbp - 16]
    push rax
    mov rax, 45
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_45
    call lx_peek
    push rax
    mov rax, 62
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_46
    call lx_adv
    mov rax, 24
    push rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 2
    push rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call lx_tok
    leave
    ret
L_if_else_46:
L_if_end_46:
    mov rax, 17
    push rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 1
    push rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call lx_tok
    leave
    ret
L_if_else_45:
L_if_end_45:
    mov rax, QWORD [rbp - 16]
    push rax
    mov rax, 60
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_47
    call lx_peek
    push rax
    mov rax, 61
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_48
    call lx_adv
    mov rax, 22
    push rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 2
    push rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call lx_tok
    leave
    ret
L_if_else_48:
L_if_end_48:
    mov rax, 20
    push rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 1
    push rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call lx_tok
    leave
    ret
L_if_else_47:
L_if_end_47:
    mov rax, QWORD [rbp - 16]
    push rax
    mov rax, 62
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_49
    call lx_peek
    push rax
    mov rax, 61
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_50
    call lx_adv
    mov rax, 23
    push rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 2
    push rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call lx_tok
    leave
    ret
L_if_else_50:
L_if_end_50:
    mov rax, 21
    push rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 1
    push rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call lx_tok
    leave
    ret
L_if_else_49:
L_if_end_49:
    mov rax, QWORD [rbp - 16]
    push rax
    mov rax, 33
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_51
    call lx_peek
    push rax
    mov rax, 61
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_52
    call lx_adv
    mov rax, 38
    push rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 2
    push rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call lx_tok
    leave
    ret
L_if_else_52:
L_if_end_52:
    mov rax, 1
    push rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 1
    push rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call lx_tok
    leave
    ret
L_if_else_51:
L_if_end_51:
    mov rax, QWORD [rbp - 16]
    push rax
    mov rax, 38
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_53
    call lx_peek
    push rax
    mov rax, 38
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_54
    call lx_adv
    mov rax, 39
    push rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 2
    push rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call lx_tok
    leave
    ret
L_if_else_54:
L_if_end_54:
    mov rax, 38
    push rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 1
    push rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call lx_tok
    leave
    ret
L_if_else_53:
L_if_end_53:
    mov rax, QWORD [rbp - 16]
    push rax
    mov rax, 124
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_55
    call lx_peek
    push rax
    mov rax, 124
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_56
    call lx_adv
    mov rax, 40
    push rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 2
    push rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call lx_tok
    leave
    ret
L_if_else_56:
L_if_end_56:
    mov rax, 1
    push rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 1
    push rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call lx_tok
    leave
    ret
L_if_else_55:
L_if_end_55:
    mov rax, QWORD [rbp - 16]
    push rax
    pop rax
    mov rdi, rax
    call lx_is_digit
    push rax
    mov rax, 1
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_57
    mov rax, QWORD [rbp - 16]
    push rax
    mov rax, 48
    pop rbx
    mov rcx, rax
    mov rax, rbx
    sub rax, rcx
    mov QWORD [rbp - 32], rax
L_rep_start_58:
    call lx_peek
    push rax
    pop rax
    mov rdi, rax
    call lx_is_digit
    push rax
    mov rax, 1
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_rep_end_58
    mov rax, QWORD [rbp - 32]
    push rax
    mov rax, 10
    pop rbx
    imul rax, rbx
    push rax
    call lx_adv
    push rax
    mov rax, 48
    pop rbx
    mov rcx, rax
    mov rax, rbx
    sub rax, rcx
    pop rbx
    add rax, rbx
    mov QWORD [rbp - 32], rax
    jmp L_rep_start_58
L_rep_end_58:
    mov rax, QWORD [rbp - 32]
    mov QWORD [token_value], rax
    mov rax, 4
    push rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, QWORD [lx_cur]
    push rax
    mov rax, QWORD [rbp - 8]
    pop rbx
    mov rcx, rax
    mov rax, rbx
    sub rax, rcx
    push rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call lx_tok
    leave
    ret
L_if_else_57:
L_if_end_57:
    mov rax, QWORD [rbp - 16]
    push rax
    mov rax, 39
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_59
    call lx_adv
    mov QWORD [rbp - 40], rax
    mov rax, QWORD [rbp - 40]
    push rax
    mov rax, 92
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_60
    call lx_adv
    mov QWORD [rbp - 48], rax
    mov rax, QWORD [rbp - 48]
    mov QWORD [rbp - 40], rax
    mov rax, QWORD [rbp - 48]
    push rax
    mov rax, 110
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_61
    mov rax, 10
    mov QWORD [rbp - 40], rax
L_if_else_61:
L_if_end_61:
    mov rax, QWORD [rbp - 48]
    push rax
    mov rax, 116
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_62
    mov rax, 9
    mov QWORD [rbp - 40], rax
L_if_else_62:
L_if_end_62:
    mov rax, QWORD [rbp - 48]
    push rax
    mov rax, 114
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_63
    mov rax, 13
    mov QWORD [rbp - 40], rax
L_if_else_63:
L_if_end_63:
    mov rax, QWORD [rbp - 48]
    push rax
    mov rax, 48
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_64
    mov rax, 0
    mov QWORD [rbp - 40], rax
L_if_else_64:
L_if_end_64:
L_if_else_60:
L_if_end_60:
    call lx_adv
    mov rax, QWORD [rbp - 40]
    mov QWORD [token_value], rax
    mov rax, 41
    push rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, QWORD [lx_cur]
    push rax
    mov rax, QWORD [rbp - 8]
    pop rbx
    mov rcx, rax
    mov rax, rbx
    sub rax, rcx
    push rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call lx_tok
    leave
    ret
L_if_else_59:
L_if_end_59:
    mov rax, QWORD [rbp - 16]
    push rax
    mov rax, 34
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_65
    mov rax, QWORD [lx_cur]
    mov QWORD [rbp - 56], rax
L_rep_start_66:
    call lx_peek
    push rax
    mov rax, 34
    pop rbx
    cmp rbx, rax
    setne al
    movzx rax, al
    push rax
    call lx_peek
    push rax
    mov rax, 0
    pop rbx
    cmp rbx, rax
    setne al
    movzx rax, al
    pop rbx
    test rax, rax
    setne al
    test rbx, rbx
    setne bl
    and al, bl
    movzx rax, al
    test rax, rax
    jz L_rep_end_66
    call lx_peek
    push rax
    mov rax, 92
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_67
    call lx_adv
L_if_else_67:
L_if_end_67:
    call lx_adv
    jmp L_rep_start_66
L_rep_end_66:
    mov rax, QWORD [lx_cur]
    push rax
    mov rax, QWORD [rbp - 56]
    pop rbx
    mov rcx, rax
    mov rax, rbx
    sub rax, rcx
    mov QWORD [rbp - 64], rax
    call lx_adv
    mov rax, 6
    push rax
    mov rax, QWORD [rbp - 56]
    push rax
    mov rax, QWORD [rbp - 64]
    push rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call lx_tok
    leave
    ret
L_if_else_65:
L_if_end_65:
    mov rax, QWORD [rbp - 16]
    push rax
    pop rax
    mov rdi, rax
    call lx_is_alpha
    push rax
    mov rax, 1
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_68
L_rep_start_69:
    call lx_peek
    push rax
    pop rax
    mov rdi, rax
    call lx_is_alnum
    push rax
    mov rax, 1
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_rep_end_69
    call lx_adv
    jmp L_rep_start_69
L_rep_end_69:
    mov rax, QWORD [lx_cur]
    push rax
    mov rax, QWORD [rbp - 8]
    pop rbx
    mov rcx, rax
    mov rax, rbx
    sub rax, rcx
    mov QWORD [rbp - 72], rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, QWORD [rbp - 72]
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call lx_keyword
    push rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, QWORD [rbp - 72]
    push rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call lx_tok
    leave
    ret
L_if_else_68:
L_if_end_68:
    mov rax, 1
    push rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 1
    push rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call lx_tok
    leave
    ret
FRAME_20 equ 80
lx_copy_to_path:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_21
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    mov rax, rsi
    mov QWORD [rbp - 16], rax
    mov rax, rdx
    mov QWORD [rbp - 24], rax
    mov rax, 0
    mov QWORD [rbp - 32], rax
L_rep_start_70:
    mov rax, QWORD [rbp - 32]
    push rax
    mov rax, QWORD [rbp - 16]
    pop rbx
    cmp rbx, rax
    setne al
    movzx rax, al
    test rax, rax
    jz L_rep_end_70
    lea rax, [lx_path]
    push rax
    mov rax, QWORD [rbp - 24]
    pop rbx
    add rax, rbx
    push rax
    mov rax, QWORD [rbp - 32]
    pop rbx
    add rax, rbx
    push rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, QWORD [rbp - 32]
    pop rbx
    add rax, rbx
    movzx rax, byte [rax]
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call poke8
    mov rax, QWORD [rbp - 32]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    mov QWORD [rbp - 32], rax
    jmp L_rep_start_70
L_rep_end_70:
    mov rax, QWORD [rbp - 24]
    push rax
    mov rax, QWORD [rbp - 16]
    pop rbx
    add rax, rbx
    leave
    ret
FRAME_21 equ 32
lx_find_used:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_22
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    mov rax, 0
    mov QWORD [rbp - 16], rax
L_rep_start_71:
    mov rax, QWORD [rbp - 16]
    push rax
    mov rax, QWORD [lx_used_count]
    pop rbx
    cmp rbx, rax
    setne al
    movzx rax, al
    test rax, rax
    jz L_rep_end_71
    mov rax, QWORD [rbp - 16]
    mov r11, rax
    mov rax, QWORD [lx_usedlen + r11 * 8]
    push rax
    mov rax, QWORD [rbp - 8]
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_72
    lea rax, [lx_used]
    push rax
    mov rax, QWORD [rbp - 16]
    push rax
    mov rax, 4096
    pop rbx
    imul rax, rbx
    pop rbx
    add rax, rbx
    mov QWORD [rbp - 24], rax
    mov rax, 0
    mov QWORD [rbp - 32], rax
    mov rax, 1
    mov QWORD [rbp - 40], rax
L_rep_start_73:
    mov rax, QWORD [rbp - 32]
    push rax
    mov rax, QWORD [rbp - 8]
    pop rbx
    cmp rbx, rax
    setne al
    movzx rax, al
    test rax, rax
    jz L_rep_end_73
    mov rax, QWORD [rbp - 24]
    push rax
    mov rax, QWORD [rbp - 32]
    pop rbx
    add rax, rbx
    movzx rax, byte [rax]
    push rax
    lea rax, [lx_path]
    push rax
    mov rax, QWORD [rbp - 32]
    pop rbx
    add rax, rbx
    movzx rax, byte [rax]
    pop rbx
    cmp rbx, rax
    setne al
    movzx rax, al
    test rax, rax
    jz L_if_else_74
    mov rax, 0
    mov QWORD [rbp - 40], rax
L_if_else_74:
L_if_end_74:
    mov rax, QWORD [rbp - 32]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    mov QWORD [rbp - 32], rax
    jmp L_rep_start_73
L_rep_end_73:
    mov rax, QWORD [rbp - 40]
    push rax
    mov rax, 1
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_75
    mov rax, 1
    leave
    ret
L_if_else_75:
L_if_end_75:
L_if_else_72:
L_if_end_72:
    mov rax, QWORD [rbp - 16]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    mov QWORD [rbp - 16], rax
    jmp L_rep_start_71
L_rep_end_71:
    mov rax, 0
    leave
    ret
FRAME_22 equ 48
lx_record_used:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_23
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    lea rax, [lx_used]
    push rax
    mov rax, QWORD [lx_used_count]
    push rax
    mov rax, 4096
    pop rbx
    imul rax, rbx
    pop rbx
    add rax, rbx
    mov QWORD [rbp - 16], rax
    mov rax, 0
    mov QWORD [rbp - 24], rax
L_rep_start_76:
    mov rax, QWORD [rbp - 24]
    push rax
    mov rax, QWORD [rbp - 8]
    pop rbx
    cmp rbx, rax
    setne al
    movzx rax, al
    test rax, rax
    jz L_rep_end_76
    mov rax, QWORD [rbp - 16]
    push rax
    mov rax, QWORD [rbp - 24]
    pop rbx
    add rax, rbx
    push rax
    lea rax, [lx_path]
    push rax
    mov rax, QWORD [rbp - 24]
    pop rbx
    add rax, rbx
    movzx rax, byte [rax]
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call poke8
    mov rax, QWORD [rbp - 24]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    mov QWORD [rbp - 24], rax
    jmp L_rep_start_76
L_rep_end_76:
    mov rax, QWORD [lx_used_count]
    push rax
    mov rax, QWORD [rbp - 8]
    mov r12, rax
    pop r11
    mov QWORD [lx_usedlen + r11 * 8], r12
    mov rax, QWORD [lx_used_count]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    mov QWORD [lx_used_count], rax
    mov rax, 0
    leave
    ret
FRAME_23 equ 32
lx_set_dir:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_24
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    mov rax, rsi
    mov QWORD [rbp - 16], rax
    mov rax, 0
    mov QWORD [rbp - 24], rax
    mov rax, 0
    mov QWORD [rbp - 32], rax
L_rep_start_77:
    mov rax, QWORD [rbp - 24]
    push rax
    mov rax, QWORD [rbp - 16]
    pop rbx
    cmp rbx, rax
    setne al
    movzx rax, al
    test rax, rax
    jz L_rep_end_77
    lea rax, [lx_path]
    push rax
    mov rax, QWORD [rbp - 24]
    pop rbx
    add rax, rbx
    movzx rax, byte [rax]
    push rax
    mov rax, 47
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_78
    mov rax, QWORD [rbp - 24]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    mov QWORD [rbp - 32], rax
L_if_else_78:
L_if_end_78:
    mov rax, QWORD [rbp - 24]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    mov QWORD [rbp - 24], rax
    jmp L_rep_start_77
L_rep_end_77:
    lea rax, [lx_dirs]
    push rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 4096
    pop rbx
    imul rax, rbx
    pop rbx
    add rax, rbx
    mov QWORD [rbp - 40], rax
    mov rax, 0
    mov QWORD [rbp - 24], rax
L_rep_start_79:
    mov rax, QWORD [rbp - 24]
    push rax
    mov rax, QWORD [rbp - 32]
    pop rbx
    cmp rbx, rax
    setne al
    movzx rax, al
    test rax, rax
    jz L_rep_end_79
    mov rax, QWORD [rbp - 40]
    push rax
    mov rax, QWORD [rbp - 24]
    pop rbx
    add rax, rbx
    push rax
    lea rax, [lx_path]
    push rax
    mov rax, QWORD [rbp - 24]
    pop rbx
    add rax, rbx
    movzx rax, byte [rax]
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call poke8
    mov rax, QWORD [rbp - 24]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    mov QWORD [rbp - 24], rax
    jmp L_rep_start_79
L_rep_end_79:
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, QWORD [rbp - 32]
    mov r12, rax
    pop r11
    mov QWORD [lx_dirlen + r11 * 8], r12
    mov rax, 0
    leave
    ret
FRAME_24 equ 48
lx_load:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_25
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    lea rax, [lx_path]
    push rax
    mov rax, QWORD [rbp - 8]
    pop rbx
    add rax, rbx
    push rax
    mov rax, 0
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call poke8
    mov rax, QWORD [rbp - 8]
    push rax
    pop rax
    mov rdi, rax
    call lx_find_used
    push rax
    mov rax, 1
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_80
    mov rax, 1
    leave
    ret
L_if_else_80:
L_if_end_80:
    mov rax, QWORD [lx_file_count]
    push rax
    mov rax, 31
    pop rbx
    cmp rbx, rax
    setge al
    movzx rax, al
    push rax
    mov rax, QWORD [lx_depth]
    push rax
    mov rax, 31
    pop rbx
    cmp rbx, rax
    setge al
    movzx rax, al
    pop rbx
    or rax, rbx
    test rax, rax
    setne al
    movzx rax, al
    test rax, rax
    jz L_if_else_81
section .rodata
str_18: db 116, 111, 111, 32, 109, 97, 110, 121, 32, 115, 111, 117, 114, 99, 101, 32, 102, 105, 108, 101, 115, 0
section .text
    lea rax, [rel str_18]
    push rax
    pop rax
    mov rdi, rax
    call lx_fail
L_if_else_81:
L_if_end_81:
    mov rax, QWORD [rbp - 8]
    push rax
    pop rax
    mov rdi, rax
    call lx_record_used
    mov rax, QWORD [lx_file_count]
    mov QWORD [rbp - 16], rax
    mov rax, QWORD [lx_file_count]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    mov QWORD [lx_file_count], rax
    lea rax, [lx_pool]
    push rax
    mov rax, QWORD [rbp - 16]
    push rax
    mov rax, 65536
    pop rbx
    imul rax, rbx
    pop rbx
    add rax, rbx
    mov QWORD [rbp - 24], rax
    lea rax, [lx_path]
    push rax
    mov rax, QWORD [rbp - 24]
    push rax
    mov rax, 65535
    push rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call read_file
    mov QWORD [rbp - 32], rax
    mov rax, QWORD [rbp - 32]
    push rax
    mov rax, 0
    pop rbx
    cmp rbx, rax
    setl al
    movzx rax, al
    test rax, rax
    jz L_if_else_82
section .rodata
str_19: db 99, 97, 110, 110, 111, 116, 32, 111, 112, 101, 110, 32, 115, 111, 117, 114, 99, 101, 32, 102, 105, 108, 101, 0
section .text
    lea rax, [rel str_19]
    push rax
    pop rax
    mov rdi, rax
    call lx_fail
L_if_else_82:
L_if_end_82:
    mov rax, QWORD [rbp - 24]
    push rax
    mov rax, QWORD [rbp - 32]
    pop rbx
    add rax, rbx
    push rax
    mov rax, 0
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call poke8
    mov rax, QWORD [lx_depth]
    push rax
    mov rax, QWORD [lx_cur]
    mov r12, rax
    pop r11
    mov QWORD [lx_stack_cur + r11 * 8], r12
    mov rax, QWORD [lx_depth]
    push rax
    mov rax, QWORD [lx_end]
    mov r12, rax
    pop r11
    mov QWORD [lx_stack_end + r11 * 8], r12
    mov rax, QWORD [lx_depth]
    push rax
    mov rax, QWORD [lx_slot]
    mov r12, rax
    pop r11
    mov QWORD [lx_stack_slot + r11 * 8], r12
    mov rax, QWORD [lx_depth]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    mov QWORD [lx_depth], rax
    mov rax, QWORD [rbp - 24]
    mov QWORD [lx_cur], rax
    mov rax, QWORD [rbp - 24]
    push rax
    mov rax, QWORD [rbp - 32]
    pop rbx
    add rax, rbx
    mov QWORD [lx_end], rax
    mov rax, QWORD [rbp - 16]
    mov QWORD [lx_slot], rax
    mov rax, QWORD [rbp - 16]
    push rax
    mov rax, QWORD [rbp - 8]
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call lx_set_dir
    mov rax, 1
    leave
    ret
FRAME_25 equ 32
lexer_open:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_26
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    mov rax, QWORD [rbp - 8]
    push rax
    pop rax
    mov rdi, rax
    call str_len
    mov QWORD [rbp - 16], rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, QWORD [rbp - 16]
    push rax
    mov rax, 0
    push rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call lx_copy_to_path
    mov rax, QWORD [rbp - 16]
    push rax
    pop rax
    mov rdi, rax
    call lx_load
    leave
    ret
FRAME_26 equ 16
lexer_use_file:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_27
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    mov rax, rsi
    mov QWORD [rbp - 16], rax
    mov rax, 0
    mov QWORD [rbp - 24], rax
    mov rax, QWORD [rbp - 8]
    movzx rax, byte [rax]
    push rax
    mov rax, 47
    pop rbx
    cmp rbx, rax
    setne al
    movzx rax, al
    test rax, rax
    jz L_if_else_83
    lea rax, [lx_dirs]
    push rax
    mov rax, QWORD [lx_slot]
    push rax
    mov rax, 4096
    pop rbx
    imul rax, rbx
    pop rbx
    add rax, rbx
    push rax
    mov rax, QWORD [lx_slot]
    mov r11, rax
    mov rax, QWORD [lx_dirlen + r11 * 8]
    push rax
    mov rax, 0
    push rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call lx_copy_to_path
    mov QWORD [rbp - 24], rax
L_if_else_83:
L_if_end_83:
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, QWORD [rbp - 16]
    push rax
    mov rax, QWORD [rbp - 24]
    push rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call lx_copy_to_path
    mov QWORD [rbp - 24], rax
    mov rax, QWORD [rbp - 24]
    push rax
    pop rax
    mov rdi, rax
    call lx_load
    leave
    ret
FRAME_27 equ 32
ast_new_node:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_28
    mov rax, QWORD [ast_count]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    mov QWORD [ast_count], rax
    mov rax, QWORD [ast_count]
    leave
    ret
FRAME_28 equ 0
ast_list_new:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_29
    call ast_new_node
    mov QWORD [rbp - 8], rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 23
    mov r12, rax
    pop r11
    mov QWORD [ast_kind + r11 * 8], r12
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 0
    mov r12, rax
    pop r11
    mov QWORD [ast_a + r11 * 8], r12
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 0
    mov r12, rax
    pop r11
    mov QWORD [ast_d + r11 * 8], r12
    mov rax, QWORD [rbp - 8]
    leave
    ret
FRAME_29 equ 16
ast_list_append:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_30
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    mov rax, rsi
    mov QWORD [rbp - 16], rax
    mov rax, QWORD [rbp - 8]
    mov r11, rax
    mov rax, QWORD [ast_d + r11 * 8]
    mov QWORD [rbp - 24], rax
    mov rax, QWORD [rbp - 16]
    push rax
    mov rax, 0
    mov r12, rax
    pop r11
    mov QWORD [ast_next + r11 * 8], r12
    mov rax, QWORD [rbp - 24]
    push rax
    mov rax, 0
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_84
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, QWORD [rbp - 16]
    mov r12, rax
    pop r11
    mov QWORD [ast_a + r11 * 8], r12
L_if_else_84:
L_if_end_84:
    mov rax, QWORD [rbp - 24]
    push rax
    mov rax, 0
    pop rbx
    cmp rbx, rax
    setne al
    movzx rax, al
    test rax, rax
    jz L_if_else_85
    mov rax, QWORD [rbp - 24]
    push rax
    mov rax, QWORD [rbp - 16]
    mov r12, rax
    pop r11
    mov QWORD [ast_next + r11 * 8], r12
L_if_else_85:
L_if_end_85:
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, QWORD [rbp - 16]
    mov r12, rax
    pop r11
    mov QWORD [ast_d + r11 * 8], r12
    mov rax, 0
    leave
    ret
FRAME_30 equ 32
ast_list_first:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_31
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    mov rax, QWORD [rbp - 8]
    mov r11, rax
    mov rax, QWORD [ast_a + r11 * 8]
    leave
    ret
FRAME_31 equ 16
ast_num:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_32
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    call ast_new_node
    mov QWORD [rbp - 16], rax
    mov rax, QWORD [rbp - 16]
    push rax
    mov rax, 1
    mov r12, rax
    pop r11
    mov QWORD [ast_kind + r11 * 8], r12
    mov rax, QWORD [rbp - 16]
    push rax
    mov rax, QWORD [rbp - 8]
    mov r12, rax
    pop r11
    mov QWORD [ast_a + r11 * 8], r12
    mov rax, QWORD [rbp - 16]
    leave
    ret
FRAME_32 equ 16
ast_char:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_33
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    call ast_new_node
    mov QWORD [rbp - 16], rax
    mov rax, QWORD [rbp - 16]
    push rax
    mov rax, 2
    mov r12, rax
    pop r11
    mov QWORD [ast_kind + r11 * 8], r12
    mov rax, QWORD [rbp - 16]
    push rax
    mov rax, QWORD [rbp - 8]
    mov r12, rax
    pop r11
    mov QWORD [ast_a + r11 * 8], r12
    mov rax, QWORD [rbp - 16]
    leave
    ret
FRAME_33 equ 16
ast_string:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_34
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    mov rax, rsi
    mov QWORD [rbp - 16], rax
    call ast_new_node
    mov QWORD [rbp - 24], rax
    mov rax, QWORD [rbp - 24]
    push rax
    mov rax, 3
    mov r12, rax
    pop r11
    mov QWORD [ast_kind + r11 * 8], r12
    mov rax, QWORD [rbp - 24]
    push rax
    mov rax, QWORD [rbp - 8]
    mov r12, rax
    pop r11
    mov QWORD [ast_name_ptr + r11 * 8], r12
    mov rax, QWORD [rbp - 24]
    push rax
    mov rax, QWORD [rbp - 16]
    mov r12, rax
    pop r11
    mov QWORD [ast_name_len + r11 * 8], r12
    mov rax, QWORD [rbp - 24]
    leave
    ret
FRAME_34 equ 32
ast_ident:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_35
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    mov rax, rsi
    mov QWORD [rbp - 16], rax
    call ast_new_node
    mov QWORD [rbp - 24], rax
    mov rax, QWORD [rbp - 24]
    push rax
    mov rax, 4
    mov r12, rax
    pop r11
    mov QWORD [ast_kind + r11 * 8], r12
    mov rax, QWORD [rbp - 24]
    push rax
    mov rax, QWORD [rbp - 8]
    mov r12, rax
    pop r11
    mov QWORD [ast_name_ptr + r11 * 8], r12
    mov rax, QWORD [rbp - 24]
    push rax
    mov rax, QWORD [rbp - 16]
    mov r12, rax
    pop r11
    mov QWORD [ast_name_len + r11 * 8], r12
    mov rax, QWORD [rbp - 24]
    leave
    ret
FRAME_35 equ 32
ast_bool:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_36
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    call ast_new_node
    mov QWORD [rbp - 16], rax
    mov rax, QWORD [rbp - 16]
    push rax
    mov rax, 5
    mov r12, rax
    pop r11
    mov QWORD [ast_kind + r11 * 8], r12
    mov rax, QWORD [rbp - 16]
    push rax
    mov rax, QWORD [rbp - 8]
    mov r12, rax
    pop r11
    mov QWORD [ast_a + r11 * 8], r12
    mov rax, QWORD [rbp - 16]
    leave
    ret
FRAME_36 equ 16
ast_null:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_37
    call ast_new_node
    mov QWORD [rbp - 8], rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 6
    mov r12, rax
    pop r11
    mov QWORD [ast_kind + r11 * 8], r12
    mov rax, QWORD [rbp - 8]
    leave
    ret
FRAME_37 equ 16
ast_binop:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_38
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    mov rax, rsi
    mov QWORD [rbp - 16], rax
    mov rax, rdx
    mov QWORD [rbp - 24], rax
    call ast_new_node
    mov QWORD [rbp - 32], rax
    mov rax, QWORD [rbp - 32]
    push rax
    mov rax, 7
    mov r12, rax
    pop r11
    mov QWORD [ast_kind + r11 * 8], r12
    mov rax, QWORD [rbp - 32]
    push rax
    mov rax, QWORD [rbp - 16]
    mov r12, rax
    pop r11
    mov QWORD [ast_a + r11 * 8], r12
    mov rax, QWORD [rbp - 32]
    push rax
    mov rax, QWORD [rbp - 24]
    mov r12, rax
    pop r11
    mov QWORD [ast_b + r11 * 8], r12
    mov rax, QWORD [rbp - 32]
    push rax
    mov rax, QWORD [rbp - 8]
    mov r12, rax
    pop r11
    mov QWORD [ast_c + r11 * 8], r12
    mov rax, QWORD [rbp - 32]
    leave
    ret
FRAME_38 equ 32
ast_unary:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_39
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    mov rax, rsi
    mov QWORD [rbp - 16], rax
    call ast_new_node
    mov QWORD [rbp - 24], rax
    mov rax, QWORD [rbp - 24]
    push rax
    mov rax, 8
    mov r12, rax
    pop r11
    mov QWORD [ast_kind + r11 * 8], r12
    mov rax, QWORD [rbp - 24]
    push rax
    mov rax, QWORD [rbp - 16]
    mov r12, rax
    pop r11
    mov QWORD [ast_a + r11 * 8], r12
    mov rax, QWORD [rbp - 24]
    push rax
    mov rax, QWORD [rbp - 8]
    mov r12, rax
    pop r11
    mov QWORD [ast_c + r11 * 8], r12
    mov rax, QWORD [rbp - 24]
    leave
    ret
FRAME_39 equ 32
ast_call:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_40
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    mov rax, rsi
    mov QWORD [rbp - 16], rax
    mov rax, rdx
    mov QWORD [rbp - 24], rax
    call ast_new_node
    mov QWORD [rbp - 32], rax
    mov rax, QWORD [rbp - 32]
    push rax
    mov rax, 9
    mov r12, rax
    pop r11
    mov QWORD [ast_kind + r11 * 8], r12
    mov rax, QWORD [rbp - 32]
    push rax
    mov rax, QWORD [rbp - 8]
    mov r12, rax
    pop r11
    mov QWORD [ast_name_ptr + r11 * 8], r12
    mov rax, QWORD [rbp - 32]
    push rax
    mov rax, QWORD [rbp - 16]
    mov r12, rax
    pop r11
    mov QWORD [ast_name_len + r11 * 8], r12
    mov rax, QWORD [rbp - 32]
    push rax
    mov rax, QWORD [rbp - 24]
    mov r12, rax
    pop r11
    mov QWORD [ast_a + r11 * 8], r12
    mov rax, QWORD [rbp - 32]
    leave
    ret
FRAME_40 equ 32
ast_index:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_41
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    mov rax, rsi
    mov QWORD [rbp - 16], rax
    mov rax, rdx
    mov QWORD [rbp - 24], rax
    call ast_new_node
    mov QWORD [rbp - 32], rax
    mov rax, QWORD [rbp - 32]
    push rax
    mov rax, 10
    mov r12, rax
    pop r11
    mov QWORD [ast_kind + r11 * 8], r12
    mov rax, QWORD [rbp - 32]
    push rax
    mov rax, QWORD [rbp - 8]
    mov r12, rax
    pop r11
    mov QWORD [ast_name_ptr + r11 * 8], r12
    mov rax, QWORD [rbp - 32]
    push rax
    mov rax, QWORD [rbp - 16]
    mov r12, rax
    pop r11
    mov QWORD [ast_name_len + r11 * 8], r12
    mov rax, QWORD [rbp - 32]
    push rax
    mov rax, QWORD [rbp - 24]
    mov r12, rax
    pop r11
    mov QWORD [ast_a + r11 * 8], r12
    mov rax, QWORD [rbp - 32]
    leave
    ret
FRAME_41 equ 32
ast_assign:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_42
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    mov rax, rsi
    mov QWORD [rbp - 16], rax
    mov rax, rdx
    mov QWORD [rbp - 24], rax
    call ast_new_node
    mov QWORD [rbp - 32], rax
    mov rax, QWORD [rbp - 32]
    push rax
    mov rax, 11
    mov r12, rax
    pop r11
    mov QWORD [ast_kind + r11 * 8], r12
    mov rax, QWORD [rbp - 32]
    push rax
    mov rax, QWORD [rbp - 8]
    mov r12, rax
    pop r11
    mov QWORD [ast_name_ptr + r11 * 8], r12
    mov rax, QWORD [rbp - 32]
    push rax
    mov rax, QWORD [rbp - 16]
    mov r12, rax
    pop r11
    mov QWORD [ast_name_len + r11 * 8], r12
    mov rax, QWORD [rbp - 32]
    push rax
    mov rax, QWORD [rbp - 24]
    mov r12, rax
    pop r11
    mov QWORD [ast_a + r11 * 8], r12
    mov rax, QWORD [rbp - 32]
    leave
    ret
FRAME_42 equ 32
ast_arrassign:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_43
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    mov rax, rsi
    mov QWORD [rbp - 16], rax
    mov rax, rdx
    mov QWORD [rbp - 24], rax
    mov rax, rcx
    mov QWORD [rbp - 32], rax
    call ast_new_node
    mov QWORD [rbp - 40], rax
    mov rax, QWORD [rbp - 40]
    push rax
    mov rax, 12
    mov r12, rax
    pop r11
    mov QWORD [ast_kind + r11 * 8], r12
    mov rax, QWORD [rbp - 40]
    push rax
    mov rax, QWORD [rbp - 8]
    mov r12, rax
    pop r11
    mov QWORD [ast_name_ptr + r11 * 8], r12
    mov rax, QWORD [rbp - 40]
    push rax
    mov rax, QWORD [rbp - 16]
    mov r12, rax
    pop r11
    mov QWORD [ast_name_len + r11 * 8], r12
    mov rax, QWORD [rbp - 40]
    push rax
    mov rax, QWORD [rbp - 24]
    mov r12, rax
    pop r11
    mov QWORD [ast_a + r11 * 8], r12
    mov rax, QWORD [rbp - 40]
    push rax
    mov rax, QWORD [rbp - 32]
    mov r12, rax
    pop r11
    mov QWORD [ast_b + r11 * 8], r12
    mov rax, QWORD [rbp - 40]
    leave
    ret
FRAME_43 equ 48
ast_vardecl:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_44
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    mov rax, rsi
    mov QWORD [rbp - 16], rax
    mov rax, rdx
    mov QWORD [rbp - 24], rax
    mov rax, rcx
    mov QWORD [rbp - 32], rax
    mov rax, r8
    mov QWORD [rbp - 40], rax
    call ast_new_node
    mov QWORD [rbp - 48], rax
    mov rax, QWORD [rbp - 48]
    push rax
    mov rax, 13
    mov r12, rax
    pop r11
    mov QWORD [ast_kind + r11 * 8], r12
    mov rax, QWORD [rbp - 48]
    push rax
    mov rax, QWORD [rbp - 8]
    mov r12, rax
    pop r11
    mov QWORD [ast_a + r11 * 8], r12
    mov rax, QWORD [rbp - 48]
    push rax
    mov rax, QWORD [rbp - 16]
    mov r12, rax
    pop r11
    mov QWORD [ast_d + r11 * 8], r12
    mov rax, QWORD [rbp - 48]
    push rax
    mov rax, QWORD [rbp - 24]
    mov r12, rax
    pop r11
    mov QWORD [ast_name_ptr + r11 * 8], r12
    mov rax, QWORD [rbp - 48]
    push rax
    mov rax, QWORD [rbp - 32]
    mov r12, rax
    pop r11
    mov QWORD [ast_name_len + r11 * 8], r12
    mov rax, QWORD [rbp - 48]
    push rax
    mov rax, QWORD [rbp - 40]
    mov r12, rax
    pop r11
    mov QWORD [ast_b + r11 * 8], r12
    mov rax, QWORD [rbp - 48]
    leave
    ret
FRAME_44 equ 48
ast_arrdecl:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_45
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    mov rax, rsi
    mov QWORD [rbp - 16], rax
    mov rax, rdx
    mov QWORD [rbp - 24], rax
    mov rax, rcx
    mov QWORD [rbp - 32], rax
    call ast_new_node
    mov QWORD [rbp - 40], rax
    mov rax, QWORD [rbp - 40]
    push rax
    mov rax, 14
    mov r12, rax
    pop r11
    mov QWORD [ast_kind + r11 * 8], r12
    mov rax, QWORD [rbp - 40]
    push rax
    mov rax, QWORD [rbp - 8]
    mov r12, rax
    pop r11
    mov QWORD [ast_a + r11 * 8], r12
    mov rax, QWORD [rbp - 40]
    push rax
    mov rax, QWORD [rbp - 16]
    mov r12, rax
    pop r11
    mov QWORD [ast_name_ptr + r11 * 8], r12
    mov rax, QWORD [rbp - 40]
    push rax
    mov rax, QWORD [rbp - 24]
    mov r12, rax
    pop r11
    mov QWORD [ast_name_len + r11 * 8], r12
    mov rax, QWORD [rbp - 40]
    push rax
    mov rax, QWORD [rbp - 32]
    mov r12, rax
    pop r11
    mov QWORD [ast_d + r11 * 8], r12
    mov rax, QWORD [rbp - 40]
    leave
    ret
FRAME_45 equ 48
ast_if:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_46
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    mov rax, rsi
    mov QWORD [rbp - 16], rax
    mov rax, rdx
    mov QWORD [rbp - 24], rax
    call ast_new_node
    mov QWORD [rbp - 32], rax
    mov rax, QWORD [rbp - 32]
    push rax
    mov rax, 15
    mov r12, rax
    pop r11
    mov QWORD [ast_kind + r11 * 8], r12
    mov rax, QWORD [rbp - 32]
    push rax
    mov rax, QWORD [rbp - 8]
    mov r12, rax
    pop r11
    mov QWORD [ast_a + r11 * 8], r12
    mov rax, QWORD [rbp - 32]
    push rax
    mov rax, QWORD [rbp - 16]
    mov r12, rax
    pop r11
    mov QWORD [ast_b + r11 * 8], r12
    mov rax, QWORD [rbp - 32]
    push rax
    mov rax, QWORD [rbp - 24]
    mov r12, rax
    pop r11
    mov QWORD [ast_c + r11 * 8], r12
    mov rax, QWORD [rbp - 32]
    leave
    ret
FRAME_46 equ 32
ast_repcount:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_47
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    mov rax, rsi
    mov QWORD [rbp - 16], rax
    call ast_new_node
    mov QWORD [rbp - 24], rax
    mov rax, QWORD [rbp - 24]
    push rax
    mov rax, 16
    mov r12, rax
    pop r11
    mov QWORD [ast_kind + r11 * 8], r12
    mov rax, QWORD [rbp - 24]
    push rax
    mov rax, QWORD [rbp - 8]
    mov r12, rax
    pop r11
    mov QWORD [ast_a + r11 * 8], r12
    mov rax, QWORD [rbp - 24]
    push rax
    mov rax, QWORD [rbp - 16]
    mov r12, rax
    pop r11
    mov QWORD [ast_b + r11 * 8], r12
    mov rax, QWORD [rbp - 24]
    leave
    ret
FRAME_47 equ 32
ast_repcond:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_48
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    mov rax, rsi
    mov QWORD [rbp - 16], rax
    call ast_new_node
    mov QWORD [rbp - 24], rax
    mov rax, QWORD [rbp - 24]
    push rax
    mov rax, 17
    mov r12, rax
    pop r11
    mov QWORD [ast_kind + r11 * 8], r12
    mov rax, QWORD [rbp - 24]
    push rax
    mov rax, QWORD [rbp - 8]
    mov r12, rax
    pop r11
    mov QWORD [ast_a + r11 * 8], r12
    mov rax, QWORD [rbp - 24]
    push rax
    mov rax, QWORD [rbp - 16]
    mov r12, rax
    pop r11
    mov QWORD [ast_b + r11 * 8], r12
    mov rax, QWORD [rbp - 24]
    leave
    ret
FRAME_48 equ 32
ast_return:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_49
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    call ast_new_node
    mov QWORD [rbp - 16], rax
    mov rax, QWORD [rbp - 16]
    push rax
    mov rax, 18
    mov r12, rax
    pop r11
    mov QWORD [ast_kind + r11 * 8], r12
    mov rax, QWORD [rbp - 16]
    push rax
    mov rax, QWORD [rbp - 8]
    mov r12, rax
    pop r11
    mov QWORD [ast_a + r11 * 8], r12
    mov rax, QWORD [rbp - 16]
    leave
    ret
FRAME_49 equ 16
ast_param:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_50
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    mov rax, rsi
    mov QWORD [rbp - 16], rax
    mov rax, rdx
    mov QWORD [rbp - 24], rax
    mov rax, rcx
    mov QWORD [rbp - 32], rax
    call ast_new_node
    mov QWORD [rbp - 40], rax
    mov rax, QWORD [rbp - 40]
    push rax
    mov rax, 19
    mov r12, rax
    pop r11
    mov QWORD [ast_kind + r11 * 8], r12
    mov rax, QWORD [rbp - 40]
    push rax
    mov rax, QWORD [rbp - 8]
    mov r12, rax
    pop r11
    mov QWORD [ast_a + r11 * 8], r12
    mov rax, QWORD [rbp - 40]
    push rax
    mov rax, QWORD [rbp - 16]
    mov r12, rax
    pop r11
    mov QWORD [ast_d + r11 * 8], r12
    mov rax, QWORD [rbp - 40]
    push rax
    mov rax, QWORD [rbp - 24]
    mov r12, rax
    pop r11
    mov QWORD [ast_name_ptr + r11 * 8], r12
    mov rax, QWORD [rbp - 40]
    push rax
    mov rax, QWORD [rbp - 32]
    mov r12, rax
    pop r11
    mov QWORD [ast_name_len + r11 * 8], r12
    mov rax, QWORD [rbp - 40]
    leave
    ret
FRAME_50 equ 48
ast_func:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_51
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    mov rax, rsi
    mov QWORD [rbp - 16], rax
    mov rax, rdx
    mov QWORD [rbp - 24], rax
    mov rax, rcx
    mov QWORD [rbp - 32], rax
    mov rax, r8
    mov QWORD [rbp - 40], rax
    mov rax, r9
    mov QWORD [rbp - 48], rax
    call ast_new_node
    mov QWORD [rbp - 56], rax
    mov rax, QWORD [rbp - 56]
    push rax
    mov rax, 20
    mov r12, rax
    pop r11
    mov QWORD [ast_kind + r11 * 8], r12
    mov rax, QWORD [rbp - 56]
    push rax
    mov rax, QWORD [rbp - 8]
    mov r12, rax
    pop r11
    mov QWORD [ast_name_ptr + r11 * 8], r12
    mov rax, QWORD [rbp - 56]
    push rax
    mov rax, QWORD [rbp - 16]
    mov r12, rax
    pop r11
    mov QWORD [ast_name_len + r11 * 8], r12
    mov rax, QWORD [rbp - 56]
    push rax
    mov rax, QWORD [rbp - 24]
    mov r12, rax
    pop r11
    mov QWORD [ast_a + r11 * 8], r12
    mov rax, QWORD [rbp - 56]
    push rax
    mov rax, QWORD [rbp - 32]
    mov r12, rax
    pop r11
    mov QWORD [ast_b + r11 * 8], r12
    mov rax, QWORD [rbp - 56]
    push rax
    mov rax, QWORD [rbp - 40]
    mov r12, rax
    pop r11
    mov QWORD [ast_c + r11 * 8], r12
    mov rax, QWORD [rbp - 56]
    push rax
    mov rax, QWORD [rbp - 48]
    mov r12, rax
    pop r11
    mov QWORD [ast_d + r11 * 8], r12
    mov rax, QWORD [rbp - 56]
    leave
    ret
FRAME_51 equ 64
ast_globalvar:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_52
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    mov rax, rsi
    mov QWORD [rbp - 16], rax
    mov rax, rdx
    mov QWORD [rbp - 24], rax
    mov rax, rcx
    mov QWORD [rbp - 32], rax
    call ast_new_node
    mov QWORD [rbp - 40], rax
    mov rax, QWORD [rbp - 40]
    push rax
    mov rax, 22
    mov r12, rax
    pop r11
    mov QWORD [ast_kind + r11 * 8], r12
    mov rax, QWORD [rbp - 40]
    push rax
    mov rax, QWORD [rbp - 8]
    mov r12, rax
    pop r11
    mov QWORD [ast_a + r11 * 8], r12
    mov rax, QWORD [rbp - 40]
    push rax
    mov rax, QWORD [rbp - 16]
    mov r12, rax
    pop r11
    mov QWORD [ast_d + r11 * 8], r12
    mov rax, QWORD [rbp - 40]
    push rax
    mov rax, QWORD [rbp - 24]
    mov r12, rax
    pop r11
    mov QWORD [ast_name_ptr + r11 * 8], r12
    mov rax, QWORD [rbp - 40]
    push rax
    mov rax, QWORD [rbp - 32]
    mov r12, rax
    pop r11
    mov QWORD [ast_name_len + r11 * 8], r12
    mov rax, QWORD [rbp - 40]
    leave
    ret
FRAME_52 equ 48
ast_program:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_53
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    call ast_new_node
    mov QWORD [rbp - 16], rax
    mov rax, QWORD [rbp - 16]
    push rax
    mov rax, 21
    mov r12, rax
    pop r11
    mov QWORD [ast_kind + r11 * 8], r12
    mov rax, QWORD [rbp - 16]
    push rax
    mov rax, QWORD [rbp - 8]
    mov r12, rax
    pop r11
    mov QWORD [ast_a + r11 * 8], r12
    mov rax, QWORD [rbp - 16]
    leave
    ret
FRAME_53 equ 16
ppush:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_54
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    mov rax, QWORD [psp]
    push rax
    mov rax, QWORD [rbp - 8]
    mov r12, rax
    pop r11
    mov QWORD [pstk + r11 * 8], r12
    mov rax, QWORD [psp]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    mov QWORD [psp], rax
    mov rax, 0
    leave
    ret
FRAME_54 equ 16
ppop:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_55
    mov rax, QWORD [psp]
    push rax
    mov rax, 1
    pop rbx
    mov rcx, rax
    mov rax, rbx
    sub rax, rcx
    mov QWORD [psp], rax
    mov rax, QWORD [psp]
    mov r11, rax
    mov rax, QWORD [pstk + r11 * 8]
    leave
    ret
FRAME_55 equ 0
p_next:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_56
    call lexer_next_token
    mov QWORD [cur_tok], rax
    mov rax, QWORD [token_ptr]
    mov QWORD [cur_ptr], rax
    mov rax, QWORD [token_len]
    mov QWORD [cur_len], rax
    mov rax, QWORD [token_value]
    mov QWORD [cur_val], rax
    mov rax, 0
    leave
    ret
FRAME_56 equ 0
p_skip_nl:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_57
L_rep_start_86:
    mov rax, QWORD [cur_tok]
    push rax
    mov rax, 2
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_rep_end_86
    call p_next
    jmp L_rep_start_86
L_rep_end_86:
    mov rax, 0
    leave
    ret
FRAME_57 equ 0
p_error:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_58
    mov rax, rdi
    mov QWORD [rbp - 8], rax
section .rodata
str_20: db 83, 121, 110, 116, 97, 120, 32, 69, 114, 114, 111, 114, 58, 32, 0
section .text
    lea rax, [rel str_20]
    push rax
    pop rax
    mov rdi, rax
    call err_str
    mov rax, QWORD [rbp - 8]
    push rax
    pop rax
    mov rdi, rax
    call err_str
section .rodata
str_21: db 32, 110, 101, 97, 114, 32, 39, 0
section .text
    lea rax, [rel str_21]
    push rax
    pop rax
    mov rdi, rax
    call err_str
    mov rax, QWORD [cur_ptr]
    push rax
    mov rax, QWORD [cur_len]
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call write_err
section .rodata
str_22: db 39, 10, 0
section .text
    lea rax, [rel str_22]
    push rax
    pop rax
    mov rdi, rax
    call err_str
    mov rax, 1
    push rax
    pop rax
    mov rdi, rax
    call exit_program
    mov rax, 0
    leave
    ret
FRAME_58 equ 16
p_expect:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_59
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    mov rax, QWORD [cur_tok]
    push rax
    mov rax, QWORD [rbp - 8]
    pop rbx
    cmp rbx, rax
    setne al
    movzx rax, al
    test rax, rax
    jz L_if_else_87
section .rodata
str_23: db 117, 110, 101, 120, 112, 101, 99, 116, 101, 100, 32, 116, 111, 107, 101, 110, 0
section .text
    lea rax, [rel str_23]
    push rax
    pop rax
    mov rdi, rax
    call p_error
L_if_else_87:
L_if_end_87:
    mov rax, 0
    leave
    ret
FRAME_59 equ 16
p_eq:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_60
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    mov rax, rsi
    mov QWORD [rbp - 16], rax
    mov rax, rdx
    mov QWORD [rbp - 24], rax
    mov rax, rcx
    mov QWORD [rbp - 32], rax
    mov rax, QWORD [rbp - 16]
    push rax
    mov rax, QWORD [rbp - 32]
    pop rbx
    cmp rbx, rax
    setne al
    movzx rax, al
    test rax, rax
    jz L_if_else_88
    mov rax, 0
    movzx rax, al
    leave
    ret
L_if_else_88:
L_if_end_88:
    mov rax, 0
    mov QWORD [rbp - 40], rax
L_rep_start_89:
    mov rax, QWORD [rbp - 40]
    push rax
    mov rax, QWORD [rbp - 16]
    pop rbx
    cmp rbx, rax
    setne al
    movzx rax, al
    test rax, rax
    jz L_rep_end_89
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, QWORD [rbp - 40]
    pop rbx
    add rax, rbx
    movzx rax, byte [rax]
    push rax
    mov rax, QWORD [rbp - 24]
    push rax
    mov rax, QWORD [rbp - 40]
    pop rbx
    add rax, rbx
    movzx rax, byte [rax]
    pop rbx
    cmp rbx, rax
    setne al
    movzx rax, al
    test rax, rax
    jz L_if_else_90
    mov rax, 0
    movzx rax, al
    leave
    ret
L_if_else_90:
L_if_end_90:
    mov rax, QWORD [rbp - 40]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    mov QWORD [rbp - 40], rax
    jmp L_rep_start_89
L_rep_end_89:
    mov rax, 1
    movzx rax, al
    leave
    ret
FRAME_60 equ 48
p_is_type:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_61
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 29
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    push rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 30
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    pop rbx
    or rax, rbx
    test rax, rax
    setne al
    movzx rax, al
    push rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 31
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    pop rbx
    or rax, rbx
    test rax, rax
    setne al
    movzx rax, al
    push rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 32
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    pop rbx
    or rax, rbx
    test rax, rax
    setne al
    movzx rax, al
    push rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 33
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    pop rbx
    or rax, rbx
    test rax, rax
    setne al
    movzx rax, al
    push rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 34
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    pop rbx
    or rax, rbx
    test rax, rax
    setne al
    movzx rax, al
    push rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 35
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    pop rbx
    or rax, rbx
    test rax, rax
    setne al
    movzx rax, al
    push rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 36
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    pop rbx
    or rax, rbx
    test rax, rax
    setne al
    movzx rax, al
    push rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 5
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    pop rbx
    or rax, rbx
    test rax, rax
    setne al
    movzx rax, al
    push rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 37
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    pop rbx
    or rax, rbx
    test rax, rax
    setne al
    movzx rax, al
    test rax, rax
    jz L_if_else_91
    mov rax, 1
    movzx rax, al
    leave
    ret
L_if_else_91:
L_if_end_91:
    mov rax, 0
    movzx rax, al
    leave
    ret
FRAME_61 equ 16
p_is_cmp:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_62
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 15
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    push rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 38
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    pop rbx
    or rax, rbx
    test rax, rax
    setne al
    movzx rax, al
    push rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 20
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    pop rbx
    or rax, rbx
    test rax, rax
    setne al
    movzx rax, al
    push rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 21
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    pop rbx
    or rax, rbx
    test rax, rax
    setne al
    movzx rax, al
    push rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 22
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    pop rbx
    or rax, rbx
    test rax, rax
    setne al
    movzx rax, al
    push rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 23
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    pop rbx
    or rax, rbx
    test rax, rax
    setne al
    movzx rax, al
    test rax, rax
    jz L_if_else_92
    mov rax, 1
    movzx rax, al
    leave
    ret
L_if_else_92:
L_if_end_92:
    mov rax, 0
    movzx rax, al
    leave
    ret
FRAME_62 equ 16
p_is_const_name:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_63
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    mov rax, rsi
    mov QWORD [rbp - 16], rax
    mov rax, QWORD [rbp - 16]
    push rax
    mov rax, 4
    pop rbx
    cmp rbx, rax
    setl al
    movzx rax, al
    test rax, rax
    jz L_if_else_93
    mov rax, 0
    movzx rax, al
    leave
    ret
L_if_else_93:
L_if_end_93:
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 0
    pop rbx
    add rax, rbx
    movzx rax, byte [rax]
    push rax
    mov rax, 84
    pop rbx
    cmp rbx, rax
    setne al
    movzx rax, al
    test rax, rax
    jz L_if_else_94
    mov rax, 0
    movzx rax, al
    leave
    ret
L_if_else_94:
L_if_end_94:
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    movzx rax, byte [rax]
    push rax
    mov rax, 79
    pop rbx
    cmp rbx, rax
    setne al
    movzx rax, al
    test rax, rax
    jz L_if_else_95
    mov rax, 0
    movzx rax, al
    leave
    ret
L_if_else_95:
L_if_end_95:
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 2
    pop rbx
    add rax, rbx
    movzx rax, byte [rax]
    push rax
    mov rax, 75
    pop rbx
    cmp rbx, rax
    setne al
    movzx rax, al
    test rax, rax
    jz L_if_else_96
    mov rax, 0
    movzx rax, al
    leave
    ret
L_if_else_96:
L_if_end_96:
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 3
    pop rbx
    add rax, rbx
    movzx rax, byte [rax]
    push rax
    mov rax, 95
    pop rbx
    cmp rbx, rax
    setne al
    movzx rax, al
    test rax, rax
    jz L_if_else_97
    mov rax, 0
    movzx rax, al
    leave
    ret
L_if_else_97:
L_if_end_97:
    mov rax, 1
    movzx rax, al
    leave
    ret
FRAME_63 equ 16
p_make_const:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_64
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    mov rax, rsi
    mov QWORD [rbp - 16], rax
    mov rax, rdx
    mov QWORD [rbp - 24], rax
    call ast_new_node
    mov QWORD [rbp - 32], rax
    mov rax, QWORD [rbp - 32]
    push rax
    mov rax, 24
    mov r12, rax
    pop r11
    mov QWORD [ast_kind + r11 * 8], r12
    mov rax, QWORD [rbp - 32]
    push rax
    mov rax, QWORD [rbp - 8]
    mov r12, rax
    pop r11
    mov QWORD [ast_name_ptr + r11 * 8], r12
    mov rax, QWORD [rbp - 32]
    push rax
    mov rax, QWORD [rbp - 16]
    mov r12, rax
    pop r11
    mov QWORD [ast_name_len + r11 * 8], r12
    mov rax, QWORD [rbp - 32]
    push rax
    mov rax, QWORD [rbp - 24]
    mov r12, rax
    pop r11
    mov QWORD [ast_a + r11 * 8], r12
    mov rax, QWORD [rbp - 32]
    leave
    ret
FRAME_64 equ 32
parse_expr:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_65
    call parse_or
    leave
    ret
FRAME_65 equ 0
parse_or:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_66
    call parse_and
    mov QWORD [rbp - 8], rax
L_rep_start_98:
    mov rax, QWORD [cur_tok]
    push rax
    mov rax, 40
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_rep_end_98
    mov rax, QWORD [rbp - 8]
    push rax
    pop rax
    mov rdi, rax
    call ppush
    call p_next
    call parse_and
    mov QWORD [rbp - 16], rax
    mov rax, 40
    push rax
    call ppop
    push rax
    mov rax, QWORD [rbp - 16]
    push rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call ast_binop
    mov QWORD [rbp - 8], rax
    jmp L_rep_start_98
L_rep_end_98:
    mov rax, QWORD [rbp - 8]
    leave
    ret
FRAME_66 equ 16
parse_and:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_67
    call parse_cmp
    mov QWORD [rbp - 8], rax
L_rep_start_99:
    mov rax, QWORD [cur_tok]
    push rax
    mov rax, 39
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_rep_end_99
    mov rax, QWORD [rbp - 8]
    push rax
    pop rax
    mov rdi, rax
    call ppush
    call p_next
    call parse_cmp
    mov QWORD [rbp - 16], rax
    mov rax, 39
    push rax
    call ppop
    push rax
    mov rax, QWORD [rbp - 16]
    push rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call ast_binop
    mov QWORD [rbp - 8], rax
    jmp L_rep_start_99
L_rep_end_99:
    mov rax, QWORD [rbp - 8]
    leave
    ret
FRAME_67 equ 16
parse_cmp:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_68
    call parse_add
    mov QWORD [rbp - 8], rax
L_rep_start_100:
    mov rax, QWORD [cur_tok]
    push rax
    pop rax
    mov rdi, rax
    call p_is_cmp
    push rax
    mov rax, 1
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_rep_end_100
    mov rax, QWORD [rbp - 8]
    push rax
    pop rax
    mov rdi, rax
    call ppush
    mov rax, QWORD [cur_tok]
    push rax
    pop rax
    mov rdi, rax
    call ppush
    call p_next
    call parse_add
    mov QWORD [rbp - 16], rax
    call ppop
    mov QWORD [rbp - 24], rax
    mov rax, QWORD [rbp - 24]
    push rax
    call ppop
    push rax
    mov rax, QWORD [rbp - 16]
    push rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call ast_binop
    mov QWORD [rbp - 8], rax
    jmp L_rep_start_100
L_rep_end_100:
    mov rax, QWORD [rbp - 8]
    leave
    ret
FRAME_68 equ 32
parse_add:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_69
    call parse_mul
    mov QWORD [rbp - 8], rax
L_rep_start_101:
    mov rax, QWORD [cur_tok]
    push rax
    mov rax, 16
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    push rax
    mov rax, QWORD [cur_tok]
    push rax
    mov rax, 17
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    pop rbx
    or rax, rbx
    test rax, rax
    setne al
    movzx rax, al
    test rax, rax
    jz L_rep_end_101
    mov rax, QWORD [rbp - 8]
    push rax
    pop rax
    mov rdi, rax
    call ppush
    mov rax, QWORD [cur_tok]
    push rax
    pop rax
    mov rdi, rax
    call ppush
    call p_next
    call parse_mul
    mov QWORD [rbp - 16], rax
    call ppop
    mov QWORD [rbp - 24], rax
    mov rax, QWORD [rbp - 24]
    push rax
    call ppop
    push rax
    mov rax, QWORD [rbp - 16]
    push rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call ast_binop
    mov QWORD [rbp - 8], rax
    jmp L_rep_start_101
L_rep_end_101:
    mov rax, QWORD [rbp - 8]
    leave
    ret
FRAME_69 equ 32
parse_mul:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_70
    call parse_unary
    mov QWORD [rbp - 8], rax
L_rep_start_102:
    mov rax, QWORD [cur_tok]
    push rax
    mov rax, 18
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    push rax
    mov rax, QWORD [cur_tok]
    push rax
    mov rax, 19
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    pop rbx
    or rax, rbx
    test rax, rax
    setne al
    movzx rax, al
    test rax, rax
    jz L_rep_end_102
    mov rax, QWORD [rbp - 8]
    push rax
    pop rax
    mov rdi, rax
    call ppush
    mov rax, QWORD [cur_tok]
    push rax
    pop rax
    mov rdi, rax
    call ppush
    call p_next
    call parse_unary
    mov QWORD [rbp - 16], rax
    call ppop
    mov QWORD [rbp - 24], rax
    mov rax, QWORD [rbp - 24]
    push rax
    call ppop
    push rax
    mov rax, QWORD [rbp - 16]
    push rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call ast_binop
    mov QWORD [rbp - 8], rax
    jmp L_rep_start_102
L_rep_end_102:
    mov rax, QWORD [rbp - 8]
    leave
    ret
FRAME_70 equ 32
parse_unary:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_71
    mov rax, QWORD [cur_tok]
    push rax
    mov rax, 18
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_103
    call p_next
    mov rax, 18
    push rax
    call parse_unary
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call ast_unary
    leave
    ret
L_if_else_103:
L_if_end_103:
    mov rax, QWORD [cur_tok]
    push rax
    mov rax, 38
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_104
    call p_next
    mov rax, 38
    push rax
    call parse_unary
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call ast_unary
    leave
    ret
L_if_else_104:
L_if_end_104:
    call parse_primary
    leave
    ret
FRAME_71 equ 0
parse_call_args:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_72
    call ast_list_new
    push rax
    pop rax
    mov rdi, rax
    call ppush
    call p_next
L_rep_start_105:
    mov rax, QWORD [cur_tok]
    push rax
    mov rax, 10
    pop rbx
    cmp rbx, rax
    setne al
    movzx rax, al
    test rax, rax
    jz L_rep_end_105
    call parse_expr
    mov QWORD [rbp - 8], rax
    mov rax, QWORD [psp]
    push rax
    mov rax, 1
    pop rbx
    mov rcx, rax
    mov rax, rbx
    sub rax, rcx
    mov r11, rax
    mov rax, QWORD [pstk + r11 * 8]
    push rax
    mov rax, QWORD [rbp - 8]
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call ast_list_append
    mov rax, QWORD [cur_tok]
    push rax
    mov rax, 13
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_106
    call p_next
L_if_else_106:
L_if_end_106:
    jmp L_rep_start_105
L_rep_end_105:
    call p_next
    call ppop
    leave
    ret
FRAME_72 equ 16
parse_primary:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_73
    mov rax, 0
    mov QWORD [rbp - 8], rax
    mov rax, QWORD [cur_tok]
    push rax
    mov rax, 4
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_107
    mov rax, QWORD [cur_val]
    push rax
    pop rax
    mov rdi, rax
    call ast_num
    mov QWORD [rbp - 8], rax
    call p_next
    mov rax, QWORD [rbp - 8]
    leave
    ret
L_if_else_107:
L_if_end_107:
    mov rax, QWORD [cur_tok]
    push rax
    mov rax, 41
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_108
    mov rax, QWORD [cur_val]
    push rax
    pop rax
    mov rdi, rax
    call ast_char
    mov QWORD [rbp - 8], rax
    call p_next
    mov rax, QWORD [rbp - 8]
    leave
    ret
L_if_else_108:
L_if_end_108:
    mov rax, QWORD [cur_tok]
    push rax
    mov rax, 6
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_109
    mov rax, QWORD [cur_ptr]
    push rax
    mov rax, QWORD [cur_len]
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call ast_string
    mov QWORD [rbp - 8], rax
    call p_next
    mov rax, QWORD [rbp - 8]
    leave
    ret
L_if_else_109:
L_if_end_109:
    mov rax, QWORD [cur_tok]
    push rax
    mov rax, 0
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_110
    call ast_null
    mov QWORD [rbp - 8], rax
    call p_next
    mov rax, QWORD [rbp - 8]
    leave
    ret
L_if_else_110:
L_if_end_110:
    mov rax, QWORD [cur_tok]
    push rax
    mov rax, 9
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_111
    call p_next
    call parse_expr
    mov QWORD [rbp - 8], rax
    mov rax, 10
    push rax
    pop rax
    mov rdi, rax
    call p_expect
    call p_next
    mov rax, QWORD [rbp - 8]
    leave
    ret
L_if_else_111:
L_if_end_111:
    mov rax, QWORD [cur_tok]
    push rax
    mov rax, 3
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_112
    mov rax, QWORD [cur_ptr]
    push rax
    mov rax, QWORD [cur_len]
    push rax
section .rodata
str_24: db 116, 114, 117, 101, 0
section .text
    lea rax, [rel str_24]
    push rax
    mov rax, 4
    push rax
    pop rax
    mov rcx, rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call p_eq
    push rax
    mov rax, 1
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_113
    mov rax, 1
    push rax
    pop rax
    mov rdi, rax
    call ast_bool
    mov QWORD [rbp - 8], rax
    call p_next
    mov rax, QWORD [rbp - 8]
    leave
    ret
L_if_else_113:
L_if_end_113:
    mov rax, QWORD [cur_ptr]
    push rax
    mov rax, QWORD [cur_len]
    push rax
section .rodata
str_25: db 102, 97, 108, 115, 101, 0
section .text
    lea rax, [rel str_25]
    push rax
    mov rax, 5
    push rax
    pop rax
    mov rcx, rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call p_eq
    push rax
    mov rax, 1
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_114
    mov rax, 0
    push rax
    pop rax
    mov rdi, rax
    call ast_bool
    mov QWORD [rbp - 8], rax
    call p_next
    mov rax, QWORD [rbp - 8]
    leave
    ret
L_if_else_114:
L_if_end_114:
    mov rax, QWORD [cur_ptr]
    push rax
    pop rax
    mov rdi, rax
    call ppush
    mov rax, QWORD [cur_len]
    push rax
    pop rax
    mov rdi, rax
    call ppush
    call p_next
    mov rax, QWORD [cur_tok]
    push rax
    mov rax, 9
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_115
    call parse_call_args
    mov QWORD [rbp - 16], rax
    call ppop
    mov QWORD [rbp - 24], rax
    call ppop
    mov QWORD [rbp - 32], rax
    mov rax, QWORD [rbp - 32]
    push rax
    mov rax, QWORD [rbp - 24]
    push rax
    mov rax, QWORD [rbp - 16]
    push rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call ast_call
    leave
    ret
L_if_else_115:
L_if_end_115:
    mov rax, QWORD [cur_tok]
    push rax
    mov rax, 11
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_116
    call p_next
    call parse_expr
    mov QWORD [rbp - 40], rax
    mov rax, 12
    push rax
    pop rax
    mov rdi, rax
    call p_expect
    call p_next
    call ppop
    mov QWORD [rbp - 48], rax
    call ppop
    mov QWORD [rbp - 56], rax
    mov rax, QWORD [rbp - 56]
    push rax
    mov rax, QWORD [rbp - 48]
    push rax
    mov rax, QWORD [rbp - 40]
    push rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call ast_index
    leave
    ret
L_if_else_116:
L_if_end_116:
    call ppop
    mov QWORD [rbp - 64], rax
    call ppop
    mov QWORD [rbp - 72], rax
    mov rax, QWORD [rbp - 72]
    push rax
    mov rax, QWORD [rbp - 64]
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call ast_ident
    leave
    ret
L_if_else_112:
L_if_end_112:
section .rodata
str_26: db 101, 120, 112, 101, 99, 116, 101, 100, 32, 101, 120, 112, 114, 101, 115, 115, 105, 111, 110, 0
section .text
    lea rax, [rel str_26]
    push rax
    pop rax
    mov rdi, rax
    call p_error
    mov rax, 0
    leave
    ret
FRAME_73 equ 80
parse_block:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_74
    call p_skip_nl
    mov rax, 7
    push rax
    pop rax
    mov rdi, rax
    call p_expect
    call p_next
    call ast_list_new
    push rax
    pop rax
    mov rdi, rax
    call ppush
    call p_skip_nl
L_rep_start_117:
    mov rax, QWORD [cur_tok]
    push rax
    mov rax, 8
    pop rbx
    cmp rbx, rax
    setne al
    movzx rax, al
    test rax, rax
    jz L_rep_end_117
    mov rax, QWORD [cur_tok]
    push rax
    mov rax, 0
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_118
section .rodata
str_27: db 101, 120, 112, 101, 99, 116, 101, 100, 32, 125, 0
section .text
    lea rax, [rel str_27]
    push rax
    pop rax
    mov rdi, rax
    call p_error
L_if_else_118:
L_if_end_118:
    call parse_stmt
    mov QWORD [rbp - 8], rax
    mov rax, QWORD [psp]
    push rax
    mov rax, 1
    pop rbx
    mov rcx, rax
    mov rax, rbx
    sub rax, rcx
    mov r11, rax
    mov rax, QWORD [pstk + r11 * 8]
    push rax
    mov rax, QWORD [rbp - 8]
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call ast_list_append
    call p_skip_nl
    jmp L_rep_start_117
L_rep_end_117:
    call p_next
    call ppop
    leave
    ret
FRAME_74 equ 16
parse_stmt:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_75
    mov rax, QWORD [cur_tok]
    push rax
    pop rax
    mov rdi, rax
    call p_is_type
    push rax
    mov rax, 1
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_119
    mov rax, QWORD [cur_tok]
    push rax
    pop rax
    mov rdi, rax
    call ppush
    mov rax, 0
    push rax
    pop rax
    mov rdi, rax
    call ppush
    call p_next
    mov rax, QWORD [cur_tok]
    push rax
    mov rax, 18
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_120
    mov rax, QWORD [psp]
    push rax
    mov rax, 1
    pop rbx
    mov rcx, rax
    mov rax, rbx
    sub rax, rcx
    push rax
    mov rax, 1
    mov r12, rax
    pop r11
    mov QWORD [pstk + r11 * 8], r12
    call p_next
L_if_else_120:
L_if_end_120:
    mov rax, 3
    push rax
    pop rax
    mov rdi, rax
    call p_expect
    mov rax, QWORD [cur_ptr]
    push rax
    pop rax
    mov rdi, rax
    call ppush
    mov rax, QWORD [cur_len]
    push rax
    pop rax
    mov rdi, rax
    call ppush
    call p_next
    mov rax, QWORD [cur_tok]
    push rax
    mov rax, 11
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_121
    call p_next
    mov rax, 4
    push rax
    pop rax
    mov rdi, rax
    call p_expect
    mov rax, QWORD [cur_val]
    mov QWORD [rbp - 8], rax
    call p_next
    mov rax, 12
    push rax
    pop rax
    mov rdi, rax
    call p_expect
    call p_next
    call ppop
    mov QWORD [rbp - 16], rax
    call ppop
    mov QWORD [rbp - 24], rax
    call ppop
    call ppop
    mov QWORD [rbp - 32], rax
    mov rax, QWORD [rbp - 32]
    push rax
    mov rax, QWORD [rbp - 24]
    push rax
    mov rax, QWORD [rbp - 16]
    push rax
    mov rax, QWORD [rbp - 8]
    push rax
    pop rax
    mov rcx, rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call ast_arrdecl
    leave
    ret
L_if_else_121:
L_if_end_121:
    mov rax, 14
    push rax
    pop rax
    mov rdi, rax
    call p_expect
    call p_next
    call parse_expr
    mov QWORD [rbp - 40], rax
    call ppop
    mov QWORD [rbp - 48], rax
    call ppop
    mov QWORD [rbp - 56], rax
    call ppop
    mov QWORD [rbp - 64], rax
    call ppop
    mov QWORD [rbp - 72], rax
    mov rax, QWORD [rbp - 72]
    push rax
    mov rax, QWORD [rbp - 64]
    push rax
    mov rax, QWORD [rbp - 56]
    push rax
    mov rax, QWORD [rbp - 48]
    push rax
    mov rax, QWORD [rbp - 40]
    push rax
    pop rax
    mov r8, rax
    pop rax
    mov rcx, rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call ast_vardecl
    leave
    ret
L_if_else_119:
L_if_end_119:
    mov rax, QWORD [cur_tok]
    push rax
    mov rax, 25
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_122
    call p_next
    call parse_expr
    push rax
    pop rax
    mov rdi, rax
    call ppush
    call parse_block
    push rax
    pop rax
    mov rdi, rax
    call ppush
    call p_skip_nl
    mov rax, 0
    mov QWORD [rbp - 80], rax
    mov rax, QWORD [cur_tok]
    push rax
    mov rax, 26
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_123
    call p_next
    call parse_block
    mov QWORD [rbp - 80], rax
L_if_else_123:
L_if_end_123:
    call ppop
    mov QWORD [rbp - 88], rax
    call ppop
    mov QWORD [rbp - 96], rax
    mov rax, QWORD [rbp - 96]
    push rax
    mov rax, QWORD [rbp - 88]
    push rax
    mov rax, QWORD [rbp - 80]
    push rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call ast_if
    leave
    ret
L_if_else_122:
L_if_end_122:
    mov rax, QWORD [cur_tok]
    push rax
    mov rax, 27
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_124
    call p_next
    mov rax, QWORD [cur_tok]
    push rax
    mov rax, 4
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_125
    mov rax, QWORD [cur_val]
    push rax
    pop rax
    mov rdi, rax
    call ppush
    call p_next
    call parse_block
    mov QWORD [rbp - 104], rax
    call ppop
    mov QWORD [rbp - 112], rax
    mov rax, QWORD [rbp - 112]
    push rax
    mov rax, QWORD [rbp - 104]
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call ast_repcount
    leave
    ret
L_if_else_125:
L_if_end_125:
    call parse_expr
    push rax
    pop rax
    mov rdi, rax
    call ppush
    call parse_block
    mov QWORD [rbp - 120], rax
    call ppop
    mov QWORD [rbp - 128], rax
    mov rax, QWORD [rbp - 128]
    push rax
    mov rax, QWORD [rbp - 120]
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call ast_repcond
    leave
    ret
L_if_else_124:
L_if_end_124:
    mov rax, QWORD [cur_tok]
    push rax
    mov rax, 28
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_126
    call p_next
    mov rax, QWORD [cur_tok]
    push rax
    mov rax, 2
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    push rax
    mov rax, QWORD [cur_tok]
    push rax
    mov rax, 8
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    pop rbx
    or rax, rbx
    test rax, rax
    setne al
    movzx rax, al
    push rax
    mov rax, QWORD [cur_tok]
    push rax
    mov rax, 0
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    pop rbx
    or rax, rbx
    test rax, rax
    setne al
    movzx rax, al
    test rax, rax
    jz L_if_else_127
    mov rax, 0
    push rax
    pop rax
    mov rdi, rax
    call ast_return
    leave
    ret
L_if_else_127:
L_if_end_127:
    call parse_expr
    push rax
    pop rax
    mov rdi, rax
    call ast_return
    leave
    ret
L_if_else_126:
L_if_end_126:
    mov rax, QWORD [cur_tok]
    push rax
    mov rax, 3
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_128
    mov rax, QWORD [cur_ptr]
    push rax
    pop rax
    mov rdi, rax
    call ppush
    mov rax, QWORD [cur_len]
    push rax
    pop rax
    mov rdi, rax
    call ppush
    call p_next
    mov rax, QWORD [cur_tok]
    push rax
    mov rax, 14
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_129
    call p_next
    call parse_expr
    mov QWORD [rbp - 136], rax
    call ppop
    mov QWORD [rbp - 144], rax
    call ppop
    mov QWORD [rbp - 152], rax
    mov rax, QWORD [rbp - 152]
    push rax
    mov rax, QWORD [rbp - 144]
    push rax
    mov rax, QWORD [rbp - 136]
    push rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call ast_assign
    leave
    ret
L_if_else_129:
L_if_end_129:
    mov rax, QWORD [cur_tok]
    push rax
    mov rax, 9
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_130
    call parse_call_args
    mov QWORD [rbp - 160], rax
    call ppop
    mov QWORD [rbp - 168], rax
    call ppop
    mov QWORD [rbp - 176], rax
    mov rax, QWORD [rbp - 176]
    push rax
    mov rax, QWORD [rbp - 168]
    push rax
    mov rax, QWORD [rbp - 160]
    push rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call ast_call
    leave
    ret
L_if_else_130:
L_if_end_130:
    mov rax, QWORD [cur_tok]
    push rax
    mov rax, 11
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_131
    call p_next
    call parse_expr
    push rax
    pop rax
    mov rdi, rax
    call ppush
    mov rax, 12
    push rax
    pop rax
    mov rdi, rax
    call p_expect
    call p_next
    mov rax, 14
    push rax
    pop rax
    mov rdi, rax
    call p_expect
    call p_next
    call parse_expr
    mov QWORD [rbp - 184], rax
    call ppop
    mov QWORD [rbp - 192], rax
    call ppop
    mov QWORD [rbp - 200], rax
    call ppop
    mov QWORD [rbp - 208], rax
    mov rax, QWORD [rbp - 208]
    push rax
    mov rax, QWORD [rbp - 200]
    push rax
    mov rax, QWORD [rbp - 192]
    push rax
    mov rax, QWORD [rbp - 184]
    push rax
    pop rax
    mov rcx, rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call ast_arrassign
    leave
    ret
L_if_else_131:
L_if_end_131:
section .rodata
str_28: db 117, 110, 101, 120, 112, 101, 99, 116, 101, 100, 32, 116, 111, 107, 101, 110, 32, 97, 102, 116, 101, 114, 32, 105, 100, 101, 110, 116, 105, 102, 105, 101, 114, 0
section .text
    lea rax, [rel str_28]
    push rax
    pop rax
    mov rdi, rax
    call p_error
L_if_else_128:
L_if_end_128:
section .rodata
str_29: db 117, 110, 101, 120, 112, 101, 99, 116, 101, 100, 32, 115, 116, 97, 116, 101, 109, 101, 110, 116, 0
section .text
    lea rax, [rel str_29]
    push rax
    pop rax
    mov rdi, rax
    call p_error
    mov rax, 0
    leave
    ret
FRAME_75 equ 208
parse_params:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_76
    call ast_list_new
    push rax
    pop rax
    mov rdi, rax
    call ppush
    call p_next
L_rep_start_132:
    mov rax, QWORD [cur_tok]
    push rax
    mov rax, 10
    pop rbx
    cmp rbx, rax
    setne al
    movzx rax, al
    test rax, rax
    jz L_rep_end_132
    mov rax, 0
    push rax
    pop rax
    mov rdi, rax
    call ppush
    mov rax, QWORD [cur_tok]
    push rax
    mov rax, 18
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_133
    mov rax, QWORD [psp]
    push rax
    mov rax, 1
    pop rbx
    mov rcx, rax
    mov rax, rbx
    sub rax, rcx
    push rax
    mov rax, 1
    mov r12, rax
    pop r11
    mov QWORD [pstk + r11 * 8], r12
    call p_next
L_if_else_133:
L_if_end_133:
    mov rax, QWORD [cur_tok]
    push rax
    pop rax
    mov rdi, rax
    call p_is_type
    push rax
    mov rax, 1
    pop rbx
    cmp rbx, rax
    setne al
    movzx rax, al
    test rax, rax
    jz L_if_else_134
section .rodata
str_30: db 101, 120, 112, 101, 99, 116, 101, 100, 32, 112, 97, 114, 97, 109, 101, 116, 101, 114, 32, 116, 121, 112, 101, 0
section .text
    lea rax, [rel str_30]
    push rax
    pop rax
    mov rdi, rax
    call p_error
L_if_else_134:
L_if_end_134:
    mov rax, QWORD [cur_tok]
    push rax
    pop rax
    mov rdi, rax
    call ppush
    call p_next
    mov rax, QWORD [cur_tok]
    push rax
    mov rax, 18
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_135
    mov rax, QWORD [psp]
    push rax
    mov rax, 2
    pop rbx
    mov rcx, rax
    mov rax, rbx
    sub rax, rcx
    push rax
    mov rax, 1
    mov r12, rax
    pop r11
    mov QWORD [pstk + r11 * 8], r12
    call p_next
L_if_else_135:
L_if_end_135:
    mov rax, 3
    push rax
    pop rax
    mov rdi, rax
    call p_expect
    mov rax, QWORD [psp]
    push rax
    mov rax, 1
    pop rbx
    mov rcx, rax
    mov rax, rbx
    sub rax, rcx
    mov r11, rax
    mov rax, QWORD [pstk + r11 * 8]
    push rax
    mov rax, QWORD [psp]
    push rax
    mov rax, 2
    pop rbx
    mov rcx, rax
    mov rax, rbx
    sub rax, rcx
    mov r11, rax
    mov rax, QWORD [pstk + r11 * 8]
    push rax
    mov rax, QWORD [cur_ptr]
    push rax
    mov rax, QWORD [cur_len]
    push rax
    pop rax
    mov rcx, rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call ast_param
    mov QWORD [rbp - 8], rax
    call ppop
    call ppop
    mov rax, QWORD [psp]
    push rax
    mov rax, 1
    pop rbx
    mov rcx, rax
    mov rax, rbx
    sub rax, rcx
    mov r11, rax
    mov rax, QWORD [pstk + r11 * 8]
    push rax
    mov rax, QWORD [rbp - 8]
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call ast_list_append
    call p_next
    mov rax, QWORD [cur_tok]
    push rax
    mov rax, 13
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_136
    call p_next
L_if_else_136:
L_if_end_136:
    jmp L_rep_start_132
L_rep_end_132:
    call p_next
    call ppop
    leave
    ret
FRAME_76 equ 16
parse_function:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_77
    mov rax, QWORD [cur_ptr]
    push rax
    pop rax
    mov rdi, rax
    call ppush
    mov rax, QWORD [cur_len]
    push rax
    pop rax
    mov rdi, rax
    call ppush
    call p_next
    mov rax, 9
    push rax
    pop rax
    mov rdi, rax
    call p_expect
    call parse_params
    push rax
    pop rax
    mov rdi, rax
    call ppush
    call p_skip_nl
    mov rax, 0
    push rax
    pop rax
    mov rdi, rax
    call ppush
    mov rax, 0
    push rax
    pop rax
    mov rdi, rax
    call ppush
    mov rax, QWORD [cur_tok]
    push rax
    mov rax, 24
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_137
    call p_next
    mov rax, QWORD [cur_tok]
    push rax
    mov rax, 18
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_138
    mov rax, QWORD [psp]
    push rax
    mov rax, 1
    pop rbx
    mov rcx, rax
    mov rax, rbx
    sub rax, rcx
    push rax
    mov rax, 1
    mov r12, rax
    pop r11
    mov QWORD [pstk + r11 * 8], r12
    call p_next
L_if_else_138:
L_if_end_138:
    mov rax, QWORD [cur_tok]
    push rax
    pop rax
    mov rdi, rax
    call p_is_type
    push rax
    mov rax, 1
    pop rbx
    cmp rbx, rax
    setne al
    movzx rax, al
    test rax, rax
    jz L_if_else_139
section .rodata
str_31: db 101, 120, 112, 101, 99, 116, 101, 100, 32, 114, 101, 116, 117, 114, 110, 32, 116, 121, 112, 101, 0
section .text
    lea rax, [rel str_31]
    push rax
    pop rax
    mov rdi, rax
    call p_error
L_if_else_139:
L_if_end_139:
    mov rax, QWORD [psp]
    push rax
    mov rax, 2
    pop rbx
    mov rcx, rax
    mov rax, rbx
    sub rax, rcx
    push rax
    mov rax, QWORD [cur_tok]
    mov r12, rax
    pop r11
    mov QWORD [pstk + r11 * 8], r12
    call p_next
    mov rax, QWORD [cur_tok]
    push rax
    mov rax, 18
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_140
    mov rax, QWORD [psp]
    push rax
    mov rax, 1
    pop rbx
    mov rcx, rax
    mov rax, rbx
    sub rax, rcx
    push rax
    mov rax, 1
    mov r12, rax
    pop r11
    mov QWORD [pstk + r11 * 8], r12
    call p_next
L_if_else_140:
L_if_end_140:
L_if_else_137:
L_if_end_137:
    call parse_block
    mov QWORD [rbp - 8], rax
    call ppop
    mov QWORD [rbp - 16], rax
    call ppop
    mov QWORD [rbp - 24], rax
    call ppop
    mov QWORD [rbp - 32], rax
    call ppop
    mov QWORD [rbp - 40], rax
    call ppop
    mov QWORD [rbp - 48], rax
    mov rax, QWORD [rbp - 48]
    push rax
    mov rax, QWORD [rbp - 40]
    push rax
    mov rax, QWORD [rbp - 32]
    push rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, QWORD [rbp - 24]
    push rax
    mov rax, QWORD [rbp - 16]
    push rax
    pop rax
    mov r9, rax
    pop rax
    mov r8, rax
    pop rax
    mov rcx, rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call ast_func
    leave
    ret
FRAME_77 equ 48
parse_top_decl:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_78
    mov rax, QWORD [cur_tok]
    push rax
    pop rax
    mov rdi, rax
    call ppush
    mov rax, 0
    push rax
    pop rax
    mov rdi, rax
    call ppush
    call p_next
    mov rax, QWORD [cur_tok]
    push rax
    mov rax, 18
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_141
    mov rax, QWORD [psp]
    push rax
    mov rax, 1
    pop rbx
    mov rcx, rax
    mov rax, rbx
    sub rax, rcx
    push rax
    mov rax, 1
    mov r12, rax
    pop r11
    mov QWORD [pstk + r11 * 8], r12
    call p_next
L_if_else_141:
L_if_end_141:
    mov rax, 3
    push rax
    pop rax
    mov rdi, rax
    call p_expect
    mov rax, QWORD [cur_ptr]
    push rax
    pop rax
    mov rdi, rax
    call ppush
    mov rax, QWORD [cur_len]
    push rax
    pop rax
    mov rdi, rax
    call ppush
    call p_next
    mov rax, QWORD [cur_tok]
    push rax
    mov rax, 11
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_142
    call p_next
    mov rax, 4
    push rax
    pop rax
    mov rdi, rax
    call p_expect
    mov rax, QWORD [cur_val]
    mov QWORD [rbp - 8], rax
    call p_next
    mov rax, 12
    push rax
    pop rax
    mov rdi, rax
    call p_expect
    call p_next
    call ppop
    mov QWORD [rbp - 16], rax
    call ppop
    mov QWORD [rbp - 24], rax
    call ppop
    call ppop
    mov QWORD [rbp - 32], rax
    mov rax, QWORD [rbp - 32]
    push rax
    mov rax, QWORD [rbp - 24]
    push rax
    mov rax, QWORD [rbp - 16]
    push rax
    mov rax, QWORD [rbp - 8]
    push rax
    pop rax
    mov rcx, rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call ast_arrdecl
    leave
    ret
L_if_else_142:
L_if_end_142:
    mov rax, 14
    push rax
    pop rax
    mov rdi, rax
    call p_expect
    call p_next
    call parse_expr
    mov QWORD [rbp - 40], rax
    call ppop
    mov QWORD [rbp - 48], rax
    call ppop
    mov QWORD [rbp - 56], rax
    call ppop
    mov QWORD [rbp - 64], rax
    call ppop
    mov QWORD [rbp - 72], rax
    mov rax, QWORD [rbp - 56]
    push rax
    mov rax, QWORD [rbp - 48]
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call p_is_const_name
    push rax
    mov rax, 1
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_143
    mov rax, QWORD [rbp - 56]
    push rax
    mov rax, QWORD [rbp - 48]
    push rax
    mov rax, QWORD [rbp - 40]
    push rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call p_make_const
    leave
    ret
L_if_else_143:
L_if_end_143:
    mov rax, QWORD [rbp - 72]
    push rax
    mov rax, QWORD [rbp - 64]
    push rax
    mov rax, QWORD [rbp - 56]
    push rax
    mov rax, QWORD [rbp - 48]
    push rax
    pop rax
    mov rcx, rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call ast_globalvar
    leave
    ret
FRAME_78 equ 80
parse_program:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_79
    call p_next
    call ast_list_new
    push rax
    pop rax
    mov rdi, rax
    call ppush
    call p_skip_nl
L_rep_start_144:
    mov rax, QWORD [cur_tok]
    push rax
    mov rax, 0
    pop rbx
    cmp rbx, rax
    setne al
    movzx rax, al
    test rax, rax
    jz L_rep_end_144
    mov rax, 0
    mov QWORD [rbp - 8], rax
    mov rax, 0
    mov QWORD [rbp - 16], rax
    mov rax, QWORD [cur_tok]
    push rax
    mov rax, 42
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_145
    call p_next
    mov rax, 6
    push rax
    pop rax
    mov rdi, rax
    call p_expect
    mov rax, QWORD [cur_ptr]
    push rax
    mov rax, QWORD [cur_len]
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call lexer_use_file
    call p_next
    mov rax, 1
    mov QWORD [rbp - 8], rax
L_if_else_145:
L_if_end_145:
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 0
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    push rax
    mov rax, QWORD [cur_tok]
    push rax
    pop rax
    mov rdi, rax
    call p_is_type
    push rax
    mov rax, 1
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    pop rbx
    test rax, rax
    setne al
    test rbx, rbx
    setne bl
    and al, bl
    movzx rax, al
    test rax, rax
    jz L_if_else_146
    call parse_top_decl
    mov QWORD [rbp - 16], rax
    mov rax, QWORD [psp]
    push rax
    mov rax, 1
    pop rbx
    mov rcx, rax
    mov rax, rbx
    sub rax, rcx
    mov r11, rax
    mov rax, QWORD [pstk + r11 * 8]
    push rax
    mov rax, QWORD [rbp - 16]
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call ast_list_append
    mov rax, 1
    mov QWORD [rbp - 8], rax
L_if_else_146:
L_if_end_146:
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 0
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    push rax
    mov rax, QWORD [cur_tok]
    push rax
    mov rax, 3
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    pop rbx
    test rax, rax
    setne al
    test rbx, rbx
    setne bl
    and al, bl
    movzx rax, al
    test rax, rax
    jz L_if_else_147
    call parse_function
    mov QWORD [rbp - 16], rax
    mov rax, QWORD [psp]
    push rax
    mov rax, 1
    pop rbx
    mov rcx, rax
    mov rax, rbx
    sub rax, rcx
    mov r11, rax
    mov rax, QWORD [pstk + r11 * 8]
    push rax
    mov rax, QWORD [rbp - 16]
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call ast_list_append
    mov rax, 1
    mov QWORD [rbp - 8], rax
L_if_else_147:
L_if_end_147:
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 0
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_148
section .rodata
str_32: db 117, 110, 101, 120, 112, 101, 99, 116, 101, 100, 32, 116, 111, 107, 101, 110, 32, 97, 116, 32, 116, 111, 112, 32, 108, 101, 118, 101, 108, 0
section .text
    lea rax, [rel str_32]
    push rax
    pop rax
    mov rdi, rax
    call p_error
L_if_else_148:
L_if_end_148:
    call p_skip_nl
    jmp L_rep_start_144
L_rep_end_144:
    call ppop
    mov QWORD [rbp - 24], rax
    mov rax, QWORD [rbp - 24]
    push rax
    pop rax
    mov rdi, rax
    call ast_program
    leave
    ret
FRAME_79 equ 32
ln:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_80
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    mov rax, QWORD [rbp - 8]
    push rax
    pop rax
    mov rdi, rax
    call write_str
    call emit_nl
    leave
    ret
FRAME_80 equ 16
lab:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_81
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    mov rax, rsi
    mov QWORD [rbp - 16], rax
    mov rax, QWORD [rbp - 8]
    push rax
    pop rax
    mov rdi, rax
    call write_str
    mov rax, QWORD [rbp - 16]
    push rax
    pop rax
    mov rdi, rax
    call print_uint
    leave
    ret
FRAME_81 equ 16
labln:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_82
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    mov rax, rsi
    mov QWORD [rbp - 16], rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, QWORD [rbp - 16]
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call lab
    call emit_nl
    leave
    ret
FRAME_82 equ 16
labdef:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_83
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    mov rax, rsi
    mov QWORD [rbp - 16], rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, QWORD [rbp - 16]
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call lab
section .rodata
str_33: db 58, 0
section .text
    lea rax, [rel str_33]
    push rax
    pop rax
    mov rdi, rax
    call ln
    leave
    ret
FRAME_83 equ 16
str_eq:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_84
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    mov rax, rsi
    mov QWORD [rbp - 16], rax
    mov rax, rdx
    mov QWORD [rbp - 24], rax
    mov rax, rcx
    mov QWORD [rbp - 32], rax
    mov rax, QWORD [rbp - 16]
    push rax
    mov rax, QWORD [rbp - 32]
    pop rbx
    cmp rbx, rax
    setne al
    movzx rax, al
    test rax, rax
    jz L_if_else_149
    mov rax, 0
    leave
    ret
L_if_else_149:
L_if_end_149:
    mov rax, 0
    mov QWORD [rbp - 40], rax
L_rep_start_150:
    mov rax, QWORD [rbp - 40]
    push rax
    mov rax, QWORD [rbp - 16]
    pop rbx
    cmp rbx, rax
    setne al
    movzx rax, al
    test rax, rax
    jz L_rep_end_150
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, QWORD [rbp - 40]
    pop rbx
    add rax, rbx
    movzx rax, byte [rax]
    push rax
    mov rax, QWORD [rbp - 24]
    push rax
    mov rax, QWORD [rbp - 40]
    pop rbx
    add rax, rbx
    movzx rax, byte [rax]
    pop rbx
    cmp rbx, rax
    setne al
    movzx rax, al
    test rax, rax
    jz L_if_else_151
    mov rax, 0
    leave
    ret
L_if_else_151:
L_if_end_151:
    mov rax, QWORD [rbp - 40]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    mov QWORD [rbp - 40], rax
    jmp L_rep_start_150
L_rep_end_150:
    mov rax, 1
    leave
    ret
FRAME_84 equ 48
loc_find:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_85
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    mov rax, rsi
    mov QWORD [rbp - 16], rax
    mov rax, QWORD [loc_count]
    mov QWORD [rbp - 24], rax
L_rep_start_152:
    mov rax, QWORD [rbp - 24]
    push rax
    mov rax, 0
    pop rbx
    cmp rbx, rax
    setne al
    movzx rax, al
    test rax, rax
    jz L_rep_end_152
    mov rax, QWORD [rbp - 24]
    push rax
    mov rax, 1
    pop rbx
    mov rcx, rax
    mov rax, rbx
    sub rax, rcx
    mov QWORD [rbp - 24], rax
    mov rax, QWORD [rbp - 24]
    mov r11, rax
    mov rax, QWORD [loc_name_ptr + r11 * 8]
    push rax
    mov rax, QWORD [rbp - 24]
    mov r11, rax
    mov rax, QWORD [loc_name_len + r11 * 8]
    push rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, QWORD [rbp - 16]
    push rax
    pop rax
    mov rcx, rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call str_eq
    push rax
    mov rax, 1
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_153
    mov rax, QWORD [rbp - 24]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    leave
    ret
L_if_else_153:
L_if_end_153:
    jmp L_rep_start_152
L_rep_end_152:
    mov rax, 0
    leave
    ret
FRAME_85 equ 32
loc_add:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_86
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    mov rax, rsi
    mov QWORD [rbp - 16], rax
    mov rax, rdx
    mov QWORD [rbp - 24], rax
    mov rax, QWORD [cg_frame]
    push rax
    mov rax, QWORD [rbp - 24]
    push rax
    mov rax, 8
    pop rbx
    imul rax, rbx
    pop rbx
    add rax, rbx
    mov QWORD [cg_frame], rax
    mov rax, QWORD [loc_count]
    push rax
    mov rax, QWORD [rbp - 8]
    mov r12, rax
    pop r11
    mov QWORD [loc_name_ptr + r11 * 8], r12
    mov rax, QWORD [loc_count]
    push rax
    mov rax, QWORD [rbp - 16]
    mov r12, rax
    pop r11
    mov QWORD [loc_name_len + r11 * 8], r12
    mov rax, QWORD [loc_count]
    push rax
    mov rax, QWORD [cg_frame]
    mov r12, rax
    pop r11
    mov QWORD [loc_off + r11 * 8], r12
    mov rax, QWORD [loc_count]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    mov QWORD [loc_count], rax
    mov rax, QWORD [cg_frame]
    leave
    ret
FRAME_86 equ 32
con_find:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_87
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    mov rax, rsi
    mov QWORD [rbp - 16], rax
    mov rax, QWORD [con_count]
    mov QWORD [rbp - 24], rax
L_rep_start_154:
    mov rax, QWORD [rbp - 24]
    push rax
    mov rax, 0
    pop rbx
    cmp rbx, rax
    setne al
    movzx rax, al
    test rax, rax
    jz L_rep_end_154
    mov rax, QWORD [rbp - 24]
    push rax
    mov rax, 1
    pop rbx
    mov rcx, rax
    mov rax, rbx
    sub rax, rcx
    mov QWORD [rbp - 24], rax
    mov rax, QWORD [rbp - 24]
    mov r11, rax
    mov rax, QWORD [con_name_ptr + r11 * 8]
    push rax
    mov rax, QWORD [rbp - 24]
    mov r11, rax
    mov rax, QWORD [con_name_len + r11 * 8]
    push rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, QWORD [rbp - 16]
    push rax
    pop rax
    mov rcx, rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call str_eq
    push rax
    mov rax, 1
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_155
    mov rax, QWORD [rbp - 24]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    leave
    ret
L_if_else_155:
L_if_end_155:
    jmp L_rep_start_154
L_rep_end_154:
    mov rax, 0
    leave
    ret
FRAME_87 equ 32
con_add:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_88
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    mov rax, rsi
    mov QWORD [rbp - 16], rax
    mov rax, rdx
    mov QWORD [rbp - 24], rax
    mov rax, QWORD [con_count]
    push rax
    mov rax, QWORD [rbp - 8]
    mov r12, rax
    pop r11
    mov QWORD [con_name_ptr + r11 * 8], r12
    mov rax, QWORD [con_count]
    push rax
    mov rax, QWORD [rbp - 16]
    mov r12, rax
    pop r11
    mov QWORD [con_name_len + r11 * 8], r12
    mov rax, QWORD [con_count]
    push rax
    mov rax, QWORD [rbp - 24]
    mov r12, rax
    pop r11
    mov QWORD [con_value + r11 * 8], r12
    mov rax, QWORD [con_count]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    mov QWORD [con_count], rax
    mov rax, 0
    leave
    ret
FRAME_88 equ 32
const_eval:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_89
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    mov rax, QWORD [rbp - 8]
    mov r11, rax
    mov rax, QWORD [ast_kind + r11 * 8]
    mov QWORD [rbp - 16], rax
    mov rax, QWORD [rbp - 16]
    push rax
    mov rax, 1
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_156
    mov rax, QWORD [rbp - 8]
    mov r11, rax
    mov rax, QWORD [ast_a + r11 * 8]
    leave
    ret
L_if_else_156:
L_if_end_156:
    mov rax, QWORD [rbp - 16]
    push rax
    mov rax, 2
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_157
    mov rax, QWORD [rbp - 8]
    mov r11, rax
    mov rax, QWORD [ast_a + r11 * 8]
    leave
    ret
L_if_else_157:
L_if_end_157:
    mov rax, QWORD [rbp - 16]
    push rax
    mov rax, 4
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_158
    mov rax, QWORD [rbp - 8]
    mov r11, rax
    mov rax, QWORD [ast_name_ptr + r11 * 8]
    push rax
    mov rax, QWORD [rbp - 8]
    mov r11, rax
    mov rax, QWORD [ast_name_len + r11 * 8]
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call con_find
    mov QWORD [rbp - 24], rax
    mov rax, QWORD [rbp - 24]
    push rax
    mov rax, 0
    pop rbx
    cmp rbx, rax
    setne al
    movzx rax, al
    test rax, rax
    jz L_if_else_159
    mov rax, QWORD [rbp - 24]
    push rax
    mov rax, 1
    pop rbx
    mov rcx, rax
    mov rax, rbx
    sub rax, rcx
    mov r11, rax
    mov rax, QWORD [con_value + r11 * 8]
    leave
    ret
L_if_else_159:
L_if_end_159:
L_if_else_158:
L_if_end_158:
    mov rax, 0
    leave
    ret
FRAME_89 equ 32
emit_var:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_90
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    mov rax, rsi
    mov QWORD [rbp - 16], rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, QWORD [rbp - 16]
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call loc_find
    mov QWORD [rbp - 24], rax
    mov rax, QWORD [rbp - 24]
    push rax
    mov rax, 0
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_160
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, QWORD [rbp - 16]
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call write_bytes
    leave
    ret
L_if_else_160:
L_if_end_160:
section .rodata
str_34: db 114, 98, 112, 32, 45, 32, 0
section .text
    lea rax, [rel str_34]
    push rax
    pop rax
    mov rdi, rax
    call write_str
    mov rax, QWORD [rbp - 24]
    push rax
    mov rax, 1
    pop rbx
    mov rcx, rax
    mov rax, rbx
    sub rax, rcx
    mov r11, rax
    mov rax, QWORD [loc_off + r11 * 8]
    push rax
    pop rax
    mov rdi, rax
    call print_uint
    leave
    ret
FRAME_90 equ 32
argreg:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_91
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 0
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_161
section .rodata
str_35: db 114, 100, 105, 0
section .text
    lea rax, [rel str_35]
    push rax
    pop rax
    mov rdi, rax
    call write_str
    leave
    ret
L_if_else_161:
L_if_end_161:
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 1
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_162
section .rodata
str_36: db 114, 115, 105, 0
section .text
    lea rax, [rel str_36]
    push rax
    pop rax
    mov rdi, rax
    call write_str
    leave
    ret
L_if_else_162:
L_if_end_162:
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 2
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_163
section .rodata
str_37: db 114, 100, 120, 0
section .text
    lea rax, [rel str_37]
    push rax
    pop rax
    mov rdi, rax
    call write_str
    leave
    ret
L_if_else_163:
L_if_end_163:
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 3
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_164
section .rodata
str_38: db 114, 99, 120, 0
section .text
    lea rax, [rel str_38]
    push rax
    pop rax
    mov rdi, rax
    call write_str
    leave
    ret
L_if_else_164:
L_if_end_164:
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 4
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_165
section .rodata
str_39: db 114, 56, 0
section .text
    lea rax, [rel str_39]
    push rax
    pop rax
    mov rdi, rax
    call write_str
    leave
    ret
L_if_else_165:
L_if_end_165:
section .rodata
str_40: db 114, 57, 0
section .text
    lea rax, [rel str_40]
    push rax
    pop rax
    mov rdi, rax
    call write_str
    leave
    ret
FRAME_91 equ 16
gen_pop_args:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_92
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    mov rax, QWORD [rbp - 8]
    mov QWORD [rbp - 16], rax
L_rep_start_166:
    mov rax, QWORD [rbp - 16]
    push rax
    mov rax, 0
    pop rbx
    cmp rbx, rax
    setne al
    movzx rax, al
    test rax, rax
    jz L_rep_end_166
    mov rax, QWORD [rbp - 16]
    push rax
    mov rax, 1
    pop rbx
    mov rcx, rax
    mov rax, rbx
    sub rax, rcx
    mov QWORD [rbp - 16], rax
section .rodata
str_41: db 32, 32, 32, 32, 112, 111, 112, 32, 114, 97, 120, 0
section .text
    lea rax, [rel str_41]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_42: db 32, 32, 32, 32, 109, 111, 118, 32, 0
section .text
    lea rax, [rel str_42]
    push rax
    pop rax
    mov rdi, rax
    call write_str
    mov rax, QWORD [rbp - 16]
    push rax
    pop rax
    mov rdi, rax
    call argreg
section .rodata
str_43: db 44, 32, 114, 97, 120, 0
section .text
    lea rax, [rel str_43]
    push rax
    pop rax
    mov rdi, rax
    call ln
    jmp L_rep_start_166
L_rep_end_166:
    mov rax, 0
    leave
    ret
FRAME_92 equ 16
gen_cmp:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_93
    mov rax, rdi
    mov QWORD [rbp - 8], rax
section .rodata
str_44: db 32, 32, 32, 32, 112, 111, 112, 32, 114, 98, 120, 0
section .text
    lea rax, [rel str_44]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_45: db 32, 32, 32, 32, 99, 109, 112, 32, 114, 98, 120, 44, 32, 114, 97, 120, 0
section .text
    lea rax, [rel str_45]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_46: db 32, 32, 32, 32, 0
section .text
    lea rax, [rel str_46]
    push rax
    pop rax
    mov rdi, rax
    call write_str
    mov rax, QWORD [rbp - 8]
    push rax
    pop rax
    mov rdi, rax
    call write_str
section .rodata
str_47: db 32, 97, 108, 0
section .text
    lea rax, [rel str_47]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_48: db 32, 32, 32, 32, 109, 111, 118, 122, 120, 32, 114, 97, 120, 44, 32, 97, 108, 0
section .text
    lea rax, [rel str_48]
    push rax
    pop rax
    mov rdi, rax
    call ln
    leave
    ret
FRAME_93 equ 16
gen_binop_tail:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_94
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 16
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_167
section .rodata
str_49: db 32, 32, 32, 32, 112, 111, 112, 32, 114, 98, 120, 0
section .text
    lea rax, [rel str_49]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_50: db 32, 32, 32, 32, 97, 100, 100, 32, 114, 97, 120, 44, 32, 114, 98, 120, 0
section .text
    lea rax, [rel str_50]
    push rax
    pop rax
    mov rdi, rax
    call ln
    leave
    ret
L_if_else_167:
L_if_end_167:
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 17
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_168
section .rodata
str_51: db 32, 32, 32, 32, 112, 111, 112, 32, 114, 98, 120, 0
section .text
    lea rax, [rel str_51]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_52: db 32, 32, 32, 32, 109, 111, 118, 32, 114, 99, 120, 44, 32, 114, 97, 120, 0
section .text
    lea rax, [rel str_52]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_53: db 32, 32, 32, 32, 109, 111, 118, 32, 114, 97, 120, 44, 32, 114, 98, 120, 0
section .text
    lea rax, [rel str_53]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_54: db 32, 32, 32, 32, 115, 117, 98, 32, 114, 97, 120, 44, 32, 114, 99, 120, 0
section .text
    lea rax, [rel str_54]
    push rax
    pop rax
    mov rdi, rax
    call ln
    leave
    ret
L_if_else_168:
L_if_end_168:
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 18
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_169
section .rodata
str_55: db 32, 32, 32, 32, 112, 111, 112, 32, 114, 98, 120, 0
section .text
    lea rax, [rel str_55]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_56: db 32, 32, 32, 32, 105, 109, 117, 108, 32, 114, 97, 120, 44, 32, 114, 98, 120, 0
section .text
    lea rax, [rel str_56]
    push rax
    pop rax
    mov rdi, rax
    call ln
    leave
    ret
L_if_else_169:
L_if_end_169:
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 19
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_170
section .rodata
str_57: db 32, 32, 32, 32, 112, 111, 112, 32, 114, 98, 120, 0
section .text
    lea rax, [rel str_57]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_58: db 32, 32, 32, 32, 120, 99, 104, 103, 32, 114, 97, 120, 44, 32, 114, 98, 120, 0
section .text
    lea rax, [rel str_58]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_59: db 32, 32, 32, 32, 120, 111, 114, 32, 114, 100, 120, 44, 32, 114, 100, 120, 0
section .text
    lea rax, [rel str_59]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_60: db 32, 32, 32, 32, 100, 105, 118, 32, 114, 98, 120, 0
section .text
    lea rax, [rel str_60]
    push rax
    pop rax
    mov rdi, rax
    call ln
    leave
    ret
L_if_else_170:
L_if_end_170:
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 15
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_171
section .rodata
str_61: db 115, 101, 116, 101, 0
section .text
    lea rax, [rel str_61]
    push rax
    pop rax
    mov rdi, rax
    call gen_cmp
    leave
    ret
L_if_else_171:
L_if_end_171:
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 38
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_172
section .rodata
str_62: db 115, 101, 116, 110, 101, 0
section .text
    lea rax, [rel str_62]
    push rax
    pop rax
    mov rdi, rax
    call gen_cmp
    leave
    ret
L_if_else_172:
L_if_end_172:
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 20
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_173
section .rodata
str_63: db 115, 101, 116, 108, 0
section .text
    lea rax, [rel str_63]
    push rax
    pop rax
    mov rdi, rax
    call gen_cmp
    leave
    ret
L_if_else_173:
L_if_end_173:
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 21
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_174
section .rodata
str_64: db 115, 101, 116, 103, 0
section .text
    lea rax, [rel str_64]
    push rax
    pop rax
    mov rdi, rax
    call gen_cmp
    leave
    ret
L_if_else_174:
L_if_end_174:
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 22
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_175
section .rodata
str_65: db 115, 101, 116, 108, 101, 0
section .text
    lea rax, [rel str_65]
    push rax
    pop rax
    mov rdi, rax
    call gen_cmp
    leave
    ret
L_if_else_175:
L_if_end_175:
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 23
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_176
section .rodata
str_66: db 115, 101, 116, 103, 101, 0
section .text
    lea rax, [rel str_66]
    push rax
    pop rax
    mov rdi, rax
    call gen_cmp
    leave
    ret
L_if_else_176:
L_if_end_176:
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 39
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_177
section .rodata
str_67: db 32, 32, 32, 32, 112, 111, 112, 32, 114, 98, 120, 0
section .text
    lea rax, [rel str_67]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_68: db 32, 32, 32, 32, 116, 101, 115, 116, 32, 114, 97, 120, 44, 32, 114, 97, 120, 0
section .text
    lea rax, [rel str_68]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_69: db 32, 32, 32, 32, 115, 101, 116, 110, 101, 32, 97, 108, 0
section .text
    lea rax, [rel str_69]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_70: db 32, 32, 32, 32, 116, 101, 115, 116, 32, 114, 98, 120, 44, 32, 114, 98, 120, 0
section .text
    lea rax, [rel str_70]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_71: db 32, 32, 32, 32, 115, 101, 116, 110, 101, 32, 98, 108, 0
section .text
    lea rax, [rel str_71]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_72: db 32, 32, 32, 32, 97, 110, 100, 32, 97, 108, 44, 32, 98, 108, 0
section .text
    lea rax, [rel str_72]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_73: db 32, 32, 32, 32, 109, 111, 118, 122, 120, 32, 114, 97, 120, 44, 32, 97, 108, 0
section .text
    lea rax, [rel str_73]
    push rax
    pop rax
    mov rdi, rax
    call ln
    leave
    ret
L_if_else_177:
L_if_end_177:
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 40
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_178
section .rodata
str_74: db 32, 32, 32, 32, 112, 111, 112, 32, 114, 98, 120, 0
section .text
    lea rax, [rel str_74]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_75: db 32, 32, 32, 32, 111, 114, 32, 114, 97, 120, 44, 32, 114, 98, 120, 0
section .text
    lea rax, [rel str_75]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_76: db 32, 32, 32, 32, 116, 101, 115, 116, 32, 114, 97, 120, 44, 32, 114, 97, 120, 0
section .text
    lea rax, [rel str_76]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_77: db 32, 32, 32, 32, 115, 101, 116, 110, 101, 32, 97, 108, 0
section .text
    lea rax, [rel str_77]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_78: db 32, 32, 32, 32, 109, 111, 118, 122, 120, 32, 114, 97, 120, 44, 32, 97, 108, 0
section .text
    lea rax, [rel str_78]
    push rax
    pop rax
    mov rdi, rax
    call ln
    leave
    ret
L_if_else_178:
L_if_end_178:
    mov rax, 0
    leave
    ret
FRAME_94 equ 16
gen_string:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_95
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    mov rax, QWORD [cg_str]
    mov QWORD [rbp - 16], rax
    mov rax, QWORD [cg_str]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    mov QWORD [cg_str], rax
section .rodata
str_79: db 115, 101, 99, 116, 105, 111, 110, 32, 46, 114, 111, 100, 97, 116, 97, 0
section .text
    lea rax, [rel str_79]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_80: db 115, 116, 114, 95, 0
section .text
    lea rax, [rel str_80]
    push rax
    mov rax, QWORD [rbp - 16]
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call lab
section .rodata
str_81: db 58, 32, 100, 98, 32, 0
section .text
    lea rax, [rel str_81]
    push rax
    pop rax
    mov rdi, rax
    call write_str
    mov rax, QWORD [rbp - 8]
    mov r11, rax
    mov rax, QWORD [ast_name_ptr + r11 * 8]
    mov QWORD [rbp - 24], rax
    mov rax, QWORD [rbp - 8]
    mov r11, rax
    mov rax, QWORD [ast_name_len + r11 * 8]
    mov QWORD [rbp - 32], rax
    mov rax, 0
    mov QWORD [rbp - 40], rax
L_rep_start_179:
    mov rax, QWORD [rbp - 40]
    push rax
    mov rax, QWORD [rbp - 32]
    pop rbx
    cmp rbx, rax
    setl al
    movzx rax, al
    test rax, rax
    jz L_rep_end_179
    mov rax, QWORD [rbp - 24]
    push rax
    mov rax, QWORD [rbp - 40]
    pop rbx
    add rax, rbx
    movzx rax, byte [rax]
    mov QWORD [rbp - 48], rax
    mov rax, QWORD [rbp - 48]
    push rax
    mov rax, 92
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_180
    mov rax, QWORD [rbp - 40]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    mov QWORD [rbp - 40], rax
    mov rax, QWORD [rbp - 24]
    push rax
    mov rax, QWORD [rbp - 40]
    pop rbx
    add rax, rbx
    movzx rax, byte [rax]
    mov QWORD [rbp - 56], rax
    mov rax, QWORD [rbp - 56]
    mov QWORD [rbp - 48], rax
    mov rax, QWORD [rbp - 56]
    push rax
    mov rax, 110
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_181
    mov rax, 10
    mov QWORD [rbp - 48], rax
L_if_else_181:
L_if_end_181:
    mov rax, QWORD [rbp - 56]
    push rax
    mov rax, 116
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_182
    mov rax, 9
    mov QWORD [rbp - 48], rax
L_if_else_182:
L_if_end_182:
    mov rax, QWORD [rbp - 56]
    push rax
    mov rax, 114
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_183
    mov rax, 13
    mov QWORD [rbp - 48], rax
L_if_else_183:
L_if_end_183:
    mov rax, QWORD [rbp - 56]
    push rax
    mov rax, 48
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_184
    mov rax, 0
    mov QWORD [rbp - 48], rax
L_if_else_184:
L_if_end_184:
L_if_else_180:
L_if_end_180:
    mov rax, QWORD [rbp - 48]
    push rax
    pop rax
    mov rdi, rax
    call print_uint
section .rodata
str_82: db 44, 32, 0
section .text
    lea rax, [rel str_82]
    push rax
    pop rax
    mov rdi, rax
    call write_str
    mov rax, QWORD [rbp - 40]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    mov QWORD [rbp - 40], rax
    jmp L_rep_start_179
L_rep_end_179:
section .rodata
str_83: db 48, 0
section .text
    lea rax, [rel str_83]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_84: db 115, 101, 99, 116, 105, 111, 110, 32, 46, 116, 101, 120, 116, 0
section .text
    lea rax, [rel str_84]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_85: db 32, 32, 32, 32, 108, 101, 97, 32, 114, 97, 120, 44, 32, 91, 114, 101, 108, 32, 115, 116, 114, 95, 0
section .text
    lea rax, [rel str_85]
    push rax
    mov rax, QWORD [rbp - 16]
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call lab
section .rodata
str_86: db 93, 0
section .text
    lea rax, [rel str_86]
    push rax
    pop rax
    mov rdi, rax
    call ln
    leave
    ret
FRAME_95 equ 64
gen_print:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_96
    mov rax, QWORD [cg_label]
    mov QWORD [rbp - 8], rax
    mov rax, QWORD [cg_label]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    mov QWORD [cg_label], rax
section .rodata
str_87: db 32, 32, 32, 32, 115, 117, 98, 32, 114, 115, 112, 44, 32, 51, 50, 0
section .text
    lea rax, [rel str_87]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_88: db 32, 32, 32, 32, 109, 111, 118, 32, 114, 56, 44, 32, 114, 115, 112, 0
section .text
    lea rax, [rel str_88]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_89: db 32, 32, 32, 32, 97, 100, 100, 32, 114, 56, 44, 32, 51, 49, 0
section .text
    lea rax, [rel str_89]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_90: db 32, 32, 32, 32, 109, 111, 118, 32, 98, 121, 116, 101, 32, 91, 114, 56, 93, 44, 32, 49, 48, 0
section .text
    lea rax, [rel str_90]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_91: db 32, 32, 32, 32, 109, 111, 118, 32, 114, 57, 44, 32, 114, 56, 0
section .text
    lea rax, [rel str_91]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_92: db 32, 32, 32, 32, 116, 101, 115, 116, 32, 114, 97, 120, 44, 32, 114, 97, 120, 0
section .text
    lea rax, [rel str_92]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_93: db 32, 32, 32, 32, 106, 110, 122, 32, 76, 95, 112, 114, 95, 99, 95, 0
section .text
    lea rax, [rel str_93]
    push rax
    mov rax, QWORD [rbp - 8]
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call labln
section .rodata
str_94: db 32, 32, 32, 32, 100, 101, 99, 32, 114, 56, 0
section .text
    lea rax, [rel str_94]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_95: db 32, 32, 32, 32, 109, 111, 118, 32, 98, 121, 116, 101, 32, 91, 114, 56, 93, 44, 32, 39, 48, 39, 0
section .text
    lea rax, [rel str_95]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_96: db 32, 32, 32, 32, 106, 109, 112, 32, 76, 95, 112, 114, 95, 111, 95, 0
section .text
    lea rax, [rel str_96]
    push rax
    mov rax, QWORD [rbp - 8]
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call labln
section .rodata
str_97: db 76, 95, 112, 114, 95, 99, 95, 0
section .text
    lea rax, [rel str_97]
    push rax
    mov rax, QWORD [rbp - 8]
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call labdef
section .rodata
str_98: db 32, 32, 32, 32, 109, 111, 118, 32, 114, 49, 48, 44, 32, 49, 48, 0
section .text
    lea rax, [rel str_98]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_99: db 76, 95, 112, 114, 95, 108, 95, 0
section .text
    lea rax, [rel str_99]
    push rax
    mov rax, QWORD [rbp - 8]
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call labdef
section .rodata
str_100: db 32, 32, 32, 32, 116, 101, 115, 116, 32, 114, 97, 120, 44, 32, 114, 97, 120, 0
section .text
    lea rax, [rel str_100]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_101: db 32, 32, 32, 32, 106, 122, 32, 76, 95, 112, 114, 95, 111, 95, 0
section .text
    lea rax, [rel str_101]
    push rax
    mov rax, QWORD [rbp - 8]
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call labln
section .rodata
str_102: db 32, 32, 32, 32, 120, 111, 114, 32, 114, 100, 120, 44, 32, 114, 100, 120, 0
section .text
    lea rax, [rel str_102]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_103: db 32, 32, 32, 32, 100, 105, 118, 32, 114, 49, 48, 0
section .text
    lea rax, [rel str_103]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_104: db 32, 32, 32, 32, 97, 100, 100, 32, 100, 108, 44, 32, 39, 48, 39, 0
section .text
    lea rax, [rel str_104]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_105: db 32, 32, 32, 32, 100, 101, 99, 32, 114, 56, 0
section .text
    lea rax, [rel str_105]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_106: db 32, 32, 32, 32, 109, 111, 118, 32, 91, 114, 56, 93, 44, 32, 100, 108, 0
section .text
    lea rax, [rel str_106]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_107: db 32, 32, 32, 32, 106, 109, 112, 32, 76, 95, 112, 114, 95, 108, 95, 0
section .text
    lea rax, [rel str_107]
    push rax
    mov rax, QWORD [rbp - 8]
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call labln
section .rodata
str_108: db 76, 95, 112, 114, 95, 111, 95, 0
section .text
    lea rax, [rel str_108]
    push rax
    mov rax, QWORD [rbp - 8]
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call labdef
section .rodata
str_109: db 32, 32, 32, 32, 109, 111, 118, 32, 101, 97, 120, 44, 32, 49, 0
section .text
    lea rax, [rel str_109]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_110: db 32, 32, 32, 32, 109, 111, 118, 32, 101, 100, 105, 44, 32, 49, 0
section .text
    lea rax, [rel str_110]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_111: db 32, 32, 32, 32, 109, 111, 118, 32, 114, 115, 105, 44, 32, 114, 56, 0
section .text
    lea rax, [rel str_111]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_112: db 32, 32, 32, 32, 109, 111, 118, 32, 114, 100, 120, 44, 32, 114, 57, 0
section .text
    lea rax, [rel str_112]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_113: db 32, 32, 32, 32, 105, 110, 99, 32, 114, 100, 120, 0
section .text
    lea rax, [rel str_113]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_114: db 32, 32, 32, 32, 115, 117, 98, 32, 114, 100, 120, 44, 32, 114, 56, 0
section .text
    lea rax, [rel str_114]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_115: db 32, 32, 32, 32, 115, 121, 115, 99, 97, 108, 108, 0
section .text
    lea rax, [rel str_115]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_116: db 32, 32, 32, 32, 97, 100, 100, 32, 114, 115, 112, 44, 32, 51, 50, 0
section .text
    lea rax, [rel str_116]
    push rax
    pop rax
    mov rdi, rax
    call ln
    leave
    ret
FRAME_96 equ 16
gen_call:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_97
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    mov rax, QWORD [rbp - 8]
    mov r11, rax
    mov rax, QWORD [ast_name_ptr + r11 * 8]
    push rax
    mov rax, QWORD [rbp - 8]
    mov r11, rax
    mov rax, QWORD [ast_name_len + r11 * 8]
    push rax
section .rodata
str_117: db 112, 114, 105, 110, 116, 0
section .text
    lea rax, [rel str_117]
    push rax
    mov rax, 5
    push rax
    pop rax
    mov rcx, rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call str_eq
    push rax
    mov rax, 1
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_185
    mov rax, QWORD [rbp - 8]
    mov r11, rax
    mov rax, QWORD [ast_a + r11 * 8]
    push rax
    pop rax
    mov rdi, rax
    call ast_list_first
    mov QWORD [rbp - 16], rax
    mov rax, QWORD [rbp - 16]
    push rax
    mov rax, 0
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_186
section .rodata
str_118: db 32, 32, 32, 32, 109, 111, 118, 32, 114, 97, 120, 44, 32, 48, 0
section .text
    lea rax, [rel str_118]
    push rax
    pop rax
    mov rdi, rax
    call ln
L_if_else_186:
L_if_end_186:
    mov rax, QWORD [rbp - 16]
    push rax
    mov rax, 0
    pop rbx
    cmp rbx, rax
    setne al
    movzx rax, al
    test rax, rax
    jz L_if_else_187
    mov rax, QWORD [rbp - 16]
    push rax
    pop rax
    mov rdi, rax
    call gen_expr
L_if_else_187:
L_if_end_187:
    call gen_print
    leave
    ret
L_if_else_185:
L_if_end_185:
    mov rax, QWORD [rbp - 8]
    mov r11, rax
    mov rax, QWORD [ast_a + r11 * 8]
    push rax
    pop rax
    mov rdi, rax
    call ast_list_first
    mov QWORD [rbp - 24], rax
    mov rax, 0
    mov QWORD [rbp - 32], rax
L_rep_start_188:
    mov rax, QWORD [rbp - 24]
    push rax
    mov rax, 0
    pop rbx
    cmp rbx, rax
    setne al
    movzx rax, al
    test rax, rax
    jz L_rep_end_188
    mov rax, QWORD [rbp - 24]
    push rax
    pop rax
    mov rdi, rax
    call gen_expr
section .rodata
str_119: db 32, 32, 32, 32, 112, 117, 115, 104, 32, 114, 97, 120, 0
section .text
    lea rax, [rel str_119]
    push rax
    pop rax
    mov rdi, rax
    call ln
    mov rax, QWORD [rbp - 32]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    mov QWORD [rbp - 32], rax
    mov rax, QWORD [rbp - 24]
    mov r11, rax
    mov rax, QWORD [ast_next + r11 * 8]
    mov QWORD [rbp - 24], rax
    jmp L_rep_start_188
L_rep_end_188:
    mov rax, QWORD [rbp - 32]
    push rax
    pop rax
    mov rdi, rax
    call gen_pop_args
section .rodata
str_120: db 32, 32, 32, 32, 99, 97, 108, 108, 32, 0
section .text
    lea rax, [rel str_120]
    push rax
    pop rax
    mov rdi, rax
    call write_str
    mov rax, QWORD [rbp - 8]
    mov r11, rax
    mov rax, QWORD [ast_name_ptr + r11 * 8]
    push rax
    mov rax, QWORD [rbp - 8]
    mov r11, rax
    mov rax, QWORD [ast_name_len + r11 * 8]
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call write_bytes
    call emit_nl
    leave
    ret
FRAME_97 equ 32
gen_expr:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_98
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    mov rax, QWORD [rbp - 8]
    mov r11, rax
    mov rax, QWORD [ast_kind + r11 * 8]
    mov QWORD [rbp - 16], rax
    mov rax, QWORD [rbp - 16]
    push rax
    mov rax, 1
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    push rax
    mov rax, QWORD [rbp - 16]
    push rax
    mov rax, 2
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    pop rbx
    or rax, rbx
    test rax, rax
    setne al
    movzx rax, al
    push rax
    mov rax, QWORD [rbp - 16]
    push rax
    mov rax, 5
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    pop rbx
    or rax, rbx
    test rax, rax
    setne al
    movzx rax, al
    test rax, rax
    jz L_if_else_189
section .rodata
str_121: db 32, 32, 32, 32, 109, 111, 118, 32, 114, 97, 120, 44, 32, 0
section .text
    lea rax, [rel str_121]
    push rax
    pop rax
    mov rdi, rax
    call write_str
    mov rax, QWORD [rbp - 8]
    mov r11, rax
    mov rax, QWORD [ast_a + r11 * 8]
    push rax
    pop rax
    mov rdi, rax
    call print_uint
    call emit_nl
    leave
    ret
L_if_else_189:
L_if_end_189:
    mov rax, QWORD [rbp - 16]
    push rax
    mov rax, 6
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_190
section .rodata
str_122: db 32, 32, 32, 32, 109, 111, 118, 32, 114, 97, 120, 44, 32, 48, 0
section .text
    lea rax, [rel str_122]
    push rax
    pop rax
    mov rdi, rax
    call ln
    leave
    ret
L_if_else_190:
L_if_end_190:
    mov rax, QWORD [rbp - 16]
    push rax
    mov rax, 3
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_191
    mov rax, QWORD [rbp - 8]
    push rax
    pop rax
    mov rdi, rax
    call gen_string
    leave
    ret
L_if_else_191:
L_if_end_191:
    mov rax, QWORD [rbp - 16]
    push rax
    mov rax, 4
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_192
    mov rax, QWORD [rbp - 8]
    mov r11, rax
    mov rax, QWORD [ast_name_ptr + r11 * 8]
    push rax
    mov rax, QWORD [rbp - 8]
    mov r11, rax
    mov rax, QWORD [ast_name_len + r11 * 8]
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call loc_find
    mov QWORD [rbp - 24], rax
    mov rax, QWORD [rbp - 8]
    mov r11, rax
    mov rax, QWORD [ast_name_ptr + r11 * 8]
    push rax
    mov rax, QWORD [rbp - 8]
    mov r11, rax
    mov rax, QWORD [ast_name_len + r11 * 8]
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call con_find
    mov QWORD [rbp - 32], rax
    mov rax, QWORD [rbp - 24]
    push rax
    mov rax, 0
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    push rax
    mov rax, QWORD [rbp - 32]
    push rax
    mov rax, 0
    pop rbx
    cmp rbx, rax
    setne al
    movzx rax, al
    pop rbx
    test rax, rax
    setne al
    test rbx, rbx
    setne bl
    and al, bl
    movzx rax, al
    test rax, rax
    jz L_if_else_193
section .rodata
str_123: db 32, 32, 32, 32, 109, 111, 118, 32, 114, 97, 120, 44, 32, 0
section .text
    lea rax, [rel str_123]
    push rax
    pop rax
    mov rdi, rax
    call write_str
    mov rax, QWORD [rbp - 32]
    push rax
    mov rax, 1
    pop rbx
    mov rcx, rax
    mov rax, rbx
    sub rax, rcx
    mov r11, rax
    mov rax, QWORD [con_value + r11 * 8]
    push rax
    pop rax
    mov rdi, rax
    call print_uint
    call emit_nl
    leave
    ret
L_if_else_193:
L_if_end_193:
section .rodata
str_124: db 32, 32, 32, 32, 109, 111, 118, 32, 114, 97, 120, 44, 32, 81, 87, 79, 82, 68, 32, 91, 0
section .text
    lea rax, [rel str_124]
    push rax
    pop rax
    mov rdi, rax
    call write_str
    mov rax, QWORD [rbp - 8]
    mov r11, rax
    mov rax, QWORD [ast_name_ptr + r11 * 8]
    push rax
    mov rax, QWORD [rbp - 8]
    mov r11, rax
    mov rax, QWORD [ast_name_len + r11 * 8]
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call emit_var
section .rodata
str_125: db 93, 0
section .text
    lea rax, [rel str_125]
    push rax
    pop rax
    mov rdi, rax
    call ln
    leave
    ret
L_if_else_192:
L_if_end_192:
    mov rax, QWORD [rbp - 16]
    push rax
    mov rax, 10
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_194
    mov rax, QWORD [rbp - 8]
    mov r11, rax
    mov rax, QWORD [ast_a + r11 * 8]
    push rax
    pop rax
    mov rdi, rax
    call gen_expr
section .rodata
str_126: db 32, 32, 32, 32, 109, 111, 118, 32, 114, 49, 49, 44, 32, 114, 97, 120, 0
section .text
    lea rax, [rel str_126]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_127: db 32, 32, 32, 32, 109, 111, 118, 32, 114, 97, 120, 44, 32, 81, 87, 79, 82, 68, 32, 91, 0
section .text
    lea rax, [rel str_127]
    push rax
    pop rax
    mov rdi, rax
    call write_str
    mov rax, QWORD [rbp - 8]
    mov r11, rax
    mov rax, QWORD [ast_name_ptr + r11 * 8]
    push rax
    mov rax, QWORD [rbp - 8]
    mov r11, rax
    mov rax, QWORD [ast_name_len + r11 * 8]
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call emit_var
section .rodata
str_128: db 32, 43, 32, 114, 49, 49, 32, 42, 32, 56, 93, 0
section .text
    lea rax, [rel str_128]
    push rax
    pop rax
    mov rdi, rax
    call ln
    leave
    ret
L_if_else_194:
L_if_end_194:
    mov rax, QWORD [rbp - 16]
    push rax
    mov rax, 8
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_195
    mov rax, QWORD [rbp - 8]
    mov r11, rax
    mov rax, QWORD [ast_c + r11 * 8]
    push rax
    mov rax, 18
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_196
    mov rax, QWORD [rbp - 8]
    mov r11, rax
    mov rax, QWORD [ast_a + r11 * 8]
    push rax
    pop rax
    mov rdi, rax
    call gen_expr
section .rodata
str_129: db 32, 32, 32, 32, 109, 111, 118, 122, 120, 32, 114, 97, 120, 44, 32, 98, 121, 116, 101, 32, 91, 114, 97, 120, 93, 0
section .text
    lea rax, [rel str_129]
    push rax
    pop rax
    mov rdi, rax
    call ln
    leave
    ret
L_if_else_196:
L_if_end_196:
    mov rax, QWORD [rbp - 8]
    mov r11, rax
    mov rax, QWORD [ast_a + r11 * 8]
    mov QWORD [rbp - 40], rax
section .rodata
str_130: db 32, 32, 32, 32, 108, 101, 97, 32, 114, 97, 120, 44, 32, 91, 0
section .text
    lea rax, [rel str_130]
    push rax
    pop rax
    mov rdi, rax
    call write_str
    mov rax, QWORD [rbp - 40]
    mov r11, rax
    mov rax, QWORD [ast_name_ptr + r11 * 8]
    push rax
    mov rax, QWORD [rbp - 40]
    mov r11, rax
    mov rax, QWORD [ast_name_len + r11 * 8]
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call emit_var
section .rodata
str_131: db 93, 0
section .text
    lea rax, [rel str_131]
    push rax
    pop rax
    mov rdi, rax
    call ln
    leave
    ret
L_if_else_195:
L_if_end_195:
    mov rax, QWORD [rbp - 16]
    push rax
    mov rax, 7
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_197
    mov rax, QWORD [rbp - 8]
    mov r11, rax
    mov rax, QWORD [ast_a + r11 * 8]
    push rax
    pop rax
    mov rdi, rax
    call gen_expr
section .rodata
str_132: db 32, 32, 32, 32, 112, 117, 115, 104, 32, 114, 97, 120, 0
section .text
    lea rax, [rel str_132]
    push rax
    pop rax
    mov rdi, rax
    call ln
    mov rax, QWORD [rbp - 8]
    mov r11, rax
    mov rax, QWORD [ast_b + r11 * 8]
    push rax
    pop rax
    mov rdi, rax
    call gen_expr
    mov rax, QWORD [rbp - 8]
    mov r11, rax
    mov rax, QWORD [ast_c + r11 * 8]
    push rax
    pop rax
    mov rdi, rax
    call gen_binop_tail
    leave
    ret
L_if_else_197:
L_if_end_197:
    mov rax, QWORD [rbp - 16]
    push rax
    mov rax, 9
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_198
    mov rax, QWORD [rbp - 8]
    push rax
    pop rax
    mov rdi, rax
    call gen_call
    leave
    ret
L_if_else_198:
L_if_end_198:
    mov rax, 0
    leave
    ret
FRAME_98 equ 48
gen_truncate:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_99
    mov rax, QWORD [cg_ret_ptr]
    push rax
    mov rax, 1
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_199
    mov rax, 0
    leave
    ret
L_if_else_199:
L_if_end_199:
    mov rax, QWORD [cg_ret_type]
    mov QWORD [rbp - 8], rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 29
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_200
section .rodata
str_133: db 32, 32, 32, 32, 109, 111, 118, 115, 120, 32, 114, 97, 120, 44, 32, 97, 108, 0
section .text
    lea rax, [rel str_133]
    push rax
    pop rax
    mov rdi, rax
    call ln
L_if_else_200:
L_if_end_200:
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 30
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    push rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 5
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    pop rbx
    or rax, rbx
    test rax, rax
    setne al
    movzx rax, al
    push rax
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 37
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    pop rbx
    or rax, rbx
    test rax, rax
    setne al
    movzx rax, al
    test rax, rax
    jz L_if_else_201
section .rodata
str_134: db 32, 32, 32, 32, 109, 111, 118, 122, 120, 32, 114, 97, 120, 44, 32, 97, 108, 0
section .text
    lea rax, [rel str_134]
    push rax
    pop rax
    mov rdi, rax
    call ln
L_if_else_201:
L_if_end_201:
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 31
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_202
section .rodata
str_135: db 32, 32, 32, 32, 109, 111, 118, 115, 120, 32, 114, 97, 120, 44, 32, 97, 120, 0
section .text
    lea rax, [rel str_135]
    push rax
    pop rax
    mov rdi, rax
    call ln
L_if_else_202:
L_if_end_202:
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 32
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_203
section .rodata
str_136: db 32, 32, 32, 32, 109, 111, 118, 122, 120, 32, 114, 97, 120, 44, 32, 97, 120, 0
section .text
    lea rax, [rel str_136]
    push rax
    pop rax
    mov rdi, rax
    call ln
L_if_else_203:
L_if_end_203:
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 33
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_204
section .rodata
str_137: db 32, 32, 32, 32, 99, 100, 113, 101, 0
section .text
    lea rax, [rel str_137]
    push rax
    pop rax
    mov rdi, rax
    call ln
L_if_else_204:
L_if_end_204:
    mov rax, QWORD [rbp - 8]
    push rax
    mov rax, 34
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_205
section .rodata
str_138: db 32, 32, 32, 32, 109, 111, 118, 32, 101, 97, 120, 44, 32, 101, 97, 120, 0
section .text
    lea rax, [rel str_138]
    push rax
    pop rax
    mov rdi, rax
    call ln
L_if_else_205:
L_if_end_205:
    mov rax, 0
    leave
    ret
FRAME_99 equ 16
gen_stmt:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_100
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    mov rax, QWORD [rbp - 8]
    mov r11, rax
    mov rax, QWORD [ast_kind + r11 * 8]
    mov QWORD [rbp - 16], rax
    mov rax, QWORD [rbp - 16]
    push rax
    mov rax, 13
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_206
    mov rax, QWORD [rbp - 8]
    mov r11, rax
    mov rax, QWORD [ast_name_ptr + r11 * 8]
    push rax
    mov rax, QWORD [rbp - 8]
    mov r11, rax
    mov rax, QWORD [ast_name_len + r11 * 8]
    push rax
    mov rax, 1
    push rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call loc_add
    mov QWORD [rbp - 24], rax
    mov rax, QWORD [rbp - 8]
    mov r11, rax
    mov rax, QWORD [ast_b + r11 * 8]
    push rax
    pop rax
    mov rdi, rax
    call gen_expr
section .rodata
str_139: db 32, 32, 32, 32, 109, 111, 118, 32, 81, 87, 79, 82, 68, 32, 91, 114, 98, 112, 32, 45, 32, 0
section .text
    lea rax, [rel str_139]
    push rax
    pop rax
    mov rdi, rax
    call write_str
    mov rax, QWORD [rbp - 24]
    push rax
    pop rax
    mov rdi, rax
    call print_uint
section .rodata
str_140: db 93, 44, 32, 114, 97, 120, 0
section .text
    lea rax, [rel str_140]
    push rax
    pop rax
    mov rdi, rax
    call ln
    leave
    ret
L_if_else_206:
L_if_end_206:
    mov rax, QWORD [rbp - 16]
    push rax
    mov rax, 14
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_207
    mov rax, QWORD [rbp - 8]
    mov r11, rax
    mov rax, QWORD [ast_name_ptr + r11 * 8]
    push rax
    mov rax, QWORD [rbp - 8]
    mov r11, rax
    mov rax, QWORD [ast_name_len + r11 * 8]
    push rax
    mov rax, QWORD [rbp - 8]
    mov r11, rax
    mov rax, QWORD [ast_d + r11 * 8]
    push rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call loc_add
    mov rax, 0
    leave
    ret
L_if_else_207:
L_if_end_207:
    mov rax, QWORD [rbp - 16]
    push rax
    mov rax, 11
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_208
    mov rax, QWORD [rbp - 8]
    mov r11, rax
    mov rax, QWORD [ast_a + r11 * 8]
    push rax
    pop rax
    mov rdi, rax
    call gen_expr
section .rodata
str_141: db 32, 32, 32, 32, 109, 111, 118, 32, 81, 87, 79, 82, 68, 32, 91, 0
section .text
    lea rax, [rel str_141]
    push rax
    pop rax
    mov rdi, rax
    call write_str
    mov rax, QWORD [rbp - 8]
    mov r11, rax
    mov rax, QWORD [ast_name_ptr + r11 * 8]
    push rax
    mov rax, QWORD [rbp - 8]
    mov r11, rax
    mov rax, QWORD [ast_name_len + r11 * 8]
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call emit_var
section .rodata
str_142: db 93, 44, 32, 114, 97, 120, 0
section .text
    lea rax, [rel str_142]
    push rax
    pop rax
    mov rdi, rax
    call ln
    leave
    ret
L_if_else_208:
L_if_end_208:
    mov rax, QWORD [rbp - 16]
    push rax
    mov rax, 12
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_209
    mov rax, QWORD [rbp - 8]
    mov r11, rax
    mov rax, QWORD [ast_a + r11 * 8]
    push rax
    pop rax
    mov rdi, rax
    call gen_expr
section .rodata
str_143: db 32, 32, 32, 32, 112, 117, 115, 104, 32, 114, 97, 120, 0
section .text
    lea rax, [rel str_143]
    push rax
    pop rax
    mov rdi, rax
    call ln
    mov rax, QWORD [rbp - 8]
    mov r11, rax
    mov rax, QWORD [ast_b + r11 * 8]
    push rax
    pop rax
    mov rdi, rax
    call gen_expr
section .rodata
str_144: db 32, 32, 32, 32, 109, 111, 118, 32, 114, 49, 50, 44, 32, 114, 97, 120, 0
section .text
    lea rax, [rel str_144]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_145: db 32, 32, 32, 32, 112, 111, 112, 32, 114, 49, 49, 0
section .text
    lea rax, [rel str_145]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_146: db 32, 32, 32, 32, 109, 111, 118, 32, 81, 87, 79, 82, 68, 32, 91, 0
section .text
    lea rax, [rel str_146]
    push rax
    pop rax
    mov rdi, rax
    call write_str
    mov rax, QWORD [rbp - 8]
    mov r11, rax
    mov rax, QWORD [ast_name_ptr + r11 * 8]
    push rax
    mov rax, QWORD [rbp - 8]
    mov r11, rax
    mov rax, QWORD [ast_name_len + r11 * 8]
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call emit_var
section .rodata
str_147: db 32, 43, 32, 114, 49, 49, 32, 42, 32, 56, 93, 44, 32, 114, 49, 50, 0
section .text
    lea rax, [rel str_147]
    push rax
    pop rax
    mov rdi, rax
    call ln
    leave
    ret
L_if_else_209:
L_if_end_209:
    mov rax, QWORD [rbp - 16]
    push rax
    mov rax, 15
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_210
    mov rax, QWORD [rbp - 8]
    mov r11, rax
    mov rax, QWORD [ast_a + r11 * 8]
    push rax
    pop rax
    mov rdi, rax
    call gen_expr
    mov rax, QWORD [cg_label]
    mov QWORD [rbp - 32], rax
    mov rax, QWORD [cg_label]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    mov QWORD [cg_label], rax
section .rodata
str_148: db 32, 32, 32, 32, 116, 101, 115, 116, 32, 114, 97, 120, 44, 32, 114, 97, 120, 0
section .text
    lea rax, [rel str_148]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_149: db 32, 32, 32, 32, 106, 122, 32, 76, 95, 105, 102, 95, 101, 108, 115, 101, 95, 0
section .text
    lea rax, [rel str_149]
    push rax
    mov rax, QWORD [rbp - 32]
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call labln
    mov rax, QWORD [cg_nest]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    mov QWORD [cg_nest], rax
    mov rax, QWORD [rbp - 8]
    mov r11, rax
    mov rax, QWORD [ast_b + r11 * 8]
    push rax
    pop rax
    mov rdi, rax
    call gen_block
    mov rax, QWORD [rbp - 8]
    mov r11, rax
    mov rax, QWORD [ast_c + r11 * 8]
    push rax
    mov rax, 0
    pop rbx
    cmp rbx, rax
    setne al
    movzx rax, al
    test rax, rax
    jz L_if_else_211
section .rodata
str_150: db 32, 32, 32, 32, 106, 109, 112, 32, 76, 95, 105, 102, 95, 101, 110, 100, 95, 0
section .text
    lea rax, [rel str_150]
    push rax
    mov rax, QWORD [rbp - 32]
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call labln
section .rodata
str_151: db 76, 95, 105, 102, 95, 101, 108, 115, 101, 95, 0
section .text
    lea rax, [rel str_151]
    push rax
    mov rax, QWORD [rbp - 32]
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call labdef
    mov rax, QWORD [rbp - 8]
    mov r11, rax
    mov rax, QWORD [ast_c + r11 * 8]
    push rax
    pop rax
    mov rdi, rax
    call gen_block
    jmp L_if_end_211
L_if_else_211:
section .rodata
str_152: db 76, 95, 105, 102, 95, 101, 108, 115, 101, 95, 0
section .text
    lea rax, [rel str_152]
    push rax
    mov rax, QWORD [rbp - 32]
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call labdef
L_if_end_211:
    mov rax, QWORD [cg_nest]
    push rax
    mov rax, 1
    pop rbx
    mov rcx, rax
    mov rax, rbx
    sub rax, rcx
    mov QWORD [cg_nest], rax
section .rodata
str_153: db 76, 95, 105, 102, 95, 101, 110, 100, 95, 0
section .text
    lea rax, [rel str_153]
    push rax
    mov rax, QWORD [rbp - 32]
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call labdef
    leave
    ret
L_if_else_210:
L_if_end_210:
    mov rax, QWORD [rbp - 16]
    push rax
    mov rax, 16
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_212
    mov rax, QWORD [cg_label]
    mov QWORD [rbp - 40], rax
    mov rax, QWORD [cg_label]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    mov QWORD [cg_label], rax
section .rodata
str_154: db 32, 32, 32, 32, 109, 111, 118, 32, 114, 97, 120, 44, 32, 0
section .text
    lea rax, [rel str_154]
    push rax
    pop rax
    mov rdi, rax
    call write_str
    mov rax, QWORD [rbp - 8]
    mov r11, rax
    mov rax, QWORD [ast_a + r11 * 8]
    push rax
    pop rax
    mov rdi, rax
    call print_uint
    call emit_nl
section .rodata
str_155: db 32, 32, 32, 32, 112, 117, 115, 104, 32, 114, 97, 120, 0
section .text
    lea rax, [rel str_155]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_156: db 76, 95, 114, 101, 112, 95, 115, 116, 97, 114, 116, 95, 0
section .text
    lea rax, [rel str_156]
    push rax
    mov rax, QWORD [rbp - 40]
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call labdef
section .rodata
str_157: db 32, 32, 32, 32, 99, 109, 112, 32, 113, 119, 111, 114, 100, 32, 91, 114, 115, 112, 93, 44, 32, 48, 0
section .text
    lea rax, [rel str_157]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_158: db 32, 32, 32, 32, 106, 108, 101, 32, 76, 95, 114, 101, 112, 95, 101, 110, 100, 95, 0
section .text
    lea rax, [rel str_158]
    push rax
    mov rax, QWORD [rbp - 40]
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call labln
    mov rax, QWORD [cg_nest]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    mov QWORD [cg_nest], rax
    mov rax, QWORD [rbp - 8]
    mov r11, rax
    mov rax, QWORD [ast_b + r11 * 8]
    push rax
    pop rax
    mov rdi, rax
    call gen_block
    mov rax, QWORD [cg_nest]
    push rax
    mov rax, 1
    pop rbx
    mov rcx, rax
    mov rax, rbx
    sub rax, rcx
    mov QWORD [cg_nest], rax
section .rodata
str_159: db 32, 32, 32, 32, 100, 101, 99, 32, 113, 119, 111, 114, 100, 32, 91, 114, 115, 112, 93, 0
section .text
    lea rax, [rel str_159]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_160: db 32, 32, 32, 32, 106, 109, 112, 32, 76, 95, 114, 101, 112, 95, 115, 116, 97, 114, 116, 95, 0
section .text
    lea rax, [rel str_160]
    push rax
    mov rax, QWORD [rbp - 40]
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call labln
section .rodata
str_161: db 76, 95, 114, 101, 112, 95, 101, 110, 100, 95, 0
section .text
    lea rax, [rel str_161]
    push rax
    mov rax, QWORD [rbp - 40]
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call labdef
section .rodata
str_162: db 32, 32, 32, 32, 97, 100, 100, 32, 114, 115, 112, 44, 32, 56, 0
section .text
    lea rax, [rel str_162]
    push rax
    pop rax
    mov rdi, rax
    call ln
    leave
    ret
L_if_else_212:
L_if_end_212:
    mov rax, QWORD [rbp - 16]
    push rax
    mov rax, 17
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_213
    mov rax, QWORD [cg_label]
    mov QWORD [rbp - 48], rax
    mov rax, QWORD [cg_label]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    mov QWORD [cg_label], rax
section .rodata
str_163: db 76, 95, 114, 101, 112, 95, 115, 116, 97, 114, 116, 95, 0
section .text
    lea rax, [rel str_163]
    push rax
    mov rax, QWORD [rbp - 48]
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call labdef
    mov rax, QWORD [rbp - 8]
    mov r11, rax
    mov rax, QWORD [ast_a + r11 * 8]
    push rax
    pop rax
    mov rdi, rax
    call gen_expr
section .rodata
str_164: db 32, 32, 32, 32, 116, 101, 115, 116, 32, 114, 97, 120, 44, 32, 114, 97, 120, 0
section .text
    lea rax, [rel str_164]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_165: db 32, 32, 32, 32, 106, 122, 32, 76, 95, 114, 101, 112, 95, 101, 110, 100, 95, 0
section .text
    lea rax, [rel str_165]
    push rax
    mov rax, QWORD [rbp - 48]
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call labln
    mov rax, QWORD [cg_nest]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    mov QWORD [cg_nest], rax
    mov rax, QWORD [rbp - 8]
    mov r11, rax
    mov rax, QWORD [ast_b + r11 * 8]
    push rax
    pop rax
    mov rdi, rax
    call gen_block
    mov rax, QWORD [cg_nest]
    push rax
    mov rax, 1
    pop rbx
    mov rcx, rax
    mov rax, rbx
    sub rax, rcx
    mov QWORD [cg_nest], rax
section .rodata
str_166: db 32, 32, 32, 32, 106, 109, 112, 32, 76, 95, 114, 101, 112, 95, 115, 116, 97, 114, 116, 95, 0
section .text
    lea rax, [rel str_166]
    push rax
    mov rax, QWORD [rbp - 48]
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call labln
section .rodata
str_167: db 76, 95, 114, 101, 112, 95, 101, 110, 100, 95, 0
section .text
    lea rax, [rel str_167]
    push rax
    mov rax, QWORD [rbp - 48]
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call labdef
    leave
    ret
L_if_else_213:
L_if_end_213:
    mov rax, QWORD [rbp - 16]
    push rax
    mov rax, 18
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_214
    mov rax, QWORD [rbp - 8]
    mov r11, rax
    mov rax, QWORD [ast_a + r11 * 8]
    push rax
    mov rax, 0
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_215
section .rodata
str_168: db 32, 32, 32, 32, 109, 111, 118, 32, 114, 97, 120, 44, 32, 48, 0
section .text
    lea rax, [rel str_168]
    push rax
    pop rax
    mov rdi, rax
    call ln
    jmp L_if_end_215
L_if_else_215:
    mov rax, QWORD [rbp - 8]
    mov r11, rax
    mov rax, QWORD [ast_a + r11 * 8]
    push rax
    pop rax
    mov rdi, rax
    call gen_expr
L_if_end_215:
    call gen_truncate
section .rodata
str_169: db 32, 32, 32, 32, 108, 101, 97, 118, 101, 0
section .text
    lea rax, [rel str_169]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_170: db 32, 32, 32, 32, 114, 101, 116, 0
section .text
    lea rax, [rel str_170]
    push rax
    pop rax
    mov rdi, rax
    call ln
    mov rax, QWORD [cg_nest]
    push rax
    mov rax, 0
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_216
    mov rax, 1
    mov QWORD [cg_has_ret], rax
L_if_else_216:
L_if_end_216:
    mov rax, 0
    leave
    ret
L_if_else_214:
L_if_end_214:
    mov rax, QWORD [rbp - 8]
    push rax
    pop rax
    mov rdi, rax
    call gen_expr
    leave
    ret
FRAME_100 equ 48
gen_block:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_101
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    mov rax, QWORD [rbp - 8]
    push rax
    pop rax
    mov rdi, rax
    call ast_list_first
    mov QWORD [rbp - 16], rax
L_rep_start_217:
    mov rax, QWORD [rbp - 16]
    push rax
    mov rax, 0
    pop rbx
    cmp rbx, rax
    setne al
    movzx rax, al
    test rax, rax
    jz L_rep_end_217
    mov rax, QWORD [rbp - 16]
    push rax
    pop rax
    mov rdi, rax
    call gen_stmt
    mov rax, QWORD [rbp - 16]
    mov r11, rax
    mov rax, QWORD [ast_next + r11 * 8]
    mov QWORD [rbp - 16], rax
    jmp L_rep_start_217
L_rep_end_217:
    mov rax, 0
    leave
    ret
FRAME_101 equ 16
gen_func:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_102
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    mov rax, QWORD [cg_fn]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    mov QWORD [cg_fn], rax
    mov rax, 0
    mov QWORD [cg_frame], rax
    mov rax, 0
    mov QWORD [loc_count], rax
    mov rax, 0
    mov QWORD [cg_has_ret], rax
    mov rax, 0
    mov QWORD [cg_nest], rax
    mov rax, QWORD [rbp - 8]
    mov r11, rax
    mov rax, QWORD [ast_c + r11 * 8]
    mov QWORD [cg_ret_type], rax
    mov rax, QWORD [rbp - 8]
    mov r11, rax
    mov rax, QWORD [ast_d + r11 * 8]
    mov QWORD [cg_ret_ptr], rax
    mov rax, QWORD [rbp - 8]
    mov r11, rax
    mov rax, QWORD [ast_name_ptr + r11 * 8]
    push rax
    mov rax, QWORD [rbp - 8]
    mov r11, rax
    mov rax, QWORD [ast_name_len + r11 * 8]
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call write_bytes
section .rodata
str_171: db 58, 0
section .text
    lea rax, [rel str_171]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_172: db 32, 32, 32, 32, 112, 117, 115, 104, 32, 114, 98, 112, 0
section .text
    lea rax, [rel str_172]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_173: db 32, 32, 32, 32, 109, 111, 118, 32, 114, 98, 112, 44, 32, 114, 115, 112, 0
section .text
    lea rax, [rel str_173]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_174: db 32, 32, 32, 32, 115, 117, 98, 32, 114, 115, 112, 44, 32, 115, 116, 114, 105, 99, 116, 32, 100, 119, 111, 114, 100, 32, 70, 82, 65, 77, 69, 95, 0
section .text
    lea rax, [rel str_174]
    push rax
    mov rax, QWORD [cg_fn]
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call labln
    mov rax, QWORD [rbp - 8]
    mov r11, rax
    mov rax, QWORD [ast_a + r11 * 8]
    push rax
    pop rax
    mov rdi, rax
    call ast_list_first
    mov QWORD [rbp - 16], rax
    mov rax, 0
    mov QWORD [rbp - 24], rax
L_rep_start_218:
    mov rax, QWORD [rbp - 16]
    push rax
    mov rax, 0
    pop rbx
    cmp rbx, rax
    setne al
    movzx rax, al
    test rax, rax
    jz L_rep_end_218
    mov rax, QWORD [rbp - 16]
    mov r11, rax
    mov rax, QWORD [ast_name_ptr + r11 * 8]
    push rax
    mov rax, QWORD [rbp - 16]
    mov r11, rax
    mov rax, QWORD [ast_name_len + r11 * 8]
    push rax
    mov rax, 1
    push rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call loc_add
    mov QWORD [rbp - 32], rax
section .rodata
str_175: db 32, 32, 32, 32, 109, 111, 118, 32, 114, 97, 120, 44, 32, 0
section .text
    lea rax, [rel str_175]
    push rax
    pop rax
    mov rdi, rax
    call write_str
    mov rax, QWORD [rbp - 24]
    push rax
    pop rax
    mov rdi, rax
    call argreg
    call emit_nl
section .rodata
str_176: db 32, 32, 32, 32, 109, 111, 118, 32, 81, 87, 79, 82, 68, 32, 91, 114, 98, 112, 32, 45, 32, 0
section .text
    lea rax, [rel str_176]
    push rax
    pop rax
    mov rdi, rax
    call write_str
    mov rax, QWORD [rbp - 32]
    push rax
    pop rax
    mov rdi, rax
    call print_uint
section .rodata
str_177: db 93, 44, 32, 114, 97, 120, 0
section .text
    lea rax, [rel str_177]
    push rax
    pop rax
    mov rdi, rax
    call ln
    mov rax, QWORD [rbp - 24]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    mov QWORD [rbp - 24], rax
    mov rax, QWORD [rbp - 16]
    mov r11, rax
    mov rax, QWORD [ast_next + r11 * 8]
    mov QWORD [rbp - 16], rax
    jmp L_rep_start_218
L_rep_end_218:
    mov rax, QWORD [rbp - 8]
    mov r11, rax
    mov rax, QWORD [ast_b + r11 * 8]
    push rax
    pop rax
    mov rdi, rax
    call gen_block
    mov rax, QWORD [cg_has_ret]
    push rax
    mov rax, 0
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_219
section .rodata
str_178: db 32, 32, 32, 32, 109, 111, 118, 32, 114, 97, 120, 44, 32, 48, 0
section .text
    lea rax, [rel str_178]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_179: db 32, 32, 32, 32, 108, 101, 97, 118, 101, 0
section .text
    lea rax, [rel str_179]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_180: db 32, 32, 32, 32, 114, 101, 116, 0
section .text
    lea rax, [rel str_180]
    push rax
    pop rax
    mov rdi, rax
    call ln
L_if_else_219:
L_if_end_219:
section .rodata
str_181: db 70, 82, 65, 77, 69, 95, 0
section .text
    lea rax, [rel str_181]
    push rax
    mov rax, QWORD [cg_fn]
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call lab
section .rodata
str_182: db 32, 101, 113, 117, 32, 0
section .text
    lea rax, [rel str_182]
    push rax
    pop rax
    mov rdi, rax
    call write_str
    mov rax, QWORD [cg_frame]
    push rax
    mov rax, 15
    pop rbx
    add rax, rbx
    push rax
    mov rax, 16
    pop rbx
    xchg rax, rbx
    xor rdx, rdx
    div rbx
    push rax
    mov rax, 16
    pop rbx
    imul rax, rbx
    push rax
    pop rax
    mov rdi, rax
    call print_uint
    call emit_nl
    leave
    ret
FRAME_102 equ 32
gen_global:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_103
    mov rax, rdi
    mov QWORD [rbp - 8], rax
    mov rax, rsi
    mov QWORD [rbp - 16], rax
section .rodata
str_183: db 115, 101, 99, 116, 105, 111, 110, 32, 46, 98, 115, 115, 0
section .text
    lea rax, [rel str_183]
    push rax
    pop rax
    mov rdi, rax
    call ln
    mov rax, QWORD [rbp - 8]
    mov r11, rax
    mov rax, QWORD [ast_name_ptr + r11 * 8]
    push rax
    mov rax, QWORD [rbp - 8]
    mov r11, rax
    mov rax, QWORD [ast_name_len + r11 * 8]
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call write_bytes
section .rodata
str_184: db 58, 32, 114, 101, 115, 113, 32, 0
section .text
    lea rax, [rel str_184]
    push rax
    pop rax
    mov rdi, rax
    call write_str
    mov rax, QWORD [rbp - 16]
    push rax
    pop rax
    mov rdi, rax
    call print_uint
    call emit_nl
section .rodata
str_185: db 115, 101, 99, 116, 105, 111, 110, 32, 46, 116, 101, 120, 116, 0
section .text
    lea rax, [rel str_185]
    push rax
    pop rax
    mov rdi, rax
    call ln
    leave
    ret
FRAME_103 equ 16
gen_program:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_104
    mov rax, rdi
    mov QWORD [rbp - 8], rax
section .rodata
str_186: db 100, 101, 102, 97, 117, 108, 116, 32, 114, 101, 108, 0
section .text
    lea rax, [rel str_186]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_187: db 0
section .text
    lea rax, [rel str_187]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_188: db 101, 120, 116, 101, 114, 110, 32, 119, 114, 105, 116, 101, 95, 98, 121, 116, 101, 115, 0
section .text
    lea rax, [rel str_188]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_189: db 101, 120, 116, 101, 114, 110, 32, 119, 114, 105, 116, 101, 95, 101, 114, 114, 0
section .text
    lea rax, [rel str_189]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_190: db 101, 120, 116, 101, 114, 110, 32, 115, 121, 115, 99, 97, 108, 108, 50, 0
section .text
    lea rax, [rel str_190]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_191: db 101, 120, 116, 101, 114, 110, 32, 114, 101, 97, 100, 95, 102, 105, 108, 101, 0
section .text
    lea rax, [rel str_191]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_192: db 101, 120, 116, 101, 114, 110, 32, 103, 101, 116, 95, 97, 114, 103, 0
section .text
    lea rax, [rel str_192]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_193: db 101, 120, 116, 101, 114, 110, 32, 97, 114, 103, 95, 99, 111, 117, 110, 116, 0
section .text
    lea rax, [rel str_193]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_194: db 101, 120, 116, 101, 114, 110, 32, 114, 117, 110, 116, 105, 109, 101, 95, 105, 110, 105, 116, 0
section .text
    lea rax, [rel str_194]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_195: db 101, 120, 116, 101, 114, 110, 32, 112, 111, 107, 101, 56, 0
section .text
    lea rax, [rel str_195]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_196: db 0
section .text
    lea rax, [rel str_196]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_197: db 103, 108, 111, 98, 97, 108, 32, 95, 115, 116, 97, 114, 116, 0
section .text
    lea rax, [rel str_197]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_198: db 95, 115, 116, 97, 114, 116, 58, 0
section .text
    lea rax, [rel str_198]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_199: db 32, 32, 32, 32, 109, 111, 118, 32, 114, 100, 105, 44, 32, 114, 115, 112, 0
section .text
    lea rax, [rel str_199]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_200: db 32, 32, 32, 32, 99, 97, 108, 108, 32, 114, 117, 110, 116, 105, 109, 101, 95, 105, 110, 105, 116, 0
section .text
    lea rax, [rel str_200]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_201: db 32, 32, 32, 32, 99, 97, 108, 108, 32, 109, 97, 105, 110, 0
section .text
    lea rax, [rel str_201]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_202: db 32, 32, 32, 32, 109, 111, 118, 32, 101, 100, 105, 44, 32, 101, 97, 120, 0
section .text
    lea rax, [rel str_202]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_203: db 32, 32, 32, 32, 109, 111, 118, 32, 101, 97, 120, 44, 32, 54, 48, 0
section .text
    lea rax, [rel str_203]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_204: db 32, 32, 32, 32, 115, 121, 115, 99, 97, 108, 108, 0
section .text
    lea rax, [rel str_204]
    push rax
    pop rax
    mov rdi, rax
    call ln
section .rodata
str_205: db 0
section .text
    lea rax, [rel str_205]
    push rax
    pop rax
    mov rdi, rax
    call ln
    mov rax, QWORD [rbp - 8]
    mov r11, rax
    mov rax, QWORD [ast_a + r11 * 8]
    mov QWORD [rbp - 16], rax
    mov rax, QWORD [rbp - 16]
    push rax
    pop rax
    mov rdi, rax
    call ast_list_first
    mov QWORD [rbp - 24], rax
L_rep_start_220:
    mov rax, QWORD [rbp - 24]
    push rax
    mov rax, 0
    pop rbx
    cmp rbx, rax
    setne al
    movzx rax, al
    test rax, rax
    jz L_rep_end_220
    mov rax, QWORD [rbp - 24]
    mov r11, rax
    mov rax, QWORD [ast_kind + r11 * 8]
    push rax
    mov rax, 24
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_221
    mov rax, QWORD [rbp - 24]
    mov r11, rax
    mov rax, QWORD [ast_name_ptr + r11 * 8]
    push rax
    mov rax, QWORD [rbp - 24]
    mov r11, rax
    mov rax, QWORD [ast_name_len + r11 * 8]
    push rax
    mov rax, QWORD [rbp - 24]
    mov r11, rax
    mov rax, QWORD [ast_a + r11 * 8]
    push rax
    pop rax
    mov rdi, rax
    call const_eval
    push rax
    pop rax
    mov rdx, rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call con_add
L_if_else_221:
L_if_end_221:
    mov rax, QWORD [rbp - 24]
    mov r11, rax
    mov rax, QWORD [ast_next + r11 * 8]
    mov QWORD [rbp - 24], rax
    jmp L_rep_start_220
L_rep_end_220:
    mov rax, QWORD [rbp - 16]
    push rax
    pop rax
    mov rdi, rax
    call ast_list_first
    mov QWORD [rbp - 24], rax
L_rep_start_222:
    mov rax, QWORD [rbp - 24]
    push rax
    mov rax, 0
    pop rbx
    cmp rbx, rax
    setne al
    movzx rax, al
    test rax, rax
    jz L_rep_end_222
    mov rax, QWORD [rbp - 24]
    mov r11, rax
    mov rax, QWORD [ast_kind + r11 * 8]
    mov QWORD [rbp - 32], rax
    mov rax, QWORD [rbp - 32]
    push rax
    mov rax, 22
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_223
    mov rax, QWORD [rbp - 24]
    push rax
    mov rax, 1
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call gen_global
L_if_else_223:
L_if_end_223:
    mov rax, QWORD [rbp - 32]
    push rax
    mov rax, 14
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_224
    mov rax, QWORD [rbp - 24]
    push rax
    mov rax, QWORD [rbp - 24]
    mov r11, rax
    mov rax, QWORD [ast_d + r11 * 8]
    push rax
    pop rax
    mov rsi, rax
    pop rax
    mov rdi, rax
    call gen_global
L_if_else_224:
L_if_end_224:
    mov rax, QWORD [rbp - 24]
    mov r11, rax
    mov rax, QWORD [ast_next + r11 * 8]
    mov QWORD [rbp - 24], rax
    jmp L_rep_start_222
L_rep_end_222:
    mov rax, QWORD [rbp - 16]
    push rax
    pop rax
    mov rdi, rax
    call ast_list_first
    mov QWORD [rbp - 24], rax
L_rep_start_225:
    mov rax, QWORD [rbp - 24]
    push rax
    mov rax, 0
    pop rbx
    cmp rbx, rax
    setne al
    movzx rax, al
    test rax, rax
    jz L_rep_end_225
    mov rax, QWORD [rbp - 24]
    mov r11, rax
    mov rax, QWORD [ast_kind + r11 * 8]
    push rax
    mov rax, 20
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_226
    mov rax, QWORD [rbp - 24]
    push rax
    pop rax
    mov rdi, rax
    call gen_func
L_if_else_226:
L_if_end_226:
    mov rax, QWORD [rbp - 24]
    mov r11, rax
    mov rax, QWORD [ast_next + r11 * 8]
    mov QWORD [rbp - 24], rax
    jmp L_rep_start_225
L_rep_end_225:
    mov rax, 0
    leave
    ret
FRAME_104 equ 32
main:
    push rbp
    mov rbp, rsp
    sub rsp, strict dword FRAME_105
    mov rax, 1
    push rax
    pop rax
    mov rdi, rax
    call get_arg
    push rax
    mov rax, 0
    pop rbx
    cmp rbx, rax
    sete al
    movzx rax, al
    test rax, rax
    jz L_if_else_227
section .rodata
str_206: db 85, 115, 97, 103, 101, 58, 32, 122, 101, 114, 111, 32, 60, 115, 111, 117, 114, 99, 101, 46, 122, 114, 62, 10, 0
section .text
    lea rax, [rel str_206]
    push rax
    pop rax
    mov rdi, rax
    call err_str
    mov rax, 1
    leave
    ret
L_if_else_227:
L_if_end_227:
    mov rax, 1
    push rax
    pop rax
    mov rdi, rax
    call get_arg
    push rax
    pop rax
    mov rdi, rax
    call lexer_open
    call parse_program
    mov QWORD [rbp - 8], rax
    mov rax, QWORD [rbp - 8]
    push rax
    pop rax
    mov rdi, rax
    call gen_program
    mov rax, 0
    leave
    ret
FRAME_105 equ 16
