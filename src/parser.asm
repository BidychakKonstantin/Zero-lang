%include "src/include/tokens.inc"

default rel


; ============================================================
; GLOBAL
; ============================================================

global parser_parse
global symbol_table


; ============================================================
; LEXER
; ============================================================

extern lexer_next_token
extern lexer_use_file

extern ident_ptr
extern ident_len

extern string_ptr
extern string_len

extern current_number
extern token_value


; ============================================================
; CODEGEN
; ============================================================

extern codegen_set_global
extern codegen_set_local

extern codegen_function_start
extern codegen_function_end

extern codegen_call_function
extern codegen_return

extern codegen_truncate_int8
extern codegen_truncate_nat8
extern codegen_truncate_int16
extern codegen_truncate_nat16
extern codegen_truncate_int32
extern codegen_truncate_nat32

extern codegen_load_number
extern codegen_load_variable
extern codegen_load_array_element
extern codegen_load_char
extern codegen_load_string

extern codegen_declare_variable
extern codegen_load_arg_register
extern codegen_store_variable
extern codegen_save_value
extern codegen_dereference

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
extern codegen_rep_start_condition
extern codegen_rep_condition_check
extern codegen_rep_end

extern codegen_print


; ============================================================
; SYSTEM
; ============================================================

%define SYS_WRITE 1
%define SYS_EXIT  60

%define STDOUT 1
%define STDERR 2


; ============================================================
; SYMBOL KINDS
; ============================================================

%define SYM_FUNC        1
%define SYM_VAR         2
%define SYM_CONST       3
%define SYM_GLOBAL_VAR  4


; ============================================================
; SCOPE
; ============================================================

%define SCOPE_GLOBAL 0
%define SCOPE_LOCAL  1


; ============================================================
; SYMBOL TABLE
;
; +0   name ptr
; +8   name len
; +16  type
; +24  kind
; +32  value
; +40  scope
;
; = 48 bytes
; ============================================================

%define SYM_MAX  1024
%define SYM_SIZE 48

%define SYM_NAME_PTR 0
%define SYM_NAME_LEN 8
%define SYM_TYPE     16
%define SYM_KIND     24
%define SYM_VALUE    32
%define SYM_SCOPE    40


%define MAX_CALL_ARGS 6


; ============================================================
; ERROR MESSAGES
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


msg_global_init:
    db "Syntax Error: Global variable must be initialized with 0 or NULL", 10
msg_global_init_len equ $ - msg_global_init


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


; ============================================================
; CALL ARGUMENT OUTPUT
; ============================================================

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


; Left side of assignment.
assign_symbol:
    resq 1


temp_type:
    resq 1


temp_value:
    resq 1


current_function:
    resq 1


function_scope_base:
    resq 1


current_call_symbol:
    resq 1


call_arg_count:
    resq 1


; ============================================================
; TEXT
; ============================================================

section .text


; ============================================================
; ENTRY
; ============================================================

parser_parse:

    xor eax, eax

    mov [rel symbol_count], rax
    mov [rel current_token], rax

    mov [rel current_function], rax
    mov [rel function_scope_base], rax

    mov [rel current_call_symbol], rax
    mov [rel call_arg_count], rax

    mov [rel assign_symbol], rax


    call parser_next

    jmp parser_top


; ============================================================
; NEXT TOKEN
; ============================================================

parser_next:

    call lexer_next_token

    mov [rel current_token], rax

    ret


; ============================================================
; SKIP NEWLINES
; ============================================================

parser_skip_newlines:

.loop:

    cmp qword [rel current_token], TOK_NEWLINE
    jne .done

    call parser_next

    jmp .loop


.done:

    ret


