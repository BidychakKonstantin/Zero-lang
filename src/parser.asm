%include "src/include/tokens.inc"

default rel

global parser_parse
global symbol_table

extern lexer_next_token
extern lexer_use_file

extern ident_ptr
extern ident_len

extern string_ptr
extern string_len

extern current_number
extern token_value

extern codegen_function_start
extern codegen_function_end
extern codegen_call_function
extern codegen_return

extern codegen_load_number
extern codegen_load_variable
extern codegen_load_array_element
extern codegen_load_char
extern codegen_load_string

extern codegen_store_variable
extern codegen_save_value

extern codegen_add
extern codegen_sub
extern codegen_mul

extern codegen_cmp_eq
extern codegen_cmp_lt
extern codegen_cmp_gt
extern codegen_cmp_lte
extern codegen_cmp_gte

extern codegen_if_start
extern codegen_if_else
extern codegen_if_end

extern codegen_rep_start
extern codegen_rep_end


%define SYS_WRITE 1
%define SYS_EXIT  60
%define STDOUT    1
%define STDERR    2


; ============================================================
; SYMBOL TABLE
; ============================================================

%define SYM_FUNC  1
%define SYM_VAR   2
%define SYM_CONST 3

%define SYM_MAX   1024
%define SYM_SIZE  40

%define SYM_NAME_PTR  0
%define SYM_NAME_LEN  8
%define SYM_TYPE      16
%define SYM_KIND      24
%define SYM_VALUE     32


; ============================================================
; LIMITS
; ============================================================

%define MAX_CALL_ARGS 6


; ============================================================
; READ ONLY DATA
; ============================================================

section .rodata

msg_ident:
    db "Syntax Error: Expected identifier", 10
msg_ident_len equ $ - msg_ident

msg_lparen:
    db "Syntax Error: Expected '('", 10
msg_lparen_len equ $ - msg_lparen

msg_rparen:
    db "Syntax Error: Expected ')'", 10
msg_rparen_len equ $ - msg_rparen

msg_lbrace:
    db "Syntax Error: Expected '{'", 10
msg_lbrace_len equ $ - msg_lbrace

msg_rbrace:
    db "Syntax Error: Expected '}'", 10
msg_rbrace_len equ $ - msg_rbrace

msg_rbrack:
    db "Syntax Error: Expected ']'", 10
msg_rbrack_len equ $ - msg_rbrack

msg_equal:
    db "Syntax Error: Expected '='", 10
msg_equal_len equ $ - msg_equal

msg_type:
    db "Syntax Error: Expected type", 10
msg_type_len equ $ - msg_type

msg_expr:
    db "Syntax Error: Expected expression", 10
msg_expr_len equ $ - msg_expr

msg_else:
    db "Syntax Error: Expected '{' after else", 10
msg_else_len equ $ - msg_else

msg_unknown:
    db "Syntax Error: Unexpected token", 10
msg_unknown_len equ $ - msg_unknown

msg_use:
    db "Syntax Error: Expected string after use", 10
msg_use_len equ $ - msg_use

msg_use_file:
    db "Error: Could not open file in use", 10
msg_use_file_len equ $ - msg_use_file

msg_symtab:
    db "Internal Error: symbol table full", 10
msg_symtab_len equ $ - msg_symtab

msg_const:
    db "Syntax Error: Invalid constant value", 10
msg_const_len equ $ - msg_const

msg_undefined:
    db "Semantic Error: Undefined identifier '"
msg_undefined_len equ $ - msg_undefined

msg_not_function:
    db "Semantic Error: Identifier is not a function", 10
msg_not_function_len equ $ - msg_not_function

msg_call_args:
    db "Syntax Error: Too many function arguments", 10
msg_call_args_len equ $ - msg_call_args

msg_call_count:
    db "Syntax Error: Wrong number of function arguments", 10
msg_call_count_len equ $ - msg_call_count

msg_quote:
    db "'", 10
msg_quote_len equ $ - msg_quote

s_call_arg_pop_r9:
    db "    pop rax", 10
    db "    mov r9, rax", 10
s_call_arg_pop_r9_len equ $ - s_call_arg_pop_r9

s_call_arg_pop_r8:
    db "    pop rax", 10
    db "    mov r8, rax", 10
s_call_arg_pop_r8_len equ $ - s_call_arg_pop_r8

s_call_arg_pop_rcx:
    db "    pop rax", 10
    db "    mov rcx, rax", 10
s_call_arg_pop_rcx_len equ $ - s_call_arg_pop_rcx

