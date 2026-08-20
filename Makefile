ASM = nasm
ASMFLAGS = -f elf64 -I src/include/
LD = ld

SRC_DIR = src
BUILD_DIR = build

OBJS = $(BUILD_DIR)/main.o \
       $(BUILD_DIR)/lexer.o \
       $(BUILD_DIR)/parser.o \
       $(BUILD_DIR)/codegen.o

all: $(BUILD_DIR)/zero

$(BUILD_DIR)/zero: $(OBJS)
	$(LD) $(OBJS) -o $@

$(BUILD_DIR)/main.o: $(SRC_DIR)/main.asm
	mkdir -p $(BUILD_DIR)
	$(ASM) $(ASMFLAGS) $< -o $@

$(BUILD_DIR)/lexer.o: $(SRC_DIR)/lexer.asm
	mkdir -p $(BUILD_DIR)
	$(ASM) $(ASMFLAGS) $< -o $@

$(BUILD_DIR)/parser.o: $(SRC_DIR)/parser.asm
	mkdir -p $(BUILD_DIR)
	$(ASM) $(ASMFLAGS) $< -o $@

$(BUILD_DIR)/codegen.o: $(SRC_DIR)/codegen.asm
	mkdir -p $(BUILD_DIR)
	$(ASM) $(ASMFLAGS) $< -o $@

clean:
	rm -rf $(BUILD_DIR)

run: all
	./$(BUILD_DIR)/zero stage0/src/main.zr