%include "src/include/tokens.inc"
default rel

global lexer_init
global lexer_next_token
global lexer_use_file
global lexer_set_source_dir

global ident_ptr
global ident_len
global string_ptr
global string_len
global current_number
global token_value
global line_number
global col_number

%define SYS_READ 0
%define SYS_CLOSE 3
%define SYS_OPENAT 257
%define AT_FDCWD -100
%define O_RDONLY 0

%define MAX_SOURCE_DEPTH 32
%define SOURCE_BUFFER_SIZE 65536
%define PATH_BUFFER_SIZE 4096

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

source_depth:
resq 1

source_ptr_stack:
resq MAX_SOURCE_DEPTH

source_end_stack:
resq MAX_SOURCE_DEPTH

source_line_stack:
resq MAX_SOURCE_DEPTH

source_col_stack:
resq MAX_SOURCE_DEPTH

source_dir_stack:
resb MAX_SOURCE_DEPTH * PATH_BUFFER_SIZE

current_source_dir:
resb PATH_BUFFER_SIZE

path_buffer:
resb PATH_BUFFER_SIZE

source_buffers:
resb MAX_SOURCE_DEPTH * SOURCE_BUFFER_SIZE

section .text


lexer_init:
    mov qword [rel source_depth], 0
    mov qword [rel line_number], 1
    mov qword [rel col_number], 1

    mov [rel src_ptr], rdi

    lea rax, [rdi + rsi]
    mov [rel src_end], rax

    xor eax, eax

    mov [rel token_value], rax
    mov [rel current_number], rax

    mov [rel ident_ptr], rax
    mov [rel ident_len], rax

    mov [rel string_ptr], rax
    mov [rel string_len], rax

    ret


lexer_set_source_dir:
    push r12
    push r13

    mov r12, rdi
    mov r13, rsi

    cmp r13, PATH_BUFFER_SIZE - 2
    ja .fail

    lea rdi, [rel current_source_dir]
    mov rsi, r12
    mov rcx, r13

    rep movsb

    test r13, r13
    jz .slash

    lea r11, [rel current_source_dir]
    cmp byte [r11 + r13 - 1], '/'
    je .terminate

.slash:
    mov byte [rdi], '/'
    inc rdi

.terminate:
    mov byte [rdi], 0

    xor eax, eax

    pop r13
    pop r12

    ret

.fail:
    mov rax, -1

    pop r13
    pop r12

    ret


lexer_use_file:
    push rbx
    push r12
    push r13
    push r14
    push r15

    mov r12, rdi
    mov r13, rsi

    test r13, r13
    jz .fail

    cmp r13, PATH_BUFFER_SIZE - 1
    jae .fail

    mov rax, [rel source_depth]

    cmp rax, MAX_SOURCE_DEPTH
    jae .fail

    mov rbx, rax

    lea r11, [rel source_ptr_stack]
    mov rax, [rel src_ptr]
    mov [r11 + rbx * 8], rax

    lea r11, [rel source_end_stack]
    mov rax, [rel src_end]
    mov [r11 + rbx * 8], rax

    lea r11, [rel source_line_stack]
    mov rax, [rel line_number]
    mov [r11 + rbx * 8], rax

    lea r11, [rel source_col_stack]
    mov rax, [rel col_number]
    mov [r11 + rbx * 8], rax

    mov rax, rbx
    imul rax, PATH_BUFFER_SIZE

    lea rdi, [rel source_dir_stack]
    add rdi, rax
    lea rsi, [rel current_source_dir]

    call lexer_copy_string

    cmp byte [r12], '/'
    je .absolute

    lea rdi, [rel path_buffer]
    mov r8, rdi

    lea rsi, [rel current_source_dir]

    call lexer_copy_string

    mov rax, rdi
    sub rax, r8
    add rax, r13
    inc rax

    cmp rax, PATH_BUFFER_SIZE
    jae .fail

    mov rsi, r12
    mov rcx, r13

    rep movsb

    mov byte [rdi], 0

    jmp .open

.absolute:
    lea rdi, [rel path_buffer]
    mov rsi, r12
    mov rcx, r13

    rep movsb

    mov byte [rdi], 0