s_call_arg_pop_rdx:
    db "    pop rax", 10
    db "    mov rdx, rax", 10
s_call_arg_pop_rdx_len equ $ - s_call_arg_pop_rdx

s_call_arg_pop_rsi:
    db "    pop rax", 10
    db "    mov rsi, rax", 10
s_call_arg_pop_rsi_len equ $ - s_call_arg_pop_rsi

s_call_arg_pop_rdi:
    db "    pop rax", 10
    db "    mov rdi, rax", 10
s_call_arg_pop_rdi_len equ $ - s_call_arg_pop_rdi


; ============================================================
; BSS
; ============================================================

section .bss

align 8

symbol_table:
    resb SYM_MAX * SYM_SIZE

symbol_count:
    resq 1

current_token:
    resq 1

decl_type:
    resq 1

decl_name_ptr:
    resq 1

decl_name_len:
    resq 1

expr_name_ptr:
    resq 1

expr_name_len:
    resq 1

expr_symbol:
    resq 1

expr_delim:
    resq 1

temp_type:
    resq 1

temp_value:
    resq 1

temp_delim:
    resq 1

current_function:
    resq 1

function_scope_base:
    resq 1

current_call_symbol:
    resq 1

call_arg_count:
    resq 1

call_arg_index:
    resq 1


section .text


; ============================================================
; PARSER ENTRY
; ============================================================

parser_parse:
    xor eax, eax

    mov [rel symbol_count], rax
    mov [rel current_token], rax

    mov [rel current_function], rax
    mov [rel function_scope_base], rax

    mov [rel current_call_symbol], rax
    mov [rel call_arg_count], rax
    mov [rel call_arg_index], rax

    call parser_next

    jmp near parser_top


; ============================================================
; NEXT TOKEN
; ============================================================

parser_next:
    call lexer_next_token

    mov [rel current_token], rax

    ret


; ============================================================
; TOP LEVEL
; ============================================================

parser_top:
    mov rax, [rel current_token]

    cmp rax, TOK_EOF
    je near parser_done

    cmp rax, TOK_NEWLINE
    je near parser_top_next

    cmp rax, TOK_USE
    je near parser_top_use

    cmp rax, TOK_INT8
    je near parser_global_const

    cmp rax, TOK_NAT8
    je near parser_global_const

    cmp rax, TOK_INT16
    je near parser_global_const

    cmp rax, TOK_NAT16
    je near parser_global_const

    cmp rax, TOK_INT32
    je near parser_global_const

    cmp rax, TOK_NAT32
    je near parser_global_const

    cmp rax, TOK_INT64
    je near parser_global_const

    cmp rax, TOK_NAT64
    je near parser_global_const

    cmp rax, TOK_CHR
    je near parser_global_const

%ifdef TOK_BOOL
    cmp rax, TOK_BOOL
    je near parser_global_const
%endif

    cmp rax, TOK_IDENT
    je near parser_function

    jmp near parser_error_unknown


parser_top_next:
    call parser_next

    jmp near parser_top


; ============================================================
; USE TOP LEVEL
; ============================================================

parser_top_use:
    call parser_next

    cmp rax, TOK_STRING
    jne near parser_error_use

    mov rdi, [rel string_ptr]
    mov rsi, [rel string_len]

    call lexer_use_file

    test rax, rax
    js near parser_error_use_file

    call parser_next

    jmp near parser_top


; ============================================================
; FUNCTION
; ============================================================

parser_function:
    mov rax, [rel ident_ptr]
    mov [rel decl_name_ptr], rax

    mov rax, [rel ident_len]
    mov [rel decl_name_len], rax

    mov rax, [rel decl_name_ptr]
    mov [rel ident_ptr], rax

    mov rax, [rel decl_name_len]
    mov [rel ident_len], rax

    xor r8d, r8d
    mov r9d, SYM_FUNC

    call parser_add_symbol

    mov rcx, [rel symbol_count]
    dec rcx

    imul rcx, SYM_SIZE

    lea r10, [rel symbol_table]
    add r10, rcx

    mov [rel current_function], r10

    mov rax, [rel symbol_count]
    mov [rel function_scope_base], rax

    mov rax, [rel decl_name_ptr]
    mov [rel ident_ptr], rax

    mov rax, [rel decl_name_len]
    mov [rel ident_len], rax

    call codegen_function_start

    call parser_next

    cmp rax, TOK_LPAREN
    jne near parser_error_lparen

    call parser_args

    call parser_next

    cmp rax, TOK_ARROW
    je near parser_function_return_type

    cmp rax, TOK_LBRACE
    je near parser_function_body

    jmp near parser_error_lbrace