; ============================================================
; EXPECT {
; ============================================================

parser_expect_lbrace:

    call parser_skip_newlines

    cmp qword [rel current_token], TOK_LBRACE
    jne parser_error_lbrace

    ret


; ============================================================
; TOP LEVEL
; ============================================================

parser_top:

    mov rax, [rel current_token]


    cmp rax, TOK_EOF
    je parser_done


    cmp rax, TOK_NEWLINE
    je parser_top_newline


    cmp rax, TOK_USE
    je parser_top_use


    cmp rax, TOK_INT8
    je parser_global_declaration

    cmp rax, TOK_NAT8
    je parser_global_declaration

    cmp rax, TOK_INT16
    je parser_global_declaration

    cmp rax, TOK_NAT16
    je parser_global_declaration

    cmp rax, TOK_INT32
    je parser_global_declaration

    cmp rax, TOK_NAT32
    je parser_global_declaration

    cmp rax, TOK_INT64
    je parser_global_declaration

    cmp rax, TOK_NAT64
    je parser_global_declaration

    cmp rax, TOK_CHR
    je parser_global_declaration


%ifdef TOK_BOOL

    cmp rax, TOK_BOOL
    je parser_global_declaration

%endif


    cmp rax, TOK_IDENT
    je parser_function


    jmp parser_error_unknown


parser_top_newline:

    call parser_next

    jmp parser_top


; ============================================================
; USE
; ============================================================

parser_top_use:

    call parser_next


    cmp qword [rel current_token], TOK_STRING
    jne parser_error_use


    mov rdi, [rel string_ptr]
    mov rsi, [rel string_len]


    call lexer_use_file


    test rax, rax
    js parser_error_use_file


    call parser_next


    jmp parser_top


; ============================================================
; GLOBAL DECLARATION
; ============================================================

parser_global_declaration:

    mov [rel decl_type], rax


    xor r9d, r9d


    call parser_next


    cmp qword [rel current_token], TOK_STAR
    jne .pointer_done


    mov r9d, 1

    call parser_next


.pointer_done:

    cmp qword [rel current_token], TOK_IDENT
    jne parser_error_ident


    mov rax, [rel ident_ptr]
    mov [rel decl_name_ptr], rax


    mov rax, [rel ident_len]
    mov [rel decl_name_len], rax


    call parser_next


    cmp qword [rel current_token], TOK_EQUAL
    jne parser_error_equal


    call parser_is_legacy_constant_name


    test eax, eax
    jnz parser_global_const_after_equal


    jmp parser_global_variable_after_equal


; ============================================================
; TOK_* NAME
; ============================================================

parser_is_legacy_constant_name:

    mov rcx, [rel decl_name_len]


    cmp rcx, 4
    jb .no


    mov rsi, [rel decl_name_ptr]


    cmp byte [rsi], 'T'
    jne .no

    cmp byte [rsi + 1], 'O'
    jne .no

    cmp byte [rsi + 2], 'K'
    jne .no

    cmp byte [rsi + 3], '_'
    jne .no


    mov eax, 1

    ret


.no:

    xor eax, eax

    ret


; ============================================================
; GLOBAL CONST
; ============================================================

parser_global_const_after_equal:

    call parser_next


    mov rax, [rel current_token]


    cmp rax, TOK_NUMBER
    je .number

    cmp rax, TOK_NULL
    je .null

    cmp rax, TOK_CHAR
    je .char

    cmp rax, TOK_MINUS
    je .negative

    cmp rax, TOK_IDENT
    je .identifier


    jmp parser_error_const


.number:

    mov rax, [rel current_number]

    mov [rel temp_value], rax

    jmp parser_global_const_store


.null:

    xor eax, eax

    mov [rel temp_value], rax

    jmp parser_global_const_store


.char:

    mov rax, [rel token_value]

    mov [rel temp_value], rax

    jmp parser_global_const_store


.negative:

    call parser_next


    cmp qword [rel current_token], TOK_NUMBER
    jne parser_error_const


    mov rax, [rel current_number]

    neg rax

    mov [rel temp_value], rax


    jmp parser_global_const_store


.identifier:

    call parser_find_symbol


    test rax, rax
    jz parser_error_undefined


    cmp qword [rax + SYM_KIND], SYM_CONST
    jne parser_error_const


    mov rax, [rax + SYM_VALUE]

    mov [rel temp_value], rax


    jmp parser_global_const_store


parser_global_const_store:

    mov rcx, [rel symbol_count]


    cmp rcx, SYM_MAX
    jae parser_error_symtab


    imul rcx, SYM_SIZE


    lea rdi, [rel symbol_table]

    add rdi, rcx


    mov rax, [rel decl_name_ptr]

    mov [rdi + SYM_NAME_PTR], rax


    mov rax, [rel decl_name_len]

    mov [rdi + SYM_NAME_LEN], rax


    mov rax, [rel decl_type]


    test r9d, r9d

    jz .type_done


    bts rax, 63


.type_done:

    mov [rdi + SYM_TYPE], rax

    mov qword [rdi + SYM_KIND], SYM_CONST
    mov qword [rdi + SYM_SCOPE], SCOPE_GLOBAL


    mov rax, [rel temp_value]

    mov [rdi + SYM_VALUE], rax


    inc qword [rel symbol_count]


    call parser_next


    cmp qword [rel current_token], TOK_NEWLINE
    je parser_top


    cmp qword [rel current_token], TOK_EOF
    je parser_done


    jmp parser_error_unknown


; ============================================================
; GLOBAL VARIABLE
; ============================================================

parser_global_variable_after_equal:

    call parser_next


    mov rax, [rel current_token]


    cmp rax, TOK_NUMBER
    je .number

    cmp rax, TOK_NULL
    je .null


    jmp parser_error_global_init


.number:

    mov rax, [rel current_number]

    test rax, rax

    jnz parser_error_global_init


    jmp parser_global_variable_store


.null:

    jmp parser_global_variable_store


parser_global_variable_store:

    mov rcx, [rel symbol_count]


    cmp rcx, SYM_MAX
    jae parser_error_symtab


    imul rcx, SYM_SIZE


    lea rdi, [rel symbol_table]

    add rdi, rcx


    mov rax, [rel decl_name_ptr]

    mov [rdi + SYM_NAME_PTR], rax


    mov rax, [rel decl_name_len]

    mov [rdi + SYM_NAME_LEN], rax


    mov rax, [rel decl_type]


    test r9d, r9d

    jz .type_done


    bts rax, 63


.type_done:

    mov [rdi + SYM_TYPE], rax

    mov qword [rdi + SYM_KIND], SYM_GLOBAL_VAR
    mov qword [rdi + SYM_SCOPE], SCOPE_GLOBAL


    xor eax, eax

    mov [rdi + SYM_VALUE], rax


    inc qword [rel symbol_count]


    call codegen_set_global


    mov rax, [rel decl_name_ptr]

    mov [rel ident_ptr], rax


    mov rax, [rel decl_name_len]

    mov [rel ident_len], rax


    call codegen_declare_variable


    call parser_next


    cmp qword [rel current_token], TOK_NEWLINE
    je parser_top


    cmp qword [rel current_token], TOK_EOF
    je parser_done


    jmp parser_error_unknown


; ============================================================
; FUNCTION
; ============================================================

parser_function:

    mov rax, [rel ident_ptr]

    mov [rel decl_name_ptr], rax


    mov rax, [rel ident_len]

    mov [rel decl_name_len], rax


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


    cmp qword [rel current_token], TOK_LPAREN
    jne parser_error_lparen


    call parser_args


    call parser_next

    call parser_skip_newlines


    cmp qword [rel current_token], TOK_ARROW
    je parser_function_return_type


    cmp qword [rel current_token], TOK_LBRACE
    je parser_function_body


    jmp parser_error_lbrace


; ============================================================
; RETURN TYPE
; ============================================================

parser_function_return_type:

    call parser_next


    xor r9d, r9d


    cmp qword [rel current_token], TOK_STAR
    jne .leading_done


    mov r9d, 1

    call parser_next


.leading_done:

    mov rax, [rel current_token]


    call parser_is_type


    test r8d, r8d

    jz parser_error_type


    mov [rel temp_type], rax


    call parser_next


    cmp qword [rel current_token], TOK_STAR
    jne .trailing_done


    mov r9d, 1

    call parser_next


.trailing_done:

    call parser_skip_newlines


    cmp qword [rel current_token], TOK_LBRACE
    jne parser_error_lbrace


    mov rax, [rel temp_type]


    test r9d, r9d

    jz .plain


    bts rax, 63


.plain:

    mov r10, [rel current_function]


    test r10, r10

    jz parser_error_type


    mov [r10 + SYM_TYPE], rax


    jmp parser_function_body


; ============================================================
; FUNCTION BODY
; ============================================================

parser_function_body:

    call parser_body


    call codegen_function_end


    ; Remove local symbols.
    mov rax, [rel function_scope_base]

    mov [rel symbol_count], rax


    xor eax, eax

    mov [rel current_function], rax
    mov [rel function_scope_base], rax


    ; parser_body leaves }.
    call parser_next


    jmp parser_top


