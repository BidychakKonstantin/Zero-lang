%include "src/include/tokens.inc"

DEFAULT REL

global parser_parse
global symbol_table

extern lexer_next_token

extern ident_ptr
extern ident_len

extern codegen_load_number
extern codegen_load_variable
extern codegen_load_array_element
extern codegen_load_char
extern codegen_load_string

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


SYM_FUNC equ 1
SYM_VAR  equ 2

SYMTAB_MAX_ENTRIES equ 256


section .rodata

err_ident:
    db "Syntax Error: Expected identifier", 10
err_ident_len equ $ - err_ident

err_lparen:
    db "Syntax Error: Expected '('", 10
err_lparen_len equ $ - err_lparen

err_rparen:
    db "Syntax Error: Expected ')'", 10
err_rparen_len equ $ - err_rparen

err_lbrace:
    db "Syntax Error: Expected '{'", 10
err_lbrace_len equ $ - err_lbrace

err_rbrace:
    db "Syntax Error: Expected '}'", 10
err_rbrace_len equ $ - err_rbrace

err_equal:
    db "Syntax Error: Expected '='", 10
err_equal_len equ $ - err_equal

err_type:
    db "Type Error: Expected type", 10
err_type_len equ $ - err_type

err_expr:
    db "Syntax Error: Expected expression", 10
err_expr_len equ $ - err_expr

err_rbrack:
    db "Syntax Error: Expected ']'", 10
err_rbrack_len equ $ - err_rbrack

err_else:
    db "Syntax Error: Expected '{' after else", 10
err_else_len equ $ - err_else

err_symtab:
    db "Internal Error: symbol table full", 10
err_symtab_len equ $ - err_symtab

undef_1:
    db "Semantic Error: Undefined variable '"
undef_1_len equ $ - undef_1

undef_2:
    db "'", 10
undef_2_len equ $ - undef_2


section .bss

symbol_table:
    resb 8192

symbol_count:
    resq 1

temp_type:
    resq 1

array_ptr:
    resq 1

array_len:
    resq 1


section .text


parser_parse:

.loop:
    call lexer_next_token

    cmp rax, TOK_EOF
    je .done

    cmp rax, TOK_NEWLINE
    je .loop

    cmp rax, TOK_IDENT
    jne .error_ident

    xor r8, r8
    mov r9, SYM_FUNC
    call .add_symbol

    call lexer_next_token

    cmp rax, TOK_LPAREN
    jne .error_lparen

    call .parse_args

    call lexer_next_token

    cmp rax, TOK_ARROW
    jne .check_function_body

    call lexer_next_token
    call .is_type

    cmp r8, 1
    jne .error_type

    call lexer_next_token


.check_function_body:
    cmp rax, TOK_LBRACE
    jne .error_lbrace

    call .parse_body

    jmp .loop


.done:
    ret


.parse_args:

.args:
    call lexer_next_token

    cmp rax, TOK_RPAREN
    je .args_done

    call .is_type

    cmp r8, 1
    jne .error_type

    mov [temp_type], rax

    call lexer_next_token

    cmp rax, TOK_IDENT
    jne .error_ident

    mov r8, [temp_type]
    mov r9, SYM_VAR

    call .add_symbol

    call lexer_next_token

    cmp rax, TOK_COMMA
    je .args

    cmp rax, TOK_RPAREN
    je .args_done

    jmp .error_rparen


.args_done:
    ret


.parse_body:

.body:
    call lexer_next_token

    cmp rax, TOK_EOF
    je .error_rbrace

    cmp rax, TOK_RBRACE
    je .body_done

    cmp rax, TOK_NEWLINE
    je .body

    push rax
    call .is_type
    mov r10, r8
    pop rax

    cmp r10, 1
    je .parse_var

    cmp rax, TOK_IF
    je .parse_if

    cmp rax, TOK_REP
    je .parse_rep

    cmp rax, TOK_RET
    je .parse_ret

    call .parse_expression

    cmp rax, TOK_NEWLINE
    je .body

    cmp rax, TOK_RBRACE
    je .body_done

    jmp .body


.body_done:
    ret


