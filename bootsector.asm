bits 16 ; set bitness to 16(16 bit real mode)
org 0x7C00 ;Loads boot section to mem addr, org says pretend this code starts at 0x7C00 when calculating addrs
; does not generate anything, just info for assembler


mov ah, 0x0E ; upper half of AX set to 0xE0; The BIOS teletype function
mov al, 'H' ; set lower half of AX to 'H'
int 0x10 ; ah sets the command, 0xE0, which is print 1 charater, which uses AL(In ASCII)
; int 0x10 is the BIOS video interrupt. Kind oflike if you thought of a function that does bios_function(0xE0, 'H'),
;but instead of a function, its more like int0x10(i0x10.print_char, byte 'H') //with i0x10 being a enum


;print the rest of "Hello world!"
helloworld db "ello World!", 0
mov si, helloworld

.print_helloworld:
    lodsb ;AL = [SI], SI++
    test al, al ;Is it 0?
    jz .print_helloworld_done

    int 0x10
    jmp .print_helloworld

.print_helloworld_done:



jmp $ ;jumps to current address,
;Without this, the CPU would continue executing whatever bytes come after your code. like while(1){}

times 510-($-$$) db 0 ;boot sector must be 512 bytes, last 2 bytes are reserved for boot signature
;`$$` is the start of the section
;`$` is the current addr, so $-$$ gives the program size
dw 0xAA55
