section .text
    global ft_strlen

ft_strlen:
	test rdi, rdi 			; if str == null
	jz .error 				; si oui jump a .error
	xor rax, rax 			; int i = 0;
.loop:
	cmp byte [rdi + rax], 0 ;  str[i] ? '\0'
	je .end					; if == '\0', break

	inc rax					; sinon i++
	jmp .loop				; retourne debut de la boucle
.end:
	ret						; return i, dans ce cas rax
.error:
	xor rax, rax			; return 0
	ret