.open:
    mov eax, SYS_OPENAT
    mov edi, AT_FDCWD
    lea rsi, [rel path_buffer]
    mov edx, O_RDONLY
    xor r10d, r10d

    syscall

    test rax, rax
    js .fail

    mov r15, rax

    mov rax, rbx
    imul rax, SOURCE_BUFFER_SIZE

    lea r14, [rel source_buffers]
    add r14, rax

    mov eax, SYS_READ
    mov rdi, r15
    mov rsi, r14
    mov edx, SOURCE_BUFFER_SIZE

    syscall

    test rax, rax
    js .read_fail

    mov r13, rax

    mov eax, SYS_CLOSE
    mov rdi, r15

    syscall

    mov [rel src_ptr], r14

    lea rax, [r14 + r13]
    mov [rel src_end], rax

    mov qword [rel line_number], 1
    mov qword [rel col_number], 1

    call lexer_update_current_dir

    inc rbx
    mov [rel source_depth], rbx

    xor eax, eax

    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx

    ret

.read_fail:
    mov eax, SYS_CLOSE
    mov rdi, r15

    syscall

.fail:
    mov rax, -1

    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx

    ret


lexer_copy_string:
.copy:
    mov al, [rsi]
    mov [rdi], al

    inc rsi
    inc rdi

    test al, al
    jnz .copy

    dec rdi

    ret


lexer_update_current_dir:
    lea rsi, [rel path_buffer]
    xor rcx, rcx

.find_end:
    cmp byte [rsi + rcx], 0
    je .end_found

    inc rcx

    cmp rcx, PATH_BUFFER_SIZE
    jb .find_end

    ret

.end_found:
    test rcx, rcx
    jz .no_dir

    dec rcx

.find_slash:
    cmp byte [rsi + rcx], '/'
    je .slash_found

    test rcx, rcx
    jz .no_dir

    dec rcx

    jmp .find_slash

.slash_found:
    inc rcx

    lea rdi, [rel current_source_dir]
    lea rsi, [rel path_buffer]

    rep movsb

    mov byte [rdi], 0

    ret

.no_dir:
    lea r11, [rel current_source_dir]
    mov byte [r11], '.'
    mov byte [r11 + 1], 0

    ret


lexer_next_token:
.skip_whitespace:
    mov rcx, [rel src_ptr]

    cmp rcx, [rel src_end]
    jae .source_eof

    movzx eax, byte [rcx]

    cmp al, ' '
    je .skip

    cmp al, 9
    je .skip

    cmp al, 13
    je .skip

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
    jb .identifier_check

    cmp al, '9'
    jbe .number

.identifier_check:
    cmp al, '_'
    je .identifier

    cmp al, 'A'
    jb .unknown

    cmp al, 'Z'
    jbe .identifier

    cmp al, 'a'
    jb .unknown

    cmp al, 'z'
    jbe .identifier

    jmp .unknown

.unknown:
    mov rax, TOK_UNKNOWN

    inc qword [rel src_ptr]
    inc qword [rel col_number]

    ret

.skip:
    inc qword [rel src_ptr]
    inc qword [rel col_number]

    jmp .skip_whitespace

.newline:
    inc qword [rel src_ptr]

    mov qword [rel col_number], 1
    inc qword [rel line_number]

    mov rax, TOK_NEWLINE

    ret

.single:
    inc qword [rel src_ptr]
    inc qword [rel col_number]

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
    lea rdx, [rcx + 1]

    cmp rdx, [rel src_end]
    jae .equal_one

    cmp byte [rdx], '='
    je .eqeq

.equal_one:
    mov rax, TOK_EQUAL
    jmp .single

.eqeq:
    add qword [rel src_ptr], 2
    add qword [rel col_number], 2

    mov rax, TOK_EQEQ

    ret

.minus:
    lea rdx, [rcx + 1]

    cmp rdx, [rel src_end]
    jae .minus_one

    cmp byte [rdx], '>'
    je .arrow

.minus_one:
    mov rax, TOK_MINUS
    jmp .single

