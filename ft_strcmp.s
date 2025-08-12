section .text
    global ft_strcmp

ft_strcmp:
	test rdi, rdi 			; if s1 == null
	jz .error 				; si oui jump a .error

	test rsi, rsi 			; if s2 == null
	jz .error 				; si oui jump a .error

	xor rcx, rcx 			; int i = 0

.loop:
	mov al, [rdi + rcx]		;  al =s1[i]
	mov bl, [rsi + rcx]		;  bl =s2[i]

	cmp al, bl				; if !=
	jne .diff

	cmp al, 0				; if == '\0'
	je .end

	inc rcx					; i++
	jmp .loop				; retourne debut de la boucle

.diff:
	movzx eax, al			; cast vers registre plus gros pour comparaison
	movzx ebx, bl			; same
	sub eax, ebx 			; eax = (unsigned char)s1[i] - (unsigned char)s2[i]
	ret

.end:
	xor rax, rax			; return 0
	ret

.error:
	mov eax, -1				; return -1 si un des pts == NULL
	ret
