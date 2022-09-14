;
; boot sector to launch a C++ kernel in 32-bit protected mode
;
[ org 0x7c00 ] ; Where this bootloader should be loaded
KERNEL_OFFSET equ 0x1000 ; Where the kernel will be loaded
	
	mov [BOOT_DRIVE], dl ; BIOS stores the boot drive in DL

	mov bp, 0x9000 ; Set base of stack
	mov sp, bp

	mov bx, MSG_REAL_MODE
	call print_string_BIOS

	call load_kernel ; Load the kernel from the disk

	call switch_to_pm ; Switch to protected mode and never return

	jmp $

; Libraries
%include "print/print_string_BIOS.asm"
%include "disk/disk_load.asm"
%include "pm/gdt.asm"
%include "print/print_string_pm.asm"
%include "pm/switch_to_pm.asm"

[bits 16]

load_kernel:
	mov bx, MSG_LOAD_KERNEL
	call print_string_BIOS

	mov bx, KERNEL_OFFSET ; Set up parameters for disk_load routine
	mov dh, 15			  ; to load first 15 sectors from boot disk 
	mov dl, [BOOT_DRIVE]  ; to address KERNEL_OFFSET
	call disk_load

	ret

[bits 32]
BEGIN_PM:
	mov ebx, MSG_PROT_MODE
	call print_string_pm

	call KERNEL_OFFSET ; Jump to address of the loaded kernel

	jmp $

; Global variables
BOOT_DRIVE		db 0
MSG_REAL_MODE	db "Started in 16-bit Real Mode", 10, 13, 0
MSG_PROT_MODE	db "Successfully landed in 32-bit Protected Mode", 0
MSG_LOAD_KERNEL	db "Loading kernel into memory", 10, 13, 0

times 510 - ( $ - $$ ) db 0	; Zero padding

dw 0xaa55	; Last two bytes ( one word ) form the magic number 
			; so BIOS knows we are a boot sector.

; Data here will end up in the next sectors of the disk
; after the boot sector
times 256 dw 0xface