; ============================================================
; FUNCTION RETURN TYPE
; ============================================================

parser_function_return_type:
    call parser_next

    xor r9d, r9d

    cmp rax, TOK_STAR
    jne .return_type_no_leading_pointer

    mov r9d, 1

    call parser_next

.return_type_no_leading_pointer:
    call parser_is_type

    test r8d, r8d
    jz near parser_error_type

    mov [rel temp_type], rax

    call parser_next

    cmp rax, TOK_STAR
    jne .return_type_no_trailing_pointer

    mov r9d, 1

    call parser_next

.return_type_no_trailing_pointer:
    cmp rax, TOK_LBRACE
    jne near parser_error_lbrace

    mov rax, [rel temp_type]

    test r9d, r9d
    jz .return_type_not_pointer

    bts rax, 63

.return_type_not_pointer:
    mov r10, [rel current_function]

    test r10, r10
    jz near parser_error_type

    mov [r10 + SYM_TYPE], rax

    jmp near parser_function_body


; ============================================================
; FUNCTION BODY
; ============================================================

parser_function_body:
    call parser_body

    call codegen_function_end

    mov rax, [rel function_scope_base]
    mov [rel symbol_count], rax

    xor eax, eax

    mov [rel current_function], rax
    mov [rel function_scope_base], rax

    call parser_next

    jmp near parser_top


; ============================================================
; FUNCTION ARGUMENTS
; ============================================================

parser_args:
    call parser_next

    cmp rax, TOK_RPAREN
    je near parser_args_done

parser_args_loop:
    mov rcx, [rel current_function]

    test rcx, rcx
    jz near parser_error_type

    mov rdx, [rcx + SYM_VALUE]

    cmp rdx, MAX_CALL_ARGS
    jae near parser_error_call_args

    xor r9d, r9d

    cmp rax, TOK_STAR
    jne .arg_no_leading_pointer

    mov r9d, 1

    call parser_next

.arg_no_leading_pointer:
    call parser_is_type

    test r8d, r8d
    jz near parser_error_type

    mov [rel temp_type], rax

    call parser_next

    cmp rax, TOK_STAR
    jne .arg_no_trailing_pointer

    mov r9d, 1

    call parser_next

.arg_no_trailing_pointer:
    cmp rax, TOK_IDENT
    jne near parser_error_ident

    mov r8, [rel temp_type]

    test r9d, r9d
    jz .arg_type_not_pointer

    bts r8, 63

.arg_type_not_pointer:
    mov r9d, SYM_VAR

    call parser_add_symbol

    mov r10, [rel current_function]

    mov rax, [r10 + SYM_VALUE]
    inc rax

    mov [r10 + SYM_VALUE], rax

    call parser_next

    cmp rax, TOK_COMMA
    je near parser_args_comma

    cmp rax, TOK_RPAREN
    je near parser_args_done

    jmp near parser_error_rparen

parser_args_comma:
    call parser_next

    jmp near parser_args_loop

parser_args_done:
    ret


; ============================================================
; BODY
; ============================================================

parser_body:
parser_body_loop:
    call parser_next

    cmp rax, TOK_RBRACE
    je near parser_body_done

    cmp rax, TOK_EOF
    je near parser_error_rbrace

    cmp rax, TOK_NEWLINE
    je near parser_body_loop

    cmp rax, TOK_USE
    je near parser_body_use

    cmp rax, TOK_INT8
    je near parser_variable

    cmp rax, TOK_NAT8
    je near parser_variable

    cmp rax, TOK_INT16
    je near parser_variable

    cmp rax, TOK_NAT16
    je near parser_variable

    cmp rax, TOK_INT32
    je near parser_variable

    cmp rax, TOK_NAT32
    je near parser_variable

    cmp rax, TOK_INT64
    je near parser_variable

    cmp rax, TOK_NAT64
    je near parser_variable

    cmp rax, TOK_CHR
    je near parser_variable

%ifdef TOK_BOOL
    cmp rax, TOK_BOOL
    je near parser_variable
%endif

    cmp rax, TOK_IF
    je near parser_if

    cmp rax, TOK_REP
    je near parser_rep

    cmp rax, TOK_RET
    je near parser_return

    call parser_expression

    mov [rel temp_delim], rax

    cmp rax, TOK_NEWLINE
    je near parser_body_loop

    cmp rax, TOK_RBRACE
    je near parser_body_done

    cmp rax, TOK_EOF
    je near parser_error_rbrace

    jmp near parser_error_unknown

parser_body_done:
    ret


