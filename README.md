# Zero-lang

A freestanding systems programming language with no external dependencies. The compiler is self-hosting, targets x86-64 Linux, and emits NASM assembly.

Zero-lang starts at raw syscalls and builds up. There is no libc, no runtime, no garbage collector and no implicit heap allocation. The programmer controls memory layout, syscalls and the generated code directly, which also suits kernel, bootloader and embedded work.

## Contents

- [Design constraints](#design-constraints)
- [Architecture and bootstrapping](#architecture-and-bootstrapping)
- [The language](#the-language)
- [Performance model](#performance-model)
- [Building and running](#building-and-running)

## Design constraints

| Constraint | Meaning |
|---|---|
| No dependencies | No LLVM, no libc, no external build system. Only `nasm`, `ld` and the Linux kernel. |
| Explicit syntax | No implicit behavior or hidden control flow. |
| Freestanding | No runtime, no libc, no hidden heap. |
| Performance | Goal: an architecture-aware optimizer rather than a plain translator. Not implemented or measured yet. |

## Architecture and bootstrapping

A self-hosting compiler has to be built by something. Zero-lang keeps that chain short enough to audit by hand.

- `stage0/src/*.zr`: the compiler (lexer, parser, flat AST, code generator that emits NASM).
- `src/runtime.asm`: the only hand-written assembly in the build. A few raw-syscall wrappers (`write_bytes`, `write_err`, `read_file`, `get_arg`, `arg_count`, ...). No libc, no `crt0`.
- `seed/zero.asm`: the compiler translated to assembly. Building it needs only `nasm` and `ld`.

The first compiler was written entirely in x86-64 NASM. It compiled the first Zero-lang version of the compiler and is kept in git history and in `old_asm/`. It is no longer needed to build the project.

Bootstrap chain:

```
seed/zero.asm --> zero --> asm1.asm --> gen1 --> asm2.asm --> gen2 --> asm3.asm
```

Each stage compiles `stage0/src/main.zr` with the previous one. If `asm2.asm` and `asm3.asm` are byte-identical, the compiler has reached a fixed point and reproduces itself. `make selfhost` performs this check.

Rules for changing the compiler: implement the new construct, run `make test`, refresh the seed with `make seed`, and only then use the construct in the compiler's own source.

## The language

- **Types:** `int8 nat8 int16 nat16 int32 nat32 int64 nat64 chr bool` and pointers `T*`. Values live in 64-bit registers; return values are truncated to the declared type.
- **Functions:** `name(args) -> type { }`. Up to 6 arguments, passed in registers. Recursion is supported. A function may be called before it is declared.
- **Control flow:** `if / else`, `rep N { }` (fixed count), `rep condition { }`, `ret`.
- **Operators:** `+ - * /`, signed comparisons, `&& ||`, address-of `&x`, byte dereference `*p`.
- **Data:** local and global arrays `type name[N]`, string literals with escapes, global constants.
- **Modules:** `use "file.zr"`. The path is relative to the current file; each file is included once.
- **Builtins:** `print(n)`, `write_bytes(ptr, len)` and the runtime wrappers.

In progress: `%`, unary `-`, `!`, writing through pointers (`*p = x`).

Not implemented: bitwise operators, `break` / `continue`, `else if`, structs, hex literals, block comments.

## Performance model

Design goals, not yet implemented.

Hand-written assembly gives full control, but instruction scheduling for modern CPU pipelines is hard to do by hand. Zero-lang intends to automate it:

1. **Pipeline scheduling.** Reorder instructions to keep execution units busy and raise IPC.
2. **Instruction replacement.** Replace inefficient sequences with faster micro-operations and better register allocation.
3. **Section layout.** Control over binary sections, so jump tables, alignment and L1 instruction-cache usage are predictable.

Today the code generator is a straightforward translator and does none of this.

## Building and running

Requires `nasm`, `ld` and GNU `make`.

```sh
git clone https://github.com/BidychakKonstantin/Zero-lang.git
cd Zero-lang
make selfhost    # prints "self-host OK" on success
```

### Make targets

| Command | Action |
|---|---|
| `make` | Build `build/zero` from `seed/zero.asm` |
| `make selfhost` | Run the full chain and verify `asm2.asm == asm3.asm` |
| `make test` | `selfhost`, then `tests/run.sh` |
| `make seed` | After `selfhost`, copy `asm3.asm` to `seed/zero.asm` |
| `make run` | Print the compiler's own assembly to stdout |
| `make exec FILE=prog.zr` | Compile, assemble, link and run a program (default: `prog.zr`) |
| `make clean` | Remove `build/` |

### Compiling a program manually

```sh
./build/gen3 prog.zr > build/prog.asm
nasm -f elf64 build/prog.asm -o build/prog.o
ld build/prog.o build/runtime.o -o build/prog
./build/prog
```

### Building without make

```sh
mkdir -p build
nasm -f elf64 -I src/include/ src/runtime.asm -o build/runtime.o
nasm -f elf64 seed/zero.asm -o build/seed.o
ld build/seed.o build/runtime.o -o build/zero
./build/zero stage0/src/main.zr > build/asm1.asm
```
