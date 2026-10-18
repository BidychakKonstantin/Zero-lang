ASM = nasm

ASMFLAGS = -f elf64 -I src/include/

LD = ld

SRC_DIR = src
BUILD_DIR = build

INC = $(SRC_DIR)/include/tokens.inc

OBJS = \
    $(BUILD_DIR)/main.o \
    $(BUILD_DIR)/lexer.o \
    $(BUILD_DIR)/parser.o \
    $(BUILD_DIR)/codegen.o


.PHONY: all clean run exec


all: $(BUILD_DIR)/zero


$(BUILD_DIR)/zero: $(OBJS)
	$(LD) $(OBJS) -o $@


$(BUILD_DIR)/main.o: $(SRC_DIR)/main.asm $(INC)
	mkdir -p $(BUILD_DIR)
	$(ASM) $(ASMFLAGS) $< -o $@


$(BUILD_DIR)/lexer.o: $(SRC_DIR)/lexer.asm $(INC)
	mkdir -p $(BUILD_DIR)
	$(ASM) $(ASMFLAGS) $< -o $@


$(BUILD_DIR)/parser.o: $(SRC_DIR)/parser.asm $(INC)
	mkdir -p $(BUILD_DIR)
	$(ASM) $(ASMFLAGS) $< -o $@


$(BUILD_DIR)/codegen.o: $(SRC_DIR)/codegen.asm $(INC)
	mkdir -p $(BUILD_DIR)
	$(ASM) $(ASMFLAGS) $< -o $@


clean:
	rm -rf $(BUILD_DIR)


run: all
	./$(BUILD_DIR)/zero stage0/src/main.zr


exec: all
	./$(BUILD_DIR)/zero stage0/src/main.zr > $(BUILD_DIR)/out.asm
	$(ASM) -f elf64 $(BUILD_DIR)/out.asm -o $(BUILD_DIR)/out.o
	$(ASM) -f elf64 src/runtime.asm -o $(BUILD_DIR)/runtime.o
	$(LD) $(BUILD_DIR)/out.o $(BUILD_DIR)/runtime.o -o $(BUILD_DIR)/out
	./$(BUILD_DIR)/out stage0/src/main.zr > $(BUILD_DIR)/stage1.asm || true
test: all
	@for f in tests/*.zr; do \
	  ./$(BUILD_DIR)/zero $$f > $(BUILD_DIR)/a.asm || exit 1; \
	  ./$(BUILD_DIR)/zero2 $$f > $(BUILD_DIR)/b.asm || exit 1; \
	  cmp $(BUILD_DIR)/a.asm $(BUILD_DIR)/b.asm || { echo "DIFF $$f"; exit 1; }; \
	  $(ASM) -f elf64 $(BUILD_DIR)/b.asm -o $(BUILD_DIR)/b.o && \
	  $(LD) $(BUILD_DIR)/b.o $(BUILD_DIR)/runtime.o -o $(BUILD_DIR)/tbin && \
	  echo "== $$f" && ./$(BUILD_DIR)/tbin; \
	done