; ============================================================
; USE INSIDE FUNCTION
; ============================================================

parser_body_use:
    call parser_next

    cmp rax, TOK_STRING
    jne near parser_error_use

    mov rdi, [rel string_ptr]
    mov rsi, [rel string_len]

    call lexer_use_file

    test rax, rax
    js near parser_error_use_file

    jmp near parser_body_loop


; ============================================================
; VARIABLE
; ============================================================

parser_variable:
    mov [rel decl_type], rax

    xor r9d, r9d

    call parser_next

    cmp rax, TOK_STAR
    jne .variable_after_type

    mov r9d, 1

    call parser_next

.variable_after_type:
    cmp rax, TOK_IDENT
    jne near parser_error_ident

    mov rax, [rel ident_ptr]
    mov [rel decl_name_ptr], rax

    mov rax, [rel ident_len]
    mov [rel decl_name_len], rax

    mov rax, [rel decl_type]

    test r9d, r9d
    jz .variable_type_not_pointer

    bts rax, 63

.variable_type_not_pointer:
    mov [rel decl_type], rax

    call parser_next

    cmp rax, TOK_EQUAL
    jne near parser_error_equal

    mov r8, [rel decl_type]
    mov r9d, SYM_VAR

    mov rax, [rel decl_name_ptr]
    mov [rel ident_ptr], rax

    mov rax, [rel decl_name_len]
    mov [rel ident_len], rax

    call parser_add_symbol

    call parser_next

    call parser_expression

    mov [rel temp_delim], rax

    mov rax, [rel decl_name_ptr]
    mov [rel ident_ptr], rax

    mov rax, [rel decl_name_len]
    mov [rel ident_len], rax

    call codegen_store_variable

    mov rax, [rel temp_delim]

    cmp rax, TOK_NEWLINE
    je near parser_body_loop

    cmp rax, TOK_RBRACE
    je near parser_body_done

    cmp rax, TOK_EOF
    je near parser_error_rbrace

    jmp near parser_error_unknown


; ============================================================
; RETURN
; ============================================================

parser_return:
    call parser_next

    call parser_expression

    mov [rel temp_delim], rax

    call codegen_return

    mov rax, [rel temp_delim]

    cmp rax, TOK_NEWLINE
    je near parser_body_loop

    cmp rax, TOK_RBRACE
    je near parser_body_done

    cmp rax, TOK_EOF
    je near parser_done

    jmp near parser_error_unknown


; ============================================================
; IF
; ============================================================

parser_if:
    call parser_next

    call parser_expression

    cmp rax, TOK_LBRACE
    jne near parser_error_lbrace

    call codegen_if_start

    call parser_body

    call parser_next

    cmp rax, TOK_ELSE
    je near parser_if_else

    cmp rax, TOK_NEWLINE
    je near parser_if_finish_newline

    cmp rax, TOK_RBRACE
    je near parser_if_finish_rbrace

    cmp rax, TOK_EOF
    je near parser_if_finish_eof

    jmp near parser_error_unknown


; ============================================================
; ELSE
; ============================================================

parser_if_else:
    call codegen_if_else

    call parser_next

    cmp rax, TOK_LBRACE
    jne near parser_error_else

    call parser_body

    call codegen_if_end

    call parser_next

    cmp rax, TOK_NEWLINE
    je near parser_body_loop

    cmp rax, TOK_RBRACE
    je near parser_body_done

    cmp rax, TOK_EOF
    je near parser_done

    jmp near parser_error_unknown

parser_if_finish_newline:
    call codegen_if_end

    jmp near parser_body_loop

parser_if_finish_rbrace:
    call codegen_if_end

    jmp near parser_body_done

parser_if_finish_eof:
    call codegen_if_end

    jmp near parser_done


; ============================================================
; REP
; ============================================================

parser_rep:
    call parser_next

    call parser_expression

    cmp rax, TOK_LBRACE
    jne near parser_error_lbrace

    call codegen_rep_start

    call parser_body

    call codegen_rep_end

    call parser_next

    cmp rax, TOK_NEWLINE
    je near parser_body_loop

    cmp rax, TOK_RBRACE
    je near parser_body_done

    cmp rax, TOK_EOF
    je near parser_done

    jmp near parser_error_unknown


; ============================================================
; EXPRESSION
; ============================================================

parser_expression:
    call parser_expression_additive

    ret


; ============================================================
; ADDITIVE
; ============================================================

parser_expression_additive:
    call parser_expression_multiplicative