; ============================================================
; ARGUMENTS
; ============================================================

parser_args:

    call parser_next


    cmp qword [rel current_token], TOK_RPAREN
    je parser_args_done


parser_args_loop:

    mov r10, [rel current_function]


    test r10, r10

    jz parser_error_type


    mov rdx, [r10 + SYM_VALUE]


    cmp rdx, MAX_CALL_ARGS
    jae parser_error_call_args


    xor r9d, r9d


    cmp qword [rel current_token], TOK_STAR
    jne .leading_done


    mov r9d, 1

    call parser_next


.leading_done:

    mov rax, [rel current_token]


    call parser_is_type


    test r8d, r8d

    jz parser_error_type


    mov [rel temp_type], rax


    call parser_next


    cmp qword [rel current_token], TOK_STAR
    jne .trailing_done


    mov r9d, 1

    call parser_next


.trailing_done:

    cmp qword [rel current_token], TOK_IDENT
    jne parser_error_ident


    mov r8, [rel temp_type]


    test r9d, r9d

    jz .type_done


    bts r8, 63


.type_done:

    mov r9d, SYM_VAR


    call parser_add_symbol


    ; Newly created argument.
    mov rcx, [rel symbol_count]

    dec rcx

    imul rcx, SYM_SIZE


    lea r10, [rel symbol_table]

    add r10, rcx


    mov qword [r10 + SYM_SCOPE], SCOPE_LOCAL


    call codegen_set_local


    call codegen_declare_variable


    mov r10, [rel current_function]

    mov rax, [r10 + SYM_VALUE]


    call codegen_load_arg_register


    call codegen_set_local

    call codegen_store_variable


    mov r10, [rel current_function]

    mov rax, [r10 + SYM_VALUE]

    inc rax


    mov [r10 + SYM_VALUE], rax


    call parser_next


    cmp qword [rel current_token], TOK_COMMA
    je parser_args_comma


    cmp qword [rel current_token], TOK_RPAREN
    je parser_args_done


    jmp parser_error_rparen


parser_args_comma:

    call parser_next

    jmp parser_args_loop


parser_args_done:

    ret


; ============================================================
; BODY
;
; IMPORTANT:
;
; Each statement handler returns back here.
;
; Only TOK_RBRACE terminates the body.
; ============================================================

parser_body:

    cmp qword [rel current_token], TOK_LBRACE
    jne parser_error_lbrace


    call parser_next


