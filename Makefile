.RECIPEPREFIX = >
.DELETE_ON_ERROR:

ASM = nasm
ASMFLAGS = -f elf64 -I src/include/
LD = ld

SRC_DIR = src
BUILD_DIR = build
INC = $(SRC_DIR)/include/tokens.inc

ZSRC = stage0/src/main.zr
ZFILES = $(wildcard stage0/src/*.zr)

OBJS = $(BUILD_DIR)/main.o $(BUILD_DIR)/lexer.o $(BUILD_DIR)/parser.o $(BUILD_DIR)/codegen.o

.PHONY: all clean run selfhost seed from-seed test

all: $(BUILD_DIR)/zero

$(BUILD_DIR):
> mkdir -p $@

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.asm $(INC) | $(BUILD_DIR)
> $(ASM) $(ASMFLAGS) $< -o $@

$(BUILD_DIR)/zero: $(OBJS)
> $(LD) $(OBJS) -o $@

run: all
> ./$(BUILD_DIR)/zero $(ZSRC)

$(BUILD_DIR)/asm1.asm: $(BUILD_DIR)/zero $(ZFILES)
> ./$(BUILD_DIR)/zero $(ZSRC) > $@

$(BUILD_DIR)/asm2.asm: $(BUILD_DIR)/gen1 $(ZFILES)
> ./$(BUILD_DIR)/gen1 $(ZSRC) > $@

$(BUILD_DIR)/asm3.asm: $(BUILD_DIR)/gen2 $(ZFILES)
> ./$(BUILD_DIR)/gen2 $(ZSRC) > $@

$(BUILD_DIR)/gen%: $(BUILD_DIR)/asm%.asm $(BUILD_DIR)/runtime.o
> $(ASM) -f elf64 $< -o $(BUILD_DIR)/asm$*.o
> $(LD) $(BUILD_DIR)/asm$*.o $(BUILD_DIR)/runtime.o -o $@

selfhost: $(BUILD_DIR)/gen3 $(BUILD_DIR)/asm2.asm $(BUILD_DIR)/asm3.asm
> cmp $(BUILD_DIR)/asm2.asm $(BUILD_DIR)/asm3.asm && echo "self-host OK"

seed: selfhost
> mkdir -p seed
> cp $(BUILD_DIR)/asm3.asm seed/zero.asm

from-seed: $(BUILD_DIR)/runtime.o
> $(ASM) -f elf64 seed/zero.asm -o $(BUILD_DIR)/seed.o
> $(LD) $(BUILD_DIR)/seed.o $(BUILD_DIR)/runtime.o -o $(BUILD_DIR)/zero_seed

test: selfhost
> sh tests/run.sh

clean:
> rm -rf $(BUILD_DIR)