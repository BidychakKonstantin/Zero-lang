%include "src/include/tokens.inc"

DEFAULT REL

global lexer_init
global ident_ptr
global ident_len
global string_ptr
global string_len
global current_number
global token_value
global lexer_next_token
global line_number
global col_number

section .bss

src_ptr:
    resq 1

src_end:
    resq 1

line_number:
    resq 1

col_number:
    resq 1

token_value:
    resq 1

current_number:
    resq 1

ident_ptr:
    resq 1

ident_len:
    resq 1

string_ptr:
    resq 1

string_len:
    resq 1


section .text

lexer_init:
    mov qword [line_number], 1
    mov qword [col_number], 1

    mov [src_ptr], rdi

    add rdi, rsi
    mov [src_end], rdi

    ret


lexer_next_token:

.skip:
    mov rcx, [src_ptr]

    cmp rcx, [src_end]
    jae .eof

    movzx eax, byte [rcx]

    cmp al, ' '
    je .skip_char

    cmp al, 9
    je .skip_char

    cmp al, 13
    je .skip_char

    cmp al, 10
    je .newline

    cmp al, '{'
    je .lbrace

    cmp al, '}'
    je .rbrace

    cmp al, '('
    je .lparen

    cmp al, ')'
    je .rparen

    cmp al, '['
    je .lbrack

    cmp al, ']'
    je .rbrack

    cmp al, ','
    je .comma

    cmp al, '+'
    je .plus

    cmp al, '-'
    je .minus

    cmp al, '*'
    je .star

    cmp al, '/'
    je .slash

    cmp al, '='
    je .equal

    cmp al, '<'
    je .less

    cmp al, '>'
    je .greater

    cmp al, "'"
    je .char

    cmp al, '"'
    je .string

    cmp al, '0'
    jb .check_ident

    cmp al, '9'
    jbe .number


.check_ident:
    cmp al, '_'
    je .ident

    cmp al, 'A'
    jb .unknown

    cmp al, 'Z'
    jbe .ident

    cmp al, 'a'
    jb .unknown

    cmp al, 'z'
    jbe .ident


.unknown:
    mov rax, TOK_UNKNOWN
    jmp .single


.skip_char:
    inc qword [src_ptr]
    inc qword [col_number]
    jmp .skip


.newline:
    inc qword [src_ptr]
    mov qword [col_number], 1
    inc qword [line_number]

    mov rax, TOK_NEWLINE
    ret


.lbrace:
    mov rax, TOK_LBRACE
    jmp .single


.rbrace:
    mov rax, TOK_RBRACE
    jmp .single


.lparen:
    mov rax, TOK_LPAREN
    jmp .single


.rparen:
    mov rax, TOK_RPAREN
    jmp .single


.lbrack:
    mov rax, TOK_LBRACK
    jmp .single


.rbrack:
    mov rax, TOK_RBRACK
    jmp .single


.comma:
    mov rax, TOK_COMMA
    jmp .single


.plus:
    mov rax, TOK_PLUS
    jmp .single


.star:
    mov rax, TOK_STAR
    jmp .single


.equal:
    mov rdx, rcx
    inc rdx

    cmp rdx, [src_end]
    jae .emit_equal

    cmp byte [rdx], '='
    je .eqeq


.emit_equal:
    mov rax, TOK_EQUAL
    jmp .single


.eqeq:
    add qword [src_ptr], 2
    add qword [col_number], 2

    mov rax, TOK_EQEQ
    ret


.minus:
    mov rdx, rcx
    inc rdx

    cmp rdx, [src_end]
    jae .emit_minus

    cmp byte [rdx], '>'
    je .arrow


.emit_minus:
    mov rax, TOK_MINUS
    jmp .single


.arrow:
    add qword [src_ptr], 2
    add qword [col_number], 2

    mov rax, TOK_ARROW
    ret


.less:
    mov rdx, rcx
    inc rdx

    cmp rdx, [src_end]
    jae .emit_less

    cmp byte [rdx], '='
    je .lte


.emit_less:
    mov rax, TOK_LT
    jmp .single


.lte:
    add qword [src_ptr], 2
    add qword [col_number], 2

    mov rax, TOK_LTE
    ret


.greater:
    mov rdx, rcx
    inc rdx

    cmp rdx, [src_end]
    jae .emit_greater

    cmp byte [rdx], '='
    je .gte


.emit_greater:
    mov rax, TOK_GT
    jmp .single


.gte:
    add qword [src_ptr], 2
    add qword [col_number], 2

    mov rax, TOK_GTE
    ret


