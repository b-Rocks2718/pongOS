[bits 16]
; Switch to protected mode
switch_to_pm:
	cli		; disable interrupts until we set up the
			; protected mode Interrupt Vector Table

	lgdt [gdt_descriptor] ; load our gdt

	mov eax, cr0 ; Set the first bit of CR0 to enter protected mode
	or eax, 0x1
	mov cr0, eax

	jmp CODE_SEG:init_pm ; Far jump to flush pipeline

[bits 32]
; Initialize registers and the stack once in PM
init_pm:

	mov ax, DATA_SEG ; Update segment registers to data selector
	mov ds, ax		 ; in GDT
	mov ss, ax
	mov es, ax
	mov fs, ax
	mov gs, ax

	mov ebp, 0x90000 ; Set the stack to the top of free space
	mov esp, ebp

	call BEGIN_PM