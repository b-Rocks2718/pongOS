; Load DH sectors to ES:BX from drive DL
disk_load:
	push dx ; Save parameter

	mov ah, 0x02 ; BIOS read sector function
	mov al, dh   ; Read DH sectors
	mov ch, 0x00 ; Select cylinder 0
	mov dh, 0x00 ; Select head 0
	mov cl, 0x02 ; Start reading from the second sector

	int 0x13 ; BIOS interrupt

	jc disk_error ; Errors set the carry flag

	pop dx ; Restore DX
	cmp dh, al ; If AL (sectors read) != DH (sectors expected)
	jne disk_error ; Display error message
	ret

disk_error:
	
	mov bx, DISK_ERROR_MSG
	call print_string_BIOS
	jmp $

; Variables
DISK_ERROR_MSG: db "Disk read error!", 0