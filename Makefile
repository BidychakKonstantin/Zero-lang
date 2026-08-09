AS = nasm
ASFLAGS = -f elf64
LD = ld

SRC = src/main.asm
OBJ = build/main.o
TARGET = build/zero

.PHONY: all run clean

all: $(TARGET)

$(TARGET): $(SRC)
	@mkdir -p build
	$(AS) $(ASFLAGS) $(SRC) -o $(OBJ)
	$(LD) $(OBJ) -o $(TARGET)

run: all
	./$(TARGET)

clean:
	rm -rf build