.arrow:
    add qword [rel src_ptr], 2
    add qword [rel col_number], 2

    mov rax, TOK_ARROW

    ret

.less:
    lea rdx, [rcx + 1]

    cmp rdx, [rel src_end]
    jae .less_one

    cmp byte [rdx], '='
    je .lte

.less_one:
    mov rax, TOK_LT
    jmp .single

.lte:
    add qword [rel src_ptr], 2
    add qword [rel col_number], 2

    mov rax, TOK_LTE

    ret

.greater:
    lea rdx, [rcx + 1]

    cmp rdx, [rel src_end]
    jae .greater_one

    cmp byte [rdx], '='
    je .gte

.greater_one:
    mov rax, TOK_GT
    jmp .single

.gte:
    add qword [rel src_ptr], 2
    add qword [rel col_number], 2

    mov rax, TOK_GTE

    ret

.slash:
    lea rdx, [rcx + 1]

    cmp rdx, [rel src_end]
    jae .slash_one

    cmp byte [rdx], '/'
    je .comment

.slash_one:
    mov rax, TOK_SLASH
    jmp .single

.comment:
    add qword [rel src_ptr], 2
    add qword [rel col_number], 2

.comment_loop:
    mov rcx, [rel src_ptr]

    cmp rcx, [rel src_end]
    jae .source_eof

    cmp byte [rcx], 10
    je .skip_whitespace

    inc qword [rel src_ptr]
    inc qword [rel col_number]

    jmp .comment_loop

.char:
    inc qword [rel src_ptr]
    inc qword [rel col_number]

    mov rcx, [rel src_ptr]

    cmp rcx, [rel src_end]
    jae .char_error

    movzx eax, byte [rcx]

    cmp al, '\'
    je .char_escape

    mov [rel token_value], rax
    mov [rel current_number], rax

    inc qword [rel src_ptr]
    inc qword [rel col_number]

    jmp .char_close

.char_escape:
    inc qword [rel src_ptr]
    inc qword [rel col_number]

    mov rcx, [rel src_ptr]

    cmp rcx, [rel src_end]
    jae .char_error

    movzx eax, byte [rcx]

    cmp al, 'n'
    je .char_n

    cmp al, 't'
    je .char_t

    cmp al, 'r'
    je .char_r

    cmp al, '0'
    je .char_zero

    cmp al, '\'
    je .char_backslash

    cmp al, "'"
    je .char_quote

    jmp .char_escape_done

.char_n:
    mov eax, 10
    jmp .char_escape_done

.char_t:
    mov eax, 9
    jmp .char_escape_done

.char_r:
    mov eax, 13
    jmp .char_escape_done

.char_zero:
    xor eax, eax
    jmp .char_escape_done

.char_backslash:
    mov eax, 92
    jmp .char_escape_done

.char_quote:
    mov eax, "'"

.char_escape_done:
    mov [rel token_value], rax
    mov [rel current_number], rax

    inc qword [rel src_ptr]
    inc qword [rel col_number]

.char_close:
    mov rcx, [rel src_ptr]

    cmp rcx, [rel src_end]
    jae .char_error

    cmp byte [rcx], "'"
    jne .char_error

    inc qword [rel src_ptr]
    inc qword [rel col_number]

    mov rax, TOK_CHAR

    ret

.char_error:
    mov rax, TOK_UNKNOWN

    ret

.string:
    inc qword [rel src_ptr]
    inc qword [rel col_number]

    mov rsi, [rel src_ptr]

.string_loop:
    mov rcx, [rel src_ptr]

    cmp rcx, [rel src_end]
    jae .string_error

    movzx eax, byte [rcx]

    cmp al, '"'
    je .string_done

    cmp al, 10
    je .string_error

    cmp al, '\'
    je .string_escape

    inc qword [rel src_ptr]
    inc qword [rel col_number]

    jmp .string_loop

.string_escape:
    inc qword [rel src_ptr]
    inc qword [rel col_number]

    mov rcx, [rel src_ptr]

    cmp rcx, [rel src_end]
    jae .string_error

    inc qword [rel src_ptr]
    inc qword [rel col_number]

    jmp .string_loop

