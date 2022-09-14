CXX = gcc
CFLAGS = -ffreestanding -c

ASM = nasm
ASMFLAGS = -f bin

all: kernel.bin boot_sect.bin
	cat boot_sect.bin kernel.bin > os-image

run:
	qemu-system-x86_64 -fda os-image

kernel.bin: kernel.o kernel_entry.o
	ld -o kernel.bin -Ttext 0x1000 $^ --oformat binary

kernel_entry.o: kernel_entry.asm
	$(ASM) $< -f elf64 -o $@

kernel.o: kernel.cpp
	$(CXX) $< $(CFLAGS) -o $@

boot_sect.bin: boot_sect.asm
	$(ASM) $< $(ASMFLAGS) -o $@
