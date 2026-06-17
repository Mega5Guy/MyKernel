nasm -f bin bootsector.asm -o boot.bin

#Build a ELF format binary that does not link yet
gcc -m32 \
    -ffreestanding \
    -fno-pic \
    -fno-pie \
    -fno-stack-protector \
    -c kernel/Kernel.c \
    -o K.o

#Link with my linker script
ld -m elf_i386 \
    -T linker.ld \
    K.o \
    -o K.elf

#convert into raw binary
objcopy -O binary K.elf kernel.bin

cat boot.bin kernel.bin > OS.img
truncate -s 1024 OS.img
qemu-system-x86_64 -drive file=OS.img,format=raw #I guess I need no space between the comma and format for some reason
