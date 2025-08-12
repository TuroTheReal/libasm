section .text
    global ft_strcpy

ft_strcpy:
	test rsi, rsi 			; if src == null
	jz .error 				; si oui jump a .error

	test rdi, rdi 			; if dst == null
	jz .error 				; si oui jump a .error

	xor rcx, rcx 			; int i = 0

.loop:
	mov al, [rsi + rcx]		; al = src[i]
	mov [rdi + rcx], al		; dest[i] = al

	cmp al, 0				; si al == '\0' fin de copie
	je .end					; if == '\0', break

	inc rcx					; i++
	jmp .loop				; retourne debut de la boucle

.end:
	mov rax, rdi
	ret						; return i, dans ce cas rax

.error:
	xor rax, rax			; return 0
	ret
