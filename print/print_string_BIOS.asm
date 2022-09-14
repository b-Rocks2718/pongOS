print_string_BIOS:
	; Print null terminated string with address passed in bx

	push ax ;
	push bx ; Save registers that will be used
	push cx ;

	mov ah, 0x0e ; int 10/ah = 0x0e -> scrolling teletype BIOS routine

	print_char:
		mov cx, [bx] ; Load character from address
		cmp cl, 0 ; End if NULL
		jz print_string_done
		mov al, cl ; Put char in al to print
		int 0x10 ; Call BIOS routine
		inc bx ; Move to next character
		jmp print_char

print_string_done:
	pop cx ;
	pop bx ; Restore registers
	pop ax ;
	ret