extern get_errno_ptr

section .text
    global ft_write

ft_write:
							; Arguments: rdi = fd, rsi = buf, rdx = count
							; Syscall write: rax = 1
	mov rax, 1				; syscall number for write
	syscall

	cmp rax, 0				; if != 0
	jl .error				; si < 0
	ret

.error:
	neg rax					; converti en valeur positive
	push rax				; save errno


	call get_errno_ptr		; cherche & errno
	pop rdx					; recup error
	mov [rax], rdx			; *errno = valeur d'erreur
	mov rax, -1				; erreur write == return -1
	ret