%ifndef TOKEN_INC
%define TOKEN_INC

%define TOK_EOF        0
%define TOK_INDENT     1 ;words(fn,var,main,ret, 0)
%define TOK_NUMBER     2 ;numbers(42,18,0)
%define LBRANCE        3 ; {
%define RBRANCE        4 ; }
%define LPAREN         5 ; (
%define RPAREN         6 ; )
%define TOK_EQUEL      7 ; =
%define TOK_PLUS       8 ; +
%define TOK_NEWLINE    9 ; /n

%endif