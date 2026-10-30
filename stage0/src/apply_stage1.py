import re, os, shutil

files = {}
errs = []

def load(p):
    if p not in files:
        files[p] = open(p).read()
    return files[p]

def before(p, rx, text):
    s = load(p)
    n = len(re.findall(rx, s, re.M))
    if n != 1:
        errs.append("%s: anchor found %d times: %r" % (p, n, rx[:60]))
        return
    files[p] = re.sub(rx, lambda m: text + m.group(0), s, count=1, flags=re.M)

def after(p, rx, text):
    s = load(p)
    n = len(re.findall(rx, s, re.M))
    if n != 1:
        errs.append("%s: anchor found %d times: %r" % (p, n, rx[:60]))
        return
    files[p] = re.sub(rx, lambda m: m.group(0) + text, s, count=1, flags=re.M)

def sub(p, rx, fn):
    s = load(p)
    n = len(re.findall(rx, s, re.S))
    if n != 1:
        errs.append("%s: anchor found %d times: %r" % (p, n, rx[:60]))
        return
    files[p] = re.sub(rx, fn, s, count=1, flags=re.S)

def append(p, text):
    files[p] = load(p) + text

# ---------- tokens.inc ----------
inc = "src/include/tokens.inc"
s = load(inc)
nums = [int(x) for x in re.findall(r"%define\s+TOK_\w+\s+(\d+)", s)]
top = max(nums)
if "TOK_PERCENT" not in s:
    append(inc, "\n%%define TOK_PERCENT %d\n%%define TOK_BANG %d\n" % (top + 1, top + 2))

# ---------- lexer.asm ----------
lx = "src/lexer.asm"
after(lx, r"^    je \.bang\n", "\n    cmp al, '%'\n    je .percent\n")
before(lx, r"^\.bang:\n", ".percent:\n\n    mov rax, TOK_PERCENT\n\n    jmp .single\n\n\n")
sub(lx,
    r"(\.bang:\s*lea rdx, \[rcx \+ 1\]\s*cmp rdx, \[rel source_end\]\s*)jae \.unknown(\s*cmp byte \[rdx\], '='\s*je \.noteq\s*)jmp \.unknown",
    lambda m: m.group(1) + "jae .bang_single" + m.group(2) +
              ".bang_single:\n\n    mov rax, TOK_BANG\n\n    jmp .single")

# ---------- parser.asm ----------
pa = "src/parser.asm"
after(pa, r"^extern codegen_div\n", "extern codegen_mod\nextern codegen_store_byte\n")
after(pa, r"^    je parser_expression_div\n", "\n    cmp rax, TOK_PERCENT\n    je parser_expression_mod\n")
before(pa, r"^parser_expression_unary:\n", r'''parser_expression_mod:

    call codegen_save_value

    call parser_next

    call parser_expression_unary

    call codegen_mod

    jmp parser_expression_multiplicative_loop

''')
after(pa, r"^    je parser_unary_addr\n",
      "\n    cmp rax, TOK_MINUS\n    je parser_unary_neg\n\n    cmp rax, TOK_BANG\n    je parser_unary_not\n")
before(pa, r"^parser_unary_deref:\n", r'''parser_unary_neg:

    xor eax, eax

    mov [rel current_number], rax

    mov [rel token_value], rax

    call codegen_load_number

    call codegen_save_value

    call parser_next

    call parser_expression_unary

    call codegen_sub

    ret

parser_unary_not:

    call parser_next

    call parser_expression_unary

    call codegen_save_value

    xor eax, eax

    mov [rel current_number], rax

    mov [rel token_value], rax

    call codegen_load_number

    call codegen_cmp_eq

    ret

''')
before(pa, r"^    cmp rax, TOK_IDENT\n    je parser_body_statement_ident\n",
       "    cmp rax, TOK_STAR\n    je parser_body_statement_ptrassign\n\n")
before(pa, r"^parser_body_ident:\n", r'''parser_body_statement_ptrassign:

    call parser_body_ptrassign

    jmp parser_body_loop

parser_body_ptrassign:

    call parser_next

    call parser_expression_unary

    call codegen_save_value

    cmp qword [rel current_token], TOK_EQUAL
    jne parser_error_equal

    call parser_next

    call parser_expression

    call codegen_store_byte

    cmp qword [rel current_token], TOK_NEWLINE
    je parser_body_newline

    cmp qword [rel current_token], TOK_RBRACE
    je parser_body_done

    jmp parser_error_unknown

''')