.string_done:
    mov rcx, [rel src_ptr]
    sub rcx, rsi

    mov [rel string_ptr], rsi
    mov [rel string_len], rcx

    mov [rel ident_ptr], rsi
    mov [rel ident_len], rcx

    inc qword [rel src_ptr]
    inc qword [rel col_number]

    mov rax, TOK_STRING

    ret

.string_error:
    mov rax, TOK_UNKNOWN

    ret

.number:
    xor r8, r8

.number_loop:
    mov rcx, [rel src_ptr]

    cmp rcx, [rel src_end]
    jae .number_done

    movzx eax, byte [rcx]

    cmp al, '0'
    jb .number_done

    cmp al, '9'
    ja .number_done

    sub eax, '0'

    imul r8, r8, 10
    add r8, rax

    inc qword [rel src_ptr]
    inc qword [rel col_number]

    jmp .number_loop

.number_done:
    mov [rel token_value], r8
    mov [rel current_number], r8

    mov rax, TOK_NUMBER

    ret

.identifier:
    mov rsi, [rel src_ptr]

.ident_loop:
    mov rcx, [rel src_ptr]

    cmp rcx, [rel src_end]
    jae .ident_done

    movzx eax, byte [rcx]

    cmp al, '_'
    je .ident_next

    cmp al, '0'
    jb .ident_alpha

    cmp al, '9'
    jbe .ident_next

.ident_alpha:
    cmp al, 'A'
    jb .ident_lower

    cmp al, 'Z'
    jbe .ident_next

.ident_lower:
    cmp al, 'a'
    jb .ident_done

    cmp al, 'z'
    ja .ident_done

.ident_next:
    inc qword [rel src_ptr]
    inc qword [rel col_number]

    jmp .ident_loop

.ident_done:
    mov rcx, [rel src_ptr]
    sub rcx, rsi

    mov [rel ident_ptr], rsi
    mov [rel ident_len], rcx

    cmp rcx, 2
    je .keyword_2

    cmp rcx, 3
    je .keyword_3

    cmp rcx, 4
    je .keyword_4

    cmp rcx, 5
    je .keyword_5

    mov rax, TOK_IDENT

    ret

.keyword_2:
    cmp byte [rsi], 'i'
    jne .ident_return

    cmp byte [rsi + 1], 'f'
    jne .ident_return

    mov rax, TOK_IF

    ret

.keyword_3:
    cmp byte [rsi], 'r'
    je .check_r_words
    cmp byte [rsi], 'u'
    je .check_use
    cmp byte [rsi], 'c'
    je .check_chr
    jmp .ident_return

.check_r_words:
    cmp byte [rsi + 1], 'e'
    jne .ident_return
    cmp byte [rsi + 2], 'p'
    je .return_rep
    cmp byte [rsi + 2], 't'
    je .return_ret
    jmp .ident_return

.check_use:
    cmp byte [rsi + 1], 's'
    jne .ident_return
    cmp byte [rsi + 2], 'e'
    jne .ident_return
    mov rax, TOK_USE
    ret

.check_chr:
    cmp byte [rsi + 1], 'h'
    jne .ident_return
    cmp byte [rsi + 2], 'r'
    jne .ident_return
    mov rax, TOK_CHR
    ret

.return_rep:
    mov rax, TOK_REP
    ret

.return_ret:
    mov rax, TOK_RET
    ret

.keyword_4:
    cmp byte [rsi], 'e'
    je .check_else
    cmp byte [rsi], 'i'
    je .check_int8
    cmp byte [rsi], 'n'
    je .check_n_words
    cmp byte [rsi], 'N'
    je .check_N_words
%ifdef TOK_BOOL
    cmp byte [rsi], 'b'
    je .check_bool
%endif
    jmp .ident_return

.check_n_words:
    cmp byte [rsi + 1], 'a'
    je .check_nat8
    cmp byte [rsi + 1], 'u'
    je .check_null_lower
    jmp .ident_return

.check_N_words:
    cmp byte [rsi + 1], 'U'
    jne .ident_return
    cmp byte [rsi + 2], 'L'
    jne .ident_return
    cmp byte [rsi + 3], 'L'
    jne .ident_return
    mov rax, TOK_NULL
    ret