parser_expression_additive_loop:
    cmp rax, TOK_PLUS
    je near parser_expression_add

    cmp rax, TOK_MINUS
    je near parser_expression_sub

    cmp rax, TOK_EQEQ
    je near parser_expression_eq

    cmp rax, TOK_LT
    je near parser_expression_lt

    cmp rax, TOK_GT
    je near parser_expression_gt

    cmp rax, TOK_LTE
    je near parser_expression_lte

    cmp rax, TOK_GTE
    je near parser_expression_gte

    ret


; ============================================================
; ADD / SUB
; ============================================================

parser_expression_add:
    call codegen_save_value

    call parser_next

    call parser_expression_multiplicative

    mov [rel temp_delim], rax

    call codegen_add

    mov rax, [rel temp_delim]

    jmp near parser_expression_additive_loop

parser_expression_sub:
    call codegen_save_value

    call parser_next

    call parser_expression_multiplicative

    mov [rel temp_delim], rax

    call codegen_sub

    mov rax, [rel temp_delim]

    jmp near parser_expression_additive_loop


; ============================================================
; MULTIPLICATIVE
; ============================================================

parser_expression_multiplicative:
    call parser_expression_primary

parser_expression_multiplicative_loop:
    cmp rax, TOK_STAR
    je near parser_expression_mul

    ret

parser_expression_mul:
    call codegen_save_value

    call parser_next

    call parser_expression_primary

    mov [rel temp_delim], rax

    call codegen_mul

    mov rax, [rel temp_delim]

    jmp near parser_expression_multiplicative_loop


; ============================================================
; PRIMARY
; ============================================================

parser_expression_primary:
    mov rax, [rel current_token]

    cmp rax, TOK_NUMBER
    je near parser_primary_number

    cmp rax, TOK_NULL
    je near parser_primary_null

    cmp rax, TOK_CHAR
    je near parser_primary_char

    cmp rax, TOK_STRING
    je near parser_primary_string

    cmp rax, TOK_IDENT
    je near parser_primary_identifier

    cmp rax, TOK_LPAREN
    je near parser_primary_paren

    jmp near parser_error_expr

parser_primary_number:
    call codegen_load_number

    call parser_next

    ret

parser_primary_null:
    xor rax, rax
    mov [rel current_number], rax
    mov [rel token_value], rax
    
    call codegen_load_number
    
    call parser_next
    
    ret

parser_primary_char:
    call codegen_load_char

    call parser_next

    ret

parser_primary_string:
    call codegen_load_string

    call parser_next

    ret

parser_primary_identifier:
    mov rax, [rel ident_ptr]
    mov [rel expr_name_ptr], rax

    mov rax, [rel ident_len]
    mov [rel expr_name_len], rax

    call parser_next

    cmp rax, TOK_LPAREN
    je near parser_primary_call

    cmp rax, TOK_LBRACK
    je near parser_primary_array

    mov [rel expr_delim], rax

    mov rax, [rel expr_name_ptr]
    mov [rel ident_ptr], rax

    mov rax, [rel expr_name_len]
    mov [rel ident_len], rax

    call parser_find_symbol

    test rax, rax
    jz near parser_error_undefined

    mov [rel expr_symbol], rax

    cmp qword [rax + SYM_KIND], SYM_FUNC
    je near parser_error_expr

    cmp qword [rax + SYM_KIND], SYM_VAR
    je near parser_primary_variable

    cmp qword [rax + SYM_KIND], SYM_CONST
    je near parser_primary_constant

    jmp near parser_error_expr

parser_primary_variable:
    mov rax, [rel expr_name_ptr]
    mov [rel ident_ptr], rax

    mov rax, [rel expr_name_len]
    mov [rel ident_len], rax

    call codegen_load_variable

    mov rax, [rel expr_delim]

    ret

parser_primary_constant:
    mov rax, [rel expr_symbol]

    mov rax, [rax + SYM_VALUE]

    mov [rel current_number], rax
    mov [rel token_value], rax

    call codegen_load_number

    mov rax, [rel expr_delim]

    ret


; ============================================================
; FUNCTION CALL
; ============================================================

parser_primary_call:
    push qword [rel expr_name_ptr]
    push qword [rel expr_name_len]
    push qword [rel current_call_symbol]
    push qword [rel call_arg_count]

    mov rax, [rel expr_name_ptr]
    mov [rel ident_ptr], rax

    mov rax, [rel expr_name_len]
    mov [rel ident_len], rax

    call parser_find_symbol

    test rax, rax
    jz near parser_error_undefined

    cmp qword [rax + SYM_KIND], SYM_FUNC
    jne near parser_error_not_function

    mov [rel current_call_symbol], rax

    xor eax, eax
    mov [rel call_arg_count], rax

    call parser_next

    cmp rax, TOK_RPAREN
    je near parser_call_no_args

    jmp near parser_call_args

