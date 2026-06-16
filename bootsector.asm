bits 16 ; set bitness to 16(16 bit real mode)
org 0x7C00 ;Loads boot section to mem addr, org says pretend this code starts at 0x7C00 when calculating addrs
; does not generate anything, just info for assembler

mov ah, 0x0E ; upper half of AX set to 0xE0
mov al, 'H' ; set lower half of AX to 'H'
int 0x10 ; ah sets the command, 0xE0, which is print 1 charater, which uses AL(In ASCII)
; int 0x10 is the BIOS video interrupt. Kind oflike if you thought of a function that does bios_print_character('H'),
;but instead of a function, its more like int0x10(i0x10.print_char) //with i0x10 being a enum

;painfully write the rest of the word hello
mov al, 'e'
int 0x10
mov al, 'l'
int 0x10
mov al, 'l'
int 0x10
mov al, 'o'
int 0x10

mov al, 0x20 ;Hexadeciaml for ASCII space
int 0x10
;world
mov al, 'W'
int 0x10
mov al, 'o'
int 0x10
mov al, 'r'
int 0x10
mov al, 'l'
int 0x10
mov al, 'd'
int 0x10
mov al, '!'
int 0x10

jmp $ ;jumps to current address,
;Without this, the CPU would continue executing whatever bytes come after your code. like while(1){}

times 510-($-$$) db 0 ;boot sector must be 512 bytes, last 2 bytes are reserved for boot signature
;`$$` is the start of the section
;`$` is the current addr, so $-$$ gives the program size
dw 0xAA55