.slash:
    mov rdx, rcx
    inc rdx

    cmp rdx, [src_end]
    jae .emit_slash

    cmp byte [rdx], '/'
    je .comment


.emit_slash:
    mov rax, TOK_SLASH
    jmp .single


.comment:
    add qword [src_ptr], 2
    add qword [col_number], 2


.comment_loop:
    mov rcx, [src_ptr]

    cmp rcx, [src_end]
    jae .eof

    cmp byte [rcx], 10
    je .skip

    inc qword [src_ptr]
    inc qword [col_number]

    jmp .comment_loop


.char:
    inc qword [src_ptr]
    inc qword [col_number]

    mov rcx, [src_ptr]

    cmp rcx, [src_end]
    jae .char_error

    movzx eax, byte [rcx]

    cmp al, '\'
    je .char_escape

    mov [token_value], rax
    mov [current_number], rax

    inc qword [src_ptr]
    inc qword [col_number]

    jmp .char_close


.char_escape:
    inc qword [src_ptr]
    inc qword [col_number]

    mov rcx, [src_ptr]

    cmp rcx, [src_end]
    jae .char_error

    movzx eax, byte [rcx]

    cmp al, 'n'
    je .esc_n

    cmp al, 't'
    je .esc_t

    cmp al, 'r'
    je .esc_r

    cmp al, '0'
    je .esc_0

    cmp al, '\'
    je .esc_slash

    cmp al, "'"
    je .esc_quote

    jmp .esc_done


.esc_n:
    mov eax, 10
    jmp .esc_done


.esc_t:
    mov eax, 9
    jmp .esc_done


.esc_r:
    mov eax, 13
    jmp .esc_done


.esc_0:
    xor eax, eax
    jmp .esc_done


.esc_slash:
    mov eax, '\'
    jmp .esc_done


.esc_quote:
    mov eax, "'"


.esc_done:
    mov [token_value], rax
    mov [current_number], rax

    inc qword [src_ptr]
    inc qword [col_number]


.char_close:
    mov rcx, [src_ptr]

    cmp rcx, [src_end]
    jae .char_error

    cmp byte [rcx], "'"
    jne .char_error

    inc qword [src_ptr]
    inc qword [col_number]

    mov rax, TOK_CHAR
    ret


.char_error:
    mov rax, TOK_UNKNOWN
    ret


.string:
    inc qword [src_ptr]
    inc qword [col_number]

    mov rsi, [src_ptr]


.string_loop:
    mov rcx, [src_ptr]

    cmp rcx, [src_end]
    jae .string_done

    movzx eax, byte [rcx]

    cmp al, '"'
    je .string_done

    cmp al, '\'
    je .string_escape

    inc qword [src_ptr]
    inc qword [col_number]

    jmp .string_loop


.string_escape:
    mov rdx, [src_ptr]

    cmp rdx, [src_end]
    jae .string_done

    inc rdx
    cmp rdx, [src_end]
    jae .string_done

    add qword [src_ptr], 2
    add qword [col_number], 2

    jmp .string_loop


.string_done:
    mov rcx, [src_ptr]
    sub rcx, rsi

    mov [ident_ptr], rsi
    mov [ident_len], rcx

    mov [string_ptr], rsi
    mov [string_len], rcx

    cmp qword [src_ptr], 0
    je .string_return

    mov rdx, [src_ptr]

    cmp rdx, [src_end]
    jae .string_return

    cmp byte [rdx], '"'
    jne .string_return

    inc qword [src_ptr]
    inc qword [col_number]


.string_return:
    mov rax, TOK_STRING
    ret


.number:
    xor r8, r8


.number_loop:
    mov rcx, [src_ptr]

    cmp rcx, [src_end]
    jae .number_done

    movzx eax, byte [rcx]

    cmp al, '0'
    jb .number_done

    cmp al, '9'
    ja .number_done

    sub al, '0'

    imul r8, r8, 10
    add r8, rax

    inc qword [src_ptr]
    inc qword [col_number]

    jmp .number_loop


.number_done:
    mov [token_value], r8
    mov [current_number], r8

    mov rax, TOK_NUMBER
    ret


.ident:
    mov rsi, [src_ptr]


.ident_loop:
    mov rcx, [src_ptr]

    cmp rcx, [src_end]
    jae .ident_done

    movzx eax, byte [rcx]

    cmp al, '_'
    je .ident_next

    cmp al, '0'
    jb .ident_done

    cmp al, '9'
    jbe .ident_next

    cmp al, 'A'
    jb .ident_done

    cmp al, 'Z'
    jbe .ident_next

    cmp al, 'a'
    jb .ident_done

    cmp al, 'z'
    ja .ident_done


