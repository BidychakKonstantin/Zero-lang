# Zero-lang

**A freestanding systems programming language built for zero dependencies, low energy consumption, and predictable performance.**

Modern compiler toolchains rely on massive frameworks like LLVM and standard C runtimes, then abstract away the hardware until predictability is gone. Zero-lang goes the other way: it starts at raw syscalls and builds up, with every design choice made for auditability, speed, and low power draw.

This makes it a natural fit for **operating system and kernel development**. No libc, no hidden runtime, no garbage collector, no implicit heap allocation — just direct control over memory layout, syscalls, and machine instructions. The same properties that make Zero-lang auditable and energy-efficient are exactly what a kernel, bootloader, or embedded OS component needs: deterministic behavior, a small trusted base, and zero surprises at the hardware boundary.

## Table of Contents

- [Why Zero-lang](#why-zero-lang)
- [Architecture & Bootstrapping](#architecture--bootstrapping)
- [The Performance Model](#the-performance-model)
- [Energy Efficiency](#energy-efficiency)
- [Maximalist Readability](#maximalist-readability)
- [Example](#example)
- [Building & Execution](#building--execution)
- [Roadmap](#roadmap)
- [Project Status & Motivation](#project-status--motivation)
- [License](#license)

## Why Zero-lang

The project sets itself three constraints and doesn't compromise on any of them:

| Constraint | Meaning |
|---|---|
| Zero dependencies | No LLVM, no libc, no external build systems — just the kernel and the hardware. |
| Faster than hand-written assembly | The compiler works as an architecture-aware optimizer, not just a translator. |
| Explicit syntax | No implicit behavior, no hidden control flow, no compiler magic. |
| OS-ready by design | No runtime, no libc, no hidden heap — freestanding from the first instruction, which is exactly what kernels and bootloaders need. |

## Architecture & Bootstrapping

Most languages have to trust a large, opaque binary to build themselves — the classic "Trusting Trust" problem. Zero-lang avoids this with a small, verifiable bootstrap chain:

- **Stage 0** — a minimal compiler written entirely in x86-64 NASM. It talks to the Linux kernel through raw syscalls (`sys_read`, `sys_mmap`, `sys_write`) and links against nothing, not even `libc` or `crt0`.
- **Stage 1** *(in progress)* — the full Zero-lang compiler, written in Zero-lang and compiled by Stage 0.

Every step from raw instructions to the self-hosted compiler can be read and checked by hand.

## The Performance Model

Assembly gives full control, but people rarely schedule instructions well for modern CPU pipelines. Zero-lang tries to do this automatically:

1. **Pipeline scheduling** orders instructions to keep execution units busy and maximize IPC instead of stalling.
2. **Instruction replacement** finds inefficient sequences and swaps them for faster micro-operations and better register allocation.
3. **Custom section layout** gives full control over binary sections, so jump tables, memory alignment, and L1 instruction-cache usage stay predictable.

## Energy Efficiency

Fewer instructions per operation and no runtime overhead translate directly into lower power draw — this is the practical payoff of the performance model above, not a separate goal bolted on afterward:

- No garbage collector, no bytecode interpreter, no runtime scheduler running in the background and burning cycles.
- Binaries execute the exact instructions the compiler emits — nothing is re-interpreted or re-JIT-compiled at runtime.
- Tight instruction scheduling and cache-aware layout mean fewer wasted CPU cycles per task, which matters for battery-powered and embedded devices where every watt counts.
- A freestanding binary with no dynamic linking also skips the loading and initialization overhead that heavier runtimes pay on every startup.

None of this is measured yet — Stage 0 doesn't have a parser or optimizer finished — but it's a direct consequence of the design and something the project intends to benchmark once Stage 1 is running.

## Maximalist Readability

A lot of language design right now goes toward hiding things — implicit types, optional semicolons, control flow you have to infer. Zero-lang doesn't do that.

Code gets read far more than it gets written, so Zero-lang keeps its syntax explicit. Keywords like `void` and statement terminators aren't dropped just to look modern — they carry meaning. No hidden compiler magic, no implicit memory allocation. What you read is what the CPU runs.

Explicit doesn't mean rigid, though. The syntax is being designed to let you write control structures the way that reads best in context, rather than forcing one style everywhere. Conditionals, for example, will accept both a bare form and a parenthesized form:

```
if 10 > 9
if (10 > 9) {}
```

Both compile to the same thing. This flexibility is intentional and limited — it's about letting expressions breathe where parentheses add nothing, not about introducing ambiguity. The compiler still has one unambiguous grammar underneath; the surface syntax just has a little more room to match how you naturally write the condition.

## Example

Here's a small Zero-lang program: it counts from 1 to 10, printing each value along the way, and returns the final count.

```
main() {
    nat16 a = 0
    rep 10 {
        a = a + 1
        print(a)
    }
    ret a
}
```

A few things worth noticing:

- **`nat16`** is an explicit, sized type — a 16-bit natural number. No type inference guessing what you meant.
- **`rep 10 { ... }`** is a fixed-count loop. The bound is right there in the syntax, not hidden behind an iterator abstraction.
- **`print(a)`** and **`ret a`** read exactly as they execute — no implicit conversions, no hidden allocations, nothing happening off-screen.

Nothing about this program requires a runtime, a garbage collector, or a standard library. It's ready to compile straight down to the syscalls Stage 0 already understands.

Here's a second example — a small function with typed parameters and an explicit return type, called from `main`:

```
add(nat64 a, nat64 b) -> nat64 {
  ret a + b
}

main() {
    nat64 res = add(10, 10)
    ret res
}
```

The `-> nat64` return-type annotation follows the same rule as everything else in the language: nothing is inferred that doesn't have to be. A function's signature tells you exactly what goes in and what comes out, without reading the body.

**Looking ahead:** one planned type is `nat4` — a 4-bit natural number meant for cases where two `nat4` values can be packed together into a single byte and unpacked again at the end of a computation. The idea is to let the compiler treat sub-byte-sized data as a first-class type for memory-dense structures, rather than forcing everything up to a full byte just because that's the smallest addressable unit. This is still a design idea, not implemented yet, but it fits the same philosophy as everything above: explicit sizes, no wasted bits, no hidden padding.

## Building & Execution

The project builds with a plain `Makefile`. No libc, no external build system.

Build the Stage 0 compiler:

```bash
make run
```

Run the compiled binary:

```bash
make exec
```

Clean build artifacts and object files:

```bash
make clean
```

## Roadmap

- [x] Stage 0 — Core Foundation: lexer and syscall interface in x86-64 NASM.
- [x] Stage 0 — Memory Engine: arena memory management via direct `sys_mmap`.
- [ ] Stage 0 — AST & Parser: deterministic parser for Zero-lang syntax.
- [ ] Stage 0 — Instruction Optimizer: micro-instruction replacement and section builder.
- [ ] Stage 1 — Bootstrap: rewrite the compiler in Zero-lang and run the Stage 0 → Stage 1 self-hosting loop.
- [ ] Reproducibility Verification: bit-for-bit verification of self-hosted compiler binaries.

## Project Status & Motivation

Zero-lang is early-stage and actively developed. Stage 0's lexer, syscall interface, and arena memory engine are done and working, written entirely in x86-64 NASM with no external dependencies. The parser, instruction optimizer, and self-hosted Stage 1 compiler are next.

Why this is worth supporting:

**A bootstrap chain you can actually verify.** Most compiler toolchains ask you to trust a binary you can't fully inspect. Zero-lang's path — a small hand-written Stage 0 in assembly, then a self-hosted Stage 1 — stays small enough that one person can read and check the whole chain instead of taking it on faith.

**Performance and low power draw without LLVM.** Systems languages usually inherit LLVM's size and complexity by default. Zero-lang is testing whether a freestanding compiler can stay dependency-free, competitive on speed, and lighter on energy use at the same time — a combination most current toolchains don't optimize for.

**Reproducibility from the start.** Bit-for-bit reproducible builds are on the roadmap now, not added later, which matters for supply-chain security.

**A transparent reference for low-level work.** With no hidden abstractions, the codebase itself works as a readable example of how a compiler, allocator, and instruction scheduler operate at the syscall level — useful for teaching and security research, not just for using the language.

**A real foundation for OS development.** Zero-lang has no runtime to strip out and nothing to disable before it can run freestanding — it starts there. That makes it a genuinely usable base for writing kernels, bootloaders, and embedded operating systems, not just a language that can theoretically target bare metal.

Funding would go toward finishing the Stage 0 parser and instruction optimizer, completing the Stage 0 → Stage 1 self-hosting loop, and setting up the reproducibility-verification process — the largest remaining items on the roadmap.

## License

Distributed under the BSD 3-Clause License. See [`LICENSE`](./LICENSE) for details.
