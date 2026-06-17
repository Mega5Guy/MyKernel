bits 16 ; set bitness to 16(16 bit real mode)
org 0x7C00 ;Loads boot section to mem addr, org says pretend this code starts at 0x7C00 when calculating addrs
; does not generate anything, just info for assembler

KERNEL_OFFSET equ 0x1000
KERNEL_SECTORS equ 1

xor ax, ax
mov ds, ax
mov es, ax
mov ss, ax
mov sp, 0x7C00
cld

mov [BOOT_DRIVE], dl ; BIOS puts the boot disk number in DL.

mov ah, 0x0E ; upper half of AX set to 0xE0; The BIOS teletype function
mov al, 'H' ; set lower half of AX to 'H'
int 0x10 ; ah sets the command, 0xE0, which is print 1 charater, which uses AL(In ASCII)
; int 0x10 is the BIOS video interrupt. Kind oflike if you thought of a function that does bios_function(0xE0, 'H'),
;but instead of a function, its more like int0x10(i0x10.print_char, byte 'H') //with i0x10 being a enum


;print the rest of "Hello world!"
mov si, helloworld

.print_helloworld:
    lodsb ;AL = [SI], SI++
    test al, al ;Is it 0?
    jz .print_helloworld_done

    int 0x10
    jmp .print_helloworld

.print_helloworld_done:

call load_kernel


;Get into 32-bit protected mode

cli

lgdt [gdt_descriptor]

mov eax, cr0
or eax, 1 ;Set Protection Enable(PE) bit
mov cr0, eax

jmp dword 0x08:protected_mode ;CPU may continue interpreting instructions as real-mode code without this

helloworld db "ello World!", 0
BOOT_DRIVE db 0

load_kernel:
    mov ah, 0x02 ; BIOS read sectors function
    mov al, KERNEL_SECTORS ; How many sectors to read
    mov ch, 0x00 ; Cylinder 0
    mov cl, 0x02 ; Sector 2, right after the boot sector
    mov dh, 0x00 ; Head 0
    mov dl, [BOOT_DRIVE]
    mov bx, KERNEL_OFFSET ; Read into ES:BX, currently 0000:1000
    int 0x13
    jc disk_error
    ret

disk_error:
    mov ah, 0x0E
    mov al, 'E'
    int 0x10
    jmp $

;GDT
gdt_start:
dq 0x0000000000000000 ;Null descriptor

dq 0x00CF9A000000FFFF ;Code

dq 0x00CF92000000FFFF ; Data

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start





[BITS 32]

protected_mode:

mov ax, 0x10
mov ds, ax
mov es, ax
mov fs, ax
mov gs, ax
mov ss, ax

mov esp, 0x90000


;Jump to the Kernel!!!
jmp 0x08:0x1000

;I think I'm getting over excited lol

;Without this, the CPU would continue executing whatever bytes come after your code. like while(1){}
hang:
    cli
    hlt
    jmp hang

times 510-($-$$) db 0 ;boot sector must be 512 bytes, last 2 bytes are reserved for boot signature
;`$$` is the start of the section
;`$` is the current addr, so $-$$ gives the program size
dw 0xAA55
