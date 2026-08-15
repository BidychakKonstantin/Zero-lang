%include "src/include/tokens.inc"

global lexer_init
global lexer_next_token

section .bss
    src_ptr:        resq 1
    src_end:        resq 1
    current_number: resq 1
    line_number:    resq 1 
    col_number:     resq 1 

section .text

lexer_init:
    mov qword [line_number], 1
    mov qword [col_number],  1
    mov [src_ptr], rdi
    add rdi, rsi
    mov [src_end], rdi
    ret

lexer_next_token:
.skip_whitespace: 
    mov rcx, [src_ptr]
    cmp rcx, [src_end]
    jae .eof
  
    movzx eax, byte [rcx]

    cmp al, 32
    je .next_char
    cmp al, 9
    je .next_char
    cmp al, 13
    je .next_char

    cmp al, 10
    je .match_newline

    cmp al, '{'
    je .match_lbrace
    cmp al, '}'
    je .match_rbrace
    cmp al, '('
    je .match_lparen
    cmp al, ')'
    je .match_rparen
    cmp al, '='
    je .match_equal
    cmp al, '+'
    je .match_plus

    cmp al, '0'
    jl .check_ident
    cmp al, '9'
    jg .check_ident
    jmp .parse_number

.check_ident:
    cmp al, '_'
    je .match_ident
    cmp al, 'A'
    jb .unknown_char
    cmp al, 'Z'
    jbe .match_ident

    cmp al, 'a'
    jb .unknown_char
    cmp al, 'z'
    jbe .match_ident

.unknown_char:
    jmp .emit_single_char

.next_char:
    inc qword [src_ptr]
    inc qword [col_number]
    jmp .skip_whitespace

.match_newline: 
    inc qword [src_ptr]
    mov qword [col_number], 1
    inc qword [line_number]
    mov rax, TOK_NEWLINE
    ret

.match_lbrace:
    mov rax, TOK_LBRACE
    jmp .emit_single_char

.match_rbrace:
    mov rax, TOK_RBRACE
    jmp .emit_single_char

.match_lparen:
    mov rax, TOK_LPAREN
    jmp .emit_single_char

.match_rparen:
    mov rax, TOK_RPAREN
    jmp .emit_single_char

.match_equal:
    mov rax, TOK_EQUAL
    jmp .emit_single_char

.match_plus:
    mov rax, TOK_PLUS
    jmp .emit_single_char

.emit_single_char:
    inc qword [src_ptr]
    inc qword [col_number]
    ret 

.parse_number: 
    xor r8, r8

.num_loop:
    mov rcx, [src_ptr]
    cmp rcx, [src_end]
    jge .num_done
    movzx eax, byte [rcx]
    
    cmp al, '0'
    jl .num_done
    cmp al, '9'
    jg .num_done

    sub al, '0' 
    imul r8, r8, 10 
    add r8, rax
  
    inc qword [src_ptr]
    inc qword [col_number]
    jmp .num_loop

.num_done: 
    mov [current_number], r8
    mov rax, TOK_INT    
    ret

.match_ident:
    mov rsi, [src_ptr]

.ident_loop:
    mov rcx, [src_ptr]
    cmp rcx, [src_end]
    jge .ident_scanned

    movzx eax, byte [rcx]

    cmp al, '_'
    je .ident_next
    cmp al, '0'
    jl .ident_scanned
    cmp al, '9'
    jle .ident_next
    cmp al, 'A'
    jl .ident_scanned
    cmp al, 'Z'
    jle .ident_next
    cmp al, 'a'
    jl .ident_scanned
    cmp al, 'z'
    jg .ident_scanned

.ident_next:
    inc qword [src_ptr]
    inc qword [col_number]
    jmp .ident_loop

.ident_scanned:
    mov rcx, [src_ptr]
    sub rcx, rsi

.ident_done:
    cmp rcx, 2
    je .check_len_2
    cmp rcx, 3
    je .check_len_3
    cmp rcx, 6
    je .check_len_6
    jmp .return_ident

.check_len_2:
    mov ax, word [rsi]
    cmp ax, 'nf'
    je .kw_fn
    cmp ax, 'fi'
    je .kw_if
    jmp .return_ident

.check_len_3:
    mov ax, word [rsi]
    cmp ax, 'el'
    jne .return_ident
    cmp byte [rsi + 2], 't'
    je .kw_let
    jmp .return_ident

.check_len_6:
    mov eax, dword [rsi]
    cmp eax, 'uter'
    jne .return_ident
    mov dx, word [rsi + 4]
    cmp dx, 'nr'
    je .kw_return
    jmp .return_ident

.kw_fn:
    mov rax, TOK_FN
    ret

.kw_if:
    mov rax, TOK_IF
    ret

.kw_let:
    mov rax, TOK_LET
    ret

.kw_return:
    mov rax, TOK_RETURN
    ret

.return_ident:
    mov rax, TOK_IDENT
    ret

.eof: 
    mov rax, TOK_EOF
    ret