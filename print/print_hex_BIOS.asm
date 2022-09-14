print_hex_BIOS:
	; Print hex value passed in DX as a string

	push ax
	push bx ; Save registers

	; Manipulate chars at HEX_OUT to reflect DX
	mov ax, dx
	and ax, 0x000F ; Find least significant character of string
	call convert_to_ascii
	mov [HEX_OUT + 5], al

	mov ax, dx
	and ax, 0x00F0 ; Find next character of string
	shr ax, 4
	call convert_to_ascii
	mov [HEX_OUT + 4], al

	mov ax, dx
	and ax, 0x0F00 ; Find next character of string
	shr ax, 8
	call convert_to_ascii
	mov [HEX_OUT + 3], al

	mov ax, dx
	and ax, 0xF000 ; Find most significant character of string
	shr ax, 12
	call convert_to_ascii
	mov [HEX_OUT + 2], al

	mov bx, HEX_OUT
	call print_string_BIOS

	pop bx ; Restore registers
	pop ax
	ret

convert_to_ascii:
	; Overwrite the hex digit in al with its ascii value
	cmp al, 0x09
	jg letter

number:
	add al, 0x30
	ret

letter:
	add al, 0x37
	ret

HEX_OUT: db "0x0000", 0