parser_call_args:
    mov rax, [rel call_arg_count]

    cmp rax, MAX_CALL_ARGS
    jae near parser_error_call_args

    call parser_expression

    mov [rel temp_delim], rax

    call codegen_save_value

    inc qword [rel call_arg_count]

    mov rax, [rel temp_delim]

    cmp rax, TOK_COMMA
    je near parser_call_comma

    cmp rax, TOK_RPAREN
    je near parser_call_done

    jmp near parser_error_rparen

parser_call_comma:
    call parser_next

    jmp near parser_call_args

parser_call_no_args:
    xor eax, eax
    mov [rel call_arg_count], rax

    jmp near parser_call_done

parser_call_done:
    mov r10, [rel current_call_symbol]
    mov rcx, [r10 + SYM_VALUE]

    mov rax, [rel call_arg_count]

    cmp rax, rcx
    jne near parser_error_call_count

    mov rax, [rel expr_name_ptr]
    mov [rel ident_ptr], rax

    mov rax, [rel expr_name_len]
    mov [rel ident_len], rax

    call parser_emit_call_arguments

    call codegen_call_function

    call parser_next

    pop qword [rel call_arg_count]
    pop qword [rel current_call_symbol]
    pop qword [rel expr_name_len]
    pop qword [rel expr_name_ptr]

    ret

parser_emit_call_arguments:
    mov rax, [rel call_arg_count]

    cmp rax, 6
    je .args6

    cmp rax, 5
    je .args5

    cmp rax, 4
    je .args4

    cmp rax, 3
    je .args3

    cmp rax, 2
    je .args2

    cmp rax, 1
    je .args1

    ret

.args6:
    call parser_emit_arg_r9

.args5:
    call parser_emit_arg_r8

.args4:
    call parser_emit_arg_rcx

.args3:
    call parser_emit_arg_rdx

.args2:
    call parser_emit_arg_rsi

.args1:
    call parser_emit_arg_rdi

    ret

parser_emit_arg_r9:
    mov eax, SYS_WRITE
    mov edi, STDOUT
    lea rsi, [rel s_call_arg_pop_r9]
    mov edx, s_call_arg_pop_r9_len
    syscall
    ret

parser_emit_arg_r8:
    mov eax, SYS_WRITE
    mov edi, STDOUT
    lea rsi, [rel s_call_arg_pop_r8]
    mov edx, s_call_arg_pop_r8_len
    syscall
    ret

parser_emit_arg_rcx:
    mov eax, SYS_WRITE
    mov edi, STDOUT
    lea rsi, [rel s_call_arg_pop_rcx]
    mov edx, s_call_arg_pop_rcx_len
    syscall
    ret

parser_emit_arg_rdx:
    mov eax, SYS_WRITE
    mov edi, STDOUT
    lea rsi, [rel s_call_arg_pop_rdx]
    mov edx, s_call_arg_pop_rdx_len
    syscall
    ret

parser_emit_arg_rsi:
    mov eax, SYS_WRITE
    mov edi, STDOUT
    lea rsi, [rel s_call_arg_pop_rsi]
    mov edx, s_call_arg_pop_rsi_len
    syscall
    ret

parser_emit_arg_rdi:
    mov eax, SYS_WRITE
    mov edi, STDOUT
    lea rsi, [rel s_call_arg_pop_rdi]
    mov edx, s_call_arg_pop_rdi_len
    syscall
    ret

parser_primary_array:
    call parser_next

    call parser_expression

    cmp rax, TOK_RBRACK
    jne near parser_error_rbrack

    mov rax, [rel expr_name_ptr]
    mov [rel ident_ptr], rax

    mov rax, [rel expr_name_len]
    mov [rel ident_len], rax

    call codegen_load_array_element

    call parser_next

    ret

parser_primary_paren:
    call parser_next

    call parser_expression

    cmp rax, TOK_RPAREN
    jne near parser_error_rparen

    call parser_next

    ret


; ============================================================
; COMPARISONS
; ============================================================

parser_expression_eq:
    call codegen_save_value

    call parser_next

    call parser_expression_additive

    mov [rel temp_delim], rax

    call codegen_cmp_eq

    mov rax, [rel temp_delim]

    ret

parser_expression_lt:
    call codegen_save_value

    call parser_next

    call parser_expression_additive

    mov [rel temp_delim], rax

    call codegen_cmp_lt

    mov rax, [rel temp_delim]

    ret