parser_body_loop:

    mov rax, [rel current_token]


    ; --------------------------------------------------------
    ; End of this body.
    ; --------------------------------------------------------

    cmp rax, TOK_RBRACE
    je parser_body_done


    cmp rax, TOK_EOF
    je parser_error_rbrace


    cmp rax, TOK_NEWLINE
    je parser_body_newline


    ; --------------------------------------------------------
    ; USE
    ; --------------------------------------------------------

    cmp rax, TOK_USE
    je parser_body_use


    ; --------------------------------------------------------
    ; LOCAL DECLARATIONS
    ; --------------------------------------------------------

    cmp rax, TOK_INT8
    je parser_body_statement_variable

    cmp rax, TOK_NAT8
    je parser_body_statement_variable

    cmp rax, TOK_INT16
    je parser_body_statement_variable

    cmp rax, TOK_NAT16
    je parser_body_statement_variable

    cmp rax, TOK_INT32
    je parser_body_statement_variable

    cmp rax, TOK_NAT32
    je parser_body_statement_variable

    cmp rax, TOK_INT64
    je parser_body_statement_variable

    cmp rax, TOK_NAT64
    je parser_body_statement_variable

    cmp rax, TOK_CHR
    je parser_body_statement_variable


%ifdef TOK_BOOL

    cmp rax, TOK_BOOL
    je parser_body_statement_variable

%endif


    ; --------------------------------------------------------
    ; IF
    ; --------------------------------------------------------

    cmp rax, TOK_IF
    je parser_body_statement_if


    ; --------------------------------------------------------
    ; REP
    ; --------------------------------------------------------

    cmp rax, TOK_REP
    je parser_body_statement_rep


    ; --------------------------------------------------------
    ; RETURN
    ; --------------------------------------------------------

    cmp rax, TOK_RET
    je parser_body_statement_return


    ; --------------------------------------------------------
    ; IDENTIFIER
    ;
    ; Either assignment or function call.
    ; --------------------------------------------------------

    cmp rax, TOK_IDENT
    je parser_body_statement_ident


    ; --------------------------------------------------------
    ; Any other expression statement.
    ; --------------------------------------------------------

    call parser_expression


    cmp qword [rel current_token], TOK_NEWLINE
    je parser_body_newline


    cmp qword [rel current_token], TOK_RBRACE
    je parser_body_done


    jmp parser_error_unknown


; ============================================================
; NORMAL BODY NEWLINE
; ============================================================

parser_body_newline:

    call parser_next

    jmp parser_body_loop


; ============================================================
; BODY DONE
; ============================================================

parser_body_done:

    ret


; ============================================================
; BODY STATEMENT WRAPPERS
;
; Every wrapper calls one statement parser and then explicitly
; returns to parser_body_loop.
; ============================================================

parser_body_statement_variable:

    call parser_variable

    jmp parser_body_loop


parser_body_statement_if:

    call parser_if

    jmp parser_body_loop


parser_body_statement_rep:

    call parser_rep

    jmp parser_body_loop


parser_body_statement_return:

    call parser_return

    ; return handler can leave us at newline or }.
    cmp qword [rel current_token], TOK_RBRACE
    je parser_body_done

    cmp qword [rel current_token], TOK_EOF
    je parser_body_done

    jmp parser_body_loop


parser_body_statement_ident:

    call parser_body_ident

    jmp parser_body_loop


; ============================================================
; IDENTIFIER STATEMENT
; ============================================================

parser_body_ident:

    mov rax, [rel ident_ptr]

    mov [rel decl_name_ptr], rax
    mov [rel expr_name_ptr], rax


    mov rax, [rel ident_len]

    mov [rel decl_name_len], rax
    mov [rel expr_name_len], rax


    call parser_next


    cmp qword [rel current_token], TOK_EQUAL
    je parser_assign_variable


    cmp qword [rel current_token], TOK_LPAREN
    je parser_statement_call


    jmp parser_error_unknown


; ============================================================
; ASSIGNMENT
; ============================================================

parser_assign_variable:

    ; Save LHS identifier.
    mov rax, [rel decl_name_ptr]

    mov [rel ident_ptr], rax


    mov rax, [rel decl_name_len]

    mov [rel ident_len], rax


    ; Find LHS symbol.
    call parser_find_symbol


    test rax, rax
    jz parser_error_undefined


    ; CRITICAL:
    ; Keep LHS symbol independent from RHS.
    mov [rel assign_symbol], rax


    ; Set scope for RHS generation initially.
    cmp qword [rax + SYM_SCOPE], SCOPE_GLOBAL
    je .lhs_global


    call codegen_set_local

    jmp .parse_rhs


.lhs_global:

    call codegen_set_global


.parse_rhs:

    call parser_next


    call parser_expression


    ; RHS may have changed codegen scope.
    ; Restore scope using assign_symbol.
    mov r10, [rel assign_symbol]


    cmp qword [r10 + SYM_SCOPE], SCOPE_GLOBAL
    je .store_global


    call codegen_set_local

    jmp .store


.store_global:

    call codegen_set_global


.store:

    mov rax, [rel decl_name_ptr]

    mov [rel ident_ptr], rax


    mov rax, [rel decl_name_len]

    mov [rel ident_len], rax


    call codegen_store_variable


    cmp qword [rel current_token], TOK_NEWLINE
    je parser_body_newline


    cmp qword [rel current_token], TOK_RBRACE
    je parser_body_done


    jmp parser_error_unknown


; ============================================================
; CALL STATEMENT
; ============================================================

