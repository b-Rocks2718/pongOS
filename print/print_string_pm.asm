[bits 32]
; Constants
VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0f

; prints a null terminated string pointed to by EBX
print_string_pm:
	pusha
	mov edx, VIDEO_MEMORY + 18 * 160
	
print_string_pm_loop:
	mov al, [ebx] ; Store the char at EBX in AL
	mov ah, WHITE_ON_BLACK ; store attributes in AH

	cmp al, 0
	je print_string_pm_done

	mov [edx], ax ; Write character

	add ebx, 1 ; Increment EBX to next char in string
	add edx, 2 ; Move to next character cell in vid mem

	jmp print_string_pm_loop

print_string_pm_done:
	popa
	ret