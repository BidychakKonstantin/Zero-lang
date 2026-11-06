.RECIPEPREFIX = >
.DELETE_ON_ERROR:

ASM = nasm
LD = ld
BUILD_DIR = build
ZSRC = stage0/src/main.zr
ZFILES = $(wildcard stage0/src/*.zr)
RUNTIME = src/runtime.asm
FILE ?= prog.zr

.PHONY: all clean selfhost seed test run exec

all: $(BUILD_DIR)/zero

$(BUILD_DIR):
> mkdir -p $@

$(BUILD_DIR)/runtime.o: $(RUNTIME) | $(BUILD_DIR)
> $(ASM) -f elf64 -I src/include/ $< -o $@

$(BUILD_DIR)/zero: seed/zero.asm $(BUILD_DIR)/runtime.o
> $(ASM) -f elf64 seed/zero.asm -o $(BUILD_DIR)/seed.o
> $(LD) $(BUILD_DIR)/seed.o $(BUILD_DIR)/runtime.o -o $@

$(BUILD_DIR)/asm1.asm: $(BUILD_DIR)/zero $(ZFILES)
> ./$(BUILD_DIR)/zero $(ZSRC) > $@
> test -s $@

$(BUILD_DIR)/asm2.asm: $(BUILD_DIR)/gen1 $(ZFILES)
> ./$(BUILD_DIR)/gen1 $(ZSRC) > $@
> test -s $@

$(BUILD_DIR)/asm3.asm: $(BUILD_DIR)/gen2 $(ZFILES)
> ./$(BUILD_DIR)/gen2 $(ZSRC) > $@
> test -s $@

$(BUILD_DIR)/gen%: $(BUILD_DIR)/asm%.asm $(BUILD_DIR)/runtime.o
> $(ASM) -f elf64 $< -o $(BUILD_DIR)/asm$*.o
> $(LD) $(BUILD_DIR)/asm$*.o $(BUILD_DIR)/runtime.o -o $@

selfhost: $(BUILD_DIR)/asm2.asm $(BUILD_DIR)/asm3.asm
> cmp $(BUILD_DIR)/asm2.asm $(BUILD_DIR)/asm3.asm && echo "self-host OK"

seed: selfhost
> mkdir -p seed
> cp $(BUILD_DIR)/asm3.asm seed/zero.asm
> echo "seed updated"

test: selfhost $(BUILD_DIR)/gen1 $(BUILD_DIR)/gen3
> sh tests/run.sh

run: $(BUILD_DIR)/gen3
> ./$(BUILD_DIR)/gen3 $(ZSRC)

exec: $(BUILD_DIR)/gen3
> ./$(BUILD_DIR)/gen3 $(FILE) > $(BUILD_DIR)/prog.asm
> $(ASM) -f elf64 $(BUILD_DIR)/prog.asm -o $(BUILD_DIR)/prog.o
> $(LD) $(BUILD_DIR)/prog.o $(BUILD_DIR)/runtime.o -o $(BUILD_DIR)/prog
> ./$(BUILD_DIR)/prog

clean:
> rm -rf $(BUILD_DIR)