parser_expression_gt:
    call codegen_save_value

    call parser_next

    call parser_expression_additive

    mov [rel temp_delim], rax

    call codegen_cmp_gt

    mov rax, [rel temp_delim]

    ret

parser_expression_lte:
    call codegen_save_value

    call parser_next

    call parser_expression_additive

    mov [rel temp_delim], rax

    call codegen_cmp_lte

    mov rax, [rel temp_delim]

    ret

parser_expression_gte:
    call codegen_save_value

    call parser_next

    call parser_expression_additive

    mov [rel temp_delim], rax

    call codegen_cmp_gte

    mov rax, [rel temp_delim]

    ret


; ============================================================
; GLOBAL CONSTANTS
; ============================================================

parser_global_const:
    mov [rel temp_type], rax

    call parser_next

    cmp rax, TOK_IDENT
    jne near parser_error_ident

    mov rax, [rel ident_ptr]
    mov [rel decl_name_ptr], rax

    mov rax, [rel ident_len]
    mov [rel decl_name_len], rax

    call parser_next

    cmp rax, TOK_EQUAL
    jne near parser_error_equal

    call parser_next

    cmp rax, TOK_NUMBER
    je near parser_global_const_number

    cmp rax, TOK_NULL
    je near parser_global_const_null

    cmp rax, TOK_CHAR
    je near parser_global_const_char

    cmp rax, TOK_MINUS
    je near parser_global_const_negative

    cmp rax, TOK_IDENT
    je near parser_global_const_identifier

    jmp near parser_error_const

parser_global_const_number:
    mov rax, [rel current_number]
    mov [rel temp_value], rax
    jmp near parser_global_const_store

parser_global_const_null:
    xor rax, rax
    mov [rel temp_value], rax
    jmp near parser_global_const_store

parser_global_const_char:
    mov rax, [rel token_value]
    mov [rel temp_value], rax
    jmp near parser_global_const_store

parser_global_const_negative:
    call parser_next

    cmp rax, TOK_NUMBER
    jne near parser_error_const

    mov rax, [rel current_number]

    neg rax

    mov [rel temp_value], rax

    jmp near parser_global_const_store

parser_global_const_identifier:
    call parser_find_symbol

    test rax, rax
    jz near parser_error_undefined

    cmp qword [rax + SYM_KIND], SYM_CONST
    jne near parser_error_const

    mov rax, [rax + SYM_VALUE]

    mov [rel temp_value], rax

parser_global_const_store:
    mov rcx, [rel symbol_count]

    cmp rcx, SYM_MAX
    jae near parser_error_symtab

    imul rcx, SYM_SIZE

    lea rdi, [rel symbol_table]

    add rdi, rcx

    mov rax, [rel decl_name_ptr]
    mov [rdi + SYM_NAME_PTR], rax

    mov rax, [rel decl_name_len]
    mov [rdi + SYM_NAME_LEN], rax

    mov rax, [rel temp_type]
    mov [rdi + SYM_TYPE], rax

    mov qword [rdi + SYM_KIND], SYM_CONST

    mov rax, [rel temp_value]
    mov [rdi + SYM_VALUE], rax

    inc qword [rel symbol_count]

    call parser_next

    cmp rax, TOK_NEWLINE
    je near parser_top

    cmp rax, TOK_EOF
    je near parser_done

    jmp near parser_error_unknown


; ============================================================
; TYPE CHECK & SYMBOL HELPERS
; ============================================================

parser_is_type:
    xor r8d, r8d

    cmp rax, TOK_INT8
    je near parser_is_type_yes

    cmp rax, TOK_NAT8
    je near parser_is_type_yes

    cmp rax, TOK_INT16
    je near parser_is_type_yes

    cmp rax, TOK_NAT16
    je near parser_is_type_yes

    cmp rax, TOK_INT32
    je near parser_is_type_yes

    cmp rax, TOK_NAT32
    je near parser_is_type_yes

    cmp rax, TOK_INT64
    je near parser_is_type_yes

    cmp rax, TOK_NAT64
    je near parser_is_type_yes

    cmp rax, TOK_CHR
    je near parser_is_type_yes

%ifdef TOK_BOOL
    cmp rax, TOK_BOOL
    je near parser_is_type_yes
%endif

    ret

parser_is_type_yes:
    mov r8d, 1

    ret