parser_statement_call:

    call parser_primary_call


    cmp qword [rel current_token], TOK_NEWLINE
    je parser_body_newline


    cmp qword [rel current_token], TOK_RBRACE
    je parser_body_done


    cmp qword [rel current_token], TOK_EOF
    je parser_body_done


    jmp parser_error_unknown


; ============================================================
; USE INSIDE BODY
; ============================================================

parser_body_use:

    call parser_next


    cmp qword [rel current_token], TOK_STRING
    jne parser_error_use


    mov rdi, [rel string_ptr]

    mov rsi, [rel string_len]


    call lexer_use_file


    test rax, rax

    js parser_error_use_file


    call parser_next


    jmp parser_body_loop


; ============================================================
; LOCAL VARIABLE
; ============================================================

parser_variable:

    mov [rel decl_type], rax


    xor r9d, r9d


    call parser_next


    cmp qword [rel current_token], TOK_STAR
    jne .pointer_done


    mov r9d, 1

    call parser_next


.pointer_done:

    cmp qword [rel current_token], TOK_IDENT
    jne parser_error_ident


    mov rax, [rel ident_ptr]

    mov [rel decl_name_ptr], rax


    mov rax, [rel ident_len]

    mov [rel decl_name_len], rax


    mov rax, [rel decl_type]


    test r9d, r9d

    jz .type_plain


    bts rax, 63


.type_plain:

    mov [rel decl_type], rax


    call parser_next


    cmp qword [rel current_token], TOK_EQUAL
    jne parser_error_equal


    ; Add local symbol.
    mov r8, [rel decl_type]

    mov r9d, SYM_VAR


    mov rax, [rel decl_name_ptr]

    mov [rel ident_ptr], rax


    mov rax, [rel decl_name_len]

    mov [rel ident_len], rax


    call parser_add_symbol


    ; Mark newly created symbol LOCAL.
    mov rcx, [rel symbol_count]

    dec rcx

    imul rcx, SYM_SIZE


    lea r10, [rel symbol_table]

    add r10, rcx


    mov qword [r10 + SYM_SCOPE], SCOPE_LOCAL


    call codegen_set_local

    call codegen_declare_variable


    call parser_next


    call parser_expression


    ; RHS can change scope.
    call codegen_set_local


    mov rax, [rel decl_name_ptr]

    mov [rel ident_ptr], rax


    mov rax, [rel decl_name_len]

    mov [rel ident_len], rax


    call codegen_store_variable


    cmp qword [rel current_token], TOK_NEWLINE
    je parser_body_newline


    cmp qword [rel current_token], TOK_RBRACE
    je parser_body_done


    jmp parser_error_unknown


; ============================================================
; RETURN
; ============================================================

parser_return:

    call parser_next


    ; Empty return.
    cmp qword [rel current_token], TOK_NEWLINE
    je .bare


    cmp qword [rel current_token], TOK_RBRACE
    je .bare


    cmp qword [rel current_token], TOK_EOF
    je .bare


    ; Return expression.
    call parser_expression


.bare:

    call parser_emit_return_truncation

    call codegen_return


    ; Leave current token untouched.
    ret


; ============================================================
; RETURN TYPE TRUNCATION
;
; Looks at the currently-compiling function's declared return
; type (SYM_TYPE on current_function) and, if it is one of the
; fixed-width non-pointer types, emits the matching truncation
; instruction so the value actually returned in RAX is cut down
; (and sign/zero-extended back to 64 bits) to what that type can
; hold. int64 / nat64 / an unset type / pointer types (bit 63 of
; SYM_TYPE set) are left alone -- they already use the full
; 64-bit width, or aren't a fixed-width value to truncate.
; ============================================================

parser_emit_return_truncation:

    mov r10, [rel current_function]

    test r10, r10
    jz .no_trunc


    mov rax, [r10 + SYM_TYPE]


    ; Pointer return type ("chr* foo() -> ...")? Never truncate
    ; an address.
    bt rax, 63
    jc .no_trunc


    cmp rax, TOK_INT8
    je .int8

    cmp rax, TOK_NAT8
    je .nat8

    cmp rax, TOK_INT16
    je .int16

    cmp rax, TOK_NAT16
    je .nat16

    cmp rax, TOK_INT32
    je .int32

    cmp rax, TOK_NAT32
    je .nat32

    cmp rax, TOK_CHR
    je .nat8


    ; TOK_INT64 / TOK_NAT64 / no declared type (0) / anything
    ; else: full 64-bit width, nothing to do.
    jmp .no_trunc


.int8:

    call codegen_truncate_int8

    ret


.nat8:

    call codegen_truncate_nat8

    ret


.int16:

    call codegen_truncate_int16

    ret


.nat16:

    call codegen_truncate_nat16

    ret


.int32:

    call codegen_truncate_int32

    ret


.nat32:

    call codegen_truncate_nat32

    ret


.no_trunc:

    ret


; ============================================================
; IF
; ============================================================

parser_if:

    call parser_next


    call parser_expression


    call parser_expect_lbrace


    call codegen_if_start


    ; parser_body leaves current_token = then }
    call parser_body


    ; Consume then }.
    call parser_next


    cmp qword [rel current_token], TOK_ELSE
    je parser_if_else


    ; No else.
    call codegen_if_end


    ; Leave current token at the token after the IF.
    ret


