%include "src/include/tokens.inc"

global parser_parse
extern lexer_next_token
extern line_number
extern col_number

section .rodata
 err_expected_ident:  db "Syntax Error: Expected identifier", 10
    len_err_ident        equ $ - err_expected_ident

    err_expected_lparen: db "Syntax Error: Expected '('", 10
    len_err_lparen       equ $ - err_expected_lparen

    err_expected_rparen: db "Syntax Error: Expected ')'", 10
    len_err_rparen       equ $ - err_expected_rparen

    err_expected_lbrace: db "Syntax Error: Expected '{'", 10
    len_err_lbrace       equ $ - err_expected_lbrace

    err_expected_colon:  db "Type Error: Expected ':' after argument name", 10
    len_err_colon        equ $ - err_expected_colon

    err_expected_type:   db "Type Error: Expected type (e.g., i64)", 10
    len_err_type         equ $ - err_expected_type

section .text

parser_parse:
 .parse_loop:
  call lexer_next_token