.check_null_lower:
    cmp byte [rsi + 2], 'l'
    jne .ident_return
    cmp byte [rsi + 3], 'l'
    jne .ident_return
    mov rax, TOK_NULL
    ret

.check_else:
    cmp byte [rsi + 1], 'l'
    jne .ident_return
    cmp byte [rsi + 2], 's'
    jne .ident_return
    cmp byte [rsi + 3], 'e'
    jne .ident_return
    mov rax, TOK_ELSE
    ret

.check_int8:
    cmp byte [rsi + 1], 'n'
    jne .ident_return
    cmp byte [rsi + 2], 't'
    jne .ident_return
    cmp byte [rsi + 3], '8'
    jne .ident_return
    mov rax, TOK_INT8
    ret

.check_nat8:
    cmp byte [rsi + 2], 't'
    jne .ident_return
    cmp byte [rsi + 3], '8'
    jne .ident_return
    mov rax, TOK_NAT8
    ret

%ifdef TOK_BOOL
.check_bool:
    cmp byte [rsi + 1], 'o'
    jne .ident_return
    cmp byte [rsi + 2], 'o'
    jne .ident_return
    cmp byte [rsi + 3], 'l'
    jne .ident_return
    mov rax, TOK_BOOL
    ret
%endif

.keyword_5:
    cmp byte [rsi], 'i'
    je .check_int
    cmp byte [rsi], 'n'
    je .check_nat
    jmp .ident_return

.check_int:
    cmp byte [rsi + 1], 'n'
    jne .ident_return
    cmp byte [rsi + 2], 't'
    jne .ident_return
    cmp byte [rsi + 3], '1'
    je .int16
    cmp byte [rsi + 3], '3'
    je .int32
    cmp byte [rsi + 3], '6'
    je .int64
    jmp .ident_return

.int16:
    cmp byte [rsi + 4], '6'
    jne .ident_return
    mov rax, TOK_INT16
    ret

.int32:
    cmp byte [rsi + 4], '2'
    jne .ident_return
    mov rax, TOK_INT32
    ret

.int64:
    cmp byte [rsi + 4], '4'
    jne .ident_return
    mov rax, TOK_INT64
    ret

.check_nat:
    cmp byte [rsi + 1], 'a'
    jne .ident_return
    cmp byte [rsi + 2], 't'
    jne .ident_return
    cmp byte [rsi + 3], '1'
    je .nat16
    cmp byte [rsi + 3], '3'
    je .nat32
    cmp byte [rsi + 3], '6'
    je .nat64
    jmp .ident_return

.nat16:
    cmp byte [rsi + 4], '6'
    jne .ident_return
    mov rax, TOK_NAT16
    ret

.nat32:
    cmp byte [rsi + 4], '2'
    jne .ident_return
    mov rax, TOK_NAT32
    ret

.nat64:
    cmp byte [rsi + 4], '4'
    jne .ident_return
    mov rax, TOK_NAT64
    ret

.ident_return:
    mov rax, TOK_IDENT
    ret

.source_eof:
    mov rax, [rel source_depth]

    test rax, rax
    jz .final_eof

    dec rax

    mov rbx, rax

    lea r11, [rel source_ptr_stack]
    mov rax, [r11 + rbx * 8]
    mov [rel src_ptr], rax

    lea r11, [rel source_end_stack]
    mov rax, [r11 + rbx * 8]
    mov [rel src_end], rax

    lea r11, [rel source_line_stack]
    mov rax, [r11 + rbx * 8]
    mov [rel line_number], rax

    lea r11, [rel source_col_stack]
    mov rax, [r11 + rbx * 8]
    mov [rel col_number], rax

    mov rcx, rbx
    imul rcx, PATH_BUFFER_SIZE

    lea rsi, [rel source_dir_stack]
    add rsi, rcx
    lea rdi, [rel current_source_dir]

    call lexer_copy_string

    mov [rel source_depth], rbx

    jmp .skip_whitespace

.final_eof:
    mov rax, TOK_EOF

    ret