; ============================================================
; ELSE
; ============================================================

parser_if_else:

    call codegen_if_else


    call parser_next


    call parser_expect_lbrace


    call parser_body


    ; Finish IF.
    call codegen_if_end


    ; Consume else }.
    call parser_next


    ret


; ============================================================
; REP
; ============================================================

parser_rep:

    call parser_next


    cmp qword [rel current_token], TOK_NUMBER
    je parser_rep_number


    ; Conditional rep.
    call codegen_rep_start_condition


    call parser_expression


    call parser_expect_lbrace


    call codegen_rep_condition_check


    call parser_body


    call codegen_rep_end


    ; Consume }.
    call parser_next


    ret


; ============================================================
; REP NUMBER
; ============================================================

parser_rep_number:

    ; Save NUMBER.
    mov rax, [rel current_number]

    push rax


    call parser_next


    call parser_expect_lbrace


    pop rdi


    call codegen_rep_start


    call parser_body


    call codegen_rep_end


    ; Consume }.
    call parser_next


    ret


; ============================================================
; EXPRESSION
; ============================================================

parser_expression:

    call parser_expression_additive

    ret


parser_expression_additive:

    call parser_expression_multiplicative


parser_expression_additive_loop:

    mov rax, [rel current_token]


    cmp rax, TOK_PLUS
    je parser_expression_add


    cmp rax, TOK_MINUS
    je parser_expression_sub


    cmp rax, TOK_EQEQ
    je parser_expression_eq


    cmp rax, TOK_LT
    je parser_expression_lt


    cmp rax, TOK_GT
    je parser_expression_gt


    cmp rax, TOK_LTE
    je parser_expression_lte


    cmp rax, TOK_GTE
    je parser_expression_gte


    ret


parser_expression_add:

    call codegen_save_value


    call parser_next


    call parser_expression_multiplicative


    call codegen_add


    jmp parser_expression_additive_loop


parser_expression_sub:

    call codegen_save_value


    call parser_next


    call parser_expression_multiplicative


    call codegen_sub


    jmp parser_expression_additive_loop


parser_expression_multiplicative:

    call parser_expression_unary


parser_expression_multiplicative_loop:

    mov rax, [rel current_token]


    cmp rax, TOK_STAR
    je parser_expression_mul


    ret


parser_expression_mul:

    call codegen_save_value


    call parser_next


    call parser_expression_unary


    call codegen_mul


    jmp parser_expression_multiplicative_loop


parser_expression_unary:

    mov rax, [rel current_token]


    cmp rax, TOK_STAR
    je parser_unary_deref


    jmp parser_expression_primary


parser_unary_deref:

    call parser_next


    call parser_expression_unary


    call codegen_dereference


    ret


; ============================================================
; PRIMARY
; ============================================================

parser_expression_primary:

    mov rax, [rel current_token]


    cmp rax, TOK_NUMBER
    je parser_primary_number


    cmp rax, TOK_NULL
    je parser_primary_null


    cmp rax, TOK_CHAR
    je parser_primary_char


    cmp rax, TOK_STRING
    je parser_primary_string


    cmp rax, TOK_IDENT
    je parser_primary_identifier


    cmp rax, TOK_LPAREN
    je parser_primary_paren


    jmp parser_error_expr


parser_primary_number:

    call codegen_load_number

    call parser_next

    ret


parser_primary_null:

    xor eax, eax


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


; ============================================================
; BOOLEAN
; ============================================================

parser_is_bool_literal:

    mov rcx, [rel ident_len]

    mov rsi, [rel ident_ptr]


    cmp rcx, 4

    je .true


    cmp rcx, 5

    je .false


    xor eax, eax

    ret


.true:

    cmp byte [rsi], 't'
    jne .no


    cmp byte [rsi + 1], 'r'
    jne .no


    cmp byte [rsi + 2], 'u'
    jne .no


    cmp byte [rsi + 3], 'e'
    jne .no


    mov eax, 1

    mov r8, 1

    ret


.false:

    cmp byte [rsi], 'f'
    jne .no


    cmp byte [rsi + 1], 'a'
    jne .no


    cmp byte [rsi + 2], 'l'
    jne .no


    cmp byte [rsi + 3], 's'
    jne .no


    cmp byte [rsi + 4], 'e'
    jne .no


    mov eax, 1

    xor r8d, r8d

    ret


.no:

    xor eax, eax

    ret


parser_primary_bool:

    mov rax, r8


    mov [rel current_number], rax

    mov [rel token_value], rax


    call codegen_load_number


    call parser_next

    ret


; ============================================================
; PRIMARY IDENTIFIER
; ============================================================