# ---------- codegen.asm ----------
cg = "src/codegen.asm"
after(cg, r"^default rel\n", "global codegen_mod, codegen_store_byte\n")
append(cg, r'''
codegen_mod:
    EMIT "    pop rbx", 10, "    xchg rax, rbx", 10, "    xor rdx, rdx", 10
    EMIT "    div rbx", 10, "    mov rax, rdx", 10
    ret

codegen_store_byte:
    EMIT "    pop rbx", 10, "    mov byte [rbx], al", 10
    ret
''')

# ---------- tokens.zr ----------
tz = "stage0/src/tokens.zr"
if "TOK_PERCENT" not in load(tz):
    append(tz, "\nnat8 TOK_PERCENT = 45\nnat8 TOK_BANG = 46\nnat8 TOK_ND_PTRASSIGN = 25\n")

# ---------- lexer.zr ----------
lz = "stage0/stage0/src/lexer.zr".replace("stage0/stage0", "stage0")
after(lz, r"^lx_single\(nat64 c\) -> nat64 \{\n", "    if c == '%' {\n        ret TOK_PERCENT\n    }\n")
sub(lz,
    r"(if c == '!' \{\s*if lx_peek\(\) == '=' \{\s*lx_adv\(\)\s*ret lx_tok\(TOK_NOTEQ, start, 2\)\s*\}\s*)ret lx_tok\(TOK_UNKNOWN, start, 1\)",
    lambda m: m.group(1) + "ret lx_tok(TOK_BANG, start, 1)")

# ---------- parser.zr ----------
pz = "stage0/src/parser.zr"
sub(pz, r"rep cur_tok == TOK_STAR \|\| cur_tok == TOK_SLASH \{",
    lambda m: "rep cur_tok == TOK_STAR || cur_tok == TOK_SLASH || cur_tok == TOK_PERCENT {")
after(pz, r"^parse_unary\(\) -> nat64 \{\n", r'''    if cur_tok == TOK_MINUS {
        p_next()
        ret ast_binop(TOK_MINUS, ast_num(0), parse_unary())
    }
    if cur_tok == TOK_BANG {
        p_next()
        ret ast_binop(TOK_EQEQ, parse_unary(), ast_num(0))
    }
''')
before(pz, r"^    // ---- присвоєння / виклик / запис у масив ----\n", r'''    if cur_tok == TOK_STAR {
        p_next()
        ppush(parse_unary())
        p_expect(TOK_EQUAL)
        p_next()
        nat64 pv = parse_expr()
        nat64 pa = ppop()
        ret ast_ptrassign(pa, pv)
    }

''')

# ---------- ast.zr ----------
append("stage0/src/ast.zr", r'''
ast_ptrassign(nat64 addr, nat64 value) -> nat64 {
    nat64 id = ast_new_node()
    ast_kind[id] = TOK_ND_PTRASSIGN
    ast_a[id] = addr
    ast_b[id] = value
    ret id
}
''')

# ---------- codegen_ast.zr ----------
ca = "stage0/src/codegen_ast.zr"
before(ca, r"^    if op == TOK_SLASH \{\n", r'''    if op == TOK_PERCENT {
        ln("    pop rbx")
        ln("    xchg rax, rbx")
        ln("    xor rdx, rdx")
        ln("    div rbx")
        ret ln("    mov rax, rdx")
    }
''')
before(ca, r"^    if kind == TOK_ND_ASSIGN \{\n", r'''    if kind == TOK_ND_PTRASSIGN {
        gen_expr(ast_a[node])
        ln("    push rax")
        gen_expr(ast_b[node])
        ln("    pop rbx")
        ret ln("    mov byte [rbx], al")
    }
''')

if errs:
    print("NOTHING CHANGED. Problems:")
    for e in errs:
        print("  " + e)
    raise SystemExit(1)

for p, text in files.items():
    shutil.copy(p, p + ".bak")
    open(p, "w").write(text)
    print("patched", p)

# ---------- tests ----------
open("tests/t15.zr", "w").write('''main() {
    print(17 % 5)
    print(-3 + 5)
    print(!0)
    print(!7)
    print(2 + 3 % 2 * 4)
    ret 0
}
''')
open("tests/t15.out", "w").write("2\n2\n1\n0\n6\n")

open("tests/t16.zr", "w").write('''main() {
    nat64 buf[2]
    chr* p = &buf
    *p = 65
    *(p + 1) = 66
    print(*p)
    print(*(p + 1))
    ret 0
}
''')
open("tests/t16.out", "w").write("65\n66\n")
print("tests t15, t16 created")