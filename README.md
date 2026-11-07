markdown
# Zero-lang

**A freestanding systems programming language built for zero dependencies, low energy consumption, and predictable performance.**

Modern compiler toolchains rely on massive frameworks like LLVM and standard C runtimes, then abstract away the hardware until predictability is gone. Zero-lang goes the other way: it starts at raw syscalls and builds up, with every design choice made for auditability, speed, and low power draw.

This makes it a natural fit for **operating system and kernel development**. No libc, no hidden runtime, no garbage collector, no implicit heap allocation: just direct control over memory layout, syscalls, and machine instructions. The same properties that make Zero-lang auditable are exactly what a kernel, bootloader, or embedded OS component needs: deterministic behavior, a small trusted base, and zero surprises at the hardware boundary.

## Table of Contents

- [Why Zero-lang](#why-zero-lang)
- [Architecture & Bootstrapping](#architecture--bootstrapping)
- [The Language](#the-language)
- [The Performance Model](#the-performance-model)
- [Energy Efficiency](#energy-efficiency)
- [Maximalist Readability](#maximalist-readability)
- [Examples](#examples)
- [Building & Execution](#building--execution)
- [Testing](#testing)
- [Roadmap](#roadmap)
- [Project Status & Motivation](#project-status--motivation)
- [License](#license)

## Why Zero-lang

The project sets itself a few constraints and doesn't compromise on them:

| Constraint | Meaning |
|---|---|
| Zero dependencies | No LLVM, no libc, no external build systems. Just `nasm`, `ld` and the Linux kernel. |
| Explicit syntax | No implicit behavior, no hidden control flow, no compiler magic. |
| OS-ready by design | No runtime, no libc, no hidden heap. Freestanding from the first instruction, which is exactly what kernels and bootloaders need. |
| Performance (goal) | The compiler is meant to become an architecture-aware optimizer, not just a translator. Not implemented or measured yet. |

## Architecture & Bootstrapping

Most languages have to trust a large, opaque binary to build themselves: the classic "Trusting Trust" problem. Zero-lang keeps its bootstrap chain small and verifiable.

The compiler is **written in Zero-lang and is self-hosting**:

- `stage0/src/*.zr`: the compiler itself (lexer, parser, flat AST, code generator that emits NASM).
- `src/runtime.asm`: the only hand-written assembly in the build. A handful of raw-syscall wrappers (`write_bytes`, `write_err`, `read_file`, `get_arg`, `arg_count`, ...). No libc, no `crt0`.
- `seed/zero.asm`: the compiler translated to assembly. Building it needs only `nasm` and `ld`.

The very first compiler was written entirely in x86-64 NASM. It was used to compile the first Zero-lang version of the compiler and is kept in git history and in `old_asm/`; it is no longer needed to build the project.

Bootstrap chain:

```
seed/zero.asm -&gt; zero -&gt; gen1 -&gt; gen2 -&gt; gen3
```

`make selfhost` checks that `gen2` and `gen3` emit byte-identical assembly (a fixed point), so the compiler reproduces itself. Every step from raw instructions to the self-hosted compiler can be read and checked by hand.

Rules for changing the compiler: implement a new construct, run `make test`, refresh the seed with `make seed`, and only then use the construct in the compiler's own source.

## The Language

- **Sized types:** `int8 nat8 int16 nat16 int32 nat32 int64 nat64 chr bool`, pointers `T*`. Values are kept in 64-bit registers; return values are truncated to the declared type.
- **Functions:** `name(args) -> type { }`, up to 6 arguments (passed in registers), recursion supported. Functions may be called before they are declared.
- **Control flow:** `if / else`, `rep N { }` (fixed count), `rep condition { }`, `ret`.
- **Operators:** `+ - * /`, comparisons (signed), `&& ||`, address-of `&x`, byte dereference `*p`.
- **Data:** local and global arrays `type name[N]`, string literals with escapes, global constants.
- **Modules:** `use "file.zr"` (path relative to the current file, each file included once).
- **Builtins:** `print(n)`, `write_bytes(ptr, len)` and the runtime wrappers.

In progress: `%`, unary `-`, `!`, and writing through pointers (`*p = x`).

Not yet: bitwise operators, `break`/`continue`, `else if`, structs, hex literals, block comments.

## The Performance Model

*(Design goals. Not implemented yet.)*

Assembly gives full control, but people rarely schedule instructions well for modern CPU pipelines. Zero-lang intends to do this automatically:

1. **Pipeline scheduling** orders instructions to keep execution units busy and maximize IPC instead of stalling.
2. **Instruction replacement** finds inefficient sequences and swaps them for faster micro-operations and better register allocation.
3. **Custom section layout** gives full control over binary sections, so jump tables, memory alignment, and L1 instruction-cache usage stay predictable.

Today the code generator is a straight