parser_primary_identifier:

    mov rax, [rel ident_ptr]

    mov [rel expr_name_ptr], rax


    mov rax, [rel ident_len]

    mov [rel expr_name_len], rax


    ; true / false.
    call parser_is_bool_literal


    test eax, eax

    jnz parser_primary_bool


    ; Move past identifier.
    call parser_next


    cmp qword [rel current_token], TOK_LPAREN
    je parser_primary_call


    cmp qword [rel current_token], TOK_LBRACK
    je parser_primary_array


    ; Restore identifier.
    mov rax, [rel expr_name_ptr]

    mov [rel ident_ptr], rax


    mov rax, [rel expr_name_len]

    mov [rel ident_len], rax


    call parser_find_symbol


    test rax, rax

    jz parser_error_undefined


    mov [rel expr_symbol], rax


    cmp qword [rax + SYM_KIND], SYM_VAR
    je parser_primary_variable


    cmp qword [rax + SYM_KIND], SYM_GLOBAL_VAR
    je parser_primary_global_variable


    cmp qword [rax + SYM_KIND], SYM_CONST
    je parser_primary_constant


    jmp parser_error_expr


parser_primary_variable:

    call codegen_set_local


    mov rax, [rel expr_name_ptr]

    mov [rel ident_ptr], rax


    mov rax, [rel expr_name_len]

    mov [rel ident_len], rax


    call codegen_load_variable


    ret


parser_primary_global_variable:

    call codegen_set_global


    mov rax, [rel expr_name_ptr]

    mov [rel ident_ptr], rax


    mov rax, [rel expr_name_len]

    mov [rel ident_len], rax


    call codegen_load_variable


    ret


parser_primary_constant:

    mov rax, [rel expr_symbol]

    mov rax, [rax + SYM_VALUE]


    mov [rel current_number], rax

    mov [rel token_value], rax


    call codegen_load_number

    ret


; ============================================================
; FUNCTION CALL / PRINT
; ============================================================

parser_primary_call:

    push qword [rel expr_name_ptr]

    push qword [rel expr_name_len]


    mov rcx, [rel expr_name_len]


    cmp rcx, 5

    jne parser_primary_call_not_print


    mov rsi, [rel expr_name_ptr]


    cmp byte [rsi], 'p'
    jne parser_primary_call_not_print

    cmp byte [rsi + 1], 'r'
    jne parser_primary_call_not_print

    cmp byte [rsi + 2], 'i'
    jne parser_primary_call_not_print

    cmp byte [rsi + 3], 'n'
    jne parser_primary_call_not_print

    cmp byte [rsi + 4], 't'
    jne parser_primary_call_not_print


    call parser_next


    cmp qword [rel current_token], TOK_RPAREN
    je parser_print_empty


    call parser_expression


    cmp qword [rel current_token], TOK_RPAREN
    jne parser_error_rparen


parser_print_do:

    call codegen_print


    call parser_next


    pop qword [rel expr_name_len]

    pop qword [rel expr_name_ptr]


    ret


parser_print_empty:

    xor eax, eax

    mov [rel current_number], rax


    call codegen_load_number


    jmp parser_print_do


; ============================================================
; NORMAL FUNCTION CALL
; ============================================================

parser_primary_call_not_print:

    push qword [rel current_call_symbol]

    push qword [rel call_arg_count]


    mov rax, [rel expr_name_ptr]

    mov [rel ident_ptr], rax


    mov rax, [rel expr_name_len]

    mov [rel ident_len], rax


    call parser_find_symbol


    test rax, rax

    jz parser_error_undefined


    cmp qword [rax + SYM_KIND], SYM_FUNC

    jne parser_error_not_function


    mov [rel current_call_symbol], rax


    xor eax, eax

    mov [rel call_arg_count], rax


    call parser_next


    cmp qword [rel current_token], TOK_RPAREN

    je parser_call_no_args


    jmp parser_call_args


parser_call_args:

    mov rax, [rel call_arg_count]


    cmp rax, MAX_CALL_ARGS

    jae parser_error_call_args


    call parser_expression


    call codegen_save_value


    inc qword [rel call_arg_count]


    cmp qword [rel current_token], TOK_COMMA

    je parser_call_comma


    cmp qword [rel current_token], TOK_RPAREN

    je parser_call_done


    jmp parser_error_rparen


parser_call_comma:

    call parser_next

    jmp parser_call_args


parser_call_no_args:

    xor eax, eax

    mov [rel call_arg_count], rax


    jmp parser_call_done


parser_call_done:

    mov r10, [rel current_call_symbol]


    mov rcx, [r10 + SYM_VALUE]


    mov rax, [rel call_arg_count]


    cmp rax, rcx

    jne parser_error_call_count


    ; Emit the argument-loading code now, while call_arg_count
    ; still reflects THIS call's argument count. Popping it
    ; below restores the caller's saved value, which would
    ; leave parser_emit_call_arguments with the wrong count
    ; (and the pushed arguments stuck on the stack forever).
    call parser_emit_call_arguments


    pop qword [rel call_arg_count]

    pop qword [rel current_call_symbol]


    pop qword [rel expr_name_len]

    pop qword [rel expr_name_ptr]


    mov rax, [rel expr_name_ptr]

    mov [rel ident_ptr], rax


    mov rax, [rel expr_name_len]

    mov [rel ident_len], rax


    call codegen_call_function


    call parser_next


    ret


; ============================================================
; EMIT CALL ARGUMENTS
; ============================================================

