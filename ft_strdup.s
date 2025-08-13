section .text
global ft_strdup
extern ft_strlen
extern ft_strcpy
extern malloc

ft_strdup:
   						; Argument: rdi = src string
   						; r8 = registre libre

	mov r8, rdi			; save src dans r8

	call ft_strlen		; rax = longueur
	inc rax				; +1 pour '\0'

	mov rdi, rax		; taille pour malloc
    call malloc wrt ..plt ; Utiliser la PLT explicitement
	test rax, rax		; vérifier si malloc OK
	je .error			; si NULL -> erreur

						; Copier la chaîne
	mov rdi, rax		; destination = résultat malloc
	mov rsi, r8			; source = string originale
	call ft_strcpy		; copier
	ret					; rax = return ft_strcpy

.error:
	xor rax, rax		  ; retourner NULL
	ret