.ident_next:
    inc qword [src_ptr]
    inc qword [col_number]

    jmp .ident_loop


.ident_done:
    mov rcx, [src_ptr]
    sub rcx, rsi

    mov [ident_ptr], rsi
    mov [ident_len], rcx

    cmp rcx, 2
    je .keyword_2

    cmp rcx, 3
    je .keyword_3

    cmp rcx, 4
    je .keyword_4

    cmp rcx, 5
    je .keyword_5


.return_ident:
    mov rax, TOK_IDENT
    ret


.keyword_2:
    cmp byte [rsi], 'i'
    jne .return_ident

    cmp byte [rsi + 1], 'f'
    jne .return_ident

    mov rax, TOK_IF
    ret


.keyword_3:
    cmp byte [rsi], 'r'
    jne .check_else

    cmp byte [rsi + 1], 'e'
    jne .check_else

    cmp byte [rsi + 2], 'p'
    je .rep

    cmp byte [rsi + 2], 't'
    je .ret_keyword

    jmp .check_else


.check_else:
    cmp byte [rsi], 'e'
    jne .return_ident

    cmp byte [rsi + 1], 'l'
    jne .return_ident

    cmp byte [rsi + 2], 's'
    jne .return_ident

    cmp byte [rsi + 3], 'e'
    jne .return_ident

    mov rax, TOK_ELSE
    ret


.keyword_4:
    cmp byte [rsi], 'n'
    je .nat8

    cmp byte [rsi], 'i'
    je .int8

    cmp byte [rsi], 'b'
    je .bool

    jmp .return_ident


.nat8:
    cmp byte [rsi + 1], 'a'
    jne .return_ident

    cmp byte [rsi + 2], 't'
    jne .return_ident

    cmp byte [rsi + 3], '8'
    jne .return_ident

    mov rax, TOK_NAT8
    ret


.int8:
    cmp byte [rsi + 1], 'n'
    jne .return_ident

    cmp byte [rsi + 2], 't'
    jne .return_ident

    cmp byte [rsi + 3], '8'
    jne .return_ident

    mov rax, TOK_INT8
    ret


.bool:
    cmp byte [rsi + 1], 'o'
    jne .return_ident

    cmp byte [rsi + 2], 'o'
    jne .return_ident

    cmp byte [rsi + 3], 'l'
    jne .return_ident

    mov rax, TOK_BOOL
    ret


.keyword_5:
    cmp byte [rsi], 'i'
    je .int_type_5

    cmp byte [rsi], 'n'
    je .nat_type_5

    jmp .return_ident


.int_type_5:
    cmp byte [rsi + 1], 'n'
    jne .return_ident

    cmp byte [rsi + 2], 't'
    jne .return_ident

    cmp byte [rsi + 3], '1'
    je .int16

    cmp byte [rsi + 3], '3'
    je .int32

    cmp byte [rsi + 3], '6'
    je .int64

    jmp .return_ident


.nat_type_5:
    cmp byte [rsi + 1], 'a'
    jne .return_ident

    cmp byte [rsi + 2], 't'
    jne .return_ident

    cmp byte [rsi + 3], '1'
    je .nat16

    cmp byte [rsi + 3], '3'
    je .nat32

    cmp byte [rsi + 3], '6'
    je .nat64

    jmp .return_ident


.int16:
    cmp byte [rsi + 4], '6'
    jne .return_ident

    mov rax, TOK_INT16
    ret


.int32:
    cmp byte [rsi + 4], '2'
    jne .return_ident

    mov rax, TOK_INT32
    ret


.int64:
    cmp byte [rsi + 4], '4'
    jne .return_ident

    mov rax, TOK_INT64
    ret


.nat16:
    cmp byte [rsi + 4], '6'
    jne .return_ident

    mov rax, TOK_NAT16
    ret


.nat32:
    cmp byte [rsi + 4], '2'
    jne .return_ident

    mov rax, TOK_NAT32
    ret


.nat64:
    cmp byte [rsi + 4], '4'
    jne .return_ident

    mov rax, TOK_NAT64
    ret


.rep:
    mov rax, TOK_REP
    ret


.ret_keyword:
    mov rax, TOK_RET
    ret


.single:
    inc qword [src_ptr]
    inc qword [col_number]
    ret


.eof:
    mov rax, TOK_EOF
    ret