parser_emit_call_arguments:

    mov rax, [rel call_arg_count]


    cmp rax, 6
    je parser_emit_args6


    cmp rax, 5
    je parser_emit_args5


    cmp rax, 4
    je parser_emit_args4


    cmp rax, 3
    je parser_emit_args3


    cmp rax, 2
    je parser_emit_args2


    cmp rax, 1
    je parser_emit_args1


    ret


parser_emit_args6:

    call parser_emit_arg_r9


parser_emit_args5:

    call parser_emit_arg_r8


parser_emit_args4:

    call parser_emit_arg_rcx


parser_emit_args3:

    call parser_emit_arg_rdx


parser_emit_args2:

    call parser_emit_arg_rsi


parser_emit_args1:

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


; ============================================================
; ARRAY
; ============================================================

parser_primary_array:

    call parser_next


    call parser_expression


    cmp qword [rel current_token], TOK_RBRACK

    jne parser_error_rbrack


    mov rax, [rel expr_name_ptr]

    mov [rel ident_ptr], rax


    mov rax, [rel expr_name_len]

    mov [rel ident_len], rax


    call parser_find_symbol


    test rax, rax

    jz parser_error_undefined


    mov [rel expr_symbol], rax


    cmp qword [rax + SYM_KIND], SYM_GLOBAL_VAR

    je .global


    call codegen_set_local

    jmp .emit


.global:

    call codegen_set_global


.emit:

    mov rax, [rel expr_name_ptr]

    mov [rel ident_ptr], rax


    mov rax, [rel expr_name_len]

    mov [rel ident_len], rax


    call codegen_load_array_element


    call parser_next

    ret


; ============================================================
; PAREN
; ============================================================

parser_primary_paren:

    call parser_next


    call parser_expression


    cmp qword [rel current_token], TOK_RPAREN

    jne parser_error_rparen


    call parser_next

    ret


; ============================================================
; COMPARISONS
; ============================================================

parser_expression_eq:

    call codegen_save_value

    call parser_next

    call parser_expression_additive

    call codegen_cmp_eq

    ret


parser_expression_lt:

    call codegen_save_value

    call parser_next

    call parser_expression_additive

    call codegen_cmp_lt

    ret


parser_expression_gt:

    call codegen_save_value

    call parser_next

    call parser_expression_additive

    call codegen_cmp_gt

    ret


parser_expression_lte:

    call codegen_save_value

    call parser_next

    call parser_expression_additive

    call codegen_cmp_lte

    ret


parser_expression_gte:

    call codegen_save_value

    call parser_next

    call parser_expression_additive

    call codegen_cmp_gte

    ret


; ============================================================
; TYPE
; ============================================================

parser_is_type:

    xor r8d, r8d


    cmp rax, TOK_INT8
    je parser_is_type_yes

    cmp rax, TOK_NAT8
    je parser_is_type_yes

    cmp rax, TOK_INT16
    je parser_is_type_yes

    cmp rax, TOK_NAT16
    je parser_is_type_yes

    cmp rax, TOK_INT32
    je parser_is_type_yes

    cmp rax, TOK_NAT32
    je parser_is_type_yes

    cmp rax, TOK_INT64
    je parser_is_type_yes

    cmp rax, TOK_NAT64
    je parser_is_type_yes

    cmp rax, TOK_CHR
    je parser_is_type_yes


%ifdef TOK_BOOL

    cmp rax, TOK_BOOL

    je parser_is_type_yes

%endif


    ret


parser_is_type_yes:

    mov r8d, 1

    ret


; ============================================================
; ADD SYMBOL
; ============================================================

parser_add_symbol:

    mov rcx, [rel symbol_count]


    cmp rcx, SYM_MAX

    jae parser_error_symtab


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


    ; Function and local variables are local by default.
    cmp r9, SYM_GLOBAL_VAR
    je .global


    cmp r9, SYM_CONST
    je .global


    mov qword [rdi + SYM_SCOPE], SCOPE_LOCAL

    jmp .done


.global:

    mov qword [rdi + SYM_SCOPE], SCOPE_GLOBAL


.done:

    inc qword [rel symbol_count]

    ret


; ============================================================
; FIND SYMBOL
;
; Newest declaration wins.
; ============================================================

parser_find_symbol:

    mov rcx, [rel symbol_count]


    test rcx, rcx

    jz parser_find_not_found


    dec rcx


.loop:

    mov r10, rcx

    imul r10, SYM_SIZE


    lea rdi, [rel symbol_table]

    add rdi, r10


    mov r8, [rdi + SYM_NAME_LEN]


    cmp r8, [rel ident_len]

    jne .next


    mov rsi, [rel ident_ptr]

    mov rdx, [rdi + SYM_NAME_PTR]

    mov r9, r8


.compare:

    test r9, r9

    jz .found


    mov al, [rsi]

    cmp al, [rdx]

    jne .next


    inc rsi

    inc rdx

    dec r9


    jmp .compare


.next:

    test rcx, rcx

    jz parser_find_not_found


    dec rcx

    jmp .loop


.found:

    mov rax, rdi

    ret


parser_find_not_found:

    xor eax, eax

    ret


; ============================================================
; ERRORS
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


parser_error_global_init:

    lea rsi, [rel msg_global_init]

    mov edx, msg_global_init_len

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


; ============================================================
; DONE
; ============================================================

parser_done:

    ret