.parse_var:
    mov [temp_type], rax

    call lexer_next_token

    cmp rax, TOK_IDENT
    jne .error_ident

    mov r8, [temp_type]
    mov r9, SYM_VAR

    call .add_symbol

    call lexer_next_token

    cmp rax, TOK_EQUAL
    jne .error_equal

    call lexer_next_token

    call .parse_expression

    cmp rax, TOK_NEWLINE
    je .body

    cmp rax, TOK_RBRACE
    je .body_done

    jmp .body


.parse_ret:
    call lexer_next_token

    call .parse_expression

    cmp rax, TOK_NEWLINE
    je .body

    cmp rax, TOK_RBRACE
    je .body_done

    jmp .body


.parse_if:
    call lexer_next_token

    call .parse_expression

    cmp rax, TOK_LBRACE
    jne .error_lbrace

    call codegen_if_start

    call .parse_body

    call lexer_next_token

    cmp rax, TOK_ELSE
    je .has_else

    cmp rax, TOK_RBRACE
    jne .error_rbrace

    call codegen_if_end
    jmp .body


.has_else:
    call codegen_if_else

    call lexer_next_token

    cmp rax, TOK_LBRACE
    jne .error_else

    call .parse_body

    call lexer_next_token

    cmp rax, TOK_RBRACE
    jne .error_rbrace

    call codegen_if_end

    jmp .body


.parse_rep:
    call lexer_next_token

    call .parse_expression

    cmp rax, TOK_LBRACE
    jne .error_lbrace

    call codegen_rep_start

    call .parse_body

    call lexer_next_token

    cmp rax, TOK_RBRACE
    jne .error_rbrace

    call codegen_rep_end

    jmp .body


.parse_expression:
    call .parse_primary


.expr:
    cmp rax, TOK_PLUS
    je .plus

    cmp rax, TOK_MINUS
    je .minus

    cmp rax, TOK_STAR
    je .mul

    cmp rax, TOK_EQEQ
    je .eqeq

    cmp rax, TOK_LT
    je .lt

    cmp rax, TOK_GT
    je .gt

    cmp rax, TOK_LTE
    je .lte

    cmp rax, TOK_GTE
    je .gte

    ret


.plus:
    call codegen_save_value
    call lexer_next_token
    call .parse_primary
    call codegen_add
    jmp .expr


.minus:
    call codegen_save_value
    call lexer_next_token
    call .parse_primary
    call codegen_sub
    jmp .expr


.mul:
    call codegen_save_value
    call lexer_next_token
    call .parse_primary
    call codegen_mul
    jmp .expr


.eqeq:
    call codegen_save_value
    call lexer_next_token
    call .parse_primary
    call codegen_cmp_eq
    jmp .expr


.lt:
    call codegen_save_value
    call lexer_next_token
    call .parse_primary
    call codegen_cmp_lt
    jmp .expr


.gt:
    call codegen_save_value
    call lexer_next_token
    call .parse_primary
    call codegen_cmp_gt
    jmp .expr


.lte:
    call codegen_save_value
    call lexer_next_token
    call .parse_primary
    call codegen_cmp_lte
    jmp .expr


.gte:
    call codegen_save_value
    call lexer_next_token
    call .parse_primary
    call codegen_cmp_gte
    jmp .expr


.parse_primary:

    cmp rax, TOK_NUMBER
    je .number

    cmp rax, TOK_CHAR
    je .char

    cmp rax, TOK_STRING
    je .string

    cmp rax, TOK_IDENT
    je .ident

    cmp rax, TOK_LPAREN
    je .paren

    jmp .error_expr


.number:
    call codegen_load_number
    call lexer_next_token
    ret


.char:
    call codegen_load_char
    call lexer_next_token
    ret


.string:
    call codegen_load_string
    call lexer_next_token
    ret


.ident:
    call .find_symbol

    test rax, rax
    jz .error_undefined

    mov r10, rax

    mov r11, [ident_ptr]
    mov [array_ptr], r11

    mov r11, [ident_len]
    mov [array_len], r11

    call lexer_next_token

    cmp rax, TOK_LBRACK
    je .array

    mov rax, r10
    call codegen_load_variable
    ret


.array:
    call lexer_next_token

    call .parse_expression

    cmp rax, TOK_RBRACK
    jne .error_rbrack

    mov r10, [array_ptr]
    mov [ident_ptr], r10

    mov r10, [array_len]
    mov [ident_len], r10

    call codegen_load_array_element

    call lexer_next_token

    ret


.paren:
    call lexer_next_token

    call .parse_expression

    cmp rax, TOK_RPAREN
    jne .error_rparen

    call lexer_next_token

    ret


.add_symbol:
    mov rcx, [symbol_count]

    cmp rcx, SYMTAB_MAX_ENTRIES
    jae .error_symtab

    imul rcx, rcx, 32

    lea rdi, [symbol_table + rcx]

    mov rsi, [ident_ptr]
    mov [rdi], rsi

    mov rsi, [ident_len]
    mov [rdi + 8], rsi

    mov [rdi + 16], r8
    mov [rdi + 24], r9

    inc qword [symbol_count]

    ret


.is_type:
    xor r8, r8

    cmp rax, TOK_INT8
    je .type_yes

    cmp rax, TOK_NAT8
    je .type_yes

    cmp rax, TOK_INT16
    je .type_yes

    cmp rax, TOK_NAT16
    je .type_yes

    cmp rax, TOK_INT32
    je .type_yes

    cmp rax, TOK_NAT32
    je .type_yes

    cmp rax, TOK_INT64
    je .type_yes

    cmp rax, TOK_NAT64
    je .type_yes

%ifdef TOK_BOOL
    cmp rax, TOK_BOOL
    je .type_yes
%endif

    ret


.type_yes:
    mov r8, 1
    ret


.find_symbol:
    mov rcx, [symbol_count]
    lea rdi, [symbol_table]


.find_loop:
    test rcx, rcx
    jz .not_found

    mov r9, [rdi + 8]

    cmp r9, [ident_len]
    jne .next

    mov rsi, [ident_ptr]
    mov rdx, [rdi]

    mov r10, r9


.compare:
    test r10, r10
    jz .found

    mov r11b, [rsi]
    cmp r11b, [rdx]
    jne .next

    inc rsi
    inc rdx
    dec r10

    jmp .compare


.next:
    add rdi, 32
    dec rcx
    jmp .find_loop


.found:
    mov rax, rdi
    ret


.not_found:
    xor eax, eax
    ret


.error_ident:
    mov rsi, err_ident
    mov rdx, err_ident_len
    jmp .fatal


.error_lparen:
    mov rsi, err_lparen
    mov rdx, err_lparen_len
    jmp .fatal


.error_rparen:
    mov rsi, err_rparen
    mov rdx, err_rparen_len
    jmp .fatal


.error_lbrace:
    mov rsi, err_lbrace
    mov rdx, err_lbrace_len
    jmp .fatal


.error_rbrace:
    mov rsi, err_rbrace
    mov rdx, err_rbrace_len
    jmp .fatal


.error_equal:
    mov rsi, err_equal
    mov rdx, err_equal_len
    jmp .fatal


.error_type:
    mov rsi, err_type
    mov rdx, err_type_len
    jmp .fatal


.error_expr:
    mov rsi, err_expr
    mov rdx, err_expr_len
    jmp .fatal


.error_rbrack:
    mov rsi, err_rbrack
    mov rdx, err_rbrack_len
    jmp .fatal


.error_else:
    mov rsi, err_else
    mov rdx, err_else_len
    jmp .fatal


.error_symtab:
    mov rsi, err_symtab
    mov rdx, err_symtab_len
    jmp .fatal


.error_undefined:
    mov eax, 1
    mov edi, 2
    mov rsi, undef_1
    mov edx, undef_1_len
    syscall

    mov eax, 1
    mov edi, 2
    mov rsi, [ident_ptr]
    mov rdx, [ident_len]
    syscall

    mov eax, 1
    mov edi, 2
    mov rsi, undef_2
    mov edx, undef_2_len
    syscall

    mov eax, 60
    mov edi, 1
    syscall


.fatal:
    mov eax, 1
    mov edi, 2
    syscall

    mov eax, 60
    mov edi, 1
    syscall