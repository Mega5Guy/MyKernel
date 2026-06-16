nasm -f bin bootsector.asm -o boot.bin
qemu-system-x86_64 -drive file=boot.bin,format=raw //I guess I need no space between the comma and format for some reason