parser_add_symbol:
    mov rcx, [rel symbol_count]

    cmp rcx, SYM_MAX
    jae near parser_error_symtab

    imul rcx, SYM_SIZE

    lea rdi, [rel symbol_table]

    add rdi, rcx

    mov rax, [rel ident_ptr]
    mov [rdi + SYM_NAME_PTR], rax

    mov rax, [rel ident_len]
    mov [rdi + SYM_NAME_LEN], rax

    mov [rdi + SYM_TYPE], r8

    mov [rdi + SYM_KIND], r9

    xor eax, eax
    mov [rdi + SYM_VALUE], rax

    inc qword [rel symbol_count]

    ret


parser_find_symbol:
    lea rdi, [rel symbol_table]

    mov rcx, [rel symbol_count]

parser_find_loop:
    test rcx, rcx
    jz near parser_find_not_found

    mov r8, [rdi + SYM_NAME_LEN]

    cmp r8, [rel ident_len]
    jne near parser_find_next

    mov rsi, [rel ident_ptr]
    mov rdx, [rdi + SYM_NAME_PTR]

    mov r9, r8

parser_find_compare:
    test r9, r9
    jz near parser_find_found

    mov al, [rsi]

    cmp al, [rdx]
    jne near parser_find_next

    inc rsi
    inc rdx

    dec r9

    jmp near parser_find_compare

parser_find_next:
    add rdi, SYM_SIZE

    dec rcx

    jmp near parser_find_loop

parser_find_found:
    mov rax, rdi

    ret

parser_find_not_found:
    xor eax, eax
    ret


; ============================================================
; ERROR HANDLERS
; ============================================================

parser_fatal:
    mov eax, SYS_WRITE
    mov edi, STDERR
    syscall

    mov eax, SYS_EXIT
    mov edi, 1
    syscall


parser_error_ident:
    lea rsi, [rel msg_ident]
    mov edx, msg_ident_len
    jmp parser_fatal

parser_error_lparen:
    lea rsi, [rel msg_lparen]
    mov edx, msg_lparen_len
    jmp parser_fatal

parser_error_rparen:
    lea rsi, [rel msg_rparen]
    mov edx, msg_rparen_len
    jmp parser_fatal

parser_error_lbrace:
    lea rsi, [rel msg_lbrace]
    mov edx, msg_lbrace_len
    jmp parser_fatal

parser_error_rbrace:
    lea rsi, [rel msg_rbrace]
    mov edx, msg_rbrace_len
    jmp parser_fatal

parser_error_rbrack:
    lea rsi, [rel msg_rbrack]
    mov edx, msg_rbrack_len
    jmp parser_fatal

parser_error_equal:
    lea rsi, [rel msg_equal]
    mov edx, msg_equal_len
    jmp parser_fatal

parser_error_type:
    lea rsi, [rel msg_type]
    mov edx, msg_type_len
    jmp parser_fatal

parser_error_expr:
    lea rsi, [rel msg_expr]
    mov edx, msg_expr_len
    jmp parser_fatal

parser_error_else:
    lea rsi, [rel msg_else]
    mov edx, msg_else_len
    jmp parser_fatal

parser_error_unknown:
    lea rsi, [rel msg_unknown]
    mov edx, msg_unknown_len
    jmp parser_fatal

parser_error_use:
    lea rsi, [rel msg_use]
    mov edx, msg_use_len
    jmp parser_fatal

parser_error_use_file:
    lea rsi, [rel msg_use_file]
    mov edx, msg_use_file_len
    jmp parser_fatal

parser_error_symtab:
    lea rsi, [rel msg_symtab]
    mov edx, msg_symtab_len
    jmp parser_fatal

parser_error_const:
    lea rsi, [rel msg_const]
    mov edx, msg_const_len
    jmp parser_fatal

parser_error_not_function:
    lea rsi, [rel msg_not_function]
    mov edx, msg_not_function_len
    jmp parser_fatal

parser_error_call_args:
    lea rsi, [rel msg_call_args]
    mov edx, msg_call_args_len
    jmp parser_fatal

parser_error_call_count:
    lea rsi, [rel msg_call_count]
    mov edx, msg_call_count_len
    jmp parser_fatal

parser_error_undefined:
    mov eax, SYS_WRITE
    mov edi, STDERR
    lea rsi, [rel msg_undefined]
    mov edx, msg_undefined_len
    syscall

    mov eax, SYS_WRITE
    mov edi, STDERR
    mov rsi, [rel ident_ptr]
    mov rdx, [rel ident_len]
    syscall

    mov eax, SYS_WRITE
    mov edi, STDERR
    lea rsi, [rel msg_quote]
    mov edx, msg_quote_len
    syscall

    mov eax, SYS_EXIT
    mov edi, 1
    syscall

parser_done:
    ret