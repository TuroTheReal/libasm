section .text
global ft_list_size

						; ft_list_size - Calcule le nombre d'éléments dans une liste chainée
						; Arguments: rdi = t_list *lst
						; Retour: rax = nombre d'éléments
ft_list_size:
	xor rax, rax		; compteur = 0
	test rdi, rdi		; vérifier si lst == NULL
	jz .end

.count_loop:
	inc rax				; compteur++
	mov rdi, [rdi + 8]	; rdi = current->next
	test rdi, rdi		; current != NULL ?
	jnz .count_